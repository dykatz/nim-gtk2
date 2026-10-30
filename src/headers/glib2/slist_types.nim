# Included by headers/glib2.nim; do not import directly.
type
  PGSList* = ptr TGSList
  TGSList*{.final.} = object
    data*: gpointer
    next*: PGSList

  PPGSList* = ptr PGSList
