# Included by headers/glib2.nim; do not import directly.
type
  TGCClosure*{.final.} = object
    closure*: TGClosure
    callback*: gpointer


  PGCClosure* = ptr TGCClosure
