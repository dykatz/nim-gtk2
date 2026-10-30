# Included by headers/xkb.nim; do not import directly.
type
  XkbGeometryRec*{.final.} = object
    name*: Atom
    width_mm*: int16
    height_mm*: int16
    label_font*: cstring
    label_color*: PXkbColorPtr
    base_color*: PXkbColorPtr
    sz_properties*: int16
    sz_colors*: int16
    sz_shapes*: int16
    sz_sections*: int16
    sz_doodads*: int16
    sz_key_aliases*: int16
    num_properties*: int16
    num_colors*: int16
    num_shapes*: int16
    num_sections*: int16
    num_doodads*: int16
    num_key_aliases*: int16
    properties*: ptr array[0..0xffff, XkbPropertyRec]
    colors*: ptr array[0..0xffff, XkbColorRec]
    shapes*: ptr array[0..0xffff, XkbShapeRec]
    sections*: ptr array[0..0xffff, XkbSectionRec]
    key_aliases*: ptr array[0..0xffff, XkbKeyAliasRec]

  PXkbGeometryRec* = ptr XkbGeometryRec
  PXkbGeometryPtr* = PXkbGeometryRec
