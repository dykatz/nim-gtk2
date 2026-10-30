# Included by headers/xkb.nim; do not import directly.
type
  XkbAnyDoodadRec*{.final.} = object
    name*: Atom
    theType*: int8
    priority*: int8
    top*: int16
    left*: int16
    angle*: int16

  PXkbAnyDoodadPtr* = ptr XkbAnyDoodadRec
