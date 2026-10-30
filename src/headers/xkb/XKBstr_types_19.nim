# Included by headers/xkb.nim; do not import directly.
type
  XkbClientMapRec*{.final.} = object
    size_types*: int8
    num_types*: int8
    types*: ptr array[0..0xffff, XkbKeyTypeRec]
    size_syms*: int16
    num_syms*: int16
    syms*: ptr array[0..0xffff, KeySym]
    key_sym_map*: ptr array[0..0xffff, XkbSymMapRec]
    modmap*: PByte

