# Included by headers/glib2.nim; do not import directly.
type
  TGSystemThread*{.final.} = object
    data*: array[0..3, char]
    dummy_double*: float64
    dummy_pointer*: pointer
    dummy_long*: int32


  PGSystemThread* = ptr TGSystemThread
