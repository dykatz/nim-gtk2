# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SCROLLBAR*(): GType =
  result = scrollbar_get_type()

proc SCROLLBAR*(obj: pointer): PScrollbar =
  result = cast[PScrollbar](CHECK_CAST(obj, TYPE_SCROLLBAR()))

proc SCROLLBAR_CLASS*(klass: pointer): PScrollbarClass =
  result = cast[PScrollbarClass](CHECK_CLASS_CAST(klass, TYPE_SCROLLBAR()))

proc IS_SCROLLBAR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_SCROLLBAR())

proc IS_SCROLLBAR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_SCROLLBAR())

proc SCROLLBAR_GET_CLASS*(obj: pointer): PScrollbarClass =
  result = cast[PScrollbarClass](CHECK_GET_CLASS(obj, TYPE_SCROLLBAR()))

