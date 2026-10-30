# Included by headers/gtk2.nim; do not import directly.
proc COLOR_SELECTION*(obj: pointer): PColorSelection
proc COLOR_SELECTION_CLASS*(klass: pointer): PColorSelectionClass
proc IS_COLOR_SELECTION*(obj: pointer): bool
proc IS_COLOR_SELECTION_CLASS*(klass: pointer): bool
proc COLOR_SELECTION_GET_CLASS*(obj: pointer): PColorSelectionClass
proc color_selection_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_color_selection_get_type".}
proc color_selection_new*(): PColorSelection{.cdecl, dynlib: lib,
    importc: "gtk_color_selection_new".}
proc get_has_opacity_control*(colorsel: PColorSelection): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_color_selection_get_has_opacity_control".}
proc set_has_opacity_control*(colorsel: PColorSelection,
    has_opacity: gboolean){.cdecl, dynlib: lib, importc: "gtk_color_selection_set_has_opacity_control".}
proc get_has_palette*(colorsel: PColorSelection): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_color_selection_get_has_palette".}
proc set_has_palette*(colorsel: PColorSelection,
                                      has_palette: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_color_selection_set_has_palette".}
proc set_current_color*(colorsel: PColorSelection,
                                        color: gdk2.PColor){.cdecl, dynlib: lib,
    importc: "gtk_color_selection_set_current_color".}
proc set_current_alpha*(colorsel: PColorSelection,
                                        alpha: guint16){.cdecl, dynlib: lib,
    importc: "gtk_color_selection_set_current_alpha".}
proc get_current_color*(colorsel: PColorSelection,
                                        color: gdk2.PColor){.cdecl, dynlib: lib,
    importc: "gtk_color_selection_get_current_color".}
proc get_current_alpha*(colorsel: PColorSelection): guint16{.
    cdecl, dynlib: lib, importc: "gtk_color_selection_get_current_alpha".}
proc set_previous_color*(colorsel: PColorSelection,
    color: gdk2.PColor){.cdecl, dynlib: lib,
                       importc: "gtk_color_selection_set_previous_color".}
proc set_previous_alpha*(colorsel: PColorSelection,
    alpha: guint16){.cdecl, dynlib: lib,
                     importc: "gtk_color_selection_set_previous_alpha".}
proc get_previous_color*(colorsel: PColorSelection,
    color: gdk2.PColor){.cdecl, dynlib: lib,
                       importc: "gtk_color_selection_get_previous_color".}
proc get_previous_alpha*(colorsel: PColorSelection): guint16{.
    cdecl, dynlib: lib, importc: "gtk_color_selection_get_previous_alpha".}
proc is_adjusting*(colorsel: PColorSelection): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_color_selection_is_adjusting".}
proc color_selection_palette_from_string*(str: cstring, colors: var gdk2.PColor,
    n_colors: Pgint): gboolean{.cdecl, dynlib: lib, importc: "gtk_color_selection_palette_from_string".}
proc color_selection_palette_to_string*(colors: gdk2.PColor, n_colors: gint): cstring{.
    cdecl, dynlib: lib, importc: "gtk_color_selection_palette_to_string".}
proc color_selection_set_change_palette_with_screen_hook*(
    fn: TColorSelectionChangePaletteWithScreenFunc): TColorSelectionChangePaletteWithScreenFunc{.
    cdecl, dynlib: lib,
    importc: "gtk_color_selection_set_change_palette_with_screen_hook".}
proc TYPE_COLOR_SELECTION_DIALOG*(): GType
