# Included by headers/xkb.nim; do not import directly.
type
  XkbGroupAction*{.final.} = object
    theType*: int8
    flags*: int8
    group_XXX*: int8

  PXkbGroupAction* = ptr XkbGroupAction
