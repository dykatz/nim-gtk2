# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ITEM*(): GType =
  result = item_get_type()

proc ITEM*(obj: pointer): PItem =
  result = cast[PItem](CHECK_CAST(obj, TYPE_ITEM()))

proc ITEM_CLASS*(klass: pointer): PItemClass =
  result = cast[PItemClass](CHECK_CLASS_CAST(klass, TYPE_ITEM()))

proc IS_ITEM*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_ITEM())

proc IS_ITEM_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ITEM())

proc ITEM_GET_CLASS*(obj: pointer): PItemClass =
  result = cast[PItemClass](CHECK_GET_CLASS(obj, TYPE_ITEM()))

