# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TOGGLE_BUTTON*(): GType
proc TOGGLE_BUTTON*(obj: pointer): PToggleButton
proc TOGGLE_BUTTON_CLASS*(klass: pointer): PToggleButtonClass
proc IS_TOGGLE_BUTTON*(obj: pointer): bool
proc IS_TOGGLE_BUTTON_CLASS*(klass: pointer): bool
proc TOGGLE_BUTTON_GET_CLASS*(obj: pointer): PToggleButtonClass
proc active*(a: PToggleButton): guint
proc set_active*(a: PToggleButton, `active`: guint)
proc draw_indicator*(a: PToggleButton): guint
proc set_draw_indicator*(a: PToggleButton, `draw_indicator`: guint)
proc inconsistent*(a: PToggleButton): guint
proc set_inconsistent*(a: PToggleButton, `inconsistent`: guint)
proc toggle_button_get_type*(): TType{.cdecl, dynlib: lib,
                                       importc: "gtk_toggle_button_get_type".}
proc toggle_button_new*(): PToggleButton{.cdecl, dynlib: lib,
    importc: "gtk_toggle_button_new".}
proc toggle_button_new*(`label`: cstring): PToggleButton{.cdecl,
    dynlib: lib, importc: "gtk_toggle_button_new_with_label".}
proc toggle_button_new_with_mnemonic*(`label`: cstring): PToggleButton{.cdecl,
    dynlib: lib, importc: "gtk_toggle_button_new_with_mnemonic".}
proc set_mode*(toggle_button: PToggleButton,
                             draw_indicator: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_toggle_button_set_mode".}
proc get_mode*(toggle_button: PToggleButton): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_toggle_button_get_mode".}
proc set_active*(toggle_button: PToggleButton, is_active: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_toggle_button_set_active".}
proc get_active*(toggle_button: PToggleButton): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_toggle_button_get_active".}
proc toggled*(toggle_button: PToggleButton){.cdecl, dynlib: lib,
    importc: "gtk_toggle_button_toggled".}
proc set_inconsistent*(toggle_button: PToggleButton,
                                     setting: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_toggle_button_set_inconsistent".}
proc get_inconsistent*(toggle_button: PToggleButton): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_toggle_button_get_inconsistent".}
