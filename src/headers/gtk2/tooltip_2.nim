# Included by headers/gtk2.nim; do not import directly.
proc set_markup*(tp: PTooltip, mk: cstring){.cdecl, dynlib: lib,
  importc: "gtk_tooltip_set_markup".}

