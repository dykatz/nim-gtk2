# Included by headers/xkb.nim; do not import directly.
type
  XkbRedirectKeyAction*{.final.} = object
    theType*: int8
    new_key*: int8
    mods_mask*: int8
    mods*: int8
    vmods_mask0*: int8
    vmods_mask1*: int8
    vmods0*: int8
    vmods1*: int8

  PXkbRedirectKeyAction* = ptr XkbRedirectKeyAction
