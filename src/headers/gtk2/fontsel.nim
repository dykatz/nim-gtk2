# Included by headers/gtk2.nim; do not import directly.
proc FONT_SELECTION*(obj: pointer): PFontSelection
proc FONT_SELECTION_CLASS*(klass: pointer): PFontSelectionClass
proc IS_FONT_SELECTION*(obj: pointer): bool
proc IS_FONT_SELECTION_CLASS*(klass: pointer): bool
proc FONT_SELECTION_GET_CLASS*(obj: pointer): PFontSelectionClass
proc TYPE_FONT_SELECTION_DIALOG*(): GType
proc FONT_SELECTION_DIALOG*(obj: pointer): PFontSelectionDialog
proc FONT_SELECTION_DIALOG_CLASS*(klass: pointer): PFontSelectionDialogClass
proc IS_FONT_SELECTION_DIALOG*(obj: pointer): bool
proc IS_FONT_SELECTION_DIALOG_CLASS*(klass: pointer): bool
proc FONT_SELECTION_DIALOG_GET_CLASS*(obj: pointer): PFontSelectionDialogClass
proc font_selection_get_type*(): TType{.cdecl, dynlib: lib,
                                        importc: "gtk_font_selection_get_type".}
proc font_selection_new*(): PFontSelection{.cdecl, dynlib: lib,
    importc: "gtk_font_selection_new".}
proc get_font_name*(fontsel: PFontSelection): cstring{.cdecl,
    dynlib: lib, importc: "gtk_font_selection_get_font_name".}
proc set_font_name*(fontsel: PFontSelection, fontname: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_font_selection_set_font_name".}
proc get_preview_text*(fontsel: PFontSelection): cstring{.cdecl,
    dynlib: lib, importc: "gtk_font_selection_get_preview_text".}
proc set_preview_text*(fontsel: PFontSelection, text: cstring){.
    cdecl, dynlib: lib, importc: "gtk_font_selection_set_preview_text".}
proc font_selection_dialog_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_font_selection_dialog_get_type".}
proc font_selection_dialog_new*(title: cstring): PFontSelectionDialog{.cdecl,
    dynlib: lib, importc: "gtk_font_selection_dialog_new".}
proc dialog_get_font_name*(fsd: PFontSelectionDialog): cstring{.
    cdecl, dynlib: lib, importc: "gtk_font_selection_dialog_get_font_name".}
proc dialog_set_font_name*(fsd: PFontSelectionDialog,
    fontname: cstring): gboolean{.cdecl, dynlib: lib, importc: "gtk_font_selection_dialog_set_font_name".}
proc dialog_get_preview_text*(fsd: PFontSelectionDialog): cstring{.
    cdecl, dynlib: lib, importc: "gtk_font_selection_dialog_get_preview_text".}
proc dialog_set_preview_text*(fsd: PFontSelectionDialog,
    text: cstring){.cdecl, dynlib: lib,
                    importc: "gtk_font_selection_dialog_set_preview_text".}
