# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_SELECTION*(): GType =
  result = tree_selection_get_type()

proc TREE_SELECTION*(obj: pointer): PTreeSelection =
  result = cast[PTreeSelection](CHECK_CAST(obj, TYPE_TREE_SELECTION()))

proc TREE_SELECTION_CLASS*(klass: pointer): PTreeSelectionClass =
  result = cast[PTreeSelectionClass](CHECK_CLASS_CAST(klass,
      TYPE_TREE_SELECTION()))

proc IS_TREE_SELECTION*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TREE_SELECTION())

proc IS_TREE_SELECTION_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TREE_SELECTION())

proc TREE_SELECTION_GET_CLASS*(obj: pointer): PTreeSelectionClass =
  result = cast[PTreeSelectionClass](CHECK_GET_CLASS(obj, TYPE_TREE_SELECTION()))

