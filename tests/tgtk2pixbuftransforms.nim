# Unrealized storage only: no codecs, files, selections or synthesized input.
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
proc fixture(w, h, channels, stride: int, data: seq[byte], freed: ptr int): Pixbuf =
  let backing = Backing(bytes: data, freed: freed)
  GC_ref(backing)
  let native = p.pixbuf_new_from_data(addr backing.bytes[0], p.COLORSPACE_RGB, g.gbool(channels == 4),
    8, w.int32, h.int32, stride.int32, freeBacking, cast[pointer](backing))
  doAssert native != nil
  defer: g.g_object_unref(native)
  adoptForTest(native)
proc ordered(source: RgbaPixels, indexes: openArray[int]): seq[byte] =
  let data = source.bytes
  for i in indexes:
    for c in 0..3: result.add(data[i*4+c])
static:
  doAssert sizeof(p.TPixbufRotation) == sizeof(cint)
  doAssert ord(p.PIXBUF_ROTATE_COUNTERCLOCKWISE) == 90
  doAssert ord(p.PIXBUF_ROTATE_UPSIDEDOWN) == 180
  doAssert ord(p.PIXBUF_ROTATE_CLOCKWISE) == 270
gtk2.init()
suite "copied Pixbuf geometry transforms":
  test "exact non-square RGBA crop/axes/native rotation directions/zero identity copy":
    let pixels = newRgbaPixels(3, 2, [1'u8, 2, 3, 0, 4, 5, 6, 1, 7, 8, 9, 127,
      10, 11, 12, 128, 13, 14, 15, 254, 16, 17, 18, 255])
    let image = newPixbuf(pixels)
    let crop = image.cropped(1, 0, 2, 2)
    check crop.width == 2 and crop.height == 2 and crop.hasAlpha
    check crop.rgbaPixels().bytes == ordered(pixels, [1, 2, 4, 5])
    let horizontal = image.flipped(horizontal = true)
    let vertical = image.flipped(horizontal = false)
    check horizontal.rgbaPixels().bytes == ordered(pixels, [2, 1, 0, 5, 4, 3])
    check vertical.rgbaPixels().bytes == ordered(pixels, [3, 4, 5, 0, 1, 2])
    let clockwise = image.rotated(rotateClockwise)
    let counter = image.rotated(rotateCounterclockwise)
    check clockwise.width == 2 and clockwise.height == 3
    check counter.width == 2 and counter.height == 3
    check clockwise.rgbaPixels().bytes == ordered(pixels, [3, 0, 4, 1, 5, 2])
    check counter.rgbaPixels().bytes == ordered(pixels, [2, 5, 1, 4, 0, 3])
    check image.rotated(rotateUpsideDown).rgbaPixels().bytes == ordered(pixels, [5, 4, 3, 2, 1, 0])
    let none = image.rotated(rotateNone)
    let full = image.cropped(0, 0, 3, 2)
    check none.raw != image.raw and full.raw != image.raw
    check none.rgbaPixels().bytes == pixels.bytes and full.rgbaPixels().bytes == pixels.bytes
    p.fill(none.raw, 0xffffffff'u32)
    p.fill(full.raw, 0x00000000'u32)
    check image.rgbaPixels().bytes == pixels.bytes
    p.fill(image.raw, 0x12345678'u32)
    check crop.rgbaPixels().bytes == ordered(pixels, [1, 2, 4, 5])
    check vertical.rgbaPixels().bytes == ordered(pixels, [3, 4, 5, 0, 1, 2])
  test "RGB odd padding/unpadded final row, subpixbuf stride, owned outputs release source backing":
    var freed = 0
    var results: seq[Pixbuf]
    var before: seq[seq[byte]]
    block:
      let parent = fixture(3, 2, 3, 12, @[1'u8, 2, 3, 4, 5, 6, 7, 8, 9,
        0xde, 0xad, 0xbe, 10, 11, 12, 13, 14, 15, 16, 17, 18], addr freed)
      let sub = p.new_subpixbuf(parent.raw, 1, 0, 2, 2)
      require sub != nil
      defer: g.g_object_unref(sub)
      let image = adoptForTest(sub)
      let value = image.rgbaPixels()
      check p.get_rowstride(image.raw) == 12 and not image.hasAlpha
      results = @[image.cropped(0, 0, 2, 2), image.flipped(true), image.flipped(false),
        image.rotated(rotateNone), image.rotated(rotateClockwise),
        image.rotated(rotateCounterclockwise), image.rotated(rotateUpsideDown)]
      check results[1].rgbaPixels().bytes == ordered(value, [1, 0, 3, 2])
      check results[2].rgbaPixels().bytes == ordered(value, [2, 3, 0, 1])
      for output in results:
        check not output.hasAlpha and p.get_n_channels(output.raw) == 3
        before.add(output.rgbaPixels().bytes)
      p.fill(parent.raw, 0xffffffff'u32)
      for i, output in results: check output.rgbaPixels().bytes == before[i]
    check freed == 1 # No transformed result retains the subpixbuf or external source.
    for i, output in results: check output.rgbaPixels().bytes == before[i]
  test "single pixels/rows/columns retain dimensions and all-byte RGBA samples":
    var data: seq[byte]
    for i in 0..255: data.add(byte(i))
    let image = newPixbuf(8, 8, data)
    check image.flipped(true).flipped(true).rgbaPixels().bytes == data
    check image.flipped(false).flipped(false).rgbaPixels().bytes == data
    check image.rotated(rotateClockwise).rotated(rotateCounterclockwise).rgbaPixels().bytes == data
    for dimensions in [(1, 1), (1, 5), (5, 1)]:
      let source = newPixbuf(dimensions[0], dimensions[1], 0x12345600'u32)
      for angle in [rotateNone, rotateCounterclockwise, rotateUpsideDown, rotateClockwise]:
        let output = source.rotated(angle)
        check output.width == (if angle in {rotateClockwise, rotateCounterclockwise}: source.height else: source.width)
        check output.rgbaPixels().bytes == source.rgbaPixels().bytes
  test "negative/empty/outside/overflow crop and invalid rotation reject with source unchanged":
    let image = newPixbuf(3, 2, 0x12345678'u32)
    let before = image.rgbaPixels().bytes
    for rect in [(-1, 0, 1, 1), (0, -1, 1, 1), (0, 0, 0, 1), (0, 0, 1, 0),
        (3, 0, 1, 1), (0, 2, 1, 1), (2, 1, 2, 1), (0, 0, high(int), high(int)),
        (high(int), high(int), 1, 1), (0, 0, high(g.gint).int, 1)]:
      expect ValueError: discard image.cropped(rect[0], rect[1], rect[2], rect[3])
    expect ValueError: discard image.rotated(cast[gtk2.PixbufRotation](99))
    expect ValueError: discard default(Pixbuf).cropped(0, 0, 1, 1)
    expect ValueError: discard default(Pixbuf).flipped(true)
    expect ValueError: discard default(Pixbuf).rotated(rotateNone)
    check image.rgbaPixels().bytes == before
  test "source pin releases after post-metadata crop rejection":
    var freed = 0
    block:
      let image = fixture(1, 1, 3, 4, @[1'u8, 2, 3], addr freed)
      expect ValueError: discard image.cropped(1, 0, 1, 1)
      expect ValueError: discard image.cropped(0, 0, high(g.gint).int, 1)
      check freed == 0 and image.rgbaPixels().bytes == @[1'u8, 2, 3, 255]
    check freed == 1
  test "pure guards precede invalid arguments, metadata and native allocations":
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
      try: discard image.cropped(-1, 0, 1, 1)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard image.flipped(false)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard default(Pixbuf).rotated(cast[gtk2.PixbufRotation](99))
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 3
