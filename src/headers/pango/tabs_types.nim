# Included by headers/pango.nim; do not import directly.
type
  TTabArray* {.pure, final.} = object
  PTabArray* = ptr TTabArray
  TTabAlign* = enum
    TAB_LEFT

  PTabAlign* = ptr TTabAlign
