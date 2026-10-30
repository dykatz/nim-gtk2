# Included by headers/xkb.nim; do not import directly.
type
  XkbPtrDfltAction*{.final.} = object
    theType*: int8
    flags*: int8
    affect*: int8
    valueXXX*: int8

  PXkbPtrDfltAction* = ptr XkbPtrDfltAction
