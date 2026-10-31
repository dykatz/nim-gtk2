# Included by headers/gtk2.nim; do not import directly.
proc attach_options_get_type*(): GType {.cdecl, dynlib: lib,
    importc: "gtk_attach_options_get_type".}
proc arrow_type_get_type*(): GType {.cdecl, dynlib: lib,
    importc: "gtk_arrow_type_get_type".}
proc shadow_type_get_type*(): GType {.cdecl, dynlib: lib,
    importc: "gtk_shadow_type_get_type".}
proc message_type_get_type*(): GType {.cdecl, dynlib: lib,
    importc: "gtk_message_type_get_type".}
