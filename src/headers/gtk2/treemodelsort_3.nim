# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_MODEL_SORT*(): GType =
  result = tree_model_sort_get_type()

proc TREE_MODEL_SORT*(obj: pointer): PTreeModelSort =
  result = cast[PTreeModelSort](CHECK_CAST(obj, TYPE_TREE_MODEL_SORT()))

proc TREE_MODEL_SORT_CLASS*(klass: pointer): PTreeModelSortClass =
  result = cast[PTreeModelSortClass](CHECK_CLASS_CAST(klass,
      TYPE_TREE_MODEL_SORT()))

proc IS_TREE_MODEL_SORT*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TREE_MODEL_SORT())

proc IS_TREE_MODEL_SORT_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TREE_MODEL_SORT())

proc TREE_MODEL_SORT_GET_CLASS*(obj: pointer): PTreeModelSortClass =
  result = cast[PTreeModelSortClass](CHECK_GET_CLASS(obj, TYPE_TREE_MODEL_SORT()))

