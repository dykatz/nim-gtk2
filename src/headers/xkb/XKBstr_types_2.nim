# Included by headers/xkb.nim; do not import directly.
type
  XkbBehavior*{.final.} = object
    theType*: int8
    data*: int8

  PXkbBehavior* = ptr XkbBehavior
