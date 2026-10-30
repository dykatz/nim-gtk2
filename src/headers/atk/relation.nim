# Included by headers/atk.nim; do not import directly.
proc TYPE_RELATION*(): GType
proc RELATION*(obj: pointer): PRelation
proc RELATION_CLASS*(klass: pointer): PRelationClass
proc IS_RELATION*(obj: pointer): bool
proc IS_RELATION_CLASS*(klass: pointer): bool
proc RELATION_GET_CLASS*(obj: pointer): PRelationClass
proc relation_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "atk_relation_get_type".}
proc relation_type_register*(name: cstring): TRelationType{.cdecl, dynlib: lib,
    importc: "atk_relation_type_register".}
proc relation_type_get_name*(`type`: TRelationType): cstring{.cdecl,
    dynlib: lib, importc: "atk_relation_type_get_name".}
proc relation_type_for_name*(name: cstring): TRelationType{.cdecl, dynlib: lib,
    importc: "atk_relation_type_for_name".}
proc relation_new*(targets: PPAtkObject, n_targets: gint,
                   relationship: TRelationType): PRelation{.cdecl, dynlib: lib,
    importc: "atk_relation_new".}
proc get_relation_type*(relation: PRelation): TRelationType{.cdecl,
    dynlib: lib, importc: "atk_relation_get_relation_type".}
proc get_target*(relation: PRelation): PGPtrArray{.cdecl, dynlib: lib,
    importc: "atk_relation_get_target".}
