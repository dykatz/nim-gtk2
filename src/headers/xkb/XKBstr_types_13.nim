# Included by headers/xkb.nim; do not import directly.
type
  XkbDeviceBtnAction*{.final.} = object
    theType*: int8
    flags*: int8
    count*: int8
    button*: int8
    device*: int8

  PXkbDeviceBtnAction* = ptr XkbDeviceBtnAction
