# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SPIN_BUTTON*(): GType
proc SPIN_BUTTON*(obj: pointer): PSpinButton
proc SPIN_BUTTON_CLASS*(klass: pointer): PSpinButtonClass
proc IS_SPIN_BUTTON*(obj: pointer): bool
proc IS_SPIN_BUTTON_CLASS*(klass: pointer): bool
proc SPIN_BUTTON_GET_CLASS*(obj: pointer): PSpinButtonClass
proc in_child*(a: PSpinButton): guint

proc click_child*(a: PSpinButton): guint
proc set_click_child*(a: PSpinButton, `click_child`: guint)
proc button*(a: PSpinButton): guint
proc set_button*(a: PSpinButton, `button`: guint)
proc need_timer*(a: PSpinButton): guint
proc set_need_timer*(a: PSpinButton, `need_timer`: guint)
proc timer_calls*(a: PSpinButton): guint
proc set_timer_calls*(a: PSpinButton, `timer_calls`: guint)
proc digits*(a: PSpinButton): guint
proc numeric*(a: PSpinButton): guint
proc set_numeric*(a: PSpinButton, `numeric`: guint)
proc wrap*(a: PSpinButton): guint
proc set_wrap*(a: PSpinButton, `wrap`: guint)
proc snap_to_ticks*(a: PSpinButton): guint
proc set_snap_to_ticks*(a: PSpinButton, `snap_to_ticks`: guint)
proc spin_button_get_type*(): TType{.cdecl, dynlib: lib,
                                     importc: "gtk_spin_button_get_type".}
proc configure*(spin_button: PSpinButton, adjustment: PAdjustment,
                            climb_rate: gdouble, digits: guint){.cdecl,
    dynlib: lib, importc: "gtk_spin_button_configure".}
proc spin_button_new*(adjustment: PAdjustment, climb_rate: gdouble,
                      digits: guint): PSpinButton{.cdecl, dynlib: lib,
    importc: "gtk_spin_button_new".}
proc spin_button_new*(min: gdouble, max: gdouble, step: gdouble): PSpinButton{.
    cdecl, dynlib: lib, importc: "gtk_spin_button_new_with_range".}
proc set_adjustment*(spin_button: PSpinButton,
                                 adjustment: PAdjustment){.cdecl, dynlib: lib,
    importc: "gtk_spin_button_set_adjustment".}
proc get_adjustment*(spin_button: PSpinButton): PAdjustment{.cdecl,
    dynlib: lib, importc: "gtk_spin_button_get_adjustment".}
proc set_digits*(spin_button: PSpinButton, digits: guint){.cdecl,
    dynlib: lib, importc: "gtk_spin_button_set_digits".}
proc get_digits*(spin_button: PSpinButton): guint{.cdecl,
    dynlib: lib, importc: "gtk_spin_button_get_digits".}
proc set_increments*(spin_button: PSpinButton, step: gdouble,
                                 page: gdouble){.cdecl, dynlib: lib,
    importc: "gtk_spin_button_set_increments".}
proc get_increments*(spin_button: PSpinButton, step: Pgdouble,
                                 page: Pgdouble){.cdecl, dynlib: lib,
    importc: "gtk_spin_button_get_increments".}
proc set_range*(spin_button: PSpinButton, min: gdouble, max: gdouble){.
    cdecl, dynlib: lib, importc: "gtk_spin_button_set_range".}
proc get_range*(spin_button: PSpinButton, min: Pgdouble,
                            max: Pgdouble){.cdecl, dynlib: lib,
    importc: "gtk_spin_button_get_range".}
proc get_value*(spin_button: PSpinButton): gdouble{.cdecl,
    dynlib: lib, importc: "gtk_spin_button_get_value".}
proc get_value_as_int*(spin_button: PSpinButton): gint{.cdecl,
    dynlib: lib, importc: "gtk_spin_button_get_value_as_int".}
proc set_value*(spin_button: PSpinButton, value: gdouble){.cdecl,
    dynlib: lib, importc: "gtk_spin_button_set_value".}
proc set_update_policy*(spin_button: PSpinButton,
                                    policy: TSpinButtonUpdatePolicy){.cdecl,
    dynlib: lib, importc: "gtk_spin_button_set_update_policy".}
proc get_update_policy*(spin_button: PSpinButton): TSpinButtonUpdatePolicy{.
    cdecl, dynlib: lib, importc: "gtk_spin_button_get_update_policy".}
proc set_numeric*(spin_button: PSpinButton, numeric: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_spin_button_set_numeric".}
proc get_numeric*(spin_button: PSpinButton): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_spin_button_get_numeric".}
proc spin*(spin_button: PSpinButton, direction: TSpinType,
                       increment: gdouble){.cdecl, dynlib: lib,
    importc: "gtk_spin_button_spin".}
proc set_wrap*(spin_button: PSpinButton, wrap: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_spin_button_set_wrap".}
proc get_wrap*(spin_button: PSpinButton): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_spin_button_get_wrap".}
proc set_snap_to_ticks*(spin_button: PSpinButton,
                                    snap_to_ticks: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_spin_button_set_snap_to_ticks".}
proc get_snap_to_ticks*(spin_button: PSpinButton): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_spin_button_get_snap_to_ticks".}
proc update*(spin_button: PSpinButton){.cdecl, dynlib: lib,
    importc: "gtk_spin_button_update".}
