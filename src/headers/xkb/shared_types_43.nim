# Included by headers/xkb.nim; do not import directly.
type
  XkbComponentListRec*{.final.} = object   #
                                           #          The following data structures describe and track changes to a
                                           #          non-keyboard extension device
                                           #
    num_keymaps*: int16
    num_keycodes*: int16
    num_types*: int16
    num_compat*: int16
    num_symbols*: int16
    num_geometry*: int16
    keymaps*: PXkbComponentNamePtr
    keycodes*: PXkbComponentNamePtr
    types*: PXkbComponentNamePtr
    compat*: PXkbComponentNamePtr
    symbols*: PXkbComponentNamePtr
    geometry*: PXkbComponentNamePtr

  PXkbComponentListPtr* = ptr XkbComponentListRec
