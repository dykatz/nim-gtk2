# Generated from gtkspinner.h; included by headers/gtk2.nim.
proc spinner_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_spinner_get_type".}
proc spinner_new*(): ptr Spinner {.cdecl, gcsafe, dynlib: lib, importc: "gtk_spinner_new".}
proc spinner_start*(`spinner`: ptr Spinner) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_spinner_start".}
proc spinner_stop*(`spinner`: ptr Spinner) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_spinner_stop".}
