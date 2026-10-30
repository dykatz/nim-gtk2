# Included by headers/glib2.nim; do not import directly.
type
  TGTypePluginClass*{.final.} = object
    base_iface*: TGTypeInterface
    use_plugin*: TGTypePluginUse
    unuse_plugin*: TGTypePluginUnuse
    complete_type_info*: TGTypePluginCompleteTypeInfo
    complete_interface_info*: TGTypePluginCompleteInterfaceInfo


  PGTypePluginClass* = ptr TGTypePluginClass
