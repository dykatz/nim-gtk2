# Included by headers/gtk2.nim; do not import directly.
proc click_child*(a: PSpinButton): guint =
  result = (a.Spinbutton_flag0 and bm_TGtkSpinButton_click_child) shr
      bp_TGtkSpinButton_click_child

proc set_click_child*(a: PSpinButton, `click_child`: guint) =
  a.Spinbutton_flag0 = a.Spinbutton_flag0 or
      ((`click_child` shl bp_TGtkSpinButton_click_child) and
      bm_TGtkSpinButton_click_child)

proc button*(a: PSpinButton): guint =
  result = (a.Spinbutton_flag0 and bm_TGtkSpinButton_button) shr
      bp_TGtkSpinButton_button

proc set_button*(a: PSpinButton, `button`: guint) =
  a.Spinbutton_flag0 = a.Spinbutton_flag0 or
      ((`button` shl bp_TGtkSpinButton_button) and bm_TGtkSpinButton_button)

proc need_timer*(a: PSpinButton): guint =
  result = (a.Spinbutton_flag0 and bm_TGtkSpinButton_need_timer) shr
      bp_TGtkSpinButton_need_timer

proc set_need_timer*(a: PSpinButton, `need_timer`: guint) =
  a.Spinbutton_flag0 = a.Spinbutton_flag0 or
      ((`need_timer` shl bp_TGtkSpinButton_need_timer) and
      bm_TGtkSpinButton_need_timer)

proc timer_calls*(a: PSpinButton): guint =
  result = (a.Spinbutton_flag0 and bm_TGtkSpinButton_timer_calls) shr
      bp_TGtkSpinButton_timer_calls

proc set_timer_calls*(a: PSpinButton, `timer_calls`: guint) =
  a.Spinbutton_flag0 = a.Spinbutton_flag0 or
      ((`timer_calls` shl bp_TGtkSpinButton_timer_calls) and
      bm_TGtkSpinButton_timer_calls)

proc digits*(a: PSpinButton): guint =
  result = (a.Spinbutton_flag0 and bm_TGtkSpinButton_digits) shr
      bp_TGtkSpinButton_digits

