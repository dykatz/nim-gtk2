# Included by headers/atk.nim; do not import directly.
proc TYPE_VALUE*(): GType =
  result = value_get_type()

proc IS_VALUE*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_VALUE())

proc VALUE*(obj: pointer): PValue =
  result = cast[PValue](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_VALUE()))

proc VALUE_GET_IFACE*(obj: pointer): PValueIface =
  result = cast[PValueIface](G_TYPE_INSTANCE_GET_INTERFACE(obj, TYPE_VALUE()))

