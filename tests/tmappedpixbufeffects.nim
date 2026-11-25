# Actual isolated rendering and valid final samples at protected pages.
import std/[os, unittest]
when defined(posix): import std/posix as px
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
when defined(posix): import headers/gdk2pixbuf as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1" or getEnv("DISPLAY").len == 0:
  quit("Pixbuf effects tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for _ in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "effect rendering did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]

gtk2.init()
suite "copied Pixbuf effects on isolated display":
  test "real checkerboard pixels and native source/output ownership":
    var output: Pixbuf
    var sourceFreed = 0
    block:
      let source = newPixbuf(3, 2, 0x000000ff'u32)
      g.weak_ref(cast[g.PGObject](source.raw), finalized, addr sourceFreed)
      output = source.saturated(pixelate = true)
    check sourceFreed == 1
    let expected = output.rgbaPixels().bytes
    check expected == @[127'u8, 127, 127, 255, 0, 0, 0, 255, 127, 127, 127, 255,
      0, 0, 0, 255, 127, 127, 127, 255, 0, 0, 0, 255]
    let host = newOffscreenWindow(3, 2)
    defer: host.destroy()
    let view = newImage()
    host.add(view)
    var outputFreed = 0
    g.weak_ref(cast[g.PGObject](output.raw), finalized, addr outputFreed)
    view.pixbuf = output
    output = gtk2.Pixbuf()
    check outputFreed == 0
    host.showAll()
    drain()
    check host.pixbuf.rgbaPixels().bytes == expected
    view.pixbuf = newPixbuf(3, 2, 0x224488ff'u32)
    check outputFreed == 1
    drain()
    check host.pixbuf.rgbaPixels().bytes != expected
  when defined(posix):
    test "padded RGB/RGBA rows ending at protected page, independent effect and no-op":
      for alpha in [false, true]:
        let page = int(px.sysconf(px.SC_PAGESIZE))
        require page > 64 and page <= high(int) div 2
        let memory = px.mmap(nil, page*2, px.PROT_READ or px.PROT_WRITE,
          px.MAP_PRIVATE or px.MAP_ANONYMOUS, -1, px.Off(0))
        require memory != px.MAP_FAILED
        defer: discard px.munmap(memory, page*2)
        let guard = cast[pointer](cast[uint](memory)+uint(page))
        require px.mprotect(guard, page, px.PROT_NONE) == 0
        let span = 16 + 3 * (if alpha: 4 else: 3)
        let data = cast[ptr UncheckedArray[byte]](cast[uint](guard)-uint(span))
        for i in 0..<span: data[i] = byte(i*13 mod 256)
        var outputs: seq[Pixbuf]
        var snapshots: seq[seq[byte]]
        block:
          let native = p.pixbuf_new_from_data(cast[g.Pguchar](data), p.COLORSPACE_RGB,
            g.gbool(alpha), 8, 3, 2, 16, nil, nil)
          require native != nil
          defer: g.g_object_unref(native)
          let holder = newImage()
          defer: holder.destroy()
          n.set_from_pixbuf(holder.raw, native)
          let source = holder.pixbuf
          let before = source.rgbaPixels().bytes
          outputs = @[source.saturated(), source.saturated(0), source.saturated(0.5, true)]
          check source.rgbaPixels().bytes == before
          check outputs[0].rgbaPixels().bytes == before
          for image in outputs: snapshots.add(image.rgbaPixels().bytes)
        require px.mprotect(memory, page, px.PROT_NONE) == 0
        for i, image in outputs: check image.rgbaPixels().bytes == snapshots[i]
