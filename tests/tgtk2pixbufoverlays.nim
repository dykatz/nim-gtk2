# Unrealized native storage only. No codecs, files, selections or synthetic input.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2pixbuf as p
proc adoptForTest(native: p.PPixbuf): Pixbuf =
  let holder = newImage()
  defer: holder.destroy()
  n.set_from_pixbuf(holder.raw, native)
  holder.pixbuf
type Backing = ref object
  bytes: seq[byte]
  freed: ptr int
proc freeBacking(pixels: g.Pguchar, data: pointer) {.cdecl.} =
  let backing = cast[Backing](data)
  if backing.freed != nil: inc backing.freed[]
  GC_unref(backing)
proc fixture(w, h, channels, stride: int, data: seq[byte], freed: ptr int = nil): Pixbuf =
  doAssert data.len == (h-1)*stride + w*channels
  let backing = Backing(bytes: data, freed: freed)
  GC_ref(backing)
  let native = p.pixbuf_new_from_data(addr backing.bytes[0], p.COLORSPACE_RGB, g.gbool(channels == 4),
    8, w.int32, h.int32, stride.int32, freeBacking, cast[pointer](backing))
  doAssert native != nil
  defer: g.g_object_unref(native)
  adoptForTest(native)
proc reference(base, overlay: Pixbuf, x, y, opacity: int): Pixbuf =
  # Independent direct native reference, with native copy rather than SDK new/copy_area.
  let native = p.copy(base.raw)
  doAssert native != nil
  defer: g.g_object_unref(native)
  p.composite(overlay.raw, native, x.int32, y.int32, overlay.width.int32, overlay.height.int32,
    x.float64, y.float64, 1.0, 1.0, p.INTERP_NEAREST, opacity.int32)
  adoptForTest(native)
gtk2.init()
suite "copied native Pixbuf overlays":
  test "exact opaque placement/unchanged outside rectangle and no source/result aliases":
    let base = newPixbuf(4, 3, 0x123456ff'u32)
    let foreground = newPixbuf(2, 2, [255'u8, 0, 0, 255, 0, 255, 0, 255,
      0, 0, 255, 255, 19, 37, 83, 255])
    let before = base.rgbaPixels().bytes
    let fg = foreground.rgbaPixels().bytes
    let result = base.overlaid(foreground, 2, 1)
    check result.width == 4 and result.height == 3 and result.hasAlpha
    check result.raw != base.raw and result.raw != foreground.raw
    let output = result.rgbaPixels().bytes
    for y in 0..<3:
      for x in 0..<4:
        let index = (y*4+x)*4
        if x >= 2 and y >= 1:
          let source = ((y-1)*2+x-2)*4
          check output[index..<index+4] == fg[source..<source+4]
        else: check output[index..<index+4] == before[index..<index+4]
    check base.rgbaPixels().bytes == before and foreground.rgbaPixels().bytes == fg
    p.fill(result.raw, 0xffffffff'u32)
    check base.rgbaPixels().bytes == before and foreground.rgbaPixels().bytes == fg
  test "actual native RGB/RGBA blending/rounding matches raw reference for all opacity boundaries":
    for baseAlpha in [false, true]:
      let base = if baseAlpha:
        newPixbuf(2, 2, [3'u8, 51, 241, 0, 211, 37, 13, 1, 19, 73, 151, 127, 233, 41, 89, 254])
      else: fixture(2, 2, 3, 8, @[3'u8, 51, 241, 211, 37, 13, 0xee, 0xee, 19, 73, 151, 233, 41, 89])
      let before = base.rgbaPixels().bytes
      for overlayAlpha in [false, true]:
        let overlay = if overlayAlpha:
          newPixbuf(1, 2, [199'u8, 17, 91, 0, 47, 223, 131, 129])
        else: fixture(1, 2, 3, 4, @[199'u8, 17, 91, 0xee, 47, 223, 131])
        let fg = overlay.rgbaPixels().bytes
        for opacity in [0, 1, 127, 128, 254, 255]:
          let output = base.overlaid(overlay, 1, 0, opacity)
          let native = reference(base, overlay, 1, 0, opacity)
          check output.rgbaPixels().bytes == native.rgbaPixels().bytes
          check output.hasAlpha == baseAlpha
          check p.get_n_channels(output.raw) == (if baseAlpha: 4 else: 3)
          check output.raw != base.raw
          check base.rgbaPixels().bytes == before and overlay.rgbaPixels().bytes == fg
  test "same native source and overlapping subpixbuf inputs are safe, results release all backing refs":
    var freed = 0
    var outputs: seq[Pixbuf]
    var snapshots: seq[seq[byte]]
    block:
      var bytes: seq[byte]
      for i in 0..<48: bytes.add(byte(i*5 mod 256))
      let parent = fixture(4, 3, 4, 16, bytes, addr freed)
      let a = p.new_subpixbuf(parent.raw, 0, 0, 3, 2)
      let b = p.new_subpixbuf(parent.raw, 1, 0, 2, 2)
      require a != nil and b != nil
      defer: g.g_object_unref(a)
      defer: g.g_object_unref(b)
      let base = adoptForTest(a)
      let overlay = adoptForTest(b)
      let original = parent.rgbaPixels().bytes
      for opacity in [0, 128, 255]:
        let output = base.overlaid(overlay, 1, 0, opacity)
        check output.rgbaPixels().bytes == reference(base, overlay, 1, 0, opacity).rgbaPixels().bytes
        outputs.add(output)
        snapshots.add(output.rgbaPixels().bytes)
      let same = parent.overlaid(parent, 0, 0, 128)
      check same.raw != parent.raw
      check same.rgbaPixels().bytes == reference(parent, parent, 0, 0, 128).rgbaPixels().bytes
      outputs.add(same)
      snapshots.add(same.rgbaPixels().bytes)
      check parent.rgbaPixels().bytes == original
      p.fill(parent.raw, 0x12345678'u32)
      for i, image in outputs: check image.rgbaPixels().bytes == snapshots[i]
    check freed == 1
    for i, image in outputs: check image.rgbaPixels().bytes == snapshots[i]
  test "RGB unpadded source lifetimes, output independence and rejection pin cleanup":
    var freed = 0
    var retained: Pixbuf
    var expected: seq[byte]
    block:
      let base = fixture(3, 2, 3, 12, @[1'u8, 2, 3, 4, 5, 6, 7, 8, 9,
        0xde, 0xad, 0xbe, 10, 11, 12, 13, 14, 15, 16, 17, 18], addr freed)
      let overlay = fixture(1, 2, 3, 8, @[200'u8, 99, 77, 0, 0, 0, 0, 0, 31, 57, 89], addr freed)
      retained = base.overlaid(overlay, 2, 0, 128)
      expected = reference(base, overlay, 2, 0, 128).rgbaPixels().bytes
      expect ValueError: discard base.overlaid(overlay, 3, 0)
      expect ValueError: discard base.overlaid(default(Pixbuf), 0, 0)
      expect ValueError: discard overlay.overlaid(base, 0, 0)
      check freed == 0
    check freed == 2 and retained.rgbaPixels().bytes == expected
  test "negative/outside/overflow/opacity/empty handle validation leaves inputs unchanged":
    let base = newPixbuf(3, 2, 0x12345678'u32)
    let overlay = newPixbuf(2, 1, 0xabcdef80'u32)
    let before = base.rgbaPixels().bytes
    for xy in [(-1, 0), (0, -1), (2, 0), (0, 2), (high(int), 0), (0, high(int))]:
      expect ValueError: discard base.overlaid(overlay, xy[0], xy[1])
    for opacity in [-1, 256, low(int), high(int)]:
      expect ValueError: discard base.overlaid(overlay, 0, 0, opacity)
    expect ValueError: discard default(Pixbuf).overlaid(overlay, 0, 0)
    expect ValueError: discard base.overlaid(default(Pixbuf), 0, 0)
    check base.rgbaPixels().bytes == before
  test "pure guard precedes coordinates/opacity/handles/native metadata or allocations":
    let image = newPixbuf(2, 3)
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      try: discard image.overlaid(image, 0, 0)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard default(Pixbuf).overlaid(default(Pixbuf), -1, 0, 256)
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 2
