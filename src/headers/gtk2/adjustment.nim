# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ADJUSTMENT*(): GType
proc ADJUSTMENT*(obj: pointer): PAdjustment
proc ADJUSTMENT_CLASS*(klass: pointer): PAdjustmentClass
proc IS_ADJUSTMENT*(obj: pointer): bool
proc IS_ADJUSTMENT_CLASS*(klass: pointer): bool
proc ADJUSTMENT_GET_CLASS*(obj: pointer): PAdjustmentClass
proc adjustment_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_adjustment_get_type".}
proc adjustment_new*(value: gdouble, lower: gdouble, upper: gdouble,
                     step_increment: gdouble, page_increment: gdouble,
                     page_size: gdouble): PAdjustment{.cdecl, dynlib: lib,
    importc: "gtk_adjustment_new".}
proc changed*(adjustment: PAdjustment){.cdecl, dynlib: lib,
    importc: "gtk_adjustment_changed".}
proc value_changed*(adjustment: PAdjustment){.cdecl, dynlib: lib,
    importc: "gtk_adjustment_value_changed".}
proc clamp_page*(adjustment: PAdjustment, lower: gdouble,
                            upper: gdouble){.cdecl, dynlib: lib,
    importc: "gtk_adjustment_clamp_page".}
proc get_value*(adjustment: PAdjustment): gdouble{.cdecl,
    dynlib: lib, importc: "gtk_adjustment_get_value".}
proc set_value*(adjustment: PAdjustment, value: gdouble){.cdecl,
    dynlib: lib, importc: "gtk_adjustment_set_value".}
proc get_upper*(adjustment: PAdjustment): gdouble{.cdecl,
    dynlib: lib, importc: "gtk_adjustment_get_upper".}
proc set_upper*(adjustment: PAdjustment, val: gdouble){.cdecl,
    dynlib: lib, importc: "gtk_adjustment_set_upper".}
proc get_page_size*(adjustment: PAdjustment): gdouble{.cdecl,
    dynlib: lib, importc: "gtk_adjustment_get_page_size".}
proc get_lower*(adjustment: PAdjustment): gdouble {.cdecl, dynlib: lib,
    importc: "gtk_adjustment_get_lower".}
proc get_step_increment*(adjustment: PAdjustment): gdouble {.cdecl, dynlib: lib,
    importc: "gtk_adjustment_get_step_increment".}
proc get_page_increment*(adjustment: PAdjustment): gdouble {.cdecl, dynlib: lib,
    importc: "gtk_adjustment_get_page_increment".}
proc configure*(adjustment: PAdjustment, value, lower, upper, step_increment,
                page_increment, page_size: gdouble) {.cdecl, dynlib: lib,
    importc: "gtk_adjustment_configure".}
