# Included by headers/xkb.nim; do not import directly.
type
  XkbModsRec*{.final.} = object
    mask*: int8               # effective mods
    real_mods*: int8
    vmods*: int16

  PXkbModsPtr* = ptr XkbModsRec
