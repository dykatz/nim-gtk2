# Included by headers/xkb.nim; do not import directly.
type
  XkbIndicatorChangesRec*{.final.} = object
    state_changes*: int16
    map_changes*: int16

  PXkbIndicatorChangesPtr* = ptr XkbIndicatorChangesRec
