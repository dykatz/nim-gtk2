# Included by headers/glib2.nim; do not import directly.
proc g_type_register_static*(parent_type: GType, type_name: cstring,
                             info: PGTypeInfo, flags: TGTypeFlags): GType{.
    cdecl, dynlib: gobjectlib, importc: "g_type_register_static".}
proc g_type_register_dynamic*(parent_type: GType, type_name: cstring,
                              plugin: PGTypePlugin, flags: TGTypeFlags): GType{.
    cdecl, dynlib: gobjectlib, importc: "g_type_register_dynamic".}
proc g_type_register_fundamental*(type_id: GType, type_name: cstring,
                                  info: PGTypeInfo,
                                  finfo: PGTypeFundamentalInfo,
                                  flags: TGTypeFlags): GType{.cdecl,
    dynlib: gobjectlib, importc: "g_type_register_fundamental".}
proc g_type_add_interface_static*(instance_type: GType, interface_type: GType,
                                  info: PGInterfaceInfo){.cdecl,
    dynlib: gobjectlib, importc: "g_type_add_interface_static".}
proc g_type_add_interface_dynamic*(instance_type: GType, interface_type: GType,
                                   plugin: PGTypePlugin){.cdecl,
    dynlib: gobjectlib, importc: "g_type_add_interface_dynamic".}
proc g_type_interface_add_prerequisite*(interface_type: GType,
                                        prerequisite_type: GType){.cdecl,
    dynlib: gobjectlib, importc: "g_type_interface_add_prerequisite".}
proc g_type_get_plugin*(theType: GType): PGTypePlugin{.cdecl,
    dynlib: gobjectlib, importc: "g_type_get_plugin".}
proc g_type_interface_get_plugin*(instance_type: GType,
                                  implementation_type: GType): PGTypePlugin{.
    cdecl, dynlib: gobjectlib, importc: "g_type_interface_get_plugin".}
proc g_type_fundamental_next*(): GType{.cdecl, dynlib: gobjectlib,
                                        importc: "g_type_fundamental_next".}
proc G_TYPE_FUNDAMENTAL*(type_id: GType): GType{.cdecl, dynlib: gobjectlib,
    importc: "g_type_fundamental".}
proc g_type_create_instance*(theType: GType): PGTypeInstance{.cdecl,
    dynlib: gobjectlib, importc: "g_type_create_instance".}
proc free_instance*(instance: PGTypeInstance){.cdecl, dynlib: gobjectlib,
    importc: "g_type_free_instance".}
proc g_type_add_class_cache_func*(cache_data: gpointer,
                                  cache_func: TGTypeClassCacheFunc){.cdecl,
    dynlib: gobjectlib, importc: "g_type_add_class_cache_func".}
proc g_type_remove_class_cache_func*(cache_data: gpointer,
                                     cache_func: TGTypeClassCacheFunc){.cdecl,
    dynlib: gobjectlib, importc: "g_type_remove_class_cache_func".}
proc g_type_class_unref_uncached*(g_class: gpointer){.cdecl, dynlib: gobjectlib,
    importc: "g_type_class_unref_uncached".}
proc g_type_value_table_peek*(theType: GType): PGTypeValueTable{.cdecl,
    dynlib: gobjectlib, importc: "g_type_value_table_peek".}
proc private_g_type_check_instance*(instance: PGTypeInstance): gboolean{.cdecl,
    dynlib: gobjectlib, importc: "g_type_check_instance".}
proc private_g_type_check_instance_cast*(instance: PGTypeInstance,
    iface_type: GType): PGTypeInstance{.cdecl, dynlib: gobjectlib,
                                        importc: "g_type_check_instance_cast".}
proc private_g_type_check_instance_is_a*(instance: PGTypeInstance,
    iface_type: GType): gboolean{.cdecl, dynlib: gobjectlib,
                                  importc: "g_type_check_instance_is_a".}
proc private_g_type_check_class_cast*(g_class: PGTypeClass, is_a_type: GType): PGTypeClass{.
    cdecl, dynlib: gobjectlib, importc: "g_type_check_class_cast".}
proc private_g_type_check_class_is_a*(g_class: PGTypeClass, is_a_type: GType): gboolean{.
    cdecl, dynlib: gobjectlib, importc: "g_type_check_class_is_a".}
proc private_g_type_check_is_value_type*(theType: GType): gboolean{.cdecl,
    dynlib: gobjectlib, importc: "g_type_check_is_value_type".}
proc private_g_type_check_value*(value: PGValue): gboolean{.cdecl,
    dynlib: gobjectlib, importc: "g_type_check_value".}
proc private_g_type_check_value_holds*(value: PGValue, theType: GType): gboolean{.
    cdecl, dynlib: gobjectlib, importc: "g_type_check_value_holds".}
proc private_g_type_test_flags*(theType: GType, flags: guint): gboolean{.cdecl,
    dynlib: gobjectlib, importc: "g_type_test_flags".}
proc name_from_instance*(instance: PGTypeInstance): cstring{.cdecl,
    dynlib: gobjectlib, importc: "g_type_name_from_instance".}
proc name_from_class*(g_class: PGTypeClass): cstring{.cdecl,
    dynlib: gobjectlib, importc: "g_type_name_from_class".}
const
  G_TYPE_FLAG_RESERVED_ID_BIT* = GType(1 shl 0)

proc G_TYPE_IS_VALUE*(theType: GType): bool
proc G_IS_VALUE*(value: pointer): bool
proc G_VALUE_TYPE*(value: pointer): GType
proc G_VALUE_TYPE_NAME*(value: pointer): cstring
proc G_VALUE_HOLDS*(value: pointer, g_type: GType): bool
