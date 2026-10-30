# Included by headers/xkb.nim; do not import directly.
type
  XkbKeyTypeRec*{.final.} = object
    mods*: XkbModsRec
    num_levels*: int8
    map_count*: int8
    map*: PXkbKTMapEntryPtr
    preserve*: PXkbModsPtr
    name*: Atom
    level_names*: Atom

  PXkbKeyTypePtr* = ptr XkbKeyTypeRec
