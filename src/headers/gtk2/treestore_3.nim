# Included by headers/gtk2.nim; do not import directly.
proc tree_store_new*(n_columns: gint): PTreeStore{.varargs, cdecl,
    importc: "gtk_tree_store_new", dynlib: lib.}
proc set*(tree_store: PTreeStore, iter: PTreeIter){.varargs, cdecl,
    importc: "gtk_tree_store_set", dynlib: lib.}
proc set_valist*(tree_store: PTreeStore, iter: PTreeIter){.varargs,
    cdecl, importc: "gtk_tree_store_set_valist", dynlib: lib.}
proc iter_is_valid*(tree_store: PTreeStore, iter: PTreeIter): gboolean{.
    cdecl, importc: "gtk_tree_store_iter_is_valid", dynlib: lib.}
proc reorder*(tree_store: PTreeStore, parent: PTreeIter,
                         new_order: Pgint){.cdecl,
    importc: "gtk_tree_store_reorder", dynlib: lib.}
proc swap*(tree_store: PTreeStore, a: PTreeIter, b: PTreeIter){.
    cdecl, importc: "gtk_tree_store_swap", dynlib: lib.}
proc move_before*(tree_store: PTreeStore, iter: PTreeIter,
                             position: PTreeIter){.cdecl,
    importc: "gtk_tree_store_move_before", dynlib: lib.}
proc move_after*(tree_store: PTreeStore, iter: PTreeIter,
                            position: PTreeIter){.cdecl,
    importc: "gtk_tree_store_move_after", dynlib: lib.}
