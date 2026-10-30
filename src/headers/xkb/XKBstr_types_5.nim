# Included by headers/xkb.nim; do not import directly.
type
  XkbISOAction*{.final.} = object
    theType*: int8
    flags*: int8
    mask*: int8
    real_mods*: int8
    group_XXX*: int8
    affect*: int8
    vmods1*: int8
    vmods2*: int8

  PXkbISOAction* = ptr XkbISOAction
