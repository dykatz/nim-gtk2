# Included by headers/gtk2.nim; do not import directly.
proc set_width_chars*(entry: PLabel, n_chars: gint){.cdecl, dynlib: lib,
    importc: "gtk_label_set_width_chars".}
proc get_width_chars*(entry: PLabel): gint{.cdecl, dynlib: lib,
    importc: "gtk_label_get_width_chars".}
