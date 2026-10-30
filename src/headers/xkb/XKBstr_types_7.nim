# Included by headers/xkb.nim; do not import directly.
type
  XkbPtrBtnAction*{.final.} = object
    theType*: int8
    flags*: int8
    count*: int8
    button*: int8

  PXkbPtrBtnAction* = ptr XkbPtrBtnAction
