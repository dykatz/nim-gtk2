# Included by headers/xkb.nim; do not import directly.
type
  XkbKeyRec*{.final.} = object
    name*: XkbKeyNameRec
    gap*: int16
    shape_ndx*: int8
    color_ndx*: int8

  PXkbKeyPtr* = ptr XkbKeyRec
