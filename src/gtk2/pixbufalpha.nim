# Included after pixbuftransforms. Copied native alpha conversion; no implicit background.
proc checkPixbufRgb(rgb: uint32) =
  if rgb > 0xffffff'u32:
    raise newException(ValueError, "pixbuf RGB color must fit 0x000000..0xffffff")

proc copiedPixbufAlpha(image: Pixbuf, substitute: bool, rgb: uint32): Pixbuf =
  requireOutsideModelFunction()
  checkPixbufRgb(rgb)
  let source = image.raw
  discard g.g_object_ref(source)
  defer: g.g_object_unref(source)
  let info = transformInfo(source)
  checkTransformAllocation(info.w, info.h, 4)
  requiredPixbuf(rawPixbuf.add_alpha(source, g.gbool(substitute),
    g.guchar((rgb shr 16) and 255), g.guchar((rgb shr 8) and 255), g.guchar(rgb and 255)))

proc withAlpha*(image: Pixbuf): Pixbuf =
  ## RGB gets alpha 255; RGBA is independently copied with existing alpha unchanged.
  copiedPixbufAlpha(image, false, 0)
proc withAlpha*(image: Pixbuf, keyRgb: uint32): Pixbuf =
  ## Exact RGB matches get alpha zero; nonmatches retain existing alpha (RGB gets 255).
  copiedPixbufAlpha(image, true, keyRgb)

proc flattened*(image: Pixbuf, backgroundRgb: uint32): Pixbuf =
  ## Blend onto an explicit opaque RGB color through the actual native compositor.
  requireOutsideModelFunction()
  checkPixbufRgb(backgroundRgb)
  let source = image.raw
  discard g.g_object_ref(source)
  defer: g.g_object_unref(source)
  let info = transformInfo(source)
  checkTransformAllocation(info.w, info.h, 3)
  result = requiredPixbuf(rawPixbuf.pixbuf_new(rawPixbuf.COLORSPACE_RGB,
    g.gbool(false), 8, g.gint(info.w), g.gint(info.h)))
  let output = result.raw
  discard g.g_object_ref(output)
  defer: g.g_object_unref(output)
  rawPixbuf.fill(output, (backgroundRgb shl 8) or 0xff'u32)
  rawPixbuf.composite(source, output, 0, 0, g.gint(info.w), g.gint(info.h),
    0.0, 0.0, 1.0, 1.0, rawPixbuf.INTERP_NEAREST, 255)
