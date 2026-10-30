# Included by headers/pango.nim; do not import directly.
type
  TColor*{.final, pure.} = object
    red*: guint16
    green*: guint16
    blue*: guint16

  PColor* = ptr TColor
