# Included by headers/xkb.nim; do not import directly.
type
  XkbOutlineRec*{.final.} = object
    num_points*: int16
    sz_points*: int16
    corner_radius*: int16
    points*: PXkbPointPtr

  PXkbOutlinePtr* = ptr XkbOutlineRec
