# Included by headers/pango.nim; do not import directly.
proc is_cluster_start*(a: PGlyphVisAttr): guint =
  result = (a.flag0 and bm_TPangoGlyphVisAttr_is_cluster_start) shr
      bp_TPangoGlyphVisAttr_is_cluster_start

proc set_is_cluster_start*(a: PGlyphVisAttr, `is_cluster_start`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_cluster_start` shl bp_TPangoGlyphVisAttr_is_cluster_start) and
      bm_TPangoGlyphVisAttr_is_cluster_start)

proc TYPE_GLYPH_STRING*(): GType =
  result = glyph_string_get_type()

proc TYPE_LAYOUT*(): GType =
  result = layout_get_type()

