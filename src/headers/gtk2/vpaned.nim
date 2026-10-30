# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VPANED*(): GType
proc VPANED*(obj: pointer): PVPaned
proc VPANED_CLASS*(klass: pointer): PVPanedClass
proc IS_VPANED*(obj: pointer): bool
proc IS_VPANED_CLASS*(klass: pointer): bool
proc VPANED_GET_CLASS*(obj: pointer): PVPanedClass
proc vpaned_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_vpaned_get_type".}
proc vpaned_new*(): PVPaned{.cdecl, dynlib: lib, importc: "gtk_vpaned_new".}
