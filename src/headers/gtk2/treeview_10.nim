# Included by headers/gtk2.nim; do not import directly.
proc insert_column_with_attributes*(tree_view: PTreeView,
    position: gint, title: cstring, cell: PCellRenderer): gint{.varargs,
    importc: "gtk_tree_view_insert_column_with_attributes", cdecl, dynlib: lib.}
