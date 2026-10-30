# Included by headers/gtk2.nim; do not import directly.
proc trigger_tooltip_query*(widg: PTooltip){.cdecl, dynlib: lib,
  importc: "gtk_tooltip_trigger_tooltip_query".}

