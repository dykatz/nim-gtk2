# Included by headers/gtk2.nim; do not import directly.
proc message_type_get_type*(): GType {.cdecl, dynlib: lib,
    importc: "gtk_message_type_get_type".}
