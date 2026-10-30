# Included by headers/gtk2.nim; do not import directly.
type
  TMisc* = object of TWidget
    xalign*: gfloat
    yalign*: gfloat
    xpad*: guint16
    ypad*: guint16

  PMisc* = ptr TMisc
