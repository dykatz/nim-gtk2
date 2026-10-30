# Included by headers/pango.nim; do not import directly.
type
  TGlyphGeometry*{.final, pure.} = object
    width*: TGlyphUnit
    x_offset*: TGlyphUnit
    y_offset*: TGlyphUnit

  PGlyphGeometry* = ptr TGlyphGeometry
  TGlyphVisAttr*{.final, pure.} = object
    flag0*: uint16

  PGlyphVisAttr* = ptr TGlyphVisAttr
  TGlyphInfo*{.final, pure.} = object
    glyph*: TGlyph
    geometry*: TGlyphGeometry
    attr*: TGlyphVisAttr

  PGlyphInfo* = ptr TGlyphInfo
  TGlyphString*{.final, pure.} = object
    num_glyphs*: gint
    glyphs*: PGlyphInfo
    log_clusters*: Pgint
    space*: gint

  PGlyphString* = ptr TGlyphString
