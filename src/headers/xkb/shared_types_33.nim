# Included by headers/xkb.nim; do not import directly.
type
  XkbGeometrySizesRec*{.final.} = object   #
                                           #          Tie it all together into one big keyboard description
                                           #
    which*: int16
    num_properties*: int16
    num_colors*: int16
    num_shapes*: int16
    num_sections*: int16
    num_doodads*: int16
    num_key_aliases*: int16

  PXkbGeometrySizesPtr* = ptr XkbGeometrySizesRec
