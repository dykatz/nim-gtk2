# Included by headers/gtk2.nim; do not import directly.
proc TYPE_FIXED*(): GType
proc FIXED*(obj: pointer): PFixed
proc FIXED_CLASS*(klass: pointer): PFixedClass
proc IS_FIXED*(obj: pointer): bool
proc IS_FIXED_CLASS*(klass: pointer): bool
proc FIXED_GET_CLASS*(obj: pointer): PFixedClass
proc fixed_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_fixed_get_type".}
proc fixed_new*(): PFixed{.cdecl, dynlib: lib, importc: "gtk_fixed_new".}
proc put*(fixed: PFixed, widget: PWidget, x: gint, y: gint){.cdecl,
    dynlib: lib, importc: "gtk_fixed_put".}
proc move*(fixed: PFixed, widget: PWidget, x: gint, y: gint){.cdecl,
    dynlib: lib, importc: "gtk_fixed_move".}
proc set_has_window*(fixed: PFixed, has_window: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_fixed_set_has_window".}
proc get_has_window*(fixed: PFixed): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_fixed_get_has_window".}
proc TYPE_FONT_SELECTION*(): GType
