# Included by headers/gtk2.nim; do not import directly.
type
  TBox* = object of TContainer
    children*: PGList
    spacing*: gint16
    box_flag0*: guint16

  PBox* = ptr TBox
  TBoxChild*{.final, pure.} = object
    widget*: PWidget
    padding*: guint16
    flag0*: guint16

  PBoxChild* = ptr TBoxChild
