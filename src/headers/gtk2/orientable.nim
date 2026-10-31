# GtkOrientable interface (GTK 2.16+); included by headers/gtk2.nim.
type Orientable* {.pure, final, incompleteStruct.} = object
proc orientable_get_type*(): GType {.cdecl, dynlib: lib, importc: "gtk_orientable_get_type".}
proc orientable_get_orientation*(w: ptr Orientable): TOrientation {.cdecl, dynlib: lib, importc: "gtk_orientable_get_orientation".}
proc orientable_set_orientation*(w: ptr Orientable, orientation: TOrientation) {.cdecl, dynlib: lib, importc: "gtk_orientable_set_orientation".}
