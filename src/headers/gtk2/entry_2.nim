# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ENTRY*(): GType
proc ENTRY*(obj: pointer): PEntry
proc ENTRY_CLASS*(klass: pointer): PEntryClass
proc IS_ENTRY*(obj: pointer): bool
proc IS_ENTRY_CLASS*(klass: pointer): bool
proc ENTRY_GET_CLASS*(obj: pointer): PEntryClass
proc editable*(a: PEntry): guint
proc set_editable*(a: PEntry, `editable`: guint)
proc visible*(a: PEntry): guint
proc set_visible*(a: PEntry, `visible`: guint)
proc overwrite_mode*(a: PEntry): guint
proc set_overwrite_mode*(a: PEntry, `overwrite_mode`: guint)
proc in_drag*(a: PEntry): guint
proc set_in_drag*(a: PEntry, `in_drag`: guint)
proc cache_includes_preedit*(a: PEntry): guint
proc set_cache_includes_preedit*(a: PEntry, `cache_includes_preedit`: guint)
proc need_im_reset*(a: PEntry): guint
proc set_need_im_reset*(a: PEntry, `need_im_reset`: guint)
proc has_frame*(a: PEntry): guint
proc set_has_frame*(a: PEntry, `has_frame`: guint)
proc activates_default*(a: PEntry): guint
proc set_activates_default*(a: PEntry, `activates_default`: guint)
proc cursor_visible*(a: PEntry): guint
proc set_cursor_visible*(a: PEntry, `cursor_visible`: guint)
proc in_click*(a: PEntry): guint
proc set_in_click*(a: PEntry, `in_click`: guint)
proc is_cell_renderer*(a: PEntry): guint
proc set_is_cell_renderer*(a: PEntry, `is_cell_renderer`: guint)
proc editing_canceled*(a: PEntry): guint
proc set_editing_canceled*(a: PEntry, `editing_canceled`: guint)
proc mouse_cursor_obscured*(a: PEntry): guint
proc set_mouse_cursor_obscured*(a: PEntry, `mouse_cursor_obscured`: guint)
proc entry_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_entry_get_type".}
proc entry_new*(): PEntry{.cdecl, dynlib: lib, importc: "gtk_entry_new".}
proc set_visibility*(entry: PEntry, visible: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_entry_set_visibility".}
proc get_visibility*(entry: PEntry): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_entry_get_visibility".}
proc set_invisible_char*(entry: PEntry, ch: gunichar){.cdecl, dynlib: lib,
    importc: "gtk_entry_set_invisible_char".}
proc get_invisible_char*(entry: PEntry): gunichar{.cdecl, dynlib: lib,
    importc: "gtk_entry_get_invisible_char".}
proc set_has_frame*(entry: PEntry, setting: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_entry_set_has_frame".}
proc get_has_frame*(entry: PEntry): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_entry_get_has_frame".}
proc set_max_length*(entry: PEntry, max: gint){.cdecl, dynlib: lib,
    importc: "gtk_entry_set_max_length".}
proc get_max_length*(entry: PEntry): gint{.cdecl, dynlib: lib,
    importc: "gtk_entry_get_max_length".}
proc set_activates_default*(entry: PEntry, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_entry_set_activates_default".}
proc get_activates_default*(entry: PEntry): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_entry_get_activates_default".}
proc set_width_chars*(entry: PEntry, n_chars: gint){.cdecl, dynlib: lib,
    importc: "gtk_entry_set_width_chars".}
proc get_width_chars*(entry: PEntry): gint{.cdecl, dynlib: lib,
    importc: "gtk_entry_get_width_chars".}
