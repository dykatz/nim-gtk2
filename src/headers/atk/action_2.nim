# Included by headers/atk.nim; do not import directly.
proc TYPE_ACTION*(): GType =
  result = action_get_type()

proc IS_ACTION*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_ACTION())

proc ACTION*(obj: pointer): PAction =
  result = PAction(G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_ACTION()))

proc ACTION_GET_IFACE*(obj: pointer): PActionIface =
  result = cast[PActionIface](G_TYPE_INSTANCE_GET_INTERFACE(obj, TYPE_ACTION()))

