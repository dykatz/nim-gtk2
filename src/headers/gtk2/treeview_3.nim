# Included by headers/gtk2.nim; do not import directly.
proc find_node*(tree_view: PTreeView, path: PTreePath,
                          tree: var PRBTree, node: var PRBNode): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_find_node".}
proc find_path*(tree_view: PTreeView, tree: PRBTree, node: PRBNode): PTreePath{.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_find_path".}
proc child_move_resize*(tree_view: PTreeView, widget: PWidget,
                                  x: gint, y: gint, width: gint, height: gint){.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_child_move_resize".}
proc queue_draw_node*(tree_view: PTreeView, tree: PRBTree,
                                node: PRBNode, clip_rect: gdk2.PRectangle){.
    cdecl, dynlib: lib, importc: "_gtk_tree_view_queue_draw_node".}
