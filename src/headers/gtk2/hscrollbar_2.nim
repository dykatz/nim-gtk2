# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HSCROLLBAR*(): GType =
  result = hscrollbar_get_type()

proc HSCROLLBAR*(obj: pointer): PHScrollbar =
  result = cast[PHScrollbar](CHECK_CAST(obj, TYPE_HSCROLLBAR()))

proc HSCROLLBAR_CLASS*(klass: pointer): PHScrollbarClass =
  result = cast[PHScrollbarClass](CHECK_CLASS_CAST(klass, TYPE_HSCROLLBAR()))

proc IS_HSCROLLBAR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_HSCROLLBAR())

proc IS_HSCROLLBAR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_HSCROLLBAR())

proc HSCROLLBAR_GET_CLASS*(obj: pointer): PHScrollbarClass =
  result = cast[PHScrollbarClass](CHECK_GET_CLASS(obj, TYPE_HSCROLLBAR()))

