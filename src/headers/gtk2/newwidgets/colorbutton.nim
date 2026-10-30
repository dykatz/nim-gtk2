# Generated from gtkcolorbutton.h; included by headers/gtk2.nim.
proc color_button_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_get_type".}
proc color_button_new*(): ptr ColorButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_new".}
proc color_button_new_with_color*(`color`: ptr gdk2.TColor): ptr ColorButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_new_with_color".}
proc color_button_set_color*(`color_button`: ptr ColorButton; `color`: ptr gdk2.TColor) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_set_color".}
proc color_button_set_alpha*(`color_button`: ptr ColorButton; `alpha`: guint16) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_set_alpha".}
proc color_button_get_color*(`color_button`: ptr ColorButton; `color`: ptr gdk2.TColor) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_get_color".}
proc color_button_get_alpha*(`color_button`: ptr ColorButton): guint16 {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_get_alpha".}
proc color_button_set_use_alpha*(`color_button`: ptr ColorButton; `use_alpha`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_set_use_alpha".}
proc color_button_get_use_alpha*(`color_button`: ptr ColorButton): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_get_use_alpha".}
proc color_button_set_title*(`color_button`: ptr ColorButton; `title`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_set_title".}
proc color_button_get_title*(`color_button`: ptr ColorButton): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_color_button_get_title".}
