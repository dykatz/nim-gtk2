# Generated from gtkprintunixdialog.h; included by headers/gtk2.nim.
when defined(posix) and not defined(macosx):
  proc print_unix_dialog_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_type".}
  proc print_unix_dialog_new*(`title`: cstring; `parent`: ptr TWindow): ptr PrintUnixDialog {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_new".}
  proc print_unix_dialog_set_page_setup*(`dialog`: ptr PrintUnixDialog; `page_setup`: ptr PageSetup) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_set_page_setup".}
  proc print_unix_dialog_get_page_setup*(`dialog`: ptr PrintUnixDialog): ptr PageSetup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_page_setup".}
  proc print_unix_dialog_set_current_page*(`dialog`: ptr PrintUnixDialog; `current_page`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_set_current_page".}
  proc print_unix_dialog_get_current_page*(`dialog`: ptr PrintUnixDialog): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_current_page".}
  proc print_unix_dialog_set_settings*(`dialog`: ptr PrintUnixDialog; `settings`: ptr PrintSettings) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_set_settings".}
  proc print_unix_dialog_get_settings*(`dialog`: ptr PrintUnixDialog): ptr PrintSettings {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_settings".}
  proc print_unix_dialog_get_selected_printer*(`dialog`: ptr PrintUnixDialog): ptr Printer {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_selected_printer".}
  proc print_unix_dialog_add_custom_tab*(`dialog`: ptr PrintUnixDialog; `child`: ptr TWidget; `tab_label`: ptr TWidget) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_add_custom_tab".}
  proc print_unix_dialog_set_manual_capabilities*(`dialog`: ptr PrintUnixDialog; `capabilities`: PrintCapabilities) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_set_manual_capabilities".}
  proc print_unix_dialog_get_manual_capabilities*(`dialog`: ptr PrintUnixDialog): PrintCapabilities {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_manual_capabilities".}
  proc print_unix_dialog_set_support_selection*(`dialog`: ptr PrintUnixDialog; `support_selection`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_set_support_selection".}
  proc print_unix_dialog_get_support_selection*(`dialog`: ptr PrintUnixDialog): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_support_selection".}
  proc print_unix_dialog_set_has_selection*(`dialog`: ptr PrintUnixDialog; `has_selection`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_set_has_selection".}
  proc print_unix_dialog_get_has_selection*(`dialog`: ptr PrintUnixDialog): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_has_selection".}
  proc print_unix_dialog_set_embed_page_setup*(`dialog`: ptr PrintUnixDialog; `embed`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_set_embed_page_setup".}
  proc print_unix_dialog_get_embed_page_setup*(`dialog`: ptr PrintUnixDialog): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_embed_page_setup".}
  proc print_unix_dialog_get_page_setup_set*(`dialog`: ptr PrintUnixDialog): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_print_unix_dialog_get_page_setup_set".}
