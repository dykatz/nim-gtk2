# Included by headers/xkb.nim; do not import directly.
type
  XkbMessageAction*{.final.} = object
    theType*: int8
    flags*: int8
    message*: array[0..5, char]

  PXkbMessageAction* = ptr XkbMessageAction
