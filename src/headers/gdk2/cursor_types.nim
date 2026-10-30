# Included by headers/gdk2.nim; do not import directly.
type
  TCursorType* = gint
  PCursorType* = ptr TCursorType
  TCursor*{.final, pure.} = object
    `type`*: TCursorType
    ref_count*: guint

  PCursor* = ptr TCursor
