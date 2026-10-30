# Included by headers/gtk2.nim; do not import directly.
proc column_has_editable_cell*(column: PTreeViewColumn): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_column_has_editable_cell".}
proc column_get_edited_cell*(column: PTreeViewColumn): PCellRenderer{.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_column_get_edited_cell".}
proc column_count_special_cells*(column: PTreeViewColumn): gint{.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_column_count_special_cells".}
proc column_get_cell_at_pos*(column: PTreeViewColumn, x: gint): PCellRenderer{.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_column_get_cell_at_pos".}
