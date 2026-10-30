# Included by headers/gtk2.nim; do not import directly.
proc TYPE_FIXED*(): GType =
  result = fixed_get_type()

proc FIXED*(obj: pointer): PFixed =
  result = cast[PFixed](CHECK_CAST(obj, TYPE_FIXED()))

proc FIXED_CLASS*(klass: pointer): PFixedClass =
  result = cast[PFixedClass](CHECK_CLASS_CAST(klass, TYPE_FIXED()))

proc IS_FIXED*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_FIXED())

proc IS_FIXED_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_FIXED())

proc FIXED_GET_CLASS*(obj: pointer): PFixedClass =
  result = cast[PFixedClass](CHECK_GET_CLASS(obj, TYPE_FIXED()))

proc TYPE_FONT_SELECTION*(): GType =
  result = font_selection_get_type()

