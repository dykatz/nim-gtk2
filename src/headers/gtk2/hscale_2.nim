# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HSCALE*(): GType =
  result = hscale_get_type()

proc HSCALE*(obj: pointer): PHScale =
  result = cast[PHScale](CHECK_CAST(obj, TYPE_HSCALE()))

proc HSCALE_CLASS*(klass: pointer): PHScaleClass =
  result = cast[PHScaleClass](CHECK_CLASS_CAST(klass, TYPE_HSCALE()))

proc IS_HSCALE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_HSCALE())

proc IS_HSCALE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_HSCALE())

proc HSCALE_GET_CLASS*(obj: pointer): PHScaleClass =
  result = cast[PHScaleClass](CHECK_GET_CLASS(obj, TYPE_HSCALE()))

