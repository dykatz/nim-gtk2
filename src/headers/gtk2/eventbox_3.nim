# Included by headers/gtk2.nim; do not import directly.
proc set_visible_window*(evBox: PEventBox, v: gboolean){.cdecl, dynlib: lib,
  importc: "gtk_event_box_set_visible_window".}

