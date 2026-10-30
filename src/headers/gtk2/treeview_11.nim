# Included by headers/gtk2.nim; do not import directly.
proc set_tooltip_column*(w: PTreeview, column: gint){.cdecl,
  dynlib: lib, importc: "gtk_tree_view_set_tooltip_column".}

