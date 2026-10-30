# Included by headers/gtk2.nim; do not import directly.
proc HBUTTON_BOX*(obj: pointer): PHButtonBox =
  result = cast[PHButtonBox](CHECK_CAST(obj, TYPE_HBUTTON_BOX()))

proc HBUTTON_BOX_CLASS*(klass: pointer): PHButtonBoxClass =
  result = cast[PHButtonBoxClass](CHECK_CLASS_CAST(klass, TYPE_HBUTTON_BOX()))

proc IS_HBUTTON_BOX*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_HBUTTON_BOX())

proc IS_HBUTTON_BOX_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_HBUTTON_BOX())

proc HBUTTON_BOX_GET_CLASS*(obj: pointer): PHButtonBoxClass =
  result = cast[PHButtonBoxClass](CHECK_GET_CLASS(obj, TYPE_HBUTTON_BOX()))

