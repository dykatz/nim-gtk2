# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HSCALE*(): GType
proc HSCALE*(obj: pointer): PHScale
proc HSCALE_CLASS*(klass: pointer): PHScaleClass
proc IS_HSCALE*(obj: pointer): bool
proc IS_HSCALE_CLASS*(klass: pointer): bool
proc HSCALE_GET_CLASS*(obj: pointer): PHScaleClass
proc hscale_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_hscale_get_type".}
proc hscale_new*(adjustment: PAdjustment): PHScale{.cdecl, dynlib: lib,
    importc: "gtk_hscale_new".}
proc hscale_new*(min: gdouble, max: gdouble, step: gdouble): PHScale{.
    cdecl, dynlib: lib, importc: "gtk_hscale_new_with_range".}
