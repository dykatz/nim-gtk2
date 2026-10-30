# Included by headers/glib2.nim; do not import directly.
proc G_TYPE_CHECK_INSTANCE_CAST*(instance: pointer, g_type: GType): PGTypeInstance =
  result = cast[PGTypeInstance](private_g_type_check_instance_cast(
      cast[PGTypeInstance](instance), g_type))

proc G_TYPE_CHECK_INSTANCE_TYPE*(instance: pointer, g_type: GType): bool =
  result = private_g_type_check_instance_is_a(cast[PGTypeInstance](instance),
      g_type)

proc G_TYPE_INSTANCE_GET_CLASS*(instance: pointer, g_type: GType): PGTypeClass =
  result = cast[PGTypeInstance](instance).g_class
  result = private_g_type_check_class_cast(result, g_type)

proc G_TYPE_INSTANCE_GET_INTERFACE*(instance: pointer, g_type: GType): pointer =
  result = g_type_interface_peek((cast[PGTypeInstance](instance)).g_class,
                                 g_type)

proc G_TYPE_CHECK_CLASS_CAST*(g_class: pointer, g_type: GType): pointer =
  result = private_g_type_check_class_cast(cast[PGTypeClass](g_class), g_type)

proc G_TYPE_CHECK_CLASS_TYPE*(g_class: pointer, g_type: GType): bool =
  result = private_g_type_check_class_is_a(cast[PGTypeClass](g_class), g_type)

proc G_TYPE_CHECK_VALUE*(value: pointer): bool =
  result = private_g_type_check_value(cast[PGValue](value))

proc G_TYPE_CHECK_VALUE_TYPE*(value: pointer, g_type: GType): bool =
  result = private_g_type_check_value_holds(cast[PGValue](value), g_type)

proc G_TYPE_FROM_INSTANCE*(instance: pointer): GType =
  result = G_TYPE_FROM_CLASS((cast[PGTypeInstance](instance)).g_class)

proc G_TYPE_FROM_CLASS*(g_class: pointer): GType =
  result = (cast[PGTypeClass](g_class)).g_type

proc G_TYPE_FROM_INTERFACE*(g_iface: pointer): GType =
  result = (cast[PGTypeInterface](g_iface)).g_type

proc G_TYPE_IS_VALUE*(theType: GType): bool =
  result = private_g_type_check_is_value_type(theType)

proc G_IS_VALUE*(value: pointer): bool =
  result = G_TYPE_CHECK_VALUE(value)

proc G_VALUE_TYPE*(value: pointer): GType =
  result = (cast[PGValue](value)).g_type

proc G_VALUE_TYPE_NAME*(value: pointer): cstring =
  result = g_type_name(G_VALUE_TYPE(value))

proc G_VALUE_HOLDS*(value: pointer, g_type: GType): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, g_type)

proc G_TYPE_IS_PARAM*(theType: GType): bool =
  result = (G_TYPE_FUNDAMENTAL(theType)) == G_TYPE_PARAM

