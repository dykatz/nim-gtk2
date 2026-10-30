# Included by headers/xkb.nim; do not import directly.
type
  XkbColorRec*{.final.} = object
    pixel*: int16
    spec*: cstring

  PXkbColorPtr* = ptr XkbColorRec
