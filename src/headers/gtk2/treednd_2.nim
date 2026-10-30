# Included by headers/gtk2.nim; do not import directly.
proc TREE_DRAG_SOURCE*(obj: pointer): PTreeDragSource =
  result = cast[PTreeDragSource](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_TREE_DRAG_SOURCE()))

proc IS_TREE_DRAG_SOURCE*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TREE_DRAG_SOURCE())

proc TREE_DRAG_SOURCE_GET_IFACE*(obj: pointer): PTreeDragSourceIface =
  result = cast[PTreeDragSourceIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_TREE_DRAG_SOURCE()))

proc TYPE_TREE_DRAG_DEST*(): GType =
  result = tree_drag_dest_get_type()

proc TREE_DRAG_DEST*(obj: pointer): PTreeDragDest =
  result = cast[PTreeDragDest](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_TREE_DRAG_DEST()))

proc IS_TREE_DRAG_DEST*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TREE_DRAG_DEST())

proc TREE_DRAG_DEST_GET_IFACE*(obj: pointer): PTreeDragDestIface =
  result = cast[PTreeDragDestIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_TREE_DRAG_DEST()))

