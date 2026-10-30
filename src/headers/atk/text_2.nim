# Included by headers/atk.nim; do not import directly.
proc TYPE_TEXT*(): GType =
  result = text_get_type()

proc IS_TEXT*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TEXT())

proc TEXT*(obj: pointer): PText =
  result = cast[PText](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_TEXT()))

proc TEXT_GET_IFACE*(obj: pointer): PTextIface =
  result = cast[PTextIface](G_TYPE_INSTANCE_GET_INTERFACE(obj, TYPE_TEXT()))

