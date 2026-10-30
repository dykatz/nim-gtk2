# Generated from gtkaboutdialog.h; included by headers/gtk2.nim.
proc about_dialog_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_type".}
proc about_dialog_new*(): ptr AboutDialog {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_new".}
proc show_about_dialog*(`parent`: ptr TWindow; `first_property_name`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_show_about_dialog", varargs.}
proc about_dialog_get_program_name*(`about`: ptr AboutDialog): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_program_name".}
proc about_dialog_set_program_name*(`about`: ptr AboutDialog; `name`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_program_name".}
proc about_dialog_get_version*(`about`: ptr AboutDialog): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_version".}
proc about_dialog_set_version*(`about`: ptr AboutDialog; `version`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_version".}
proc about_dialog_get_copyright*(`about`: ptr AboutDialog): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_copyright".}
proc about_dialog_set_copyright*(`about`: ptr AboutDialog; `copyright`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_copyright".}
proc about_dialog_get_comments*(`about`: ptr AboutDialog): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_comments".}
proc about_dialog_set_comments*(`about`: ptr AboutDialog; `comments`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_comments".}
proc about_dialog_get_license*(`about`: ptr AboutDialog): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_license".}
proc about_dialog_set_license*(`about`: ptr AboutDialog; `license`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_license".}
proc about_dialog_get_wrap_license*(`about`: ptr AboutDialog): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_wrap_license".}
proc about_dialog_set_wrap_license*(`about`: ptr AboutDialog; `wrap_license`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_wrap_license".}
proc about_dialog_get_website*(`about`: ptr AboutDialog): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_website".}
proc about_dialog_set_website*(`about`: ptr AboutDialog; `website`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_website".}
proc about_dialog_get_website_label*(`about`: ptr AboutDialog): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_website_label".}
proc about_dialog_set_website_label*(`about`: ptr AboutDialog; `website_label`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_website_label".}
proc about_dialog_get_authors*(`about`: ptr AboutDialog): ptr cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_authors".}
proc about_dialog_set_authors*(`about`: ptr AboutDialog; `authors`: ptr cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_authors".}
proc about_dialog_get_documenters*(`about`: ptr AboutDialog): ptr cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_documenters".}
proc about_dialog_set_documenters*(`about`: ptr AboutDialog; `documenters`: ptr cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_documenters".}
proc about_dialog_get_artists*(`about`: ptr AboutDialog): ptr cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_artists".}
proc about_dialog_set_artists*(`about`: ptr AboutDialog; `artists`: ptr cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_artists".}
proc about_dialog_get_translator_credits*(`about`: ptr AboutDialog): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_translator_credits".}
proc about_dialog_set_translator_credits*(`about`: ptr AboutDialog; `translator_credits`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_translator_credits".}
proc about_dialog_get_logo*(`about`: ptr AboutDialog): gdk2pixbuf.PPixbuf {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_logo".}
proc about_dialog_set_logo*(`about`: ptr AboutDialog; `logo`: gdk2pixbuf.PPixbuf) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_logo".}
proc about_dialog_get_logo_icon_name*(`about`: ptr AboutDialog): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_get_logo_icon_name".}
proc about_dialog_set_logo_icon_name*(`about`: ptr AboutDialog; `icon_name`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_about_dialog_set_logo_icon_name".}
