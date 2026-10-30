# Included by headers/gtk2.nim; do not import directly.
proc tree_selection_new*(): PTreeSelection{.cdecl, dynlib: lib,
    importc: "_gtk_tree_selection_new".}
