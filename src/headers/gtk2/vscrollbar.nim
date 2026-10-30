# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VSCROLLBAR*(): GType
proc VSCROLLBAR*(obj: pointer): PVScrollbar
proc VSCROLLBAR_CLASS*(klass: pointer): PVScrollbarClass
proc IS_VSCROLLBAR*(obj: pointer): bool
proc IS_VSCROLLBAR_CLASS*(klass: pointer): bool
proc VSCROLLBAR_GET_CLASS*(obj: pointer): PVScrollbarClass
proc vscrollbar_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_vscrollbar_get_type".}
proc vscrollbar_new*(adjustment: PAdjustment): PVScrollbar{.cdecl, dynlib: lib,
    importc: "gtk_vscrollbar_new".}
