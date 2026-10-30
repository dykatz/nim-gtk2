# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SCALE*(): GType
proc SCALE*(obj: pointer): PScale
proc SCALE_CLASS*(klass: pointer): PScaleClass
proc IS_SCALE*(obj: pointer): bool
proc IS_SCALE_CLASS*(klass: pointer): bool
proc SCALE_GET_CLASS*(obj: pointer): PScaleClass
proc draw_value*(a: PScale): guint
proc set_draw_value*(a: PScale, `draw_value`: guint)
proc value_pos*(a: PScale): guint

proc scale_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_scale_get_type".}
proc set_digits*(scale: PScale, digits: gint){.cdecl, dynlib: lib,
    importc: "gtk_scale_set_digits".}
proc get_digits*(scale: PScale): gint{.cdecl, dynlib: lib,
    importc: "gtk_scale_get_digits".}
proc set_draw_value*(scale: PScale, draw_value: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_scale_set_draw_value".}
proc get_draw_value*(scale: PScale): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_scale_get_draw_value".}
proc set_value_pos*(scale: PScale, pos: TPositionType){.cdecl,
    dynlib: lib, importc: "gtk_scale_set_value_pos".}
proc get_value_pos*(scale: PScale): TPositionType{.cdecl, dynlib: lib,
    importc: "gtk_scale_get_value_pos".}
proc add_mark*(scale: PScale, value: gdouble, position: TPositionType, markup: cstring) {.
    cdecl, dynlib: lib, importc: "gtk_scale_add_mark".}
proc clear_marks*(scale: PScale) {.cdecl, dynlib: lib, importc: "gtk_scale_clear_marks".}
proc get_value_size*(scale: PScale, width: Pgint, height: Pgint){.cdecl,
    dynlib: lib, importc: "_gtk_scale_get_value_size".}
proc format_value*(scale: PScale, value: gdouble): cstring{.cdecl,
    dynlib: lib, importc: "_gtk_scale_format_value".}
