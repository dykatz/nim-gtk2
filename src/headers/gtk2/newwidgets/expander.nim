# Generated from gtkexpander.h; included by headers/gtk2.nim.
proc expander_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_get_type".}
proc expander_new*(`label`: cstring): ptr Expander {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_new".}
proc expander_new_with_mnemonic*(`label`: cstring): ptr Expander {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_new_with_mnemonic".}
proc expander_set_expanded*(`expander`: ptr Expander; `expanded`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_set_expanded".}
proc expander_get_expanded*(`expander`: ptr Expander): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_get_expanded".}
proc expander_set_spacing*(`expander`: ptr Expander; `spacing`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_set_spacing".}
proc expander_get_spacing*(`expander`: ptr Expander): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_get_spacing".}
proc expander_set_label*(`expander`: ptr Expander; `label`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_set_label".}
proc expander_get_label*(`expander`: ptr Expander): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_get_label".}
proc expander_set_use_underline*(`expander`: ptr Expander; `use_underline`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_set_use_underline".}
proc expander_get_use_underline*(`expander`: ptr Expander): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_get_use_underline".}
proc expander_set_use_markup*(`expander`: ptr Expander; `use_markup`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_set_use_markup".}
proc expander_get_use_markup*(`expander`: ptr Expander): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_get_use_markup".}
proc expander_set_label_widget*(`expander`: ptr Expander; `label_widget`: ptr TWidget) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_set_label_widget".}
proc expander_get_label_widget*(`expander`: ptr Expander): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_get_label_widget".}
proc expander_set_label_fill*(`expander`: ptr Expander; `label_fill`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_set_label_fill".}
proc expander_get_label_fill*(`expander`: ptr Expander): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_expander_get_label_fill".}
