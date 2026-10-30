# Included by headers/gtk2.nim; do not import directly.
proc tree_view_column_new_with_attributes*(title: cstring, cell: PCellRenderer): PTreeViewColumn{.
    importc: "gtk_tree_view_column_new_with_attributes", varargs, cdecl,
    dynlib: lib.}
proc column_set_attributes*(tree_column: PTreeViewColumn,
                                      cell_renderer: PCellRenderer){.
    importc: "gtk_tree_view_column_set_attributes", varargs, cdecl, dynlib: lib.}
