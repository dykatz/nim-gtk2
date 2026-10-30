# Included by headers/gtk2.nim; do not import directly.
proc trigger_tooltip_query*(widg: PWidget){.cdecl, dynlib: lib,
  importc: "gtk_widget_trigger_tooltip_query".}

