# Included by headers/atk.nim; do not import directly.
proc text_attribute_register*(name: cstring): TTextAttribute{.cdecl,
    dynlib: lib, importc: "atk_text_attribute_register".}
proc TYPE_TEXT*(): GType
proc IS_TEXT*(obj: pointer): bool
proc TEXT*(obj: pointer): PText
proc TEXT_GET_IFACE*(obj: pointer): PTextIface
proc text_get_type*(): GType{.cdecl, dynlib: lib, importc: "atk_text_get_type".}
proc get_text*(text: PText, start_offset: gint, end_offset: gint): cstring{.
    cdecl, dynlib: lib, importc: "atk_text_get_text".}
proc get_character_at_offset*(text: PText, offset: gint): gunichar{.cdecl,
    dynlib: lib, importc: "atk_text_get_character_at_offset".}
proc get_text_after_offset*(text: PText, offset: gint,
                                 boundary_type: TTextBoundary,
                                 start_offset: Pgint, end_offset: Pgint): cstring{.
    cdecl, dynlib: lib, importc: "atk_text_get_text_after_offset".}
proc get_text_at_offset*(text: PText, offset: gint,
                              boundary_type: TTextBoundary, start_offset: Pgint,
                              end_offset: Pgint): cstring{.cdecl, dynlib: lib,
    importc: "atk_text_get_text_at_offset".}
proc get_text_before_offset*(text: PText, offset: gint,
                                  boundary_type: TTextBoundary,
                                  start_offset: Pgint, end_offset: Pgint): cstring{.
    cdecl, dynlib: lib, importc: "atk_text_get_text_before_offset".}
proc get_caret_offset*(text: PText): gint{.cdecl, dynlib: lib,
    importc: "atk_text_get_caret_offset".}
proc get_character_extents*(text: PText, offset: gint, x: Pgint, y: Pgint,
                                 width: Pgint, height: Pgint, coords: TCoordType){.
    cdecl, dynlib: lib, importc: "atk_text_get_character_extents".}
proc get_run_attributes*(text: PText, offset: gint, start_offset: Pgint,
                              end_offset: Pgint): PAttributeSet{.cdecl,
    dynlib: lib, importc: "atk_text_get_run_attributes".}
proc get_default_attributes*(text: PText): PAttributeSet{.cdecl,
    dynlib: lib, importc: "atk_text_get_default_attributes".}
proc get_character_count*(text: PText): gint{.cdecl, dynlib: lib,
    importc: "atk_text_get_character_count".}
proc get_offset_at_point*(text: PText, x: gint, y: gint, coords: TCoordType): gint{.
    cdecl, dynlib: lib, importc: "atk_text_get_offset_at_point".}
proc get_n_selections*(text: PText): gint{.cdecl, dynlib: lib,
    importc: "atk_text_get_n_selections".}
proc get_selection*(text: PText, selection_num: gint, start_offset: Pgint,
                         end_offset: Pgint): cstring{.cdecl, dynlib: lib,
    importc: "atk_text_get_selection".}
proc add_selection*(text: PText, start_offset: gint, end_offset: gint): gboolean{.
    cdecl, dynlib: lib, importc: "atk_text_add_selection".}
proc remove_selection*(text: PText, selection_num: gint): gboolean{.cdecl,
    dynlib: lib, importc: "atk_text_remove_selection".}
proc set_selection*(text: PText, selection_num: gint, start_offset: gint,
                         end_offset: gint): gboolean{.cdecl, dynlib: lib,
    importc: "atk_text_set_selection".}
proc set_caret_offset*(text: PText, offset: gint): gboolean{.cdecl,
    dynlib: lib, importc: "atk_text_set_caret_offset".}
proc free*(attrib_set: PAttributeSet){.cdecl, dynlib: lib,
    importc: "atk_attribute_set_free".}
proc text_attribute_get_name*(attr: TTextAttribute): cstring{.cdecl,
    dynlib: lib, importc: "atk_text_attribute_get_name".}
proc text_attribute_for_name*(name: cstring): TTextAttribute{.cdecl,
    dynlib: lib, importc: "atk_text_attribute_for_name".}
proc text_attribute_get_value*(attr: TTextAttribute, index: gint): cstring{.
    cdecl, dynlib: lib, importc: "atk_text_attribute_get_value".}
