# Included by headers/gtk2.nim; do not import directly.
proc set_tree_view*(selection: PTreeSelection,
                                   tree_view: PTreeView){.cdecl, dynlib: lib,
    importc: "_gtk_tree_selection_set_tree_view".}
