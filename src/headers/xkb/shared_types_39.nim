# Included by headers/xkb.nim; do not import directly.
type
  XkbCompatChangesRec*{.final.} = object
    changed_groups*: int8
    first_si*: int16
    num_si*: int16

  PXkbCompatChangesPtr* = ptr XkbCompatChangesRec
