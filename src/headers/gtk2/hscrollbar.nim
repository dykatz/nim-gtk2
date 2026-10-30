# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HSCROLLBAR*(): GType
proc HSCROLLBAR*(obj: pointer): PHScrollbar
proc HSCROLLBAR_CLASS*(klass: pointer): PHScrollbarClass
proc IS_HSCROLLBAR*(obj: pointer): bool
proc IS_HSCROLLBAR_CLASS*(klass: pointer): bool
proc HSCROLLBAR_GET_CLASS*(obj: pointer): PHScrollbarClass
proc hscrollbar_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_hscrollbar_get_type".}
proc hscrollbar_new*(adjustment: PAdjustment): PHScrollbar{.cdecl, dynlib: lib,
    importc: "gtk_hscrollbar_new".}
