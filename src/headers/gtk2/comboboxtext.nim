# Included by headers/gtk2.nim; do not import directly.
proc combo_box_text_new*(): PComboBoxText{.cdecl, importc: "gtk_combo_box_text_new",
                                 dynlib: lib.}
proc combo_box_text_new_with_entry*(): PComboBoxText{.cdecl,
    importc: "gtk_combo_box_text_new_with_entry", dynlib: lib.}
proc append_text*(combo_box: PComboBoxText; text: cstring){.cdecl,
    importc: "gtk_combo_box_text_append_text", dynlib: lib.}
proc insert_text*(combo_box: PComboBoxText; position: gint;
                       text: cstring){.cdecl,
    importc: "gtk_combo_box_text_insert_text", dynlib: lib.}
proc prepend_text*(combo_box: PComboBoxText; text: cstring){.cdecl,
    importc: "gtk_combo_box_text_prepend_text", dynlib: lib.}
proc remove*(combo_box: PComboBoxText; position: gint){.cdecl,
    importc: "gtk_combo_box_text_remove", dynlib: lib.}
proc get_active_text*(combo_box: PComboBoxText): cstring{.cdecl,
    importc: "gtk_combo_box_text_get_active_text", dynlib: lib.}
