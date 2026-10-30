# Included by headers/atk.nim; do not import directly.
proc TYPE_STREAMABLE_CONTENT*(): GType =
  result = streamable_content_get_type()

proc IS_STREAMABLE_CONTENT*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_STREAMABLE_CONTENT())

proc STREAMABLE_CONTENT*(obj: pointer): PStreamableContent =
  result = cast[PStreamableContent](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_STREAMABLE_CONTENT()))

proc STREAMABLE_CONTENT_GET_IFACE*(obj: pointer): PStreamableContentIface =
  result = cast[PStreamableContentIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_STREAMABLE_CONTENT()))

