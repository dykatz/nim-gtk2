# Included by headers/xkb.nim; do not import directly.
type
  XkbComponentNamesRec*{.final.} = object
    keymap*: ptr int16
    keycodes*: ptr int16
    types*: ptr int16
    compat*: ptr int16
    symbols*: ptr int16
    geometry*: ptr int16

  PXkbComponentNamesPtr* = ptr XkbComponentNamesRec
