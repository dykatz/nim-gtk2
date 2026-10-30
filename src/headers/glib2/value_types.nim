# Included by headers/glib2.nim; do not import directly.
type
  TGValue*{.final.} = object
    g_type*: GType
    data*: array[0..1, gdouble]

  PGValue* = ptr TGValue
