# Included by headers/gtk2.nim; do not import directly.
proc is_active*(win: PWindow): gboolean{.cdecl,
    importc: "gtk_window_is_active", dynlib: lib.}
proc has_toplevel_focus*(win: PWindow): gboolean{.cdecl,
    importc: "gtk_window_has_toplevel_focus", dynlib: lib.}
