# Actual opted-in native fit rendering and guarded valid source storage; no codecs/files/input.
import std/[os, unittest]
when defined(posix): import std/posix as px
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Pixbuf fit tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "fit rendering did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc adoptForTest(native: p.PPixbuf): Pixbuf =
  let holder = newImage()
  defer: holder.destroy()
  n.set_from_pixbuf(holder.raw, native)
  holder.pixbuf
gtk2.init()
suite "copied aspect-fit Pixbufs on isolated display":
  test "actual fitted rendering/unchanged copies/native image ownership/source release":
    var outputs: seq[Pixbuf]
    var sourceFreed = 0
    block:
      let source = newPixbuf(3, 2, [255'u8, 0, 0, 255, 0, 255, 0, 255, 0, 0, 255, 255,
        255, 255, 0, 255, 255, 0, 255, 255, 0, 255, 255, 255]).flattened(0'u32)
      g.weak_ref(cast[g.PGObject](source.raw), finalized, addr sourceFreed)
      outputs = @[source.fitted(2, 2, interpolation = interpolateNearest),
        source.fitted(6, 6, allowUpscale = true, interpolation = interpolateNearest),
        source.fitted(20, 20), source.fitted(6, 6, allowUpscale = true)]
    check sourceFreed == 1
    check outputs[0].width == 2 and outputs[0].height == 1
    check outputs[1].width == 6 and outputs[1].height == 4
    for i in 0..<outputs.len:
      let expected = outputs[i].rgbaPixels()
      let host = newOffscreenWindow(expected.width, expected.height)
      let view = newImage()
      host.add(view)
      var freed = 0
      g.weak_ref(cast[g.PGObject](outputs[i].raw), finalized, addr freed)
      view.pixbuf = outputs[i]
      outputs[i] = gtk2.Pixbuf()
      check freed == 0
      host.showAll()
      drain()
      let snapshot = host.pixbuf.rgbaPixels()
      check snapshot.width == expected.width and snapshot.height == expected.height
      check snapshot.bytes == expected.bytes
      view.pixbuf = gtk2.Pixbuf()
      check freed == 1
      host.destroy()
      check snapshot.bytes == expected.bytes
  when defined(posix):
    test "RGB/RGBA final sample against guard page for every interpolation/up/down/identity fit":
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
        var outputs: seq[Pixbuf]
        var snapshots: seq[seq[byte]]
        block:
          let native = p.pixbuf_new_from_data(cast[g.Pguchar](data), p.COLORSPACE_RGB,
            g.gbool(alpha), 8, 3, 2, 16, nil, nil)
          require native != nil
          defer: g.g_object_unref(native)
          let image = adoptForTest(native)
          let before = image.rgbaPixels().bytes
          for mode in [interpolateNearest, interpolateTiles, interpolateBilinear, interpolateHyper]:
            outputs.add(image.fitted(1, 1, interpolation = mode))
            outputs.add(image.fitted(7, 5, allowUpscale = true, interpolation = mode))
            outputs.add(image.fitted(8, 8, interpolation = mode))
          check image.rgbaPixels().bytes == before
          for output in outputs: snapshots.add(output.rgbaPixels().bytes)
        require px.mprotect(memory, page, px.PROT_NONE) == 0
        for i, output in outputs:
          check output.hasAlpha == alpha and output.rgbaPixels().bytes == snapshots[i]
