# Included by headers/gtk2.nim; do not import directly.
proc column_realize_button*(column: PTreeViewColumn){.cdecl,
    dynlib: lib, importc: "_gtk_tree_view_column_realize_button".}
proc column_unrealize_button*(column: PTreeViewColumn){.cdecl,
    dynlib: lib, importc: "_gtk_tree_view_column_unrealize_button".}
proc column_set_tree_view*(column: PTreeViewColumn,
                                     tree_view: PTreeView){.cdecl, dynlib: lib,
    importc: "_gtk_tree_view_column_set_tree_view".}
proc column_unset_tree_view*(column: PTreeViewColumn){.cdecl,
    dynlib: lib, importc: "_gtk_tree_view_column_unset_tree_view".}
proc column_set_width*(column: PTreeViewColumn, width: gint){.cdecl,
    dynlib: lib, importc: "_gtk_tree_view_column_set_width".}
