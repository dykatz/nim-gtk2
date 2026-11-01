# Included by headers/gtk2.nim; do not import directly.
proc get_window*(w: PWidget): gdk2.PWindow {.cdecl, dynlib: lib,
    importc: "gtk_widget_get_window".}
proc get_realized*(w: PWidget): gboolean {.cdecl, dynlib: lib,
                                           importc: "gtk_widget_get_realized".}

