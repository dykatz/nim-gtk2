# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ACCESSIBLE*(): GType
proc ACCESSIBLE*(obj: pointer): PAccessible
proc ACCESSIBLE_CLASS*(klass: pointer): PAccessibleClass
proc IS_ACCESSIBLE*(obj: pointer): bool
proc IS_ACCESSIBLE_CLASS*(klass: pointer): bool
proc ACCESSIBLE_GET_CLASS*(obj: pointer): PAccessibleClass
proc accessible_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_accessible_get_type".}
proc connect_widget_destroyed*(accessible: PAccessible){.cdecl,
    dynlib: lib, importc: "gtk_accessible_connect_widget_destroyed".}
