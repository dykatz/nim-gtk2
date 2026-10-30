# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HSEPARATOR*(): GType =
  result = hseparator_get_type()

proc HSEPARATOR*(obj: pointer): PHSeparator =
  result = cast[PHSeparator](CHECK_CAST(obj, TYPE_HSEPARATOR()))

proc HSEPARATOR_CLASS*(klass: pointer): PHSeparatorClass =
  result = cast[PHSeparatorClass](CHECK_CLASS_CAST(klass, TYPE_HSEPARATOR()))

proc IS_HSEPARATOR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_HSEPARATOR())

proc IS_HSEPARATOR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_HSEPARATOR())

proc HSEPARATOR_GET_CLASS*(obj: pointer): PHSeparatorClass =
  result = cast[PHSeparatorClass](CHECK_GET_CLASS(obj, TYPE_HSEPARATOR()))

