# Generated from gtkfontbutton.h; included by headers/gtk2.nim.
proc font_button_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_get_type".}
proc font_button_new*(): ptr FontButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_new".}
proc font_button_new_with_font*(`fontname`: cstring): ptr FontButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_new_with_font".}
proc font_button_get_title*(`font_button`: ptr FontButton): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_get_title".}
proc font_button_set_title*(`font_button`: ptr FontButton; `title`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_set_title".}
proc font_button_get_use_font*(`font_button`: ptr FontButton): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_get_use_font".}
proc font_button_set_use_font*(`font_button`: ptr FontButton; `use_font`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_set_use_font".}
proc font_button_get_use_size*(`font_button`: ptr FontButton): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_get_use_size".}
proc font_button_set_use_size*(`font_button`: ptr FontButton; `use_size`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_set_use_size".}
proc font_button_get_font_name*(`font_button`: ptr FontButton): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_get_font_name".}
proc font_button_set_font_name*(`font_button`: ptr FontButton; `fontname`: cstring): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_set_font_name".}
proc font_button_get_show_style*(`font_button`: ptr FontButton): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_get_show_style".}
proc font_button_set_show_style*(`font_button`: ptr FontButton; `show_style`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_set_show_style".}
proc font_button_get_show_size*(`font_button`: ptr FontButton): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_get_show_size".}
proc font_button_set_show_size*(`font_button`: ptr FontButton; `show_size`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_font_button_set_show_size".}
