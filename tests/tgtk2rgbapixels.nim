# Pure values first, then unrealized native storage tests. No codecs/selections/input.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2pixbuf as p
suite "pure owning RGBA8 values before GTK initialization":
  test "dimensions, exact bytes and independent constructor/getter copies":
    var input: seq[byte]
    for i in 0..255: input.add(byte(i))
    let value = newRgbaPixels(8, 8, input)
    input[0] = 99
    var output = value.bytes
    output[1] = 99
    check value.width == 8 and value.height == 8 and value.len == 256 and not value.isEmpty
    check value.bytes[0..3] == @[0'u8, 1, 2, 3]
    check default(RgbaPixels).isEmpty and default(RgbaPixels).len == 0
    check default(RgbaPixels).width == 0 and default(RgbaPixels).height == 0
    check default(RgbaPixels).bytes.len == 0
  test "positive dimensions/exact byte count/gint byte capacity checked before multiplication or allocation":
    for dimensions in [(0, 1), (1, 0), (-1, 1), (1, -1), (high(int), high(int)),
        (1, high(int)), (high(g.gint).int div 4 + 1, 1), (1, high(g.gint).int div 4 + 1)]:
      expect ValueError: discard newRgbaPixels(dimensions[0], dimensions[1], [])
    expect ValueError: discard newRgbaPixels(1, 1, [])
    expect ValueError: discard newRgbaPixels(1, 1, [0'u8, 1, 2])
    expect ValueError: discard newRgbaPixels(1, 1, [0'u8, 1, 2, 3, 4])

type Backing = ref object
  bytes: seq[byte]
  freed: ptr int
proc freeBacking(pixels: g.Pguchar, data: pointer) {.cdecl.} =
  let backing = cast[Backing](data)
  inc backing.freed[]
  GC_unref(backing)
proc adoptForTest(native: p.PPixbuf): Pixbuf =
  # Use the audited public owning Image getter, never private SDK state/layout access.
  let holder = newImage()
  defer: holder.destroy()
  n.set_from_pixbuf(holder.raw, native)
  result = holder.pixbuf
proc fixture(width, height, channels, stride: int, bytes: seq[byte], freed: ptr int): Pixbuf =
  let backing = Backing(bytes: bytes, freed: freed)
  GC_ref(backing)
  let native = p.pixbuf_new_from_data(addr backing.bytes[0], p.COLORSPACE_RGB, g.gbool(channels == 4),
    8, width.int32, height.int32, stride.int32, freeBacking, cast[pointer](backing))
  doAssert native != nil
  defer: g.g_object_unref(native)
  adoptForTest(native)
gtk2.init()
suite "copied native RGBA pixel snapshots and construction":
  test "RGB odd row padding and unpadded final row normalize only actual samples":
    var freed = 0
    var value: RgbaPixels
    block:
      let image = fixture(3, 2, 3, 12, @[1'u8, 2, 3, 4, 5, 6, 7, 8, 9,
        0xde, 0xad, 0xbe, 10, 11, 12, 13, 14, 15, 16, 17, 18], addr freed)
      check not image.hasAlpha and p.get_rowstride(image.raw) == 12
      value = image.rgbaPixels(maxBytes = 24)
      check value.bytes == @[1'u8, 2, 3, 255, 4, 5, 6, 255, 7, 8, 9, 255,
        10, 11, 12, 255, 13, 14, 15, 255, 16, 17, 18, 255]
      expect ValueError: discard image.rgbaPixels(maxBytes = 23)
      expect ValueError: discard image.rgbaPixels(maxBytes = 0)
      let source = cast[ptr UncheckedArray[byte]](p.get_pixels(image.raw))
      source[0] = 99
      check value.bytes[0] == 1
    check freed == 1 # Pure values never retain native storage or its external backing.
    let rebuilt = newPixbuf(value)
    check rebuilt.hasAlpha and rebuilt.width == 3 and rebuilt.height == 2
    check rebuilt.rgbaPixels().bytes == value.bytes
  test "RGBA straight alpha/transparent RGB, larger stride and subpixbuf storage":
    var freed = 0
    block:
      let image = fixture(1, 2, 4, 8, @[1'u8, 2, 3, 0, 0xde, 0xad, 0xbe, 0xef,
        255, 128, 0, 127], addr freed)
      let value = image.rgbaPixels(maxBytes = 8)
      check value.bytes == @[1'u8, 2, 3, 0, 255, 128, 0, 127]
      let rebuilt = newPixbuf(value)
      check rebuilt.rgbaPixels().bytes == value.bytes
      p.fill(rebuilt.raw, 0x11223380'u32)
      check value.bytes == @[1'u8, 2, 3, 0, 255, 128, 0, 127]
    check freed == 1
    block:
      let parent = newPixbuf(4, 3, 0x12345680'u32)
      let native = p.new_subpixbuf(parent.raw, 1, 1, 1, 2)
      defer: g.g_object_unref(native)
      let child = adoptForTest(native)
      check p.get_rowstride(child.raw) > child.width * 4
      check child.rgbaPixels().bytes == @[0x12'u8, 0x34, 0x56, 0x80, 0x12, 0x34, 0x56, 0x80]
  test "constructed native pixels never borrow pure/caller arrays; all byte values and independent images":
    var input: seq[byte]
    for i in 0..255: input.add(byte(i))
    var image: Pixbuf
    block:
      let value = newRgbaPixels(8, 8, input)
      image = newPixbuf(value)
      let other = newPixbuf(value)
      p.fill(other.raw, 0x00000000'u32)
    input[0] = 99
    check image.rgbaPixels().bytes[0..3] == @[0'u8, 1, 2, 3]
    let direct = newPixbuf(1, 1, [255'u8, 0, 128, 127])
    check direct.rgbaPixels().bytes == @[255'u8, 0, 128, 127]
    expect ValueError: discard newPixbuf(default(RgbaPixels))
    expect ValueError: discard newPixbuf(1, 1, [])
    expect ValueError: discard default(Pixbuf).rgbaPixels()
    expect ValueError: discard image.rgbaPixels(maxBytes = -1)
    when sizeof(int) > sizeof(g.gint):
      expect ValueError: discard image.rgbaPixels(maxBytes = high(g.gint).int + 1)
  test "pure copied values are usable in model functions; native pixel operations reject early":
    let image = newPixbuf(2, 3)
    let value = newRgbaPixels(1, 1, [0'u8, 255, 128, 0])
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    template deny(body: untyped) =
      try: body
      except ValueError as error:
        if error.msg == guard: inc denied
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      let local = newRgbaPixels(value.width, value.height, value.bytes)
      check local.bytes == value.bytes and local.len == 4
      deny: discard image.rgbaPixels()
      deny: discard default(Pixbuf).rgbaPixels(maxBytes = -1)
      deny: discard newPixbuf(value)
      deny: discard newPixbuf(0, 0, [])
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 4
    check image.rgbaPixels().width == 2 # Guard restored.
