# Included by headers/gtk2.nim; do not import directly.
proc selection_incr_event*(window: gdk2.PWindow, event: gdk2.PEventProperty): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_selection_incr_event".}
