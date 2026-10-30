# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ACCEL_LABEL*(): GType =
  result = accel_label_get_type()

proc ACCEL_LABEL*(obj: pointer): PAccelLabel =
  result = cast[PAccelLabel](CHECK_CAST(obj, TYPE_ACCEL_LABEL()))

proc ACCEL_LABEL_CLASS*(klass: pointer): PAccelLabelClass =
  result = cast[PAccelLabelClass](CHECK_CLASS_CAST(klass, TYPE_ACCEL_LABEL()))

proc IS_ACCEL_LABEL*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_ACCEL_LABEL())

proc IS_ACCEL_LABEL_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ACCEL_LABEL())

proc ACCEL_LABEL_GET_CLASS*(obj: pointer): PAccelLabelClass =
  result = cast[PAccelLabelClass](CHECK_GET_CLASS(obj, TYPE_ACCEL_LABEL()))

proc latin1_to_char*(a: PAccelLabelClass): guint =
  result = (a.AccelLabelClassflag0 and bm_TGtkAccelLabelClass_latin1_to_char) shr
      bp_TGtkAccelLabelClass_latin1_to_char

proc set_latin1_to_char*(a: PAccelLabelClass, `latin1_to_char`: guint) =
  a.AccelLabelClassflag0 = a.AccelLabelClassflag0 or
      (uint16(`latin1_to_char` shl bp_TGtkAccelLabelClass_latin1_to_char) and
      bm_TGtkAccelLabelClass_latin1_to_char)

proc accelerator_width*(accel_label: PAccelLabel): guint =
  result = get_accel_width(accel_label)

