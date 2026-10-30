# Included by headers/gtk2.nim; do not import directly.
type
  TScale* = object of TRange
    digits*: gint
    Scale_flag0*: guint16

  PScale* = ptr TScale
