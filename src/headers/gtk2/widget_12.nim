# Included by headers/gtk2.nim; do not import directly.
proc selection_notify*(widget: PWidget, event: gdk2.PEventSelection): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_selection_notify".}
proc selection_property_notify*(widget: PWidget, event: gdk2.PEventProperty): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_selection_property_notify".}
