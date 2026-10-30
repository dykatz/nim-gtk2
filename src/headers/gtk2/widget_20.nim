# Included by headers/gtk2.nim; do not import directly.
proc set_tooltip_text*(w: PWidget, t: cstring){.cdecl,
  dynlib: lib, importc: "gtk_widget_set_tooltip_text".}

proc get_tooltip_text*(w: PWidget): cstring{.cdecl,
  dynlib: lib, importc: "gtk_widget_get_tooltip_text".}

proc set_tooltip_markup*(w: PWidget, m: cstring) {.cdecl, dynlib: lib,
  importc: "gtk_widget_set_tooltip_markup".}

proc get_tooltip_markup*(w: PWidget): cstring {.cdecl, dynlib: lib,
  importc: "gtk_widget_get_tooltip_markup".}

