# Included by headers/gtk2.nim; do not import directly.
proc TYPE_EDITABLE*(): GType
proc EDITABLE*(obj: pointer): PEditable
proc EDITABLE_CLASS*(vtable: pointer): PEditableClass
proc IS_EDITABLE*(obj: pointer): bool
proc IS_EDITABLE_CLASS*(vtable: pointer): bool
proc EDITABLE_GET_CLASS*(inst: pointer): PEditableClass
proc editable_get_type*(): TType{.cdecl, dynlib: lib,
                                  importc: "gtk_editable_get_type".}
proc select_region*(editable: PEditable, start: gint, theEnd: gint){.
    cdecl, dynlib: lib, importc: "gtk_editable_select_region".}
proc get_selection_bounds*(editable: PEditable, start: Pgint,
                                    theEnd: Pgint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_editable_get_selection_bounds".}
proc insert_text*(editable: PEditable, new_text: cstring,
                           new_text_length: gint, position: Pgint){.cdecl,
    dynlib: lib, importc: "gtk_editable_insert_text".}
proc delete_text*(editable: PEditable, start_pos: gint, end_pos: gint){.
    cdecl, dynlib: lib, importc: "gtk_editable_delete_text".}
proc get_chars*(editable: PEditable, start_pos: gint, end_pos: gint): cstring{.
    cdecl, dynlib: lib, importc: "gtk_editable_get_chars".}
proc cut_clipboard*(editable: PEditable){.cdecl, dynlib: lib,
    importc: "gtk_editable_cut_clipboard".}
proc copy_clipboard*(editable: PEditable){.cdecl, dynlib: lib,
    importc: "gtk_editable_copy_clipboard".}
proc paste_clipboard*(editable: PEditable){.cdecl, dynlib: lib,
    importc: "gtk_editable_paste_clipboard".}
proc delete_selection*(editable: PEditable){.cdecl, dynlib: lib,
    importc: "gtk_editable_delete_selection".}
proc set_position*(editable: PEditable, position: gint){.cdecl,
    dynlib: lib, importc: "gtk_editable_set_position".}
proc get_position*(editable: PEditable): gint{.cdecl, dynlib: lib,
    importc: "gtk_editable_get_position".}
proc set_editable*(editable: PEditable, is_editable: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_editable_set_editable".}
proc get_editable*(editable: PEditable): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_editable_get_editable".}
