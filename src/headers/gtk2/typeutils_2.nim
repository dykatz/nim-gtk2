# Included by headers/gtk2.nim; do not import directly.
proc identifier_get_type*(): GType{.cdecl, dynlib: lib,
                                    importc: "gtk_identifier_get_type".}
proc SIGNAL_FUNC*(f: pointer): TSignalFunc
proc type_class*(thetype: TType): gpointer{.cdecl, dynlib: lib,
    importc: "gtk_type_class".}
