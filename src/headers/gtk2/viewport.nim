# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VIEWPORT*(): GType
proc VIEWPORT*(obj: pointer): PViewport
proc VIEWPORT_CLASS*(klass: pointer): PViewportClass
proc IS_VIEWPORT*(obj: pointer): bool
proc IS_VIEWPORT_CLASS*(klass: pointer): bool
proc VIEWPORT_GET_CLASS*(obj: pointer): PViewportClass
proc viewport_get_type*(): TType{.cdecl, dynlib: lib,
                                  importc: "gtk_viewport_get_type".}
proc viewport_new*(hadjustment: PAdjustment, vadjustment: PAdjustment): PViewport{.
    cdecl, dynlib: lib, importc: "gtk_viewport_new".}
proc get_hadjustment*(viewport: PViewport): PAdjustment{.cdecl,
    dynlib: lib, importc: "gtk_viewport_get_hadjustment".}
proc get_vadjustment*(viewport: PViewport): PAdjustment{.cdecl,
    dynlib: lib, importc: "gtk_viewport_get_vadjustment".}
proc set_hadjustment*(viewport: PViewport, adjustment: PAdjustment){.
    cdecl, dynlib: lib, importc: "gtk_viewport_set_hadjustment".}
proc set_vadjustment*(viewport: PViewport, adjustment: PAdjustment){.
    cdecl, dynlib: lib, importc: "gtk_viewport_set_vadjustment".}
proc set_shadow_type*(viewport: PViewport, thetype: TShadowType){.
    cdecl, dynlib: lib, importc: "gtk_viewport_set_shadow_type".}
proc get_shadow_type*(viewport: PViewport): TShadowType{.cdecl,
    dynlib: lib, importc: "gtk_viewport_get_shadow_type".}
