# Included by headers/gtk2.nim; do not import directly.
proc TYPE_INVISIBLE*(): GType =
  result = invisible_get_type()

proc INVISIBLE*(obj: pointer): PInvisible =
  result = cast[PInvisible](CHECK_CAST(obj, TYPE_INVISIBLE()))

proc INVISIBLE_CLASS*(klass: pointer): PInvisibleClass =
  result = cast[PInvisibleClass](CHECK_CLASS_CAST(klass, TYPE_INVISIBLE()))

proc IS_INVISIBLE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_INVISIBLE())

proc IS_INVISIBLE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_INVISIBLE())

proc INVISIBLE_GET_CLASS*(obj: pointer): PInvisibleClass =
  result = cast[PInvisibleClass](CHECK_GET_CLASS(obj, TYPE_INVISIBLE()))

