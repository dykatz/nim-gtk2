# Included by headers/pango.nim; do not import directly.
type
  TLayoutRun*{.final, pure.} = object
    item*: PItem
    glyphs*: PGlyphString

  PLayoutRun* = ptr TLayoutRun
