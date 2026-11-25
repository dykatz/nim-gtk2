# Included after pixbuftransforms. Native effects on independent pixels.
proc saturated*(image: Pixbuf, saturation = 1.0, pixelate = false): Pixbuf =
  ## Copy pixels, then apply GTK's native saturation and optional checkerboard.
  ## 0 is grayscale; 1 preserves saturation. Alpha samples are unchanged.
  requireOutsideModelFunction()
  if not (saturation >= 0.0 and saturation <= 1.0):
    raise newException(ValueError, "pixbuf saturation must be finite and in 0..1")
  let factor = g.gfloat(saturation)
  let p = image.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let info = transformInfo(p)
  checkTransformAllocation(info.w, info.h, info.channels)
  let w = g.gint(info.w)
  let h = g.gint(info.h)
  result = requiredPixbuf(rawPixbuf.pixbuf_new(rawPixbuf.COLORSPACE_RGB, g.gbool(info.alpha), 8, w, h))
  let dst = result.raw
  rawPixbuf.copy_area(p, 0, 0, w, h, dst, 0, 0)
  # In-place is supported by the native algorithm and guarantees equal strides,
  # even for a cropped source with wider backing storage or no final padding.
  if factor != g.gfloat(1) or pixelate:
    rawPixbuf.saturate_and_pixelate(dst, dst, factor, g.gbool(pixelate))
