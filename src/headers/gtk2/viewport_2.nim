# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VIEWPORT*(): GType =
  result = viewport_get_type()

proc VIEWPORT*(obj: pointer): PViewport =
  result = cast[PViewport](CHECK_CAST(obj, TYPE_VIEWPORT()))

proc VIEWPORT_CLASS*(klass: pointer): PViewportClass =
  result = cast[PViewportClass](CHECK_CLASS_CAST(klass, TYPE_VIEWPORT()))

proc IS_VIEWPORT*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_VIEWPORT())

proc IS_VIEWPORT_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_VIEWPORT())

proc VIEWPORT_GET_CLASS*(obj: pointer): PViewportClass =
  result = cast[PViewportClass](CHECK_GET_CLASS(obj, TYPE_VIEWPORT()))

