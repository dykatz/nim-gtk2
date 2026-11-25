# Unrealized native pixels only, no codecs/files/selections/input.
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
  inc backing.freed[]
  GC_unref(backing)
proc fixture(freed: ptr int): Pixbuf =
  let backing = Backing(bytes: @[1'u8, 2, 3, 4, 5, 6, 7, 8, 9,
    0xde, 0xad, 0xbe, 10, 11, 12, 13, 14, 15, 16, 17, 18], freed: freed)
  GC_ref(backing)
  let native = p.pixbuf_new_from_data(addr backing.bytes[0], p.COLORSPACE_RGB, g.gbool(false),
    8, 3, 2, 12, freeBacking, cast[pointer](backing))
  doAssert native != nil
  defer: g.g_object_unref(native)
  adoptForTest(native)
proc reference(image: Pixbuf, w, h: int, interpolation: p.TInterpType): Pixbuf =
  let native = p.scale_simple(image.raw, w.int32, h.int32, interpolation)
  doAssert native != nil
  defer: g.g_object_unref(native)
  adoptForTest(native)
gtk2.init()
suite "copied aspect-fit Pixbuf scaling":
  test "integer floor limiting axis, one-pixel minimum, default no upscale and optional enlargement":
    let landscape = newPixbuf(6, 4, 0x123456ff'u32)
    for item in [(3, 3, 3, 2), (6, 2, 3, 2), (5, 3, 4, 3), (3, 10, 3, 2),
        (1, 1, 1, 1), (7, 7, 6, 4), (6, 4, 6, 4), (100, 100, 6, 4)]:
      let fit = landscape.fitted(item[0], item[1])
      check fit.width == item[2] and fit.height == item[3]
      check fit.width <= item[0] and fit.height <= item[1] and fit.raw != landscape.raw
    let enlarged = landscape.fitted(7, 7, allowUpscale = true)
    check enlarged.width == 7 and enlarged.height == 4
    let portrait = newPixbuf(4, 6)
    let fitted = portrait.fitted(3, 5)
    check fitted.width == 3 and fitted.height == 4
    for dimensions in [(1, 1), (1, 257), (257, 1)]:
      let source = newPixbuf(dimensions[0], dimensions[1])
      let pixel = source.fitted(1, 1)
      check pixel.width == 1 and pixel.height == 1
    let square = newPixbuf(1, 1).fitted(8, 5, allowUpscale = true)
    check square.width == 5 and square.height == 5
  test "actual native interpolation values/alpha/rounding with independent input/output pixels":
    var data: seq[byte]
    for i in 0..255: data.add(byte(i))
    let image = newPixbuf(8, 8, data)
    let modes = [p.INTERP_NEAREST, p.INTERP_TILES, p.INTERP_BILINEAR, p.INTERP_HYPER]
    for mode in [interpolateNearest, interpolateTiles, interpolateBilinear, interpolateHyper]:
      for size in [3, 11]:
        let fit = image.fitted(size, size, allowUpscale = true, interpolation = mode)
        check fit.hasAlpha and fit.width == size and fit.height == size
        check fit.rgbaPixels().bytes == reference(image, size, size, modes[ord(mode)]).rgbaPixels().bytes
        p.fill(fit.raw, 0xffffffff'u32)
        check image.rgbaPixels().bytes == data
      let same = image.fitted(10, 10, interpolation = mode)
      check same.raw != image.raw and same.rgbaPixels().bytes == data
      let rounded = image.fitted(8, 9, allowUpscale = true, interpolation = mode)
      check rounded.raw != image.raw and rounded.rgbaPixels().bytes == data
    let nearest = newPixbuf(2, 1, [255'u8, 0, 0, 255, 0, 0, 255, 255]).fitted(
      4, 2, allowUpscale = true, interpolation = interpolateNearest)
    check nearest.rgbaPixels().bytes == @[
      255'u8, 0, 0, 255, 255, 0, 0, 255, 0, 0, 255, 255, 0, 0, 255, 255,
      255, 0, 0, 255, 255, 0, 0, 255, 0, 0, 255, 255, 0, 0, 255, 255]
  test "RGB odd-stride/final-row/subpixbuf/no-op copies release source backing after scaling":
    var freed = 0
    var outputs: seq[Pixbuf]
    var snapshots: seq[seq[byte]]
    block:
      let parent = fixture(addr freed)
      let native = p.new_subpixbuf(parent.raw, 1, 0, 2, 2)
      require native != nil
      defer: g.g_object_unref(native)
      let image = adoptForTest(native)
      let original = image.rgbaPixels().bytes
      outputs = @[image.fitted(4, 4), image.fitted(1, 1), image.fitted(5, 5, allowUpscale = true)]
      check outputs[0].raw != image.raw and outputs[0].rgbaPixels().bytes == original
      for output in outputs:
        check not output.hasAlpha and p.get_n_channels(output.raw) == 3
        snapshots.add(output.rgbaPixels().bytes)
      expect ValueError: discard image.fitted(high(g.gint).int, high(g.gint).int, allowUpscale = true)
      p.fill(parent.raw, 0xffffffff'u32)
      for i, output in outputs: check output.rgbaPixels().bytes == snapshots[i]
    check freed == 1
    for i, output in outputs: check output.rgbaPixels().bytes == snapshots[i]
  test "huge boxes no upscale allocate only source; requested huge outputs reject without native allocation":
    let image = newPixbuf(2, 3)
    let boxed = image.fitted(high(g.gint).int, high(g.gint).int)
    check boxed.width == 2 and boxed.height == 3 and boxed.raw != image.raw
    expect ValueError: discard image.fitted(high(g.gint).int, high(g.gint).int, allowUpscale = true)
    for dimensions in [(0, 1), (1, 0), (-1, 1), (1, -1), (low(int), 1)]:
      expect ValueError: discard image.fitted(dimensions[0], dimensions[1])
    when sizeof(int) > sizeof(g.gint):
      expect ValueError: discard image.fitted(high(int), 1)
    expect ValueError: discard image.fitted(3, 3, interpolation = cast[Interpolation](99))
    expect ValueError: discard default(Pixbuf).fitted(1, 1)
    check image.width == 2 and image.height == 3
  test "early pure guards precede dimensions/enum/handle/native metadata/allocation":
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
      try: discard image.fitted(1, 1)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard default(Pixbuf).fitted(-1, 0, interpolation = cast[Interpolation](99))
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls*2
