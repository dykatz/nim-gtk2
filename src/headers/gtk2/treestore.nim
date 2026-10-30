# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_STORE*(): GType
proc TREE_STORE*(obj: pointer): PTreeStore
proc TREE_STORE_CLASS*(klass: pointer): PTreeStoreClass
proc IS_TREE_STORE*(obj: pointer): bool
proc IS_TREE_STORE_CLASS*(klass: pointer): bool
proc TREE_STORE_GET_CLASS*(obj: pointer): PTreeStoreClass
proc columns_dirty*(a: PTreeStore): guint
proc set_columns_dirty*(a: PTreeStore, `columns_dirty`: guint)
proc tree_store_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_tree_store_get_type".}
proc tree_store_newv*(n_columns: gint, types: PGType): PTreeStore{.cdecl,
    dynlib: lib, importc: "gtk_tree_store_newv".}
proc set_valuesv*(store: PTreeStore, iter: PTreeIter, columns: Pgint,
                 values: PGValue, count: gint) {.cdecl, dynlib: lib,
    importc: "gtk_tree_store_set_valuesv".}
proc insert_with_valuesv*(store: PTreeStore, iter: PTreeIter, parent: PTreeIter,
                         position: gint, columns: Pgint, values: PGValue,
                         count: gint) {.cdecl, dynlib: lib,
    importc: "gtk_tree_store_insert_with_valuesv".}
proc set_column_types*(tree_store: PTreeStore, n_columns: gint,
                                  types: PGType){.cdecl, dynlib: lib,
    importc: "gtk_tree_store_set_column_types".}
proc set_value*(tree_store: PTreeStore, iter: PTreeIter,
                           column: gint, value: PGValue){.cdecl, dynlib: lib,
    importc: "gtk_tree_store_set_value".}
proc remove*(tree_store: PTreeStore, iter: PTreeIter): gboolean {.cdecl,
    dynlib: lib, importc: "gtk_tree_store_remove".}
proc insert*(tree_store: PTreeStore, iter: PTreeIter,
                        parent: PTreeIter, position: gint){.cdecl, dynlib: lib,
    importc: "gtk_tree_store_insert".}
proc insert_before*(tree_store: PTreeStore, iter: PTreeIter,
                               parent: PTreeIter, sibling: PTreeIter){.cdecl,
    dynlib: lib, importc: "gtk_tree_store_insert_before".}
proc insert_after*(tree_store: PTreeStore, iter: PTreeIter,
                              parent: PTreeIter, sibling: PTreeIter){.cdecl,
    dynlib: lib, importc: "gtk_tree_store_insert_after".}
proc prepend*(tree_store: PTreeStore, iter: PTreeIter,
                         parent: PTreeIter){.cdecl, dynlib: lib,
    importc: "gtk_tree_store_prepend".}
proc append*(tree_store: PTreeStore, iter: PTreeIter,
                        parent: PTreeIter){.cdecl, dynlib: lib,
    importc: "gtk_tree_store_append".}
proc is_ancestor*(tree_store: PTreeStore, iter: PTreeIter,
                             descendant: PTreeIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_store_is_ancestor".}
proc iter_depth*(tree_store: PTreeStore, iter: PTreeIter): gint{.
    cdecl, dynlib: lib, importc: "gtk_tree_store_iter_depth".}
proc clear*(tree_store: PTreeStore){.cdecl, dynlib: lib,
    importc: "gtk_tree_store_clear".}
const
  bm_TGtkTreeViewColumn_visible* = 0x0001'u16
const
  bp_TGtkTreeViewColumn_visible* = 0'u16
const
  bm_TGtkTreeViewColumn_resizable* = 0x0002'u16
const
  bp_TGtkTreeViewColumn_resizable* = 1'u16
const
  bm_TGtkTreeViewColumn_clickable* = 0x0004'u16
const
  bp_TGtkTreeViewColumn_clickable* = 2'u16
const
  bm_TGtkTreeViewColumn_dirty* = 0x0008'u16
const
  bp_TGtkTreeViewColumn_dirty* = 3'u16
const
  bm_TGtkTreeViewColumn_show_sort_indicator* = 0x0010'u16
const
  bp_TGtkTreeViewColumn_show_sort_indicator* = 4'u16
const
  bm_TGtkTreeViewColumn_maybe_reordered* = 0x0020'u16
const
  bp_TGtkTreeViewColumn_maybe_reordered* = 5'u16
const
  bm_TGtkTreeViewColumn_reorderable* = 0x0040'u16
const
  bp_TGtkTreeViewColumn_reorderable* = 6'u16
const
  bm_TGtkTreeViewColumn_use_resized_width* = 0x0080'u16
const
  bp_TGtkTreeViewColumn_use_resized_width* = 7'u16

