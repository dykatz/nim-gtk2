# Included by headers/gtk2.nim; do not import directly.
const
  TREE_MODEL_ITERS_PERSIST* = 1 shl 0
const
  TREE_MODEL_LIST_ONLY* = 1 shl 1

proc TYPE_TREE_MODEL*(): GType
proc TREE_MODEL*(obj: pointer): PTreeModel
proc IS_TREE_MODEL*(obj: pointer): bool
proc TREE_MODEL_GET_IFACE*(obj: pointer): PTreeModelIface
proc TYPE_TREE_ITER*(): GType
proc TYPE_TREE_PATH*(): GType
proc tree_path_new*(): PTreePath{.cdecl, dynlib: lib,
                                  importc: "gtk_tree_path_new".}
proc tree_path_new_from_string*(path: cstring): PTreePath{.cdecl, dynlib: lib,
    importc: "gtk_tree_path_new_from_string".}
proc to_string*(path: PTreePath): cstring{.cdecl, dynlib: lib,
    importc: "gtk_tree_path_to_string".}
proc tree_path_new_root*(): PTreePath
proc tree_path_new_first*(): PTreePath{.cdecl, dynlib: lib,
                                        importc: "gtk_tree_path_new_first".}
proc append_index*(path: PTreePath, index: gint){.cdecl, dynlib: lib,
    importc: "gtk_tree_path_append_index".}
proc prepend_index*(path: PTreePath, index: gint){.cdecl, dynlib: lib,
    importc: "gtk_tree_path_prepend_index".}
proc get_depth*(path: PTreePath): gint{.cdecl, dynlib: lib,
    importc: "gtk_tree_path_get_depth".}
proc get_indices*(path: PTreePath): Pgint{.cdecl, dynlib: lib,
    importc: "gtk_tree_path_get_indices".}
proc free*(path: PTreePath){.cdecl, dynlib: lib,
                                       importc: "gtk_tree_path_free".}
proc copy*(path: PTreePath): PTreePath{.cdecl, dynlib: lib,
    importc: "gtk_tree_path_copy".}
proc tree_path_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "gtk_tree_path_get_type".}
proc compare*(a: PTreePath, b: PTreePath): gint{.cdecl, dynlib: lib,
    importc: "gtk_tree_path_compare".}
proc next*(path: PTreePath){.cdecl, dynlib: lib,
                                       importc: "gtk_tree_path_next".}
proc prev*(path: PTreePath): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_tree_path_prev".}
proc up*(path: PTreePath): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_tree_path_up".}
proc down*(path: PTreePath){.cdecl, dynlib: lib,
                                       importc: "gtk_tree_path_down".}
proc is_ancestor*(path: PTreePath, descendant: PTreePath): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_path_is_ancestor".}
proc is_descendant*(path: PTreePath, ancestor: PTreePath): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_path_is_descendant".}
proc row_reference_new*(model: PTreeModel, path: PTreePath): PTreeRowReference{.
    cdecl, dynlib: lib, importc: "gtk_tree_row_reference_new".}
proc tree_row_reference_new_proxy*(proxy: PGObject, model: PTreeModel,
                                   path: PTreePath): PTreeRowReference{.cdecl,
    dynlib: lib, importc: "gtk_tree_row_reference_new_proxy".}
proc reference_get_model*(reference: PTreeRowReference): PTreeModel {.cdecl,
    dynlib: lib, importc: "gtk_tree_row_reference_get_model".}
proc reference_get_path*(reference: PTreeRowReference): PTreePath{.
    cdecl, dynlib: lib, importc: "gtk_tree_row_reference_get_path".}
proc reference_valid*(reference: PTreeRowReference): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_row_reference_valid".}
proc reference_free*(reference: PTreeRowReference){.cdecl, dynlib: lib,
    importc: "gtk_tree_row_reference_free".}
proc tree_row_reference_inserted*(proxy: PGObject, path: PTreePath){.cdecl,
    dynlib: lib, importc: "gtk_tree_row_reference_inserted".}
proc tree_row_reference_deleted*(proxy: PGObject, path: PTreePath){.cdecl,
    dynlib: lib, importc: "gtk_tree_row_reference_deleted".}
proc tree_row_reference_reordered*(proxy: PGObject, path: PTreePath,
                                   iter: PTreeIter, new_order: Pgint){.cdecl,
    dynlib: lib, importc: "gtk_tree_row_reference_reordered".}
proc copy*(iter: PTreeIter): PTreeIter{.cdecl, dynlib: lib,
    importc: "gtk_tree_iter_copy".}
proc free*(iter: PTreeIter){.cdecl, dynlib: lib,
                                       importc: "gtk_tree_iter_free".}
proc tree_iter_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "gtk_tree_iter_get_type".}
proc tree_model_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_tree_model_get_type".}
proc get_flags*(tree_model: PTreeModel): TTreeModelFlags{.cdecl,
    dynlib: lib, importc: "gtk_tree_model_get_flags".}
proc get_n_columns*(tree_model: PTreeModel): gint{.cdecl,
    dynlib: lib, importc: "gtk_tree_model_get_n_columns".}
proc get_column_type*(tree_model: PTreeModel, index: gint): GType{.
    cdecl, dynlib: lib, importc: "gtk_tree_model_get_column_type".}
proc get_iter*(tree_model: PTreeModel, iter: PTreeIter,
                          path: PTreePath): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_tree_model_get_iter".}
proc get_iter_from_string*(tree_model: PTreeModel, iter: PTreeIter,
                                      path_string: cstring): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_model_get_iter_from_string".}
proc get_iter_root*(tree_model: PTreeModel, iter: PTreeIter): gboolean
proc get_iter_first*(tree_model: PTreeModel, iter: PTreeIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_model_get_iter_first".}
proc get_path*(tree_model: PTreeModel, iter: PTreeIter): PTreePath{.
    cdecl, dynlib: lib, importc: "gtk_tree_model_get_path".}
proc get_value*(tree_model: PTreeModel, iter: PTreeIter,
                           column: gint, value: PGValue){.cdecl, dynlib: lib,
    importc: "gtk_tree_model_get_value".}
proc iter_next*(tree_model: PTreeModel, iter: PTreeIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_model_iter_next".}
proc iter_children*(tree_model: PTreeModel, iter: PTreeIter,
                               parent: PTreeIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_tree_model_iter_children".}
proc iter_has_child*(tree_model: PTreeModel, iter: PTreeIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_model_iter_has_child".}
proc iter_n_children*(tree_model: PTreeModel, iter: PTreeIter): gint{.
    cdecl, dynlib: lib, importc: "gtk_tree_model_iter_n_children".}
proc iter_nth_child*(tree_model: PTreeModel, iter: PTreeIter,
                                parent: PTreeIter, n: gint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_model_iter_nth_child".}
proc iter_parent*(tree_model: PTreeModel, iter: PTreeIter,
                             child: PTreeIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_tree_model_iter_parent".}
proc get_string_from_iter*(tree_model: PTreeModel, iter: PTreeIter):
    cstring{.cdecl, dynlib: lib,
             importc: "gtk_tree_model_get_string_from_iter".}
proc ref_node*(tree_model: PTreeModel, iter: PTreeIter){.cdecl,
    dynlib: lib, importc: "gtk_tree_model_ref_node".}
proc unref_node*(tree_model: PTreeModel, iter: PTreeIter){.cdecl,
    dynlib: lib, importc: "gtk_tree_model_unref_node".}
proc foreach*(model: PTreeModel, fun: TTreeModelForeachFunc,
                         user_data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_tree_model_foreach".}
proc row_changed*(tree_model: PTreeModel, path: PTreePath,
                             iter: PTreeIter){.cdecl, dynlib: lib,
    importc: "gtk_tree_model_row_changed".}
proc row_inserted*(tree_model: PTreeModel, path: PTreePath,
                              iter: PTreeIter){.cdecl, dynlib: lib,
    importc: "gtk_tree_model_row_inserted".}
proc row_has_child_toggled*(tree_model: PTreeModel, path: PTreePath,
                                       iter: PTreeIter){.cdecl, dynlib: lib,
    importc: "gtk_tree_model_row_has_child_toggled".}
proc row_deleted*(tree_model: PTreeModel, path: PTreePath){.cdecl,
    dynlib: lib, importc: "gtk_tree_model_row_deleted".}
proc rows_reordered*(tree_model: PTreeModel, path: PTreePath,
                                iter: PTreeIter, new_order: Pgint){.cdecl,
    dynlib: lib, importc: "gtk_tree_model_rows_reordered".}
const
  TREE_SORTABLE_DEFAULT_SORT_COLUMN_ID* = - (1)

