# Included by headers/gtk2.nim; do not import directly.
proc TYPE_RANGE*(): GType =
  result = range_get_type()

proc RANGE*(obj: pointer): PRange =
  result = cast[PRange](CHECK_CAST(obj, TYPE_RANGE()))

proc RANGE_CLASS*(klass: pointer): PRangeClass =
  result = cast[PRangeClass](CHECK_CLASS_CAST(klass, TYPE_RANGE()))

proc IS_RANGE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_RANGE())

proc IS_RANGE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_RANGE())

proc RANGE_GET_CLASS*(obj: pointer): PRangeClass =
  result = cast[PRangeClass](CHECK_GET_CLASS(obj, TYPE_RANGE()))

proc inverted*(a: PRange): guint =
  result = (a.Rangeflag0 and bm_TGtkRange_inverted) shr bp_TGtkRange_inverted

proc set_inverted*(a: PRange, `inverted`: guint) =
  a.Rangeflag0 = a.Rangeflag0 or
      (uint16(`inverted` shl bp_TGtkRange_inverted) and bm_TGtkRange_inverted)

proc flippable*(a: PRange): guint =
  result = (a.Rangeflag0 and bm_TGtkRange_flippable) shr
      bp_TGtkRange_flippable

proc set_flippable*(a: PRange, `flippable`: guint) =
  a.Rangeflag0 = a.Rangeflag0 or
      (uint16(`flippable` shl bp_TGtkRange_flippable) and
      bm_TGtkRange_flippable)

proc has_stepper_a*(a: PRange): guint =
  result = (a.Rangeflag0 and bm_TGtkRange_has_stepper_a) shr
      bp_TGtkRange_has_stepper_a

proc set_has_stepper_a*(a: PRange, `has_stepper_a`: guint) =
  a.Rangeflag0 = a.Rangeflag0 or
      (uint16(`has_stepper_a` shl bp_TGtkRange_has_stepper_a) and
      bm_TGtkRange_has_stepper_a)

proc has_stepper_b*(a: PRange): guint =
  result = (a.Rangeflag0 and bm_TGtkRange_has_stepper_b) shr
      bp_TGtkRange_has_stepper_b

proc set_has_stepper_b*(a: PRange, `has_stepper_b`: guint) =
  a.Rangeflag0 = a.Rangeflag0 or
      (uint16(`has_stepper_b` shl bp_TGtkRange_has_stepper_b) and
      bm_TGtkRange_has_stepper_b)

proc has_stepper_c*(a: PRange): guint =
  result = (a.Rangeflag0 and bm_TGtkRange_has_stepper_c) shr
      bp_TGtkRange_has_stepper_c

proc set_has_stepper_c*(a: PRange, `has_stepper_c`: guint) =
  a.Rangeflag0 = a.Rangeflag0 or
      (uint16(`has_stepper_c` shl bp_TGtkRange_has_stepper_c) and
      bm_TGtkRange_has_stepper_c)

proc has_stepper_d*(a: PRange): guint =
  result = (a.Rangeflag0 and bm_TGtkRange_has_stepper_d) shr
      bp_TGtkRange_has_stepper_d

proc set_has_stepper_d*(a: PRange, `has_stepper_d`: guint) =
  a.Rangeflag0 = a.Rangeflag0 or
      (uint16(`has_stepper_d` shl bp_TGtkRange_has_stepper_d) and
      bm_TGtkRange_has_stepper_d)

proc need_recalc*(a: PRange): guint =
  result = (a.Rangeflag0 and bm_TGtkRange_need_recalc) shr
      bp_TGtkRange_need_recalc

proc set_need_recalc*(a: PRange, `need_recalc`: guint) =
  a.Rangeflag0 = a.Rangeflag0 or
      (uint16(`need_recalc` shl bp_TGtkRange_need_recalc) and
      bm_TGtkRange_need_recalc)

proc slider_size_fixed*(a: PRange): guint =
  result = (a.Rangeflag0 and bm_TGtkRange_slider_size_fixed) shr
      bp_TGtkRange_slider_size_fixed

proc set_slider_size_fixed*(a: PRange, `slider_size_fixed`: guint) =
  a.Rangeflag0 = a.Rangeflag0 or
      (uint16(`slider_size_fixed` shl bp_TGtkRange_slider_size_fixed) and
      bm_TGtkRange_slider_size_fixed)

proc trough_click_forward*(a: PRange): guint =
  result = (a.flag1 and bm_TGtkRange_trough_click_forward) shr
      bp_TGtkRange_trough_click_forward

proc set_trough_click_forward*(a: PRange, `trough_click_forward`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`trough_click_forward` shl bp_TGtkRange_trough_click_forward) and
      bm_TGtkRange_trough_click_forward)

proc update_pending*(a: PRange): guint =
  result = (a.flag1 and bm_TGtkRange_update_pending) shr
      bp_TGtkRange_update_pending

proc set_update_pending*(a: PRange, `update_pending`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`update_pending` shl bp_TGtkRange_update_pending) and
      bm_TGtkRange_update_pending)

