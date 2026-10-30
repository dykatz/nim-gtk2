# Included by headers/xkb.nim; do not import directly.
type
  XkbPropertyRec*{.final.} = object
    name*: cstring
    value*: cstring

  PXkbPropertyPtr* = ptr XkbPropertyRec
