# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TOGGLE_BUTTON*(): GType =
  result = toggle_button_get_type()

proc TOGGLE_BUTTON*(obj: pointer): PToggleButton =
  result = cast[PToggleButton](CHECK_CAST(obj, TYPE_TOGGLE_BUTTON()))

proc TOGGLE_BUTTON_CLASS*(klass: pointer): PToggleButtonClass =
  result = cast[PToggleButtonClass](CHECK_CLASS_CAST(klass, TYPE_TOGGLE_BUTTON()))

proc IS_TOGGLE_BUTTON*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TOGGLE_BUTTON())

proc IS_TOGGLE_BUTTON_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TOGGLE_BUTTON())

proc TOGGLE_BUTTON_GET_CLASS*(obj: pointer): PToggleButtonClass =
  result = cast[PToggleButtonClass](CHECK_GET_CLASS(obj, TYPE_TOGGLE_BUTTON()))

proc active*(a: PToggleButton): guint =
  result = (a.Togglebutton_flag0 and bm_TGtkToggleButton_active) shr
      bp_TGtkToggleButton_active

proc set_active*(a: PToggleButton, `active`: guint) =
  a.Togglebutton_flag0 = a.Togglebutton_flag0 or
      (uint16(`active` shl bp_TGtkToggleButton_active) and
      bm_TGtkToggleButton_active)

proc draw_indicator*(a: PToggleButton): guint =
  result = (a.Togglebutton_flag0 and bm_TGtkToggleButton_draw_indicator) shr
      bp_TGtkToggleButton_draw_indicator

proc set_draw_indicator*(a: PToggleButton, `draw_indicator`: guint) =
  a.Togglebutton_flag0 = a.Togglebutton_flag0 or
      (uint16(`draw_indicator` shl bp_TGtkToggleButton_draw_indicator) and
      bm_TGtkToggleButton_draw_indicator)

proc inconsistent*(a: PToggleButton): guint =
  result = (a.Togglebutton_flag0 and bm_TGtkToggleButton_inconsistent) shr
      bp_TGtkToggleButton_inconsistent

proc set_inconsistent*(a: PToggleButton, `inconsistent`: guint) =
  a.Togglebutton_flag0 = a.Togglebutton_flag0 or
      (uint16(`inconsistent` shl bp_TGtkToggleButton_inconsistent) and
      bm_TGtkToggleButton_inconsistent)

