# Included by headers/atk.nim; do not import directly.
proc TYPE_SELECTION*(): GType =
  result = selection_get_type()

proc IS_SELECTION*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_SELECTION())

proc SELECTION*(obj: pointer): PSelection =
  result = cast[PSelection](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_SELECTION()))

proc SELECTION_GET_IFACE*(obj: pointer): PSelectionIface =
  result = cast[PSelectionIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_SELECTION()))

