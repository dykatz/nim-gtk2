# Included by headers/gtk2.nim; do not import directly.
proc numeric*(a: PSpinButton): guint =
  result = (a.Spinbutton_flag0 and bm_TGtkSpinButton_numeric) shr
      bp_TGtkSpinButton_numeric

proc set_numeric*(a: PSpinButton, `numeric`: guint) =
  a.Spinbutton_flag0 = a.Spinbutton_flag0 or
      ((`numeric` shl bp_TGtkSpinButton_numeric) and
      bm_TGtkSpinButton_numeric)

proc wrap*(a: PSpinButton): guint =
  result = (a.Spinbutton_flag0 and bm_TGtkSpinButton_wrap) shr
      bp_TGtkSpinButton_wrap

proc set_wrap*(a: PSpinButton, `wrap`: guint) =
  a.Spinbutton_flag0 = a.Spinbutton_flag0 or
      ((`wrap` shl bp_TGtkSpinButton_wrap) and bm_TGtkSpinButton_wrap)

proc snap_to_ticks*(a: PSpinButton): guint =
  result = (a.Spinbutton_flag0 and bm_TGtkSpinButton_snap_to_ticks) shr
      bp_TGtkSpinButton_snap_to_ticks

proc set_snap_to_ticks*(a: PSpinButton, `snap_to_ticks`: guint) =
  a.Spinbutton_flag0 = a.Spinbutton_flag0 or
      ((`snap_to_ticks` shl bp_TGtkSpinButton_snap_to_ticks) and
      bm_TGtkSpinButton_snap_to_ticks)

