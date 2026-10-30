# Included by headers/glib2.nim; do not import directly.
type
  PGTrashStack* = ptr TGTrashStack
  TGTrashStack*{.final.} = object
    next*: PGTrashStack


  PPGTrashStack* = ptr PGTrashStack
