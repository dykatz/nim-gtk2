# Included by headers/xkb.nim; do not import directly.
type
  XkbDoodadRec*{.final.} = object
    any*: XkbAnyDoodadRec
    shape*: XkbShapeDoodadRec
    text*: XkbTextDoodadRec
    indicator*: XkbIndicatorDoodadRec
    logo*: XkbLogoDoodadRec

  PXkbDoodadPtr* = ptr XkbDoodadRec
