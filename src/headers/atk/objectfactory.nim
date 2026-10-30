# Included by headers/atk.nim; do not import directly.
proc TYPE_OBJECT_FACTORY*(): GType
proc OBJECT_FACTORY*(obj: pointer): PObjectFactory
proc OBJECT_FACTORY_CLASS*(klass: pointer): PObjectFactoryClass
proc IS_OBJECT_FACTORY*(obj: pointer): bool
proc IS_OBJECT_FACTORY_CLASS*(klass: pointer): bool
proc OBJECT_FACTORY_GET_CLASS*(obj: pointer): PObjectFactoryClass
proc object_factory_get_type*(): GType{.cdecl, dynlib: lib,
                                        importc: "atk_object_factory_get_type".}
proc create_accessible*(factory: PObjectFactory, obj: PGObject): PObject{.
    cdecl, dynlib: lib, importc: "atk_object_factory_create_accessible".}
proc invalidate*(factory: PObjectFactory){.cdecl, dynlib: lib,
    importc: "atk_object_factory_invalidate".}
proc get_accessible_type*(factory: PObjectFactory): GType{.cdecl,
    dynlib: lib, importc: "atk_object_factory_get_accessible_type".}
