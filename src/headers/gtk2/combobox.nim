# Included by headers/gtk2.nim; do not import directly.
proc comboBoxNew*(): PComboBox{.cdecl, importc: "gtk_combo_box_new", dynlib: lib.}
proc comboBox_new_with_entry*(): PComboBox{.cdecl,
                                       importc: "gtk_combo_box_new_with_entry",
                                       dynlib: lib.}
proc comboBox_new_with_model*(model: PTreeModel): PComboBox{.cdecl,
    importc: "gtk_combo_box_new_with_model", dynlib: lib.}
proc comboBox_new_with_model_and_entry*(model: PTreeModel): PComboBox{.cdecl,
    importc: "gtk_combo_box_new_with_model_and_entry", dynlib: lib.}

proc get_wrap_width*(combo_box: PComboBox): gint{.cdecl,
    importc: "gtk_combo_box_get_wrap_width", dynlib: lib.}
proc set_wrap_width*(combo_box: PComboBox; width: gint){.cdecl,
    importc: "gtk_combo_box_set_wrap_width", dynlib: lib.}
proc get_row_span_column*(combo_box: PComboBox): gint{.cdecl,
    importc: "gtk_combo_box_get_row_span_column", dynlib: lib.}
proc set_row_span_column*(combo_box: PComboBox; row_span: gint){.cdecl,
    importc: "gtk_combo_box_set_row_span_column", dynlib: lib.}
proc get_column_span_column*(combo_box: PComboBox): gint{.cdecl,
    importc: "gtk_combo_box_get_column_span_column", dynlib: lib.}
proc set_column_span_column*(combo_box: PComboBox; column_span: gint){.
    cdecl, importc: "gtk_combo_box_set_column_span_column", dynlib: lib.}
proc get_add_tearoffs*(combo_box: PComboBox): gboolean{.cdecl,
    importc: "gtk_combo_box_get_add_tearoffs", dynlib: lib.}
proc set_add_tearoffs*(combo_box: PComboBox; add_tearoffs: gboolean){.
    cdecl, importc: "gtk_combo_box_set_add_tearoffs", dynlib: lib.}
proc get_title*(combo_box: PComboBox): ptr gchar{.cdecl,
    importc: "gtk_combo_box_get_title", dynlib: lib.}
proc set_title*(combo_box: PComboBox; title: ptr gchar){.cdecl,
    importc: "gtk_combo_box_set_title", dynlib: lib.}
proc get_focus_on_click*(combo: PComboBox): gboolean{.cdecl,
    importc: "gtk_combo_box_get_focus_on_click", dynlib: lib.}
proc set_focus_on_click*(combo: PComboBox; focus_on_click: gboolean){.
    cdecl, importc: "gtk_combo_box_set_focus_on_click", dynlib: lib.}

proc get_active*(combo_box: PComboBox): gint{.cdecl,
    importc: "gtk_combo_box_get_active", dynlib: lib.}
proc set_active*(combo_box: PComboBox; index: gint){.cdecl,
    importc: "gtk_combo_box_set_active", dynlib: lib.}
proc get_active_iter*(combo_box: PComboBox; iter: PTreeIter): gboolean{.
    cdecl, importc: "gtk_combo_box_get_active_iter", dynlib: lib.}
proc set_active_iter*(combo_box: PComboBox; iter: PTreeIter){.cdecl,
    importc: "gtk_combo_box_set_active_iter", dynlib: lib.}

proc set_model*(combo_box: PComboBox; model: PTreeModel){.cdecl,
    importc: "gtk_combo_box_set_model", dynlib: lib.}
proc get_model*(combo_box: PComboBox): PTreeModel{.cdecl,
    importc: "gtk_combo_box_get_model", dynlib: lib.}
discard """proc get_row_separator_func*(combo_box: PComboBox): GtkTreeViewRowSeparatorFunc{.
    cdecl, importc: "gtk_combo_box_get_row_separator_func", dynlib: lib.}
proc set_row_separator_func*(combo_box: PComboBox;
                             fn: GtkTreeViewRowSeparatorFunc; data: gpointer;
                             destroy: GDestroyNotify){.cdecl,
    importc: "gtk_combo_box_set_row_separator_func", dynlib: lib.}"""
discard """proc set_button_sensitivity*(combo_box: PComboBox;
                             sensitivity: GtkSensitivityType){.cdecl,
    importc: "gtk_combo_box_set_button_sensitivity", dynlib: lib.}
proc get_button_sensitivity*(combo_box: PComboBox): GtkSensitivityType{.
    cdecl, importc: "gtk_combo_box_get_button_sensitivity", dynlib: lib.}"""
proc get_has_entry*(combo_box: PComboBox): gboolean{.cdecl,
    importc: "gtk_combo_box_get_has_entry", dynlib: lib.}
proc set_entry_text_column*(combo_box: PComboBox; text_column: gint){.
    cdecl, importc: "gtk_combo_box_set_entry_text_column", dynlib: lib.}
proc get_entry_text_column*(combo_box: PComboBox): gint{.cdecl,
    importc: "gtk_combo_box_get_entry_text_column", dynlib: lib.}

proc popup*(combo_box: PComboBox){.cdecl, importc: "gtk_combo_box_popup",
    dynlib: lib.}
proc popdown*(combo_box: PComboBox){.cdecl,
    importc: "gtk_combo_box_popdown", dynlib: lib.}
discard """proc get_popup_accessible*(combo_box: PComboBox): ptr AtkObject{.cdecl,
    importc: "gtk_combo_box_get_popup_accessible", dynlib: lib.}"""

