# Included by gtk2ui.nim. Non-floating GObjects; no destroy signal.
type
  Pixbuf* = object of ObjectHandle
  Interpolation* = enum
    interpolateNearest, interpolateTiles, interpolateBilinear, interpolateHyper
  PixbufError* = object of CatchableError
    domain*: g.TGQuark
    code*: int

proc raw*(p: Pixbuf): rawPixbuf.PPixbuf = cast[rawPixbuf.PPixbuf](nativePointer(p))
proc isEmpty*(p: Pixbuf): bool = p.state == nil
proc pixbufPointer(p: Pixbuf): rawPixbuf.PPixbuf =
  if not p.isEmpty: result = p.raw
proc ownedPixbuf(p: rawPixbuf.PPixbuf, borrowed = false): Pixbuf =
  if p == nil: return # Nullable image/model values use an empty handle.
  result.state = adoptObject(p, borrowed = borrowed, cache = true,
    hasDestroySignal = false, sink = false)
proc requiredPixbuf(p: rawPixbuf.PPixbuf): Pixbuf =
  if p == nil: raise newException(PixbufError, "could not allocate pixbuf")
  ownedPixbuf(p)
proc pixbufDimension(value: int): g.gint =
  result = checkedInt(value)
  if result == 0: raise newException(ValueError, "pixbuf dimensions must be positive")
proc newPixbuf*(width, height: int, rgba = 0x00000000'u32): Pixbuf =
  let w = pixbufDimension(width)
  let h = pixbufDimension(height)
  # Reject rowstride and total-size overflow before native allocation.
  if int64(w) * 4 > high(g.gint).int64 or int64(w) * 4 * int64(h) > high(g.gint).int64:
    raise newException(ValueError, "pixbuf allocation exceeds supported size")
  result = requiredPixbuf(rawPixbuf.pixbuf_new(rawPixbuf.COLORSPACE_RGB, g.gbool(true), 8, w, h))
  rawPixbuf.fill(result.raw, rgba)
proc loadPixbuf*(filename: string): Pixbuf =
  let name = checkedString(filename)
  var error: ptr g.GError
  let p = rawPixbuf.pixbuf_new_from_file(name, addr error)
  if error != nil:
    let failure = newException(PixbufError, $error.message)
    failure.domain = error.domain
    failure.code = error.code.int
    g.g_error_free(error)
    if p != nil: g.g_object_unref(p)
    raise failure
  requiredPixbuf(p)
proc width*(p: Pixbuf): int = rawPixbuf.get_width(p.raw).int
proc height*(p: Pixbuf): int = rawPixbuf.get_height(p.raw).int
proc hasAlpha*(p: Pixbuf): bool = g.toBool(rawPixbuf.get_has_alpha(p.raw))
proc copy*(p: Pixbuf): Pixbuf = requiredPixbuf(rawPixbuf.copy(p.raw))
proc scaled*(p: Pixbuf, width, height: int, interpolation = interpolateBilinear): Pixbuf =
  let w = pixbufDimension(width)
  let h = pixbufDimension(height)
  if int64(w) * 4 > high(g.gint).int64 or int64(w) * 4 * int64(h) > high(g.gint).int64:
    raise newException(ValueError, "pixbuf allocation exceeds supported size")
  requiredPixbuf(rawPixbuf.scale_simple(p.raw, w, h, rawPixbuf.TInterpType(ord(interpolation))))

proc newImage*(pixbuf: Pixbuf): Image =
  result.state = adoptWidget(rawGtk.image_new_from_pixbuf(pixbuf.pixbufPointer))
proc `pixbuf=`*(w: Image, value: Pixbuf) = rawGtk.set_from_pixbuf(w.raw, value.pixbufPointer)
proc pixbuf*(w: Image): Pixbuf =
  if w.storageKind == imageEmpty: return
  if w.storageKind != imagePixbuf:
    raise newException(ValueError, "image does not contain a pixbuf")
  ownedPixbuf(rawGtk.get_pixbuf(w.raw), borrowed = true)
