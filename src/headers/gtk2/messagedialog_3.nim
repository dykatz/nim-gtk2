# Included by headers/gtk2.nim; do not import directly.
proc message_dialog_new*(parent: PWindow, flags: TDialogFlags,
                         thetype: TMessageType, buttons: TButtonsType,
                         message_format: cstring): PMessageDialog{.varargs,
    cdecl, importc: "gtk_message_dialog_new", dynlib: lib.}
