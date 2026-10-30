# Included by headers/gtk2.nim; do not import directly.
proc TYPE_RANGE*(): GType
proc RANGE*(obj: pointer): PRange
proc RANGE_CLASS*(klass: pointer): PRangeClass
proc IS_RANGE*(obj: pointer): bool
proc IS_RANGE_CLASS*(klass: pointer): bool
proc RANGE_GET_CLASS*(obj: pointer): PRangeClass
proc inverted*(a: PRange): guint
proc set_inverted*(a: PRange, `inverted`: guint)
proc flippable*(a: PRange): guint
proc set_flippable*(a: PRange, `flippable`: guint)
proc has_stepper_a*(a: PRange): guint
proc set_has_stepper_a*(a: PRange, `has_stepper_a`: guint)
proc has_stepper_b*(a: PRange): guint
proc set_has_stepper_b*(a: PRange, `has_stepper_b`: guint)
proc has_stepper_c*(a: PRange): guint
proc set_has_stepper_c*(a: PRange, `has_stepper_c`: guint)
proc has_stepper_d*(a: PRange): guint
proc set_has_stepper_d*(a: PRange, `has_stepper_d`: guint)
proc need_recalc*(a: PRange): guint
proc set_need_recalc*(a: PRange, `need_recalc`: guint)
proc slider_size_fixed*(a: PRange): guint
proc set_slider_size_fixed*(a: PRange, `slider_size_fixed`: guint)
proc trough_click_forward*(a: PRange): guint
proc set_trough_click_forward*(a: PRange, `trough_click_forward`: guint)
proc update_pending*(a: PRange): guint
proc set_update_pending*(a: PRange, `update_pending`: guint)
proc range_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_range_get_type".}
proc set_update_policy*(range: PRange, policy: TUpdateType){.cdecl,
    dynlib: lib, importc: "gtk_range_set_update_policy".}
proc get_update_policy*(range: PRange): TUpdateType{.cdecl, dynlib: lib,
    importc: "gtk_range_get_update_policy".}
proc set_adjustment*(range: PRange, adjustment: PAdjustment){.cdecl,
    dynlib: lib, importc: "gtk_range_set_adjustment".}
proc get_adjustment*(range: PRange): PAdjustment{.cdecl, dynlib: lib,
    importc: "gtk_range_get_adjustment".}
proc set_inverted*(range: PRange, setting: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_range_set_inverted".}
proc get_inverted*(range: PRange): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_range_get_inverted".}
proc set_increments*(range: PRange, step: gdouble, page: gdouble){.cdecl,
    dynlib: lib, importc: "gtk_range_set_increments".}
proc set_range*(range: PRange, min: gdouble, max: gdouble){.cdecl,
    dynlib: lib, importc: "gtk_range_set_range".}
proc set_value*(range: PRange, value: gdouble){.cdecl, dynlib: lib,
    importc: "gtk_range_set_value".}
proc get_value*(range: PRange): gdouble{.cdecl, dynlib: lib,
    importc: "gtk_range_get_value".}
const
  bm_TGtkScale_draw_value* = 0x0001'u16
const
  bp_TGtkScale_draw_value* = 0'u16
const
  bm_TGtkScale_value_pos* = 0x0006'u16
const
  bp_TGtkScale_value_pos* = 1'u16

