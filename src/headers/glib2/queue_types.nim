# Included by headers/glib2.nim; do not import directly.
type
  TGQueue*{.final.} = object
    head*: PGList
    tail*: PGList
    length*: guint


  PGQueue* = ptr TGQueue
