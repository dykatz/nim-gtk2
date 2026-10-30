# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_SORTABLE*(): GType =
  result = tree_sortable_get_type()

proc TREE_SORTABLE*(obj: pointer): PTreeSortable =
  result = cast[PTreeSortable](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_TREE_SORTABLE()))

proc TREE_SORTABLE_CLASS*(obj: pointer): PTreeSortableIface =
  result = cast[PTreeSortableIface](G_TYPE_CHECK_CLASS_CAST(obj,
      TYPE_TREE_SORTABLE()))

proc IS_TREE_SORTABLE*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TREE_SORTABLE())

proc TREE_SORTABLE_GET_IFACE*(obj: pointer): PTreeSortableIface =
  result = cast[PTreeSortableIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_TREE_SORTABLE()))

