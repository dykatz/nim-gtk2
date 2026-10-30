# Included by headers/glib2.nim; do not import directly.
proc G_TYPE_PLUGIN_CLASS*(vtable: pointer): PGTypePluginClass
proc G_IS_TYPE_PLUGIN*(inst: pointer): bool
proc G_IS_TYPE_PLUGIN_CLASS*(vtable: pointer): bool
proc G_TYPE_PLUGIN_GET_CLASS*(inst: pointer): PGTypePluginClass
proc g_type_plugin_get_type*(): GType{.cdecl, dynlib: gliblib,
                                       importc: "g_type_plugin_get_type".}
proc plugin_use*(plugin: PGTypePlugin){.cdecl, dynlib: gliblib,
    importc: "g_type_plugin_use".}
proc plugin_unuse*(plugin: PGTypePlugin){.cdecl, dynlib: gliblib,
    importc: "g_type_plugin_unuse".}
proc plugin_complete_type_info*(plugin: PGTypePlugin, g_type: GType,
                                       info: PGTypeInfo,
                                       value_table: PGTypeValueTable){.cdecl,
    dynlib: gliblib, importc: "g_type_plugin_complete_type_info".}
proc plugin_complete_interface_info*(plugin: PGTypePlugin,
    instance_type: GType, interface_type: GType, info: PGInterfaceInfo){.cdecl,
    dynlib: gliblib, importc: "g_type_plugin_complete_interface_info".}
