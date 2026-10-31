# Included by headers/glib2.nim; do not import directly.
type
  GSource* {.pure, final, incompleteStruct.} = object
  PGSource* = ptr GSource
  GMainContext* {.pure, final, incompleteStruct.} = object
  PGMainContext* = ptr GMainContext
