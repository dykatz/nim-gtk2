# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_MODEL*(): GType =
  result = tree_model_get_type()

proc TREE_MODEL*(obj: pointer): PTreeModel =
  result = cast[PTreeModel](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_TREE_MODEL()))

proc IS_TREE_MODEL*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TREE_MODEL())

proc TREE_MODEL_GET_IFACE*(obj: pointer): PTreeModelIface =
  result = cast[PTreeModelIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_TREE_MODEL()))

proc TYPE_TREE_ITER*(): GType =
  result = tree_iter_get_type()

proc TYPE_TREE_PATH*(): GType =
  result = tree_path_get_type()

proc tree_path_new_root*(): PTreePath =
  result = tree_path_new_first()

proc get_iter_root*(tree_model: PTreeModel, iter: PTreeIter): gboolean =
  result = get_iter_first(tree_model, iter)

