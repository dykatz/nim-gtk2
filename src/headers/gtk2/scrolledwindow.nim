# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SCROLLED_WINDOW*(): GType
proc SCROLLED_WINDOW*(obj: pointer): PScrolledWindow
proc SCROLLED_WINDOW_CLASS*(klass: pointer): PScrolledWindowClass
proc IS_SCROLLED_WINDOW*(obj: pointer): bool
proc IS_SCROLLED_WINDOW_CLASS*(klass: pointer): bool
proc SCROLLED_WINDOW_GET_CLASS*(obj: pointer): PScrolledWindowClass
proc hscrollbar_policy*(a: PScrolledWindow): guint
proc set_hscrollbar_policy*(a: PScrolledWindow, `hscrollbar_policy`: guint)
proc vscrollbar_policy*(a: PScrolledWindow): guint
proc set_vscrollbar_policy*(a: PScrolledWindow, `vscrollbar_policy`: guint)
proc hscrollbar_visible*(a: PScrolledWindow): guint
proc set_hscrollbar_visible*(a: PScrolledWindow, `hscrollbar_visible`: guint)
proc vscrollbar_visible*(a: PScrolledWindow): guint
proc set_vscrollbar_visible*(a: PScrolledWindow, `vscrollbar_visible`: guint)
proc window_placement*(a: PScrolledWindow): guint
proc set_window_placement*(a: PScrolledWindow, `window_placement`: guint)
proc focus_out*(a: PScrolledWindow): guint
proc set_focus_out*(a: PScrolledWindow, `focus_out`: guint)
proc scrolled_window_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_scrolled_window_get_type".}
proc scrolled_window_new*(hadjustment: PAdjustment, vadjustment: PAdjustment): PScrolledWindow{.
    cdecl, dynlib: lib, importc: "gtk_scrolled_window_new".}
proc set_hadjustment*(scrolled_window: PScrolledWindow,
                                      hadjustment: PAdjustment){.cdecl,
    dynlib: lib, importc: "gtk_scrolled_window_set_hadjustment".}
proc set_vadjustment*(scrolled_window: PScrolledWindow,
                                      hadjustment: PAdjustment){.cdecl,
    dynlib: lib, importc: "gtk_scrolled_window_set_vadjustment".}
proc get_hadjustment*(scrolled_window: PScrolledWindow): PAdjustment{.
    cdecl, dynlib: lib, importc: "gtk_scrolled_window_get_hadjustment".}
proc get_vadjustment*(scrolled_window: PScrolledWindow): PAdjustment{.
    cdecl, dynlib: lib, importc: "gtk_scrolled_window_get_vadjustment".}
proc set_policy*(scrolled_window: PScrolledWindow,
                                 hscrollbar_policy: TPolicyType,
                                 vscrollbar_policy: TPolicyType){.cdecl,
    dynlib: lib, importc: "gtk_scrolled_window_set_policy".}
proc get_policy*(scrolled_window: PScrolledWindow,
                                 hscrollbar_policy: PPolicyType,
                                 vscrollbar_policy: PPolicyType){.cdecl,
    dynlib: lib, importc: "gtk_scrolled_window_get_policy".}
proc set_placement*(scrolled_window: PScrolledWindow,
                                    window_placement: TCornerType){.cdecl,
    dynlib: lib, importc: "gtk_scrolled_window_set_placement".}
proc get_placement*(scrolled_window: PScrolledWindow): TCornerType{.
    cdecl, dynlib: lib, importc: "gtk_scrolled_window_get_placement".}
proc set_shadow_type*(scrolled_window: PScrolledWindow,
                                      thetype: TShadowType){.cdecl, dynlib: lib,
    importc: "gtk_scrolled_window_set_shadow_type".}
proc get_shadow_type*(scrolled_window: PScrolledWindow): TShadowType{.
    cdecl, dynlib: lib, importc: "gtk_scrolled_window_get_shadow_type".}
proc add_with_viewport*(scrolled_window: PScrolledWindow,
                                        child: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_scrolled_window_add_with_viewport".}
proc TYPE_SELECTION_DATA*(): GType
