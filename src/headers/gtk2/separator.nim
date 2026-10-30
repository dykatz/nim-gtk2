# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SEPARATOR*(): GType
proc SEPARATOR*(obj: pointer): PSeparator
proc SEPARATOR_CLASS*(klass: pointer): PSeparatorClass
proc IS_SEPARATOR*(obj: pointer): bool
proc IS_SEPARATOR_CLASS*(klass: pointer): bool
proc SEPARATOR_GET_CLASS*(obj: pointer): PSeparatorClass
proc separator_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_separator_get_type".}
