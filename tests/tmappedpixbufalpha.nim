# Actual isolated rendering and guarded valid RGB/RGBA source storage. No codecs/file IO/input.
import std/[os, unittest]
when defined(posix): import std/posix as px
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Pixbuf alpha tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "alpha rendering did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc adoptForTest(native: p.PPixbuf): Pixbuf =
  let holder = newImage()
  defer: holder.destroy()
  n.set_from_pixbuf(holder.raw, native)
  holder.pixbuf
gtk2.init()
suite "copied Pixbuf alpha conversion on isolated display":
  test "actual flattened native rendering/background, source release and GtkImage replacement ownership":
    var output: Pixbuf
    var sourceFreed = 0
    block:
      let source = newPixbuf(3, 2, [128'u8, 255, 1, 0, 211, 37, 13, 1, 19, 73, 151, 127,
        47, 223, 131, 128, 233, 41, 89, 254, 0xde, 0xad, 0xbe, 255])
      g.weak_ref(cast[g.PGObject](source.raw), finalized, addr sourceFreed)
      output = source.withAlpha(0xdeadbe'u32).flattened(0x102030'u32)
    check sourceFreed == 1
    let expected = output.rgbaPixels()
    check expected.bytes[0..<4] == @[16'u8, 32, 48, 255]
    check expected.bytes[20..<24] == @[16'u8, 32, 48, 255] # Color key was applied before flattening.
    let host = newOffscreenWindow(3, 2)
    defer: host.destroy()
    let view = newImage()
    host.add(view)
    var freed = 0
    g.weak_ref(cast[g.PGObject](output.raw), finalized, addr freed)
    view.pixbuf = output
    output = gtk2.Pixbuf()
    check freed == 0
    host.showAll()
    drain()
    let snapshot = host.pixbuf.rgbaPixels()
    check snapshot.bytes == expected.bytes
    view.pixbuf = newPixbuf(3, 2, 0xff0000ff'u32)
    check freed == 1
    drain()
    check host.pixbuf.rgbaPixels().bytes != snapshot.bytes
    host.destroy()
    check snapshot.bytes == expected.bytes
  when defined(posix):
    test "RGB/RGBA final sample at protected page: native alpha/key/flatten read only actual storage":
      for alpha in [false, true]:
        let page = int(px.sysconf(px.SC_PAGESIZE))
        require page > 64 and page <= high(int) div 2
        let memory = px.mmap(nil, page*2, px.PROT_READ or px.PROT_WRITE,
          px.MAP_PRIVATE or px.MAP_ANONYMOUS, -1, px.Off(0))
        require memory != px.MAP_FAILED
        defer: discard px.munmap(memory, page*2)
        let guard = cast[pointer](cast[uint](memory)+uint(page))
        require px.mprotect(guard, page, px.PROT_NONE) == 0
        let channels = (if alpha: 4 else: 3)
        let span = 16+3*channels
        let data = cast[ptr UncheckedArray[byte]](cast[uint](guard)-uint(span))
        for i in 0..<span: data[i] = byte(i*7 mod 256)
        let last = 16+2*channels
        let key = (uint32(data[last]) shl 16) or (uint32(data[last+1]) shl 8) or uint32(data[last+2])
        var outputs: seq[Pixbuf]
        var snapshots: seq[seq[byte]]
        block:
          let native = p.pixbuf_new_from_data(cast[g.Pguchar](data), p.COLORSPACE_RGB,
            g.gbool(alpha), 8, 3, 2, 16, nil, nil)
          require native != nil
          defer: g.g_object_unref(native)
          let source = adoptForTest(native)
          let before = source.rgbaPixels().bytes
          outputs = @[source.withAlpha(), source.withAlpha(key), source.flattened(0x80ffe1'u32)]
          check outputs[0].hasAlpha and outputs[1].hasAlpha and not outputs[2].hasAlpha
          check outputs[0].rgbaPixels().bytes == before
          check outputs[1].rgbaPixels().bytes[23] == 0
          check source.rgbaPixels().bytes == before
          for image in outputs: snapshots.add(image.rgbaPixels().bytes)
        require px.mprotect(memory, page, px.PROT_NONE) == 0
        for i, image in outputs: check image.rgbaPixels().bytes == snapshots[i]
        # Subsequent conversion is safe too; native alpha copy never borrowed the original page.
        check outputs[0].flattened(0x102030'u32).rgbaPixels().len == 24
