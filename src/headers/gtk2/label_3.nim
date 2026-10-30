# Included by headers/gtk2.nim; do not import directly.
proc TYPE_LABEL*(): GType =
  result = label_get_type()

proc LABEL*(obj: pointer): PLabel =
  result = cast[PLabel](CHECK_CAST(obj, TYPE_LABEL()))

proc LABEL_CLASS*(klass: pointer): PLabelClass =
  result = cast[PLabelClass](CHECK_CLASS_CAST(klass, TYPE_LABEL()))

proc IS_LABEL*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_LABEL())

proc IS_LABEL_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_LABEL())

proc LABEL_GET_CLASS*(obj: pointer): PLabelClass =
  result = cast[PLabelClass](CHECK_GET_CLASS(obj, TYPE_LABEL()))

proc jtype*(a: PLabel): guint =
  result = (a.Labelflag0 and bm_TGtkLabel_jtype) shr bp_TGtkLabel_jtype

proc set_jtype*(a: PLabel, `jtype`: guint) =
  a.Labelflag0 = a.Labelflag0 or
      (uint16(`jtype` shl bp_TGtkLabel_jtype) and bm_TGtkLabel_jtype)

proc wrap*(a: PLabel): guint =
  result = ((a.Labelflag0 and bm_TGtkLabel_wrap) shr bp_TGtkLabel_wrap).guint

proc set_wrap*(a: PLabel, `wrap`: guint) =
  a.Labelflag0 = a.Labelflag0 or
      (uint16(`wrap` shl bp_TGtkLabel_wrap) and bm_TGtkLabel_wrap)

proc use_underline*(a: PLabel): guint =
  result = ((a.Labelflag0 and bm_TGtkLabel_use_underline) shr
      bp_TGtkLabel_use_underline).guint

proc set_use_underline*(a: PLabel, `use_underline`: guint) =
  a.Labelflag0 = a.Labelflag0 or
      (uint16(`use_underline` shl bp_TGtkLabel_use_underline) and
      bm_TGtkLabel_use_underline)

proc use_markup*(a: PLabel): guint =
  result = ((a.Labelflag0 and bm_TGtkLabel_use_markup) shr
      bp_TGtkLabel_use_markup).guint

proc set_use_markup*(a: PLabel, `use_markup`: guint) =
  a.Labelflag0 = a.Labelflag0 or
      (uint16(`use_markup` shl bp_TGtkLabel_use_markup) and
      bm_TGtkLabel_use_markup)

