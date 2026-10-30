# Included by headers/gtk2.nim; do not import directly.
proc COLOR_SELECTION_DIALOG*(obj: pointer): PColorSelectionDialog
proc COLOR_SELECTION_DIALOG_CLASS*(klass: pointer): PColorSelectionDialogClass
proc IS_COLOR_SELECTION_DIALOG*(obj: pointer): bool
proc IS_COLOR_SELECTION_DIALOG_CLASS*(klass: pointer): bool
proc COLOR_SELECTION_DIALOG_GET_CLASS*(obj: pointer): PColorSelectionDialogClass
proc color_selection_dialog_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_color_selection_dialog_get_type".}
proc color_selection_dialog_new*(title: cstring): PColorSelectionDialog{.cdecl,
    dynlib: lib, importc: "gtk_color_selection_dialog_new".}
