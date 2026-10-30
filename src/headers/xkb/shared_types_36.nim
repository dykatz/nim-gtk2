# Included by headers/xkb.nim; do not import directly.
type
  XkbControlsChangesRec*{.final.} = object
    changed_ctrls*: int16
    enabled_ctrls_changes*: int16
    num_groups_changed*: bool

  PXkbControlsChangesPtr* = ptr XkbControlsChangesRec
