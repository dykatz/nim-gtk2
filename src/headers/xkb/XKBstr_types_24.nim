# Included by headers/xkb.nim; do not import directly.
type
  XkbKeyNameRec*{.final.} = object
    name*: array[0..XkbKeyNameLength - 1, char]

