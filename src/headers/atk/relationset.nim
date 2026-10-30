# Included by headers/atk.nim; do not import directly.
proc TYPE_RELATION_SET*(): GType
proc RELATION_SET*(obj: pointer): PRelationSet
proc RELATION_SET_CLASS*(klass: pointer): PRelationSetClass
proc IS_RELATION_SET*(obj: pointer): bool
proc IS_RELATION_SET_CLASS*(klass: pointer): bool
proc RELATION_SET_GET_CLASS*(obj: pointer): PRelationSetClass
proc relation_set_get_type*(): GType{.cdecl, dynlib: lib,
                                      importc: "atk_relation_set_get_type".}
proc relation_set_new*(): PRelationSet{.cdecl, dynlib: lib,
                                        importc: "atk_relation_set_new".}
proc contains*(RelationSet: PRelationSet,
                            relationship: TRelationType): gboolean{.cdecl,
    dynlib: lib, importc: "atk_relation_set_contains".}
proc remove*(RelationSet: PRelationSet, relation: PRelation){.
    cdecl, dynlib: lib, importc: "atk_relation_set_remove".}
proc add*(RelationSet: PRelationSet, relation: PRelation){.cdecl,
    dynlib: lib, importc: "atk_relation_set_add".}
proc get_n_relations*(RelationSet: PRelationSet): gint{.cdecl,
    dynlib: lib, importc: "atk_relation_set_get_n_relations".}
proc get_relation*(RelationSet: PRelationSet, i: gint): PRelation{.
    cdecl, dynlib: lib, importc: "atk_relation_set_get_relation".}
proc get_relation_by_type*(RelationSet: PRelationSet,
                                        relationship: TRelationType): PRelation{.
    cdecl, dynlib: lib, importc: "atk_relation_set_get_relation_by_type".}
