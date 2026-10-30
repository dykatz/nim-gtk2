# Included by headers/gtk2.nim; do not import directly.
proc selection_data_get_type*(): GType{.cdecl, dynlib: lib,
                                        importc: "gtk_selection_data_get_type".}
proc copy*(data: PSelectionData): PSelectionData{.cdecl,
    dynlib: lib, importc: "gtk_selection_data_copy".}
proc free*(data: PSelectionData){.cdecl, dynlib: lib,
    importc: "gtk_selection_data_free".}
