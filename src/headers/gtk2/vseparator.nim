# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VSEPARATOR*(): GType
proc VSEPARATOR*(obj: pointer): PVSeparator
proc VSEPARATOR_CLASS*(klass: pointer): PVSeparatorClass
proc IS_VSEPARATOR*(obj: pointer): bool
proc IS_VSEPARATOR_CLASS*(klass: pointer): bool
proc VSEPARATOR_GET_CLASS*(obj: pointer): PVSeparatorClass
proc vseparator_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_vseparator_get_type".}
proc vseparator_new*(): PVSeparator{.cdecl, dynlib: lib,
                                     importc: "gtk_vseparator_new".}
