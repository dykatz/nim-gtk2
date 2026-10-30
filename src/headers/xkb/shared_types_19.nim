# Included by headers/xkb.nim; do not import directly.
type
  XkbPointRec*{.final.} = object
    x*: int16
    y*: int16

  PXkbPointPtr* = ptr XkbPointRec
