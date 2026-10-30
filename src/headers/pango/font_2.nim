# Included by headers/pango.nim; do not import directly.
proc font_description_get_type*(): GType{.cdecl, dynlib: lib,
    importc: "pango_font_description_get_type".}
proc font_description_new*(): PFontDescription{.cdecl, dynlib: lib,
    importc: "pango_font_description_new".}
proc copy*(desc: PFontDescription): PFontDescription{.cdecl,
    dynlib: lib, importc: "pango_font_description_copy".}
proc copy_static*(desc: PFontDescription): PFontDescription{.
    cdecl, dynlib: lib, importc: "pango_font_description_copy_static".}
proc hash*(desc: PFontDescription): guint{.cdecl, dynlib: lib,
    importc: "pango_font_description_hash".}
proc equal*(desc1: PFontDescription, desc2: PFontDescription): gboolean{.
    cdecl, dynlib: lib, importc: "pango_font_description_equal".}
proc free*(desc: PFontDescription){.cdecl, dynlib: lib,
    importc: "pango_font_description_free".}
proc font_descriptions_free*(descs: var PFontDescription, n_descs: int32){.
    cdecl, dynlib: lib, importc: "pango_font_descriptions_free".}
proc set_family*(desc: PFontDescription, family: cstring){.
    cdecl, dynlib: lib, importc: "pango_font_description_set_family".}
proc set_family_static*(desc: PFontDescription, family: cstring){.
    cdecl, dynlib: lib, importc: "pango_font_description_set_family_static".}
proc get_family*(desc: PFontDescription): cstring{.cdecl,
    dynlib: lib, importc: "pango_font_description_get_family".}
proc set_style*(desc: PFontDescription, style: TStyle){.cdecl,
    dynlib: lib, importc: "pango_font_description_set_style".}
proc get_style*(desc: PFontDescription): TStyle{.cdecl,
    dynlib: lib, importc: "pango_font_description_get_style".}
proc set_variant*(desc: PFontDescription, variant: TVariant){.
    cdecl, dynlib: lib, importc: "pango_font_description_set_variant".}
proc get_variant*(desc: PFontDescription): TVariant{.cdecl,
    dynlib: lib, importc: "pango_font_description_get_variant".}
proc set_weight*(desc: PFontDescription, weight: TWeight){.
    cdecl, dynlib: lib, importc: "pango_font_description_set_weight".}
proc get_weight*(desc: PFontDescription): TWeight{.cdecl,
    dynlib: lib, importc: "pango_font_description_get_weight".}
proc set_stretch*(desc: PFontDescription, stretch: TStretch){.
    cdecl, dynlib: lib, importc: "pango_font_description_set_stretch".}
proc get_stretch*(desc: PFontDescription): TStretch{.cdecl,
    dynlib: lib, importc: "pango_font_description_get_stretch".}
proc set_size*(desc: PFontDescription, size: gint){.cdecl,
    dynlib: lib, importc: "pango_font_description_set_size".}
proc get_size*(desc: PFontDescription): gint{.cdecl,
    dynlib: lib, importc: "pango_font_description_get_size".}
proc set_absolute_size*(desc: PFontDescription, size: float64){.
    cdecl, dynlib: lib, importc: "pango_font_description_set_absolute_size".}
proc get_size_is_absolute*(desc: PFontDescription,
    size: float64): gboolean{.cdecl, dynlib: lib, importc: "pango_font_description_get_size_is_absolute".}
proc get_set_fields*(desc: PFontDescription): TFontMask{.cdecl,
    dynlib: lib, importc: "pango_font_description_get_set_fields".}
proc unset_fields*(desc: PFontDescription, to_unset: TFontMask){.
    cdecl, dynlib: lib, importc: "pango_font_description_unset_fields".}
proc merge*(desc: PFontDescription,
                             desc_to_merge: PFontDescription,
                             replace_existing: gboolean){.cdecl, dynlib: lib,
    importc: "pango_font_description_merge".}
proc merge_static*(desc: PFontDescription,
                                    desc_to_merge: PFontDescription,
                                    replace_existing: gboolean){.cdecl,
    dynlib: lib, importc: "pango_font_description_merge_static".}
proc better_match*(desc: PFontDescription,
                                    old_match: PFontDescription,
                                    new_match: PFontDescription): gboolean{.
    cdecl, dynlib: lib, importc: "pango_font_description_better_match".}
proc font_description_from_string*(str: cstring): PFontDescription{.cdecl,
    dynlib: lib, importc: "pango_font_description_from_string".}
proc to_string*(desc: PFontDescription): cstring{.cdecl,
    dynlib: lib, importc: "pango_font_description_to_string".}
proc to_filename*(desc: PFontDescription): cstring{.cdecl,
    dynlib: lib, importc: "pango_font_description_to_filename".}
proc TYPE_FONT_METRICS*(): GType
proc font_metrics_get_type*(): GType{.cdecl, dynlib: lib,
                                      importc: "pango_font_metrics_get_type".}
proc reference*(metrics: PFontMetrics): PFontMetrics{.cdecl, dynlib: lib,
    importc: "pango_font_metrics_ref".}
proc unref*(metrics: PFontMetrics){.cdecl, dynlib: lib,
    importc: "pango_font_metrics_unref".}
proc get_ascent*(metrics: PFontMetrics): int32{.cdecl, dynlib: lib,
    importc: "pango_font_metrics_get_ascent".}
proc get_descent*(metrics: PFontMetrics): int32{.cdecl,
    dynlib: lib, importc: "pango_font_metrics_get_descent".}
proc get_approximate_char_width*(metrics: PFontMetrics): int32{.
    cdecl, dynlib: lib, importc: "pango_font_metrics_get_approximate_char_width".}
proc get_approximate_digit_width*(metrics: PFontMetrics): int32{.
    cdecl, dynlib: lib,
    importc: "pango_font_metrics_get_approximate_digit_width".}
proc TYPE_FONT_FAMILY*(): GType
proc FONT_FAMILY*(anObject: pointer): PFontFamily
proc IS_FONT_FAMILY*(anObject: pointer): bool
proc font_family_get_type*(): GType{.cdecl, dynlib: lib,
                                     importc: "pango_font_family_get_type".}
proc list_faces*(family: PFontFamily,
                             faces: var openarray[ptr PFontFace]){.cdecl,
    dynlib: lib, importc: "pango_font_family_list_faces".}
proc get_name*(family: PFontFamily): cstring{.cdecl, dynlib: lib,
    importc: "pango_font_family_get_name".}
proc TYPE_FONT_FACE*(): GType
proc FONT_FACE*(anObject: pointer): PFontFace
proc IS_FONT_FACE*(anObject: pointer): bool
proc font_face_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "pango_font_face_get_type".}
proc describe*(face: PFontFace): PFontDescription{.cdecl, dynlib: lib,
    importc: "pango_font_face_describe".}
proc get_face_name*(face: PFontFace): cstring{.cdecl, dynlib: lib,
    importc: "pango_font_face_get_face_name".}
proc TYPE_FONT*(): GType
proc FONT*(anObject: pointer): PFont
proc IS_FONT*(anObject: pointer): bool
proc font_get_type*(): GType{.cdecl, dynlib: lib, importc: "pango_font_get_type".}
proc describe*(font: PFont): PFontDescription{.cdecl, dynlib: lib,
    importc: "pango_font_describe".}
proc get_coverage*(font: PFont, language: PLanguage): PCoverage{.cdecl,
    dynlib: lib, importc: "pango_font_get_coverage".}
proc find_shaper*(font: PFont, language: PLanguage, ch: guint32): PEngineShape{.
    cdecl, dynlib: lib, importc: "pango_font_find_shaper".}
proc get_metrics*(font: PFont, language: PLanguage): PFontMetrics{.cdecl,
    dynlib: lib, importc: "pango_font_get_metrics".}
proc get_glyph_extents*(font: PFont, glyph: TGlyph, ink_rect: PRectangle,
                             logical_rect: PRectangle){.cdecl, dynlib: lib,
    importc: "pango_font_get_glyph_extents".}
proc TYPE_FONT_MAP*(): GType
