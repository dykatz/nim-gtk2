# Included after pixbuftransforms. Explicit copied aspect fit, no widget/background policy.
proc fitted*(image: Pixbuf, maxWidth, maxHeight: int, allowUpscale = false,
             interpolation = interpolateBilinear): Pixbuf =
  ## Limiting axis fills its bound; other axis floors, with a one-pixel minimum.
  requireOutsideModelFunction()
  let boundW = pixbufDimension(maxWidth).int
  let boundH = pixbufDimension(maxHeight).int
  if ord(interpolation) < ord(low(Interpolation)) or ord(interpolation) > ord(high(Interpolation)):
    raise newException(ValueError, "invalid pixbuf interpolation")
  let p = image.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let info = transformInfo(p)
  var w = info.w
  var h = info.h
  if allowUpscale or w > boundW or h > boundH:
    # All factors are positive gint values, so products fit signed int64 even on i386.
    if boundW.int64 * info.h <= boundH.int64 * info.w:
      w = boundW
      h = max(1, int(info.h.int64 * w div info.w))
    else:
      h = boundH
      w = max(1, int(info.w.int64 * h div info.h))
  checkTransformAllocation(w, h, info.channels)
  if w == info.w and h == info.h:
    return requiredPixbuf(rawPixbuf.copy(p)) # Unchanged fit is still independent pixels.
  let nativeInterpolation = case interpolation
    of interpolateNearest: rawPixbuf.INTERP_NEAREST
    of interpolateTiles: rawPixbuf.INTERP_TILES
    of interpolateBilinear: rawPixbuf.INTERP_BILINEAR
    of interpolateHyper: rawPixbuf.INTERP_HYPER
  requiredPixbuf(rawPixbuf.scale_simple(p, g.gint(w), g.gint(h), nativeInterpolation))
