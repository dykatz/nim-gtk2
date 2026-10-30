# Included by headers/xkb.nim; do not import directly.
type
  XkbShapeRec*{.final.} = object
    name*: Atom
    num_outlines*: int16
    sz_outlines*: int16
    outlines*: ptr array[0..0xffff, XkbOutlineRec]
    approx*: ptr array[0..0xffff, XkbOutlineRec]
    primary*: ptr array[0..0xffff, XkbOutlineRec]
    bounds*: XkbBoundsRec

  PXkbShapePtr* = ptr XkbShapeRec
