# Generated from gtkrecentchooserdialog.h; included by headers/gtk2.nim.
proc recent_chooser_dialog_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_dialog_get_type".}
proc recent_chooser_dialog_new*(`title`: cstring; `parent`: ptr TWindow; `first_button_text`: cstring): ptr RecentChooserDialog {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_dialog_new", varargs.}
proc recent_chooser_dialog_new_for_manager*(`title`: cstring; `parent`: ptr TWindow; `manager`: ptr RecentManager; `first_button_text`: cstring): ptr RecentChooserDialog {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_dialog_new_for_manager", varargs.}
