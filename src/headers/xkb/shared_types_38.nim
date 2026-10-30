# Included by headers/xkb.nim; do not import directly.
type
  XkbNameChangesRec*{.final.} = object
    changed*: int16
    first_type*: int8
    num_types*: int8
    first_lvl*: int8
    num_lvls*: int8
    num_aliases*: int8
    num_rg*: int8
    first_key*: int8
    num_keys*: int8
    changed_vmods*: int16
    changed_indicators*: int32
    changed_groups*: int8

  PXkbNameChangesPtr* = ptr XkbNameChangesRec
