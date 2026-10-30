# Included by headers/gtk2.nim; do not import directly.
proc format_secondary_text*(dialog: PMessageDialog, format: cstring) {.cdecl,
    dynlib: lib, varargs, importc: "gtk_message_dialog_format_secondary_text".}
proc set_markup*(msgDialog: PMessageDialog, str: cstring) {.cdecl,
    importc: "gtk_message_dialog_set_markup", dynlib: lib.}

