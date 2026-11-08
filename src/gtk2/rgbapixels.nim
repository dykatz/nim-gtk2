# Included after pixbufs. Pure copied RGBA8 values; no native pixel aliases or codecs.
type RgbaPixels* = object
  w, h: int
  payload: seq[byte] # Tightly packed, straight (not premultiplied), R/G/B/A byte order.

proc rgbaByteCount(width, height: int): int =
  if width <= 0 or height <= 0:
    raise newException(ValueError, "RGBA dimensions must be positive")
  # Short circuit before multiplication: safe on both 32-bit and 64-bit Nim.
  if width > high(g.gint).int div 4 or height > high(g.gint).int div (width * 4):
    raise newException(ValueError, "RGBA pixels exceed gint byte capacity")
  width * 4 * height
proc newRgbaPixels*(width, height: int, bytes: openArray[byte]): RgbaPixels =
  let size = rgbaByteCount(width, height)
  if bytes.len != size: raise newException(ValueError, "RGBA byte count must equal width*height*4")
  result = RgbaPixels(w: width, h: height, payload: newSeq[byte](size))
  copyMem(addr result.payload[0], unsafeAddr bytes[0], size)
proc width*(value: RgbaPixels): int = value.w
proc height*(value: RgbaPixels): int = value.h
proc len*(value: RgbaPixels): int = value.payload.len
proc isEmpty*(value: RgbaPixels): bool = value.w == 0 # Default value, not a constructible zero-size image.
proc bytes*(value: RgbaPixels): seq[byte] =
  result = newSeq[byte](value.payload.len)
  if result.len > 0: copyMem(addr result[0], unsafeAddr value.payload[0], result.len)

proc checkPixelSpan(width, height, channels, stride: int) =
  # Only the final row's actual samples need exist; never require/read final padding.
  if stride < width * channels or
      int64(height - 1) * stride.int64 + int64(width * channels) > high(int).int64:
    raise newException(ValueError, "pixbuf rowstride or address span is unsupported")
proc rgbaPixels*(image: Pixbuf, maxBytes = 16 * 1024 * 1024): RgbaPixels =
  ## Copy native RGB8/RGBA8 samples, normalizing RGB alpha to 255. Limit our output only.
  requireOutsideModelFunction()
  if maxBytes < 0 or maxBytes > high(g.gint).int:
    raise newException(ValueError, "RGBA maxBytes must be in 0..2147483647")
  let p = image.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let w = rawPixbuf.get_width(p).int
  let h = rawPixbuf.get_height(p).int
  let size = rgbaByteCount(w, h)
  if size > maxBytes: raise newException(ValueError, "RGBA snapshot exceeds maxBytes")
  let channels = rawPixbuf.get_n_channels(p).int
  let alpha = g.toBool(rawPixbuf.get_has_alpha(p))
  if rawPixbuf.get_colorspace(p) != rawPixbuf.COLORSPACE_RGB or rawPixbuf.get_bits_per_sample(p) != 8 or
      channels != (if alpha: 4 else: 3):
    raise newException(ValueError, "RGBA snapshots require native RGB8 or RGBA8 storage")
  let stride = rawPixbuf.get_rowstride(p).int
  checkPixelSpan(w, h, channels, stride)
  let source = cast[ptr UncheckedArray[byte]](rawPixbuf.get_pixels(p))
  if source == nil: raise newException(ValueError, "missing pixbuf pixels")
  result = RgbaPixels(w: w, h: h, payload: newSeq[byte](size))
  let rowBytes = w * 4
  for y in 0..<h:
    let src = y * stride
    let dest = y * rowBytes
    if alpha:
      copyMem(addr result.payload[dest], addr source[src], rowBytes)
    else:
      for x in 0..<w:
        let s = src + x * 3
        let d = dest + x * 4
        result.payload[d] = source[s]
        result.payload[d+1] = source[s+1]
        result.payload[d+2] = source[s+2]
        result.payload[d+3] = 255
proc newPixbuf*(value: RgbaPixels): Pixbuf =
  ## Allocate native-owned RGBA8 pixels and copy rows. Never new_from_data/borrowed storage.
  requireOutsideModelFunction()
  let size = rgbaByteCount(value.w, value.h) # Reject default/invalid before native allocation.
  if value.payload.len != size: raise newException(ValueError, "RGBA byte count must equal width*height*4")
  result = requiredPixbuf(rawPixbuf.pixbuf_new(rawPixbuf.COLORSPACE_RGB, g.gbool(true), 8,
    g.gint(value.w), g.gint(value.h)))
  let stride = rawPixbuf.get_rowstride(result.raw).int
  checkPixelSpan(value.w, value.h, 4, stride)
  let dest = cast[ptr UncheckedArray[byte]](rawPixbuf.get_pixels(result.raw))
  if dest == nil: raise newException(ValueError, "missing pixbuf pixels")
  let rowBytes = value.w * 4
  for y in 0..<value.h:
    copyMem(addr dest[y * stride], unsafeAddr value.payload[y * rowBytes], rowBytes)
proc newPixbuf*(width, height: int, rgba: openArray[byte]): Pixbuf =
  ## Convenience construction through a private owning value, not a mutable data alias.
  requireOutsideModelFunction()
  newPixbuf(newRgbaPixels(width, height, rgba))
