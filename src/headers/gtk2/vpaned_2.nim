# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VPANED*(): GType =
  result = vpaned_get_type()

proc VPANED*(obj: pointer): PVPaned =
  result = cast[PVPaned](CHECK_CAST(obj, TYPE_VPANED()))

proc VPANED_CLASS*(klass: pointer): PVPanedClass =
  result = cast[PVPanedClass](CHECK_CLASS_CAST(klass, TYPE_VPANED()))

proc IS_VPANED*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_VPANED())

proc IS_VPANED_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_VPANED())

proc VPANED_GET_CLASS*(obj: pointer): PVPanedClass =
  result = cast[PVPanedClass](CHECK_GET_CLASS(obj, TYPE_VPANED()))

