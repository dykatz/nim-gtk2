# Included by headers/gtk2.nim; do not import directly.
proc column_start_editing*(tree_column: PTreeViewColumn,
                                     editable_widget: PCellEditable){.cdecl,
    dynlib: lib, importc: "_gtk_tree_view_column_start_editing".}
proc column_stop_editing*(tree_column: PTreeViewColumn){.cdecl,
    dynlib: lib, importc: "_gtk_tree_view_column_stop_editing".}
