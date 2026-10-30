# Included by headers/gdk2.nim; do not import directly.
type
  TRgbDither* = enum
    RGB_DITHER_NONE, RGB_DITHER_NORMAL, RGB_DITHER_MAX
  PRgbDither* = ptr TRgbDither
  TRgbCmap*{.final, pure.} = object
    colors*: array[0..255, guint32]
    n_colors*: gint
    info_list*: PGSList

  PRgbCmap* = ptr TRgbCmap
