# Included by headers/xkb.nim; do not import directly.
type
  XkbPtrAction*{.final.} = object
    theType*: int8
    flags*: int8
    high_XXX*: int8
    low_XXX*: int8
    high_YYY*: int8
    low_YYY*: int8

  PXkbPtrAction* = ptr XkbPtrAction
