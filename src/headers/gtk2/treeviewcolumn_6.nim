# Included by headers/gtk2.nim; do not import directly.
proc column_cell_render*(tree_column: PTreeViewColumn,
                                   window: gdk2.PWindow,
                                   background_area: gdk2.PRectangle,
                                   cell_area: gdk2.PRectangle,
                                   expose_area: gdk2.PRectangle, flags: guint){.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_column_cell_render".}
proc column_cell_focus*(tree_column: PTreeViewColumn, direction: gint,
                                  left: gboolean, right: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_column_cell_focus".}
proc column_cell_draw_focus*(tree_column: PTreeViewColumn,
                                       window: gdk2.PWindow,
                                       background_area: gdk2.PRectangle,
                                       cell_area: gdk2.PRectangle,
                                       expose_area: gdk2.PRectangle, flags: guint){.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_column_cell_draw_focus".}
proc column_cell_set_dirty*(tree_column: PTreeViewColumn,
                                      install_handler: gboolean){.cdecl,
    dynlib: lib, importc: "_gtk_tree_view_column_cell_set_dirty".}
proc column_get_neighbor_sizes*(column: PTreeViewColumn,
    cell: PCellRenderer, left: Pgint, right: Pgint){.cdecl, dynlib: lib,
    importc: "_gtk_tree_view_column_get_neighbor_sizes".}
