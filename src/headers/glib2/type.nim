# Included by headers/glib2.nim; do not import directly.
proc G_TYPE_CHECK_INSTANCE_CAST*(instance: pointer, g_type: GType): PGTypeInstance
proc G_TYPE_CHECK_INSTANCE_TYPE*(instance: pointer, g_type: GType): bool
proc G_TYPE_INSTANCE_GET_CLASS*(instance: pointer, g_type: GType): PGTypeClass
proc G_TYPE_INSTANCE_GET_INTERFACE*(instance: pointer, g_type: GType): pointer
proc G_TYPE_CHECK_CLASS_CAST*(g_class: pointer, g_type: GType): pointer
proc G_TYPE_CHECK_CLASS_TYPE*(g_class: pointer, g_type: GType): bool
proc G_TYPE_CHECK_VALUE*(value: pointer): bool
proc G_TYPE_CHECK_VALUE_TYPE*(value: pointer, g_type: GType): bool
proc G_TYPE_FROM_INSTANCE*(instance: pointer): GType {.gcsafe.}
proc G_TYPE_FROM_CLASS*(g_class: pointer): GType {.gcsafe.}
proc G_TYPE_FROM_INTERFACE*(g_iface: pointer): GType
