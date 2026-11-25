# Actual isolated native compositing/rendering and valid source guard pages.
# No codecs, file writes, selections or synthetic input.
import std/[os, unittest]
when defined(posix): import std/posix as px
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Pixbuf overlays require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "overlay rendering did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc adoptForTest(native: p.PPixbuf): Pixbuf =
  let holder = newImage()
  defer: holder.destroy()
  n.set_from_pixbuf(holder.raw, native)
  holder.pixbuf
gtk2.init()
suite "copied native Pixbuf overlays on isolated display":
  test "actual blended native rendering, source disposal and native image replacement ownership":
    var output: Pixbuf
    var sourceFreed = 0
    block:
      let base = newPixbuf(4, 3, 0x123456ff'u32)
      let overlay = newPixbuf(2, 2, [255'u8, 0, 0, 255, 0, 255, 0, 128,
        0, 0, 255, 0, 199, 37, 83, 254])
      g.weak_ref(cast[g.PGObject](base.raw), finalized, addr sourceFreed)
      g.weak_ref(cast[g.PGObject](overlay.raw), finalized, addr sourceFreed)
      output = base.overlaid(overlay, 2, 1, 128)
    check sourceFreed == 2
    let expected = output.rgbaPixels()
    for i in countup(3, expected.len-1, 4): check expected.bytes[i] == 255
    let host = newOffscreenWindow(4, 3)
    defer: host.destroy()
    let view = newImage()
    host.add(view)
    var resultFreed = 0
    g.weak_ref(cast[g.PGObject](output.raw), finalized, addr resultFreed)
    view.pixbuf = output
    output = gtk2.Pixbuf()
    check resultFreed == 0
    host.showAll()
    drain()
    let snapshot = host.pixbuf.rgbaPixels()
    check snapshot.bytes == expected.bytes
    view.pixbuf = newPixbuf(4, 3, 0xff0000ff'u32)
    check resultFreed == 1
    drain()
    check host.pixbuf.rgbaPixels().bytes != snapshot.bytes
    host.destroy()
    check snapshot.bytes == expected.bytes
  when defined(posix):
    test "RGB/RGBA base and overlay samples end at guard pages; outputs alias neither source":
      for baseAlpha in [false, true]:
        for overlayAlpha in [false, true]:
          let page = int(px.sysconf(px.SC_PAGESIZE))
          require page > 64 and page <= high(int) div 4
          let memory = px.mmap(nil, page*4, px.PROT_READ or px.PROT_WRITE,
            px.MAP_PRIVATE or px.MAP_ANONYMOUS, -1, px.Off(0))
          require memory != px.MAP_FAILED
          defer: discard px.munmap(memory, page*4)
          let guard1 = cast[pointer](cast[uint](memory) + uint(page))
          let guard2 = cast[pointer](cast[uint](memory) + uint(page*3))
          require px.mprotect(guard1, page, px.PROT_NONE) == 0
          require px.mprotect(guard2, page, px.PROT_NONE) == 0
          let bc = (if baseAlpha: 4 else: 3)
          let fc = (if overlayAlpha: 4 else: 3)
          let baseSpan = 16 + 3*bc
          let foreSpan = 8 + fc
          let bg = cast[ptr UncheckedArray[byte]](cast[uint](guard1) - uint(baseSpan))
          let fg = cast[ptr UncheckedArray[byte]](cast[uint](guard2) - uint(foreSpan))
          for i in 0..<baseSpan: bg[i] = byte(i*7 mod 256)
          for i in 0..<foreSpan: fg[i] = byte(255-i*13)
          var outputs: seq[Pixbuf]
          var values: seq[seq[byte]]
          block:
            let rawBase = p.pixbuf_new_from_data(cast[g.Pguchar](bg), p.COLORSPACE_RGB,
              g.gbool(baseAlpha), 8, 3, 2, 16, nil, nil)
            let rawFore = p.pixbuf_new_from_data(cast[g.Pguchar](fg), p.COLORSPACE_RGB,
              g.gbool(overlayAlpha), 8, 1, 2, 8, nil, nil)
            require rawBase != nil and rawFore != nil
            defer: g.g_object_unref(rawBase)
            defer: g.g_object_unref(rawFore)
            let base = adoptForTest(rawBase)
            let overlay = adoptForTest(rawFore)
            let before = base.rgbaPixels().bytes
            let foreBefore = overlay.rgbaPixels().bytes
            for opacity in [0, 1, 128, 255]:
              let image = base.overlaid(overlay, 2, 0, opacity)
              outputs.add(image)
              values.add(image.rgbaPixels().bytes)
            check base.rgbaPixels().bytes == before and overlay.rgbaPixels().bytes == foreBefore
          require px.mprotect(memory, page, px.PROT_NONE) == 0
          require px.mprotect(cast[pointer](cast[uint](memory)+uint(page*2)), page, px.PROT_NONE) == 0
          for i, image in outputs:
            check image.hasAlpha == baseAlpha and image.rgbaPixels().bytes == values[i]
