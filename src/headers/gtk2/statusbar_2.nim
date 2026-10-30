# Included by headers/gtk2.nim; do not import directly.
proc TYPE_STATUSBAR*(): GType =
  result = statusbar_get_type()

proc STATUSBAR*(obj: pointer): PStatusbar =
  result = cast[PStatusbar](CHECK_CAST(obj, TYPE_STATUSBAR()))

proc STATUSBAR_CLASS*(klass: pointer): PStatusbarClass =
  result = cast[PStatusbarClass](CHECK_CLASS_CAST(klass, TYPE_STATUSBAR()))

proc IS_STATUSBAR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_STATUSBAR())

proc IS_STATUSBAR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_STATUSBAR())

proc STATUSBAR_GET_CLASS*(obj: pointer): PStatusbarClass =
  result = cast[PStatusbarClass](CHECK_GET_CLASS(obj, TYPE_STATUSBAR()))

proc has_resize_grip*(a: PStatusbar): guint =
  result = (a.Statusbarflag0 and bm_TGtkStatusbar_has_resize_grip) shr
      bp_TGtkStatusbar_has_resize_grip

proc set_has_resize_grip*(a: PStatusbar, `has_resize_grip`: guint) =
  a.Statusbarflag0 = a.Statusbarflag0 or
      (uint16(`has_resize_grip` shl bp_TGtkStatusbar_has_resize_grip) and
      bm_TGtkStatusbar_has_resize_grip)

