# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ACCESSIBLE*(): GType =
  result = accessible_get_type()

proc ACCESSIBLE*(obj: pointer): PAccessible =
  result = cast[PAccessible](CHECK_CAST(obj, TYPE_ACCESSIBLE()))

proc ACCESSIBLE_CLASS*(klass: pointer): PAccessibleClass =
  result = cast[PAccessibleClass](CHECK_CLASS_CAST(klass, TYPE_ACCESSIBLE()))

proc IS_ACCESSIBLE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_ACCESSIBLE())

proc IS_ACCESSIBLE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ACCESSIBLE())

proc ACCESSIBLE_GET_CLASS*(obj: pointer): PAccessibleClass =
  result = cast[PAccessibleClass](CHECK_GET_CLASS(obj, TYPE_ACCESSIBLE()))

