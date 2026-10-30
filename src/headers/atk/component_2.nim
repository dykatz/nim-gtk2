# Included by headers/atk.nim; do not import directly.
proc TYPE_COMPONENT*(): GType =
  result = component_get_type()

proc IS_COMPONENT*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_COMPONENT())

proc COMPONENT*(obj: pointer): PComponent =
  result = PComponent(G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_COMPONENT()))

proc COMPONENT_GET_IFACE*(obj: pointer): PComponentIface =
  result = cast[PComponentIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_COMPONENT()))

