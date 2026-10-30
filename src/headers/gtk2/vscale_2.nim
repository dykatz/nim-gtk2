# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VSCALE*(): GType =
  result = vscale_get_type()

proc VSCALE*(obj: pointer): PVScale =
  result = cast[PVScale](CHECK_CAST(obj, TYPE_VSCALE()))

proc VSCALE_CLASS*(klass: pointer): PVScaleClass =
  result = cast[PVScaleClass](CHECK_CLASS_CAST(klass, TYPE_VSCALE()))

proc IS_VSCALE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_VSCALE())

proc IS_VSCALE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_VSCALE())

proc VSCALE_GET_CLASS*(obj: pointer): PVScaleClass =
  result = cast[PVScaleClass](CHECK_GET_CLASS(obj, TYPE_VSCALE()))

