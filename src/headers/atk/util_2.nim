# Included by headers/atk.nim; do not import directly.
proc TYPE_UTIL*(): GType =
  result = util_get_type()

proc IS_UTIL*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_UTIL())

proc UTIL*(obj: pointer): PUtil =
  result = cast[PUtil](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_UTIL()))

proc UTIL_CLASS*(klass: pointer): PUtilClass =
  result = cast[PUtilClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_UTIL()))

proc IS_UTIL_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_UTIL())

proc UTIL_GET_CLASS*(obj: pointer): PUtilClass =
  result = cast[PUtilClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_UTIL()))

