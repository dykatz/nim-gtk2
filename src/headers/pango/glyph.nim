# Included by headers/pango.nim; do not import directly.
proc is_cluster_start*(a: PGlyphVisAttr): guint
proc set_is_cluster_start*(a: PGlyphVisAttr, `is_cluster_start`: guint)
proc TYPE_GLYPH_STRING*(): GType
proc glyph_string_new*(): PGlyphString{.cdecl, dynlib: lib,
                                        importc: "pango_glyph_string_new".}
proc glyph_string_set_size*(`string`: PGlyphString, new_len: gint){.cdecl,
    dynlib: lib, importc: "pango_glyph_string_set_size".}
proc glyph_string_get_type*(): GType{.cdecl, dynlib: lib,
                                      importc: "pango_glyph_string_get_type".}
proc glyph_string_copy*(`string`: PGlyphString): PGlyphString{.cdecl,
    dynlib: lib, importc: "pango_glyph_string_copy".}
proc glyph_string_free*(`string`: PGlyphString){.cdecl, dynlib: lib,
    importc: "pango_glyph_string_free".}
proc extents*(glyphs: PGlyphString, font: PFont,
                           ink_rect: PRectangle, logical_rect: PRectangle){.
    cdecl, dynlib: lib, importc: "pango_glyph_string_extents".}
proc extents_range*(glyphs: PGlyphString, start: int32,
                                 theEnd: int32, font: PFont,
                                 ink_rect: PRectangle, logical_rect: PRectangle){.
    cdecl, dynlib: lib, importc: "pango_glyph_string_extents_range".}
proc get_logical_widths*(glyphs: PGlyphString, text: cstring,
                                      length: int32, embedding_level: int32,
                                      logical_widths: var int32){.cdecl,
    dynlib: lib, importc: "pango_glyph_string_get_logical_widths".}
proc index_to_x*(glyphs: PGlyphString, text: cstring,
                              length: int32, analysis: PAnalysis, index: int32,
                              trailing: gboolean, x_pos: var int32){.cdecl,
    dynlib: lib, importc: "pango_glyph_string_index_to_x".}
proc x_to_index*(glyphs: PGlyphString, text: cstring,
                              length: int32, analysis: PAnalysis, x_pos: int32,
                              index, trailing: var int32){.cdecl, dynlib: lib,
    importc: "pango_glyph_string_x_to_index".}
proc shape*(text: cstring, length: gint, analysis: PAnalysis,
            glyphs: PGlyphString){.cdecl, dynlib: lib, importc: "pango_shape".}
