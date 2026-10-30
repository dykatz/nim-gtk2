# Included by headers/atk.nim; do not import directly.
proc TYPE_HYPERTEXT*(): GType =
  result = hypertext_get_type()

proc IS_HYPERTEXT*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_HYPERTEXT())

proc HYPERTEXT*(obj: pointer): PHypertext =
  result = cast[PHypertext](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_HYPERTEXT()))

proc HYPERTEXT_GET_IFACE*(obj: pointer): PHypertextIface =
  result = cast[PHypertextIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_HYPERTEXT()))

