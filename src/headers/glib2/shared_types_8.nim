# Included by headers/glib2.nim; do not import directly.
type
  TGTypePluginUse* = proc (plugin: PGTypePlugin){.cdecl.}
  TGTypePluginUnuse* = proc (plugin: PGTypePlugin){.cdecl.}
  TGTypePluginCompleteTypeInfo* = proc (plugin: PGTypePlugin, g_type: GType,
                                        info: PGTypeInfo,
                                        value_table: PGTypeValueTable){.cdecl.}
  TGTypePluginCompleteInterfaceInfo* = proc (plugin: PGTypePlugin,
      instance_type: GType, interface_type: GType, info: PGInterfaceInfo){.cdecl.}
