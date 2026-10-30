# Included by headers/xkb.nim; do not import directly.
type
  XkbBoundsRec*{.final.} = object
    x1*: int16
    y1*: int16
    x2*: int16
    y2*: int16

  PXkbBoundsPtr* = ptr XkbBoundsRec
