# Generated from gtkpagesetupunixdialog.h; included by headers/gtk2.nim.
when defined(posix) and not defined(macosx):
  proc page_setup_unix_dialog_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_unix_dialog_get_type".}
  proc page_setup_unix_dialog_new*(`title`: cstring; `parent`: ptr TWindow): ptr PageSetupUnixDialog {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_unix_dialog_new".}
  proc page_setup_unix_dialog_set_page_setup*(`dialog`: ptr PageSetupUnixDialog; `page_setup`: ptr PageSetup) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_unix_dialog_set_page_setup".}
  proc page_setup_unix_dialog_get_page_setup*(`dialog`: ptr PageSetupUnixDialog): ptr PageSetup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_unix_dialog_get_page_setup".}
  proc page_setup_unix_dialog_set_print_settings*(`dialog`: ptr PageSetupUnixDialog; `print_settings`: ptr PrintSettings) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_unix_dialog_set_print_settings".}
  proc page_setup_unix_dialog_get_print_settings*(`dialog`: ptr PageSetupUnixDialog): ptr PrintSettings {.cdecl, gcsafe, dynlib: lib, importc: "gtk_page_setup_unix_dialog_get_print_settings".}
