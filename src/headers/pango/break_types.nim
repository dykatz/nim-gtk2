# Included by headers/pango.nim; do not import directly.
type
  TLogAttr*{.final, pure.} = object
    flag0*: guint16

  PLogAttr* = ptr TLogAttr
