# Included by headers/atk.nim; do not import directly.
proc TYPE_REGISTRY*(): GType
proc REGISTRY*(obj: pointer): PRegistry
proc REGISTRY_CLASS*(klass: pointer): PRegistryClass
proc IS_REGISTRY*(obj: pointer): bool
proc IS_REGISTRY_CLASS*(klass: pointer): bool
proc REGISTRY_GET_CLASS*(obj: pointer): PRegistryClass
proc registry_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "atk_registry_get_type".}
proc set_factory_type*(registry: PRegistry, `type`: GType,
                                factory_type: GType){.cdecl, dynlib: lib,
    importc: "atk_registry_set_factory_type".}
proc get_factory_type*(registry: PRegistry, `type`: GType): GType{.
    cdecl, dynlib: lib, importc: "atk_registry_get_factory_type".}
proc get_factory*(registry: PRegistry, `type`: GType): PObjectFactory{.
    cdecl, dynlib: lib, importc: "atk_registry_get_factory".}
proc get_default_registry*(): PRegistry{.cdecl, dynlib: lib,
    importc: "atk_get_default_registry".}
