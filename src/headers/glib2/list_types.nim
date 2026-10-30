# Included by headers/glib2.nim; do not import directly.
type
  PGList* = ptr TGList
  TGList*{.final.} = object
    data*: gpointer
    next*: PGList
    prev*: PGList

