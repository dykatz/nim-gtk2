# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MISC*(): GType =
  result = misc_get_type()

proc MISC*(obj: pointer): PMisc =
  result = cast[PMisc](CHECK_CAST(obj, TYPE_MISC()))

proc MISC_CLASS*(klass: pointer): PMiscClass =
  result = cast[PMiscClass](CHECK_CLASS_CAST(klass, TYPE_MISC()))

proc IS_MISC*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_MISC())

proc IS_MISC_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_MISC())

proc MISC_GET_CLASS*(obj: pointer): PMiscClass =
  result = cast[PMiscClass](CHECK_GET_CLASS(obj, TYPE_MISC()))

