# Included by headers/gtk2.nim; do not import directly.
proc selection_new*(tree_view: PTreeView): PTreeSelection{.
    cdecl, dynlib: lib, importc: "_gtk_tree_selection_new_with_tree_view".}
