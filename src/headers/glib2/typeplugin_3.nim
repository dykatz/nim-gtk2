# Included by headers/glib2.nim; do not import directly.
proc G_TYPE_PLUGIN_CLASS*(vtable: pointer): PGTypePluginClass =
  result = cast[PGTypePluginClass](G_TYPE_CHECK_CLASS_CAST(vtable,
      G_TYPE_TYPE_PLUGIN()))

proc G_IS_TYPE_PLUGIN*(inst: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(inst, G_TYPE_TYPE_PLUGIN())

proc G_IS_TYPE_PLUGIN_CLASS*(vtable: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(vtable, G_TYPE_TYPE_PLUGIN())

proc G_TYPE_PLUGIN_GET_CLASS*(inst: pointer): PGTypePluginClass =
  result = cast[PGTypePluginClass](G_TYPE_INSTANCE_GET_INTERFACE(inst,
      G_TYPE_TYPE_PLUGIN()))

proc G_TYPE_IS_ENUM*(theType: GType): gboolean =
  result = (G_TYPE_FUNDAMENTAL(theType) == G_TYPE_ENUM)

