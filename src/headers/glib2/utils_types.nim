# Included by headers/glib2.nim; do not import directly.
type
  TGDebugKey*{.final.} = object
    key*: cstring
    value*: guint


  PGDebugKey* = ptr TGDebugKey
