# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ENTRY*(): GType
proc ENTRY*(obj: pointer): PEntry
proc ENTRY_CLASS*(klass: pointer): PEntryClass
proc IS_ENTRY*(obj: pointer): bool
proc IS_ENTRY_CLASS*(klass: pointer): bool
proc ENTRY_GET_CLASS*(obj: pointer): PEntryClass
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
proc unset_invisible_char*(entry: PEntry) {.cdecl, dynlib: lib,
    importc: "gtk_entry_unset_invisible_char".}
proc set_overwrite_mode*(entry: PEntry, value: gboolean) {.cdecl, dynlib: lib,
    importc: "gtk_entry_set_overwrite_mode".}
proc get_overwrite_mode*(entry: PEntry): gboolean {.cdecl, dynlib: lib,
    importc: "gtk_entry_get_overwrite_mode".}
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
proc set_progress_fraction*(entry: PEntry, fraction: gdouble) {.cdecl, dynlib: lib, importc: "gtk_entry_set_progress_fraction".}
proc get_progress_fraction*(entry: PEntry): gdouble {.cdecl, dynlib: lib, importc: "gtk_entry_get_progress_fraction".}
proc set_progress_pulse_step*(entry: PEntry, fraction: gdouble) {.cdecl, dynlib: lib, importc: "gtk_entry_set_progress_pulse_step".}
proc get_progress_pulse_step*(entry: PEntry): gdouble {.cdecl, dynlib: lib, importc: "gtk_entry_get_progress_pulse_step".}
proc entry_progress_pulse*(entry: PEntry) {.cdecl, dynlib: lib, importc: "gtk_entry_progress_pulse".}
proc set_width_chars*(entry: PEntry, n_chars: gint){.cdecl, dynlib: lib,
    importc: "gtk_entry_set_width_chars".}
proc get_width_chars*(entry: PEntry): gint{.cdecl, dynlib: lib,
    importc: "gtk_entry_get_width_chars".}
