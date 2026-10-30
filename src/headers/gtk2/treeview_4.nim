# Included by headers/gtk2.nim; do not import directly.
proc column_start_drag*(tree_view: PTreeView, column: PTreeViewColumn){.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_column_start_drag".}
