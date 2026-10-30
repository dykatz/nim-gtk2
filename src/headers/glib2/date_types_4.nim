# Included by headers/glib2.nim; do not import directly.
type
  TGDate*{.final.} = object
    flag0*: int32
    flag1*: int32


  PGDate* = ptr TGDate
