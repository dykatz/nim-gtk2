# Included by headers/xkb.nim; do not import directly.
type
  XkbSymMapRec*{.final.} = object
    kt_index*: array[0..XkbNumKbdGroups - 1, int8]
    group_info*: int8
    width*: int8
    offset*: int8

