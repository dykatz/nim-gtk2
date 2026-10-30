# Included by headers/glib2.nim; do not import directly.
type
  TGTuples*{.final.} = object
    len*: guint

  PGTuples* = ptr TGTuples
  TGRelation = object
  PGRelation* = ptr TGRelation

