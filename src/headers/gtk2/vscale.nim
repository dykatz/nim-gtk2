# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VSCALE*(): GType
proc VSCALE*(obj: pointer): PVScale
proc VSCALE_CLASS*(klass: pointer): PVScaleClass
proc IS_VSCALE*(obj: pointer): bool
proc IS_VSCALE_CLASS*(klass: pointer): bool
proc VSCALE_GET_CLASS*(obj: pointer): PVScaleClass
proc vscale_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_vscale_get_type".}
proc vscale_new*(adjustment: PAdjustment): PVScale{.cdecl, dynlib: lib,
    importc: "gtk_vscale_new".}
proc vscale_new*(min: gdouble, max: gdouble, step: gdouble): PVScale{.
    cdecl, dynlib: lib, importc: "gtk_vscale_new_with_range".}
