# Included by headers/xkb.nim; do not import directly.
type
  XkbSwitchScreenAction*{.final.} = object
    theType*: int8
    flags*: int8
    screenXXX*: int8

  PXkbSwitchScreenAction* = ptr XkbSwitchScreenAction
