# Included by headers/gtk2.nim; do not import directly.
proc install_mark_rows_col_dirty*(tree_view: PTreeView){.cdecl,
    dynlib: lib, importc: "_gtk_tree_view_install_mark_rows_col_dirty".}
proc DOgtk_tree_view_column_autosize*(tree_view: PTreeView,
                                      column: PTreeViewColumn){.cdecl,
    dynlib: lib, importc: "_gtk_tree_view_column_autosize".}
