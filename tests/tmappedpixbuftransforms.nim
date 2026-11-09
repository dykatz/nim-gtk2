# Isolated actual rendering and a POSIX guard-page external-buffer safety fixture.
# No codecs, file writes, selections or synthesized input.
import std/[os, unittest]
when defined(posix): import std/posix as px
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Pixbuf transform rendering requires isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "transform rendering did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc adoptForTest(native: p.PPixbuf): Pixbuf =
  let holder = newImage()
  defer: holder.destroy()
  n.set_from_pixbuf(holder.raw, native)
  holder.pixbuf
gtk2.init()
suite "copied native Pixbuf transforms on isolated display":
  test "actual oriented native rendering and image ownership after source/result scope exit":
    let pixels = newRgbaPixels(3, 2, [255'u8, 0, 0, 255, 0, 255, 0, 255, 0, 0, 255, 255,
      255, 255, 0, 255, 255, 0, 255, 255, 0, 255, 255, 255])
    var results: seq[Pixbuf]
    var freed = 0
    block:
      let source = newPixbuf(pixels)
      g.weak_ref(cast[g.PGObject](source.raw), finalized, addr freed)
      results = @[source.cropped(1, 0, 2, 2), source.flipped(true), source.flipped(false),
        source.rotated(rotateNone), source.rotated(rotateClockwise),
        source.rotated(rotateCounterclockwise), source.rotated(rotateUpsideDown)]
    check freed == 1 # Actual independent outputs do not keep the source alive.
    var snapshots: seq[RgbaPixels]
    for index in 0..<results.len:
      let expected = results[index].rgbaPixels()
      let host = newOffscreenWindow(expected.width, expected.height)
      let view = newImage()
      host.add(view)
      var resultFreed = 0
      block:
        let output = results[index]
        g.weak_ref(cast[g.PGObject](output.raw), finalized, addr resultFreed)
        view.pixbuf = output
      results[index] = gtk2.Pixbuf()
      check resultFreed == 0 # The native GtkImage owns the output now.
      host.showAll()
      drain()
      let snapshot = host.pixbuf.rgbaPixels()
      check snapshot.width == expected.width and snapshot.height == expected.height
      check snapshot.bytes == expected.bytes
      snapshots.add(snapshot)
      view.pixbuf = gtk2.Pixbuf()
      check resultFreed == 1
      host.destroy()
      check snapshot.bytes == expected.bytes
    check snapshots.len == 7 and snapshots[0].width == 2 and snapshots[4].height == 3
  when defined(posix):
    test "valid RGB final sample ends at inaccessible page: every transform reads only actual samples":
      let page = int(px.sysconf(px.SC_PAGESIZE))
      require page > 32 and page <= high(int) div 2
      let base = px.mmap(nil, page * 2, px.PROT_READ or px.PROT_WRITE,
        px.MAP_PRIVATE or px.MAP_ANONYMOUS, -1, px.Off(0))
      require base != px.MAP_FAILED
      defer: discard px.munmap(base, page * 2)
      let inaccessible = cast[pointer](cast[uint](base) + uint(page))
      require px.mprotect(inaccessible, page, px.PROT_NONE) == 0
      let samples = cast[ptr UncheckedArray[byte]](cast[uint](base) + uint(page - 11))
      for i in 0..<11: samples[i] = 0xdd
      samples[0] = 10; samples[1] = 20; samples[2] = 30
      samples[8] = 40; samples[9] = 50; samples[10] = 60
      var outputs: seq[Pixbuf]
      block:
        let native = p.pixbuf_new_from_data(cast[g.Pguchar](samples), p.COLORSPACE_RGB,
          g.gbool(false), 8, 1, 2, 8, nil, nil)
        require native != nil
        defer: g.g_object_unref(native)
        let source = adoptForTest(native)
        outputs = @[source.cropped(0, 0, 1, 2), source.flipped(true), source.flipped(false),
          source.rotated(rotateNone), source.rotated(rotateClockwise),
          source.rotated(rotateCounterclockwise), source.rotated(rotateUpsideDown)]
        check outputs[2].rgbaPixels().bytes == @[40'u8, 50, 60, 255, 10, 20, 30, 255]
        check source.rgbaPixels().bytes == @[10'u8, 20, 30, 255, 40, 50, 60, 255]
      # After all source refs are gone, destroy even the accessible samples. No output aliases it.
      require px.mprotect(base, page, px.PROT_NONE) == 0
      for output in outputs:
        check not output.hasAlpha and output.rgbaPixels().len == 8
      check outputs[2].flipped(false).rgbaPixels().bytes == @[10'u8, 20, 30, 255, 40, 50, 60, 255]
