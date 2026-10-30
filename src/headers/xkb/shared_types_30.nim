# Included by headers/xkb.nim; do not import directly.
type
  XkbRowRec*{.final.} = object
    top*: int16
    left*: int16
    num_keys*: int16
    sz_keys*: int16
    vertical*: int16
    Keys*: PXkbKeyPtr
    bounds*: XkbBoundsRec

  PXkbRowPtr* = ptr XkbRowRec
