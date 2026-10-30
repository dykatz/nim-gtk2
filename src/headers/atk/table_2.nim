# Included by headers/atk.nim; do not import directly.
proc TYPE_TABLE*(): GType =
  result = table_get_type()

proc IS_TABLE*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TABLE())

proc TABLE*(obj: pointer): PTable =
  result = cast[PTable](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_TABLE()))

proc TABLE_GET_IFACE*(obj: pointer): PTableIface =
  result = cast[PTableIface](G_TYPE_INSTANCE_GET_INTERFACE(obj, TYPE_TABLE()))

