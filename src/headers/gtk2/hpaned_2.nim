# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HPANED*(): GType =
  result = hpaned_get_type()

proc HPANED*(obj: pointer): PHPaned =
  result = cast[PHPaned](CHECK_CAST(obj, TYPE_HPANED()))

proc HPANED_CLASS*(klass: pointer): PHPanedClass =
  result = cast[PHPanedClass](CHECK_CLASS_CAST(klass, TYPE_HPANED()))

proc IS_HPANED*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_HPANED())

proc IS_HPANED_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_HPANED())

proc HPANED_GET_CLASS*(obj: pointer): PHPanedClass =
  result = cast[PHPanedClass](CHECK_GET_CLASS(obj, TYPE_HPANED()))

