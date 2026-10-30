# Included by headers/atk.nim; do not import directly.
proc role_register*(name: cstring): TRole{.cdecl, dynlib: lib,
    importc: "atk_role_register".}
proc object_get_type*(): GType{.cdecl, dynlib: lib,
                                importc: "atk_object_get_type".}
proc TYPE_OBJECT*(): GType
proc `OBJECT`*(obj: pointer): PObject
proc OBJECT_CLASS*(klass: pointer): PObjectClass
proc IS_OBJECT*(obj: pointer): bool
proc IS_OBJECT_CLASS*(klass: pointer): bool
proc OBJECT_GET_CLASS*(obj: pointer): PObjectClass
proc TYPE_IMPLEMENTOR*(): GType
proc IS_IMPLEMENTOR*(obj: pointer): bool
proc IMPLEMENTOR*(obj: pointer): PImplementor
proc IMPLEMENTOR_GET_IFACE*(obj: pointer): PImplementorIface
proc implementor_get_type*(): GType{.cdecl, dynlib: lib,
                                     importc: "atk_implementor_get_type".}
proc ref_accessible*(implementor: PImplementor): PObject{.cdecl,
    dynlib: lib, importc: "atk_implementor_ref_accessible".}
proc get_name*(accessible: PObject): cstring{.cdecl, dynlib: lib,
    importc: "atk_object_get_name".}
proc get_description*(accessible: PObject): cstring{.cdecl, dynlib: lib,
    importc: "atk_object_get_description".}
proc get_parent*(accessible: PObject): PObject{.cdecl, dynlib: lib,
    importc: "atk_object_get_parent".}
proc get_n_accessible_children*(accessible: PObject): gint{.cdecl,
    dynlib: lib, importc: "atk_object_get_n_accessible_children".}
proc ref_accessible_child*(accessible: PObject, i: gint): PObject{.cdecl,
    dynlib: lib, importc: "atk_object_ref_accessible_child".}
proc ref_relation_set*(accessible: PObject): PRelationSet{.cdecl,
    dynlib: lib, importc: "atk_object_ref_relation_set".}
proc get_role*(accessible: PObject): TRole{.cdecl, dynlib: lib,
    importc: "atk_object_get_role".}
proc get_layer*(accessible: PObject): TLayer{.cdecl, dynlib: lib,
    importc: "atk_object_get_layer".}
proc get_mdi_zorder*(accessible: PObject): gint{.cdecl, dynlib: lib,
    importc: "atk_object_get_mdi_zorder".}
proc ref_state_set*(accessible: PObject): PStateSet{.cdecl, dynlib: lib,
    importc: "atk_object_ref_state_set".}
proc get_index_in_parent*(accessible: PObject): gint{.cdecl, dynlib: lib,
    importc: "atk_object_get_index_in_parent".}
proc set_name*(accessible: PObject, name: cstring){.cdecl, dynlib: lib,
    importc: "atk_object_set_name".}
proc set_description*(accessible: PObject, description: cstring){.cdecl,
    dynlib: lib, importc: "atk_object_set_description".}
proc set_parent*(accessible: PObject, parent: PObject){.cdecl,
    dynlib: lib, importc: "atk_object_set_parent".}
proc set_role*(accessible: PObject, role: TRole){.cdecl, dynlib: lib,
    importc: "atk_object_set_role".}
proc connect_property_change_handler*(accessible: PObject,
    handler: TPropertyChangeHandler): guint{.cdecl, dynlib: lib,
    importc: "atk_object_connect_property_change_handler".}
proc remove_property_change_handler*(accessible: PObject,
    handler_id: guint){.cdecl, dynlib: lib,
                        importc: "atk_object_remove_property_change_handler".}
proc notify_state_change*(accessible: PObject, state: TState,
                                 value: gboolean){.cdecl, dynlib: lib,
    importc: "atk_object_notify_state_change".}
proc initialize*(accessible: PObject, data: gpointer){.cdecl,
    dynlib: lib, importc: "atk_object_initialize".}
proc role_get_name*(role: TRole): cstring{.cdecl, dynlib: lib,
    importc: "atk_role_get_name".}
proc role_for_name*(name: cstring): TRole{.cdecl, dynlib: lib,
    importc: "atk_role_for_name".}
