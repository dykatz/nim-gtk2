# Included by headers/xkb.nim; do not import directly.
type
  XkbKTMapEntryRec*{.final.} = object
    active*: bool
    level*: int8
    mods*: XkbModsRec

  PXkbKTMapEntryPtr* = ptr XkbKTMapEntryRec
