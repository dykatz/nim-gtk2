# Unrealized pixel storage only: no codecs, files, selections or synthesized input.
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
  doAssert data.len == (h-1)*stride+w*channels
  let backing = Backing(bytes: data, freed: freed)
  GC_ref(backing)
  let native = p.pixbuf_new_from_data(addr backing.bytes[0], p.COLORSPACE_RGB, g.gbool(channels == 4),
    8, w.int32, h.int32, stride.int32, freeBacking, cast[pointer](backing))
  doAssert native != nil
  defer: g.g_object_unref(native)
  adoptForTest(native)
proc reference(image: Pixbuf, backgroundRgb: uint32): Pixbuf =
  let native = p.pixbuf_new(p.COLORSPACE_RGB, g.gbool(false), 8, image.width.int32, image.height.int32)
  doAssert native != nil
  defer: g.g_object_unref(native)
  # Independent channel packing, not the SDK shift of a 24-bit word.
  let red = (backgroundRgb shr 16) and 255
  let green = (backgroundRgb shr 8) and 255
  let blue = backgroundRgb and 255
  p.fill(native, red*0x1000000'u32 + green*0x10000'u32 + blue*0x100'u32 + 255)
  p.composite(image.raw, native, 0, 0, image.width.int32, image.height.int32,
    0.0, 0.0, 1.0, 1.0, p.INTERP_NEAREST, 255)
  adoptForTest(native)
gtk2.init()
suite "copied Pixbuf alpha conversion":
  test "RGB becomes RGBA with exact RGB key/high-bit channels and preserved transparent RGB":
    var freed = 0
    var outputs: seq[Pixbuf]
    var snapshots: seq[seq[byte]]
    block:
      let image = fixture(3, 2, 3, 12, @[128'u8, 255, 1, 128, 255, 2, 0, 0, 0,
        0xde, 0xad, 0xbe, 128, 255, 1, 255, 128, 1, 255, 255, 255], addr freed)
      let before = image.rgbaPixels().bytes
      let alpha = image.withAlpha()
      check alpha.hasAlpha and p.get_n_channels(alpha.raw) == 4
      check alpha.rgbaPixels().bytes == before
      let keyed = image.withAlpha(keyRgb = 0x80ff01'u32)
      check keyed.rgbaPixels().bytes == @[128'u8, 255, 1, 0, 128, 255, 2, 255, 0, 0, 0, 255,
        128, 255, 1, 0, 255, 128, 1, 255, 255, 255, 255, 255]
      let black = image.withAlpha(0'u32)
      check black.rgbaPixels().bytes[8..<12] == @[0'u8, 0, 0, 0]
      check alpha.raw != image.raw and keyed.raw != image.raw
      outputs = @[alpha, keyed, black]
      for output in outputs: snapshots.add(output.rgbaPixels().bytes)
      p.fill(image.raw, 0xffffffff'u32)
      for i, output in outputs: check output.rgbaPixels().bytes == snapshots[i]
    check freed == 1
    for i, output in outputs: check output.rgbaPixels().bytes == snapshots[i]
  test "existing RGBA is copied, key zeros only matches and preserves all nonmatching alpha":
    let samples = @[128'u8, 255, 1, 1, 128, 255, 2, 0, 0, 0, 0, 127,
      128, 255, 1, 255, 255, 128, 1, 254, 255, 255, 255, 255]
    let image = newPixbuf(3, 2, samples)
    let alpha = image.withAlpha()
    let keyed = image.withAlpha(0x80ff01'u32)
    check alpha.raw != image.raw and alpha.rgbaPixels().bytes == samples
    var expected = samples
    expected[3] = 0
    expected[15] = 0
    check keyed.rgbaPixels().bytes == expected
    p.fill(alpha.raw, 0xffffffff'u32)
    p.fill(keyed.raw, 0x00000000'u32)
    check image.rgbaPixels().bytes == samples
    var all: seq[byte]
    for i in 0..255: all.add(byte(i))
    check newPixbuf(8, 8, all).withAlpha().rgbaPixels().bytes == all
  test "explicit opaque RGB background, exact opaque/transparent cases and native fractional rounding":
    let samples = @[111'u8, 47, 199, 0, 193, 51, 17, 1, 19, 73, 151, 127,
      17, 223, 131, 128, 233, 41, 89, 254, 0xde, 0xad, 0xbe, 255]
    let image = newPixbuf(3, 2, samples)
    for background in [0'u32, 0xffffff'u32, 0x102030'u32, 0x80ffe1'u32]:
      let flat = image.flattened(backgroundRgb = background)
      check flat.width == 3 and flat.height == 2 and not flat.hasAlpha
      check p.get_n_channels(flat.raw) == 3 and flat.raw != image.raw
      let bytes = flat.rgbaPixels().bytes
      check bytes == reference(image, background).rgbaPixels().bytes
      check bytes[0..<4] == @[byte(background shr 16), byte((background shr 8) and 255), byte(background and 255), 255'u8]
      check bytes[20..<24] == @[0xde'u8, 0xad, 0xbe, 255]
      for i in countup(3, bytes.high, 4): check bytes[i] == 255
      p.fill(flat.raw, 0x000000ff'u32)
      check image.rgbaPixels().bytes == samples
  test "RGB flatten/subpixbuf inputs/unpadded final rows and outputs retain no backing":
    var freed = 0
    var outputs: seq[Pixbuf]
    var snapshots: seq[seq[byte]]
    block:
      let parent = fixture(3, 2, 3, 12, @[1'u8, 2, 3, 4, 5, 6, 7, 8, 9,
        0xde, 0xad, 0xbe, 10, 11, 12, 13, 14, 15, 16, 17, 18], addr freed)
      let native = p.new_subpixbuf(parent.raw, 1, 0, 2, 2)
      require native != nil
      defer: g.g_object_unref(native)
      let image = adoptForTest(native)
      let before = image.rgbaPixels().bytes
      outputs = @[image.flattened(0x123456'u32), image.withAlpha(), image.withAlpha(0x040506'u32)]
      check not outputs[0].hasAlpha and outputs[0].rgbaPixels().bytes == before
      for output in outputs: snapshots.add(output.rgbaPixels().bytes)
      expect ValueError: discard image.withAlpha(0x1000000'u32)
      expect ValueError: discard image.flattened(0xffffffff'u32)
      p.fill(parent.raw, 0xffffffff'u32)
      for i, output in outputs: check output.rgbaPixels().bytes == snapshots[i]
    check freed == 1
    for i, output in outputs: check output.rgbaPixels().bytes == snapshots[i]
  test "invalid RGB words/empty handles reject without modifying source":
    let image = newPixbuf(2, 3, 0x12345678'u32)
    let before = image.rgbaPixels().bytes
    for color in [0x1000000'u32, 0xff000000'u32, high(uint32)]:
      expect ValueError: discard image.withAlpha(color)
      expect ValueError: discard image.flattened(color)
    expect ValueError: discard default(Pixbuf).withAlpha()
    expect ValueError: discard default(Pixbuf).withAlpha(0'u32)
    expect ValueError: discard default(Pixbuf).flattened(0'u32)
    check image.rgbaPixels().bytes == before
  test "early pure guard precedes key/background validation and native handle/format work":
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
      try: discard image.withAlpha()
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard default(Pixbuf).withAlpha(high(uint32))
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard image.flattened(high(uint32))
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls*3
