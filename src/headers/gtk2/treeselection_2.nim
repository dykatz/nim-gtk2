# Included by headers/gtk2.nim; do not import directly.
proc internal_select_node*(selection: PTreeSelection,
    node: PRBNode, tree: PRBTree, path: PTreePath, state: gdk2.TModifierType,
    override_browse_mode: gboolean){.cdecl, dynlib: lib, importc: "_gtk_tree_selection_internal_select_node".}
