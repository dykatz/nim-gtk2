# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ADJUSTMENT*(): GType =
  result = adjustment_get_type()

proc ADJUSTMENT*(obj: pointer): PAdjustment =
  result = cast[PAdjustment](CHECK_CAST(obj, TYPE_ADJUSTMENT()))

proc ADJUSTMENT_CLASS*(klass: pointer): PAdjustmentClass =
  result = cast[PAdjustmentClass](CHECK_CLASS_CAST(klass, TYPE_ADJUSTMENT()))

proc IS_ADJUSTMENT*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_ADJUSTMENT())

proc IS_ADJUSTMENT_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ADJUSTMENT())

proc ADJUSTMENT_GET_CLASS*(obj: pointer): PAdjustmentClass =
  result = cast[PAdjustmentClass](CHECK_GET_CLASS(obj, TYPE_ADJUSTMENT()))

