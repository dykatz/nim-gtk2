# Included by headers/atk.nim; do not import directly.
proc TYPE_EDITABLE_TEXT*(): GType
proc IS_EDITABLE_TEXT*(obj: pointer): bool
proc EDITABLE_TEXT*(obj: pointer): PEditableText
proc EDITABLE_TEXT_GET_IFACE*(obj: pointer): PEditableTextIface
proc editable_text_get_type*(): GType{.cdecl, dynlib: lib,
                                       importc: "atk_editable_text_get_type".}
proc set_run_attributes*(text: PEditableText,
                                       attrib_set: PAttributeSet,
                                       start_offset: gint, end_offset: gint): gboolean{.
    cdecl, dynlib: lib, importc: "atk_editable_text_set_run_attributes".}
proc set_text_contents*(text: PEditableText, string: cstring){.
    cdecl, dynlib: lib, importc: "atk_editable_text_set_text_contents".}
proc insert_text*(text: PEditableText, `string`: cstring,
                                length: gint, position: Pgint){.cdecl,
    dynlib: lib, importc: "atk_editable_text_insert_text".}
proc copy_text*(text: PEditableText, start_pos: gint,
                              end_pos: gint){.cdecl, dynlib: lib,
    importc: "atk_editable_text_copy_text".}
proc cut_text*(text: PEditableText, start_pos: gint, end_pos: gint){.
    cdecl, dynlib: lib, importc: "atk_editable_text_cut_text".}
proc delete_text*(text: PEditableText, start_pos: gint,
                                end_pos: gint){.cdecl, dynlib: lib,
    importc: "atk_editable_text_delete_text".}
proc paste_text*(text: PEditableText, position: gint){.cdecl,
    dynlib: lib, importc: "atk_editable_text_paste_text".}
