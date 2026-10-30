# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VSCROLLBAR*(): GType =
  result = vscrollbar_get_type()

proc VSCROLLBAR*(obj: pointer): PVScrollbar =
  result = cast[PVScrollbar](CHECK_CAST(obj, TYPE_VSCROLLBAR()))

proc VSCROLLBAR_CLASS*(klass: pointer): PVScrollbarClass =
  result = cast[PVScrollbarClass](CHECK_CLASS_CAST(klass, TYPE_VSCROLLBAR()))

proc IS_VSCROLLBAR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_VSCROLLBAR())

proc IS_VSCROLLBAR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_VSCROLLBAR())

proc VSCROLLBAR_GET_CLASS*(obj: pointer): PVScrollbarClass =
  result = cast[PVScrollbarClass](CHECK_GET_CLASS(obj, TYPE_VSCROLLBAR()))

