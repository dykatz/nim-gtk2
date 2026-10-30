# Included by headers/glib2.nim; do not import directly.
type
  TGTypeCValue*{.final.} = object
    v_double*: gdouble

  PGTypeCValue* = ptr TGTypeCValue
