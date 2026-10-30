# Included by headers/gtk2.nim; do not import directly.
proc set_has_tooltip*(widget: PWidget, b: gboolean){.cdecl, dynlib: lib,
  importc: "gtk_widget_set_has_tooltip".}

proc get_has_tooltip*(widget: PWidget): gboolean{.cdecl, dynlib: lib,
  importc: "gtk_widget_get_has_tooltip".}

