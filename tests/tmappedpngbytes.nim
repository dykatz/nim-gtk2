# Opted-in native encoding. Only self-produced trusted tiny PNG bytes are decoded,
# via raw public loader APIs in this test; no SDK decoder or filesystem writes.
import std/[os, unittest]
import gtk2
import headers/gtk2 as n
import headers/gdk2pixbuf as p
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("PNG byte tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc decodeTrusted(value: PngBytes): Pixbuf =
  let data = value.bytes
  doAssert data.len > 0
  var error: ptr g.GError
  defer:
    if error != nil: g.g_error_free(error)
  let loader = p.pixbuf_loader_new("png", addr error)
  doAssert loader != nil and error == nil
  var closed = false
  defer:
    if not closed: discard p.close(loader, nil)
    g.g_object_unref(loader)
  doAssert g.toBool(p.write(loader, cast[g.Pguchar](unsafeAddr data[0]), g.gsize(data.len), addr error))
  let ok = p.close(loader, addr error)
  closed = true
  doAssert g.toBool(ok) and error == nil
  let image = p.get_pixbuf(loader)
  doAssert image != nil
  let holder = newImage()
  defer: holder.destroy()
  n.set_from_pixbuf(holder.raw, image)
  holder.pixbuf
proc checkSignature(value: PngBytes) =
  let bytes = value.bytes
  doAssert bytes.len > 8
  doAssert bytes[0..<8] == @[137'u8, 80, 78, 71, 13, 10, 26, 10]
  doAssert 0'u8 in bytes and 137'u8 in bytes # Binary output is not a NUL-terminated string.
gtk2.init()
suite "copied native PNG byte encoding":
  test "real RGBA pixels/transparent RGB, all-byte payload, owned copies after source release":
    let pixels = newRgbaPixels(3, 2, [1'u8, 2, 3, 0, 255, 128, 0, 127, 19, 57, 211, 255,
      0, 255, 128, 1, 250, 2, 179, 128, 3, 4, 5, 254])
    var encoded: PngBytes
    var freed = 0
    block:
      let image = newPixbuf(pixels)
      g.weak_ref(cast[g.PGObject](image.raw), finalized, addr freed)
      encoded = image.encodePng()
      check image.rgbaPixels().bytes == pixels.bytes
    check freed == 1
    check not encoded.isEmpty
    checkSignature(encoded)
    let alias = encoded
    var changed = encoded.bytes
    changed[0] = 0
    changed.setLen(0)
    checkSignature(alias)
    let decoded = decodeTrusted(encoded)
    check decoded.width == 3 and decoded.height == 2 and decoded.hasAlpha
    check decoded.rgbaPixels().bytes == pixels.bytes
    var samples: seq[byte]
    for i in 0..255: samples.add(byte(i))
    let all = newPixbuf(8, 8, samples).encodePng()
    check decodeTrusted(all).rgbaPixels().bytes == samples
  test "native RGB encoding retains RGB; re-encoding does not mutate earlier owned output":
    let native = p.pixbuf_new(p.COLORSPACE_RGB, g.gbool(false), 8, 3, 2)
    require native != nil
    defer: g.g_object_unref(native)
    p.fill(native, 0x123456ff'u32)
    let holder = newImage()
    defer: holder.destroy()
    n.set_from_pixbuf(holder.raw, native)
    let image = holder.pixbuf
    let before = image.encodePng()
    let snapshot = before.bytes
    p.fill(native, 0xabcdef00'u32) # Actual later native pixel mutation, outside synchronous decisions.
    let after = image.encodePng()
    check before.bytes == snapshot
    let oldImage = decodeTrusted(before)
    let newImage = decodeTrusted(after)
    check not oldImage.hasAlpha and not newImage.hasAlpha
    check oldImage.rgbaPixels().bytes[0..<4] == @[0x12'u8, 0x34, 0x56, 255]
    check newImage.rgbaPixels().bytes[0..<4] == @[0xab'u8, 0xcd, 0xef, 255]
  test "post-encode exact/short/zero/high-int bounds and success/rejection image pin cleanup":
    var freed = 0
    block:
      let image = newPixbuf(2, 3, 0x12345678'u32)
      g.weak_ref(cast[g.PGObject](image.raw), finalized, addr freed)
      let first = image.encodePng()
      check first.len > 0
      let exact = image.encodePng(first.len)
      check decodeTrusted(exact).rgbaPixels().bytes == image.rgbaPixels().bytes
      for bound in [0, 1, first.len - 1]:
        try:
          discard image.encodePng(bound)
          check false
        except ValueError as error: check error.msg == "PNG encoding exceeds maxBytes"
      let unlimited = image.encodePng(high(int)) # No allocation of the requested cap itself.
      check decodeTrusted(unlimited).rgbaPixels().bytes == image.rgbaPixels().bytes
      check freed == 0
    check freed == 1
    block:
      let image = newPixbuf(1, 1)
      g.weak_ref(cast[g.PGObject](image.raw), finalized, addr freed)
      expect ValueError: discard image.encodePng(0)
    check freed == 2 # Rejection after native allocation retains no native image pin.
  test "real raw buffer-encoder GError ownership on unsupported format; fixed PNG still works":
    # Native-only error probe: SDK has no format parameter; do not fake its PNG failure.
    let image = newPixbuf(2, 3)
    var buffer: cstring
    var size: g.gsize
    var error: ptr g.GError
    defer:
      if buffer != nil: g.g_free(buffer)
      if error != nil: g.g_error_free(error)
    let ok = p.save_to_bufferv(image.raw, addr buffer, addr size,
      "nim-gtk2-no-such-image-format", nil, nil, addr error)
    check not g.toBool(ok)
    require error != nil
    check error.domain == p.pixbuf_error_quark()
    check error.code == p.PIXBUF_ERROR_UNKNOWN_TYPE.ord
    check buffer == nil and size == 0
    let copied = $error.message
    check copied.len > 0
    g.g_error_free(error)
    error = nil
    let encoded = image.encodePng()
    check decodeTrusted(encoded).rgbaPixels().bytes == image.rgbaPixels().bytes
    check copied.len > 0
  test "nonempty copied values remain pure inside synchronous decisions":
    let value = newPixbuf(2, 3).encodePng()
    let baseline = value.bytes
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, pure = 0
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      var copy = value.bytes
      copy[0] = 0
      if not value.isEmpty and value.len == baseline.len and value.bytes == baseline: inc pure
      true)
    completion.refilter()
    check calls > 0 and pure == calls
