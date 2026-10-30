# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SEPARATOR*(): GType =
  result = separator_get_type()

proc SEPARATOR*(obj: pointer): PSeparator =
  result = cast[PSeparator](CHECK_CAST(obj, TYPE_SEPARATOR()))

proc SEPARATOR_CLASS*(klass: pointer): PSeparatorClass =
  result = cast[PSeparatorClass](CHECK_CLASS_CAST(klass, TYPE_SEPARATOR()))

proc IS_SEPARATOR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_SEPARATOR())

proc IS_SEPARATOR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_SEPARATOR())

proc SEPARATOR_GET_CLASS*(obj: pointer): PSeparatorClass =
  result = cast[PSeparatorClass](CHECK_GET_CLASS(obj, TYPE_SEPARATOR()))

