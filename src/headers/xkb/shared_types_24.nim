# Included by headers/xkb.nim; do not import directly.
type
  XkbTextDoodadRec*{.final.} = object
    name*: Atom
    theType*: int8
    priority*: int8
    top*: int16
    left*: int16
    angle*: int16
    width*: int16
    height*: int16
    color_ndx*: int16
    text*: cstring
    font*: cstring

  PXkbTextDoodadPtr* = ptr XkbTextDoodadRec
