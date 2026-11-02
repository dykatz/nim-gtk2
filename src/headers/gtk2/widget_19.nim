# Included by headers/gtk2.nim; do not import directly.
proc get_allocation*(w: PWidget, allocation: PAllocation) {.cdecl, dynlib: lib,
    importc: "gtk_widget_get_allocation".}
proc get_mapped*(w: PWidget): gboolean {.cdecl, dynlib: lib,
    importc: "gtk_widget_get_mapped".}
proc get_can_focus*(w: PWidget): gboolean {.cdecl, dynlib: lib,
    importc: "gtk_widget_get_can_focus".}
proc set_can_focus*(w: PWidget, value: gboolean) {.cdecl, dynlib: lib,
    importc: "gtk_widget_set_can_focus".}
proc get_window*(w: PWidget): gdk2.PWindow {.cdecl, dynlib: lib,
    importc: "gtk_widget_get_window".}
proc get_realized*(w: PWidget): gboolean {.cdecl, dynlib: lib,
                                           importc: "gtk_widget_get_realized".}

