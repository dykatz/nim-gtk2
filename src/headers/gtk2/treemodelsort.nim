# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_MODEL_SORT*(): GType
proc TREE_MODEL_SORT*(obj: pointer): PTreeModelSort
proc TREE_MODEL_SORT_CLASS*(klass: pointer): PTreeModelSortClass
proc IS_TREE_MODEL_SORT*(obj: pointer): bool
proc IS_TREE_MODEL_SORT_CLASS*(klass: pointer): bool
proc TREE_MODEL_SORT_GET_CLASS*(obj: pointer): PTreeModelSortClass
proc tree_model_sort_get_type*(): GType{.cdecl, dynlib: lib,
    importc: "gtk_tree_model_sort_get_type".}
proc sort_new*(child_model: PTreeModel): PTreeModel{.
    cdecl, dynlib: lib, importc: "gtk_tree_model_sort_new_with_model".}
proc sort_get_model*(tree_model: PTreeModelSort): PTreeModel{.cdecl,
    dynlib: lib, importc: "gtk_tree_model_sort_get_model".}
proc tree_model_sort_convert_child_path_to_path*(
    tree_model_sort: PTreeModelSort, child_path: PTreePath): PTreePath{.cdecl,
    dynlib: lib, importc: "gtk_tree_model_sort_convert_child_path_to_path".}
proc tree_model_sort_convert_child_iter_to_iter*(
    tree_model_sort: PTreeModelSort, sort_iter: PTreeIter, child_iter: PTreeIter): gboolean {.
    cdecl, dynlib: lib,
    importc: "gtk_tree_model_sort_convert_child_iter_to_iter".}
proc tree_model_sort_convert_path_to_child_path*(
    tree_model_sort: PTreeModelSort, sorted_path: PTreePath): PTreePath{.cdecl,
    dynlib: lib, importc: "gtk_tree_model_sort_convert_path_to_child_path".}
proc tree_model_sort_convert_iter_to_child_iter*(
    tree_model_sort: PTreeModelSort, child_iter: PTreeIter,
    sorted_iter: PTreeIter){.cdecl, dynlib: lib, importc: "gtk_tree_model_sort_convert_iter_to_child_iter".}
