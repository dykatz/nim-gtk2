# Included by headers/gtk2.nim; do not import directly.
type
  TCheckMenuItem* = object of TMenuItem
    CheckMenuItem_flag0*: guint16

  PCheckMenuItem* = ptr TCheckMenuItem
