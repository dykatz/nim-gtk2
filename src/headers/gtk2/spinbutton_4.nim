# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SPIN_BUTTON*(): GType =
  result = spin_button_get_type()

proc SPIN_BUTTON*(obj: pointer): PSpinButton =
  result = cast[PSpinButton](CHECK_CAST(obj, TYPE_SPIN_BUTTON()))

proc SPIN_BUTTON_CLASS*(klass: pointer): PSpinButtonClass =
  result = cast[PSpinButtonClass](CHECK_CLASS_CAST(klass, TYPE_SPIN_BUTTON()))

proc IS_SPIN_BUTTON*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_SPIN_BUTTON())

proc IS_SPIN_BUTTON_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_SPIN_BUTTON())

proc SPIN_BUTTON_GET_CLASS*(obj: pointer): PSpinButtonClass =
  result = cast[PSpinButtonClass](CHECK_GET_CLASS(obj, TYPE_SPIN_BUTTON()))

proc in_child*(a: PSpinButton): guint =
  result = (a.Spinbutton_flag0 and bm_TGtkSpinButton_in_child) shr
      bp_TGtkSpinButton_in_child

