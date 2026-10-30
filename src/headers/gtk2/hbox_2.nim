# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HBOX*(): GType =
  result = hbox_get_type()

proc HBOX*(obj: pointer): PHBox =
  result = cast[PHBox](CHECK_CAST(obj, TYPE_HBOX()))

proc HBOX_CLASS*(klass: pointer): PHBoxClass =
  result = cast[PHBoxClass](CHECK_CLASS_CAST(klass, TYPE_HBOX()))

proc IS_HBOX*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_HBOX())

proc IS_HBOX_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_HBOX())

proc HBOX_GET_CLASS*(obj: pointer): PHBoxClass =
  result = cast[PHBoxClass](CHECK_GET_CLASS(obj, TYPE_HBOX()))

