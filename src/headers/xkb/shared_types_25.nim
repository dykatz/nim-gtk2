# Included by headers/xkb.nim; do not import directly.
type
  XkbIndicatorDoodadRec*{.final.} = object
    name*: Atom
    theType*: int8
    priority*: int8
    top*: int16
    left*: int16
    angle*: int16
    shape_ndx*: int16
    on_color_ndx*: int16
    off_color_ndx*: int16

  PXkbIndicatorDoodadPtr* = ptr XkbIndicatorDoodadRec
