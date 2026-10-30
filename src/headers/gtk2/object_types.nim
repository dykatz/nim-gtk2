# Included by headers/gtk2.nim; do not import directly.
type
  TObjectFlags* = int32
  PObjectFlags* = ptr TObjectFlags
  TObject* = object of TGObject
    flags*: guint32

  PObject* = ptr TObject
  PPGtkObject* = ptr PObject
