# Included by headers/gtk2.nim; do not import directly.
proc get_visible_window*(evBox: PEventBox): gboolean {.cdecl, dynlib: lib,
  importc: "gtk_event_box_get_visible_window".}
proc get_above_child*(evBox: PEventBox): gboolean {.cdecl, dynlib: lib,
  importc: "gtk_event_box_get_above_child".}
proc set_above_child*(evBox: PEventBox, value: gboolean) {.cdecl, dynlib: lib,
  importc: "gtk_event_box_set_above_child".}
proc set_visible_window*(evBox: PEventBox, v: gboolean){.cdecl, dynlib: lib,
  importc: "gtk_event_box_set_visible_window".}

