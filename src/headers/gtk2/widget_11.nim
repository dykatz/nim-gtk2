# Included by headers/gtk2.nim; do not import directly.
proc selection_request*(widget: PWidget, event: gdk2.PEventSelection): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_selection_request".}
