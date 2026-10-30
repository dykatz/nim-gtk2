# Included by headers/xkb.nim; do not import directly.
type
  XkbComponentNameRec*{.final.} = object
    flags*: int16
    name*: cstring

  PXkbComponentNamePtr* = ptr XkbComponentNameRec
