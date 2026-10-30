# Included by headers/xkb.nim; do not import directly.
type
  XkbShapeDoodadRec*{.final.} = object
    name*: Atom
    theType*: int8
    priority*: int8
    top*: int16
    left*: int16
    angle*: int16
    color_ndx*: int16
    shape_ndx*: int16

  PXkbShapeDoodadPtr* = ptr XkbShapeDoodadRec
