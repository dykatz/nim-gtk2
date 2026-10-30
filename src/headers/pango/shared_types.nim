# Included by headers/pango.nim; do not import directly.
type
  TGlyph* = guint32
  PGlyph* = ptr TGlyph
  TEngineRange*{.final, pure.} = object
    start*: int32
    theEnd*: int32
    langs*: cstring

  PEngineRange* = ptr TEngineRange
  TGlyphUnit* = gint32
  PGlyphUnit* = ptr TGlyphUnit
