# Included by headers/gtk2.nim; do not import directly.
type
  TAlignment* = object of TBin
    xalign*: gfloat
    yalign*: gfloat
    xscale*: gfloat
    yscale*: gfloat

  PAlignment* = ptr TAlignment
