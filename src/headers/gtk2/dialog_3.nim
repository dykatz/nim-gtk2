# Included by headers/gtk2.nim; do not import directly.
proc add_buttons*(dialog: PDialog, first_button_text: cstring){.varargs,
    cdecl, importc: "gtk_dialog_add_buttons", dynlib: lib.}
proc dialog_new_with_buttons*(title: cstring, parent: PWindow,
                              flags: TDialogFlags, first_button_text: cstring): PDialog{.
    varargs, cdecl, importc: "gtk_dialog_new_with_buttons", dynlib: lib.}
