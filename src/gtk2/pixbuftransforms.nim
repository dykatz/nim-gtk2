# Included after pixbufs. Independent pixels via public native transforms/copies only.
type PixbufRotation* = enum
  rotateNone, rotateCounterclockwise, rotateUpsideDown, rotateClockwise

type TransformInfo = tuple[w, h, channels: int, alpha: bool]
proc transformInfo(p: rawPixbuf.PPixbuf): TransformInfo =
  result = (rawPixbuf.get_width(p).int, rawPixbuf.get_height(p).int,
    rawPixbuf.get_n_channels(p).int, g.toBool(rawPixbuf.get_has_alpha(p)))
  if result.w <= 0 or result.h <= 0 or rawPixbuf.get_colorspace(p) != rawPixbuf.COLORSPACE_RGB or
      rawPixbuf.get_bits_per_sample(p) != 8 or result.channels != (if result.alpha: 4 else: 3):
    raise newException(ValueError, "pixbuf transforms require native RGB8 or RGBA8 storage")
  let stride = rawPixbuf.get_rowstride(p).int64
  let row = result.w.int64 * result.channels
  # Native per-pixel transforms use gint offsets; final padding need not exist.
  if stride < row or (result.h.int64 - 1) * stride + row > high(g.gint).int64:
    raise newException(ValueError, "pixbuf transform source stride/span is unsupported")

proc checkTransformAllocation(w, h, channels: int) =
  let stride = (w.int64 * channels + 3) and not 3'i64
  if stride <= 0 or stride > high(g.gint).int64 or h.int64 > high(g.gint).int64 div stride:
    raise newException(ValueError, "pixbuf transform allocation exceeds supported size")

proc cropped*(image: Pixbuf, x, y, width, height: int): Pixbuf =
  requireOutsideModelFunction()
  let sx = checkedInt(x)
  let sy = checkedInt(y)
  let w = pixbufDimension(width)
  let h = pixbufDimension(height)
  let p = image.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let info = transformInfo(p)
  # Subtraction after origin checks avoids x+width/y+height overflow.
  if sx >= info.w or sy >= info.h or w > info.w - sx or h > info.h - sy:
    raise newException(ValueError, "pixbuf crop is outside source bounds")
  checkTransformAllocation(w.int, h.int, info.channels)
  result = requiredPixbuf(rawPixbuf.pixbuf_new(rawPixbuf.COLORSPACE_RGB, g.gbool(info.alpha), 8, w, h))
  rawPixbuf.copy_area(p, sx, sy, w, h, result.raw, 0, 0)

proc flipped*(image: Pixbuf, horizontal: bool): Pixbuf =
  requireOutsideModelFunction()
  let p = image.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let info = transformInfo(p)
  checkTransformAllocation(info.w, info.h, info.channels)
  if horizontal:
    return requiredPixbuf(rawPixbuf.flip(p, g.gbool(true)))
  # Native vertical flip copies padding beyond a valid unpadded final RGB row.
  # Compose two actual public per-pixel native transforms instead; no layout repair.
  let turned = rawPixbuf.rotate_simple(p, rawPixbuf.PIXBUF_ROTATE_UPSIDEDOWN)
  if turned == nil: raise newException(PixbufError, "could not allocate pixbuf")
  defer: g.g_object_unref(turned)
  requiredPixbuf(rawPixbuf.flip(turned, g.gbool(true)))

proc rotated*(image: Pixbuf, rotation: PixbufRotation): Pixbuf =
  requireOutsideModelFunction()
  if ord(rotation) < ord(low(PixbufRotation)) or ord(rotation) > ord(high(PixbufRotation)):
    raise newException(ValueError, "invalid pixbuf rotation")
  let p = image.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let info = transformInfo(p)
  if rotation in {rotateCounterclockwise, rotateClockwise}:
    checkTransformAllocation(info.h, info.w, info.channels)
  else:
    checkTransformAllocation(info.w, info.h, info.channels)
  let angle = case rotation
    of rotateNone: rawPixbuf.PIXBUF_ROTATE_NONE
    of rotateCounterclockwise: rawPixbuf.PIXBUF_ROTATE_COUNTERCLOCKWISE
    of rotateUpsideDown: rawPixbuf.PIXBUF_ROTATE_UPSIDEDOWN
    of rotateClockwise: rawPixbuf.PIXBUF_ROTATE_CLOCKWISE
  requiredPixbuf(rawPixbuf.rotate_simple(p, angle))
