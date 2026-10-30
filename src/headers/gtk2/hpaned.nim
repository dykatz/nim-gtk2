# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HPANED*(): GType
proc HPANED*(obj: pointer): PHPaned
proc HPANED_CLASS*(klass: pointer): PHPanedClass
proc IS_HPANED*(obj: pointer): bool
proc IS_HPANED_CLASS*(klass: pointer): bool
proc HPANED_GET_CLASS*(obj: pointer): PHPanedClass
proc hpaned_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_hpaned_get_type".}
proc hpaned_new*(): PHPaned{.cdecl, dynlib: lib, importc: "gtk_hpaned_new".}
