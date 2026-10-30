# Included by headers/xkb.nim; do not import directly.
type
  XkbCompatMapRec*{.final.} = object
    sym_interpret*: PXkbSymInterpretPtr
    groups*: array[0..XkbNumKbdGroups - 1, XkbModsRec]
    num_si*: int16
    size_si*: int16

