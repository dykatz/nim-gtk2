# Included by headers/glib2.nim; do not import directly.
type
  TGValueArray*{.final.} = object
    n_values*: guint
    values*: PGValue
    n_prealloced*: guint


  PGValueArray* = ptr TGValueArray
