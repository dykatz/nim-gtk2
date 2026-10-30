# Included by headers/atk.nim; do not import directly.
proc TYPE_GOBJECT_ACCESSIBLE*(): GType
proc GOBJECT_ACCESSIBLE*(obj: pointer): PGObjectAccessible
proc GOBJECT_ACCESSIBLE_CLASS*(klass: pointer): PGObjectAccessibleClass
proc IS_GOBJECT_ACCESSIBLE*(obj: pointer): bool
proc IS_GOBJECT_ACCESSIBLE_CLASS*(klass: pointer): bool
proc GOBJECT_ACCESSIBLE_GET_CLASS*(obj: pointer): PGObjectAccessibleClass
proc gobject_accessible_get_type*(): GType{.cdecl, dynlib: lib,
    importc: "atk_gobject_accessible_get_type".}
proc accessible_for_object*(obj: PGObject): PObject{.cdecl, dynlib: lib,
    importc: "atk_gobject_accessible_for_object".}
proc get_object*(obj: PGObjectAccessible): PGObject{.cdecl,
    dynlib: lib, importc: "atk_gobject_accessible_get_object".}
