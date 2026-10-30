# Included by headers/gtk2.nim; do not import directly.
proc file_chooser_dialog_new*(title: cstring, parent: PWindow,
                              action: TFileChooserAction,
                              first_button_text: cstring): PFileChooser{.cdecl,
    varargs, dynlib: lib, importc: "gtk_file_chooser_dialog_new".}

proc file_chooser_dialog_new_with_backend*(title: cstring, parent: PWindow,
    action: TFileChooserAction, backend: cstring, first_button_text: cstring): PFileChooser{.
    varargs, cdecl, dynlib: lib,
    importc: "gtk_file_chooser_dialog_new_with_backend".}
