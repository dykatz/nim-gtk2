# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HSEPARATOR*(): GType
proc HSEPARATOR*(obj: pointer): PHSeparator
proc HSEPARATOR_CLASS*(klass: pointer): PHSeparatorClass
proc IS_HSEPARATOR*(obj: pointer): bool
proc IS_HSEPARATOR_CLASS*(klass: pointer): bool
proc HSEPARATOR_GET_CLASS*(obj: pointer): PHSeparatorClass
proc hseparator_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_hseparator_get_type".}
proc hseparator_new*(): PHSeparator{.cdecl, dynlib: lib,
                                     importc: "gtk_hseparator_new".}
