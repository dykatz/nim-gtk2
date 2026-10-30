# Included by headers/gtk2.nim; do not import directly.
proc TYPE_BUTTON*(): GType
proc BUTTON*(obj: pointer): PButton
proc BUTTON_CLASS*(klass: pointer): PButtonClass
proc IS_BUTTON*(obj: pointer): bool
proc IS_BUTTON_CLASS*(klass: pointer): bool
proc BUTTON_GET_CLASS*(obj: pointer): PButtonClass
proc constructed*(a: PButton): guint
proc set_constructed*(a: PButton, `constructed`: guint)
proc in_button*(a: PButton): guint
proc set_in_button*(a: PButton, `in_button`: guint)
proc button_down*(a: PButton): guint
proc set_button_down*(a: PButton, `button_down`: guint)
proc relief*(a: PButton): guint
proc use_underline*(a: PButton): guint
proc set_use_underline*(a: PButton, `use_underline`: guint)
proc use_stock*(a: PButton): guint
proc set_use_stock*(a: PButton, `use_stock`: guint)
proc depressed*(a: PButton): guint
proc set_depressed*(a: PButton, `depressed`: guint)
proc depress_on_activate*(a: PButton): guint
proc set_depress_on_activate*(a: PButton, `depress_on_activate`: guint)
proc button_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_button_get_type".}
proc button_new*(): PButton{.cdecl, dynlib: lib, importc: "gtk_button_new".}
proc button_new*(`label`: cstring): PButton{.cdecl, dynlib: lib,
    importc: "gtk_button_new_with_label".}
proc button_new_from_stock*(stock_id: cstring): PButton{.cdecl, dynlib: lib,
    importc: "gtk_button_new_from_stock".}
proc button_new_with_mnemonic*(`label`: cstring): PButton{.cdecl, dynlib: lib,
    importc: "gtk_button_new_with_mnemonic".}
proc pressed*(button: PButton){.cdecl, dynlib: lib,
                                       importc: "gtk_button_pressed".}
proc released*(button: PButton){.cdecl, dynlib: lib,
                                        importc: "gtk_button_released".}
proc clicked*(button: PButton){.cdecl, dynlib: lib,
                                       importc: "gtk_button_clicked".}
proc enter*(button: PButton){.cdecl, dynlib: lib,
                                     importc: "gtk_button_enter".}
proc leave*(button: PButton){.cdecl, dynlib: lib,
                                     importc: "gtk_button_leave".}
proc set_relief*(button: PButton, newstyle: TReliefStyle){.cdecl,
    dynlib: lib, importc: "gtk_button_set_relief".}
proc get_relief*(button: PButton): TReliefStyle{.cdecl, dynlib: lib,
    importc: "gtk_button_get_relief".}
proc set_label*(button: PButton, `label`: cstring){.cdecl, dynlib: lib,
    importc: "gtk_button_set_label".}
proc get_label*(button: PButton): cstring{.cdecl, dynlib: lib,
    importc: "gtk_button_get_label".}
proc set_use_underline*(button: PButton, use_underline: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_button_set_use_underline".}
proc get_use_underline*(button: PButton): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_button_get_use_underline".}
proc set_use_stock*(button: PButton, use_stock: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_button_set_use_stock".}
proc get_use_stock*(button: PButton): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_button_get_use_stock".}
proc set_depressed*(button: PButton, depressed: gboolean){.cdecl,
    dynlib: lib, importc: "_gtk_button_set_depressed".}
proc paint*(button: PButton, area: gdk2.PRectangle, state_type: TStateType,
                   shadow_type: TShadowType, main_detail: cstring,
                   default_detail: cstring){.cdecl, dynlib: lib,
    importc: "_gtk_button_paint".}
proc set_image*(button: PButton, image: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_button_set_image".}
proc get_image*(button: PButton): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_button_get_image".}
