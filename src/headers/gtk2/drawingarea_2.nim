# Included by headers/gtk2.nim; do not import directly.
proc TYPE_DRAWING_AREA*(): GType =
  result = drawing_area_get_type()

proc DRAWING_AREA*(obj: pointer): PDrawingArea =
  result = cast[PDrawingArea](CHECK_CAST(obj, TYPE_DRAWING_AREA()))

proc DRAWING_AREA_CLASS*(klass: pointer): PDrawingAreaClass =
  result = cast[PDrawingAreaClass](CHECK_CLASS_CAST(klass, TYPE_DRAWING_AREA()))

proc IS_DRAWING_AREA*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_DRAWING_AREA())

proc IS_DRAWING_AREA_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_DRAWING_AREA())

proc DRAWING_AREA_GET_CLASS*(obj: pointer): PDrawingAreaClass =
  result = cast[PDrawingAreaClass](CHECK_GET_CLASS(obj, TYPE_DRAWING_AREA()))

