# Included after pixbuftransforms. Native alpha blending into independent base pixels.
proc overlaid*(base, overlay: Pixbuf, x, y: int, opacity = 255): Pixbuf =
  ## Fully contained, unit-scale nearest native composite; no clipping or input mutation.
  requireOutsideModelFunction()
  let dx = checkedInt(x)
  let dy = checkedInt(y)
  if opacity < 0 or opacity > 255:
    raise newException(ValueError, "pixbuf overlay opacity must be in 0..255")
  let background = base.raw
  discard g.g_object_ref(background)
  defer: g.g_object_unref(background)
  let foreground = overlay.raw
  discard g.g_object_ref(foreground)
  defer: g.g_object_unref(foreground)
  let b = transformInfo(background)
  let f = transformInfo(foreground)
  if dx >= b.w or dy >= b.h or f.w > b.w - dx or f.h > b.h - dy:
    raise newException(ValueError, "pixbuf overlay is outside base bounds")
  checkTransformAllocation(b.w, b.h, b.channels)
  result = requiredPixbuf(rawPixbuf.pixbuf_new(rawPixbuf.COLORSPACE_RGB,
    g.gbool(b.alpha), 8, g.gint(b.w), g.gint(b.h)))
  let output = result.raw
  discard g.g_object_ref(output)
  defer: g.g_object_unref(output)
  rawPixbuf.copy_area(background, 0, 0, g.gint(b.w), g.gint(b.h), output, 0, 0)
  # Let the real native compositor choose alpha arithmetic/rounding, including zero.
  rawPixbuf.composite(foreground, output, dx, dy, g.gint(f.w), g.gint(f.h),
    float64(dx), float64(dy), 1.0, 1.0, rawPixbuf.INTERP_NEAREST, g.gint(opacity))
