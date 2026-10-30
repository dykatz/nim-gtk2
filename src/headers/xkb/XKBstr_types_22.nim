# Included by headers/xkb.nim; do not import directly.
type
  XkbIndicatorMapRec*{.final.} = object
    flags*: int8
    which_groups*: int8
    groups*: int8
    which_mods*: int8
    mods*: XkbModsRec
    ctrls*: int16

