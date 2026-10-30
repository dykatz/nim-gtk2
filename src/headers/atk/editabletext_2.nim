# Included by headers/atk.nim; do not import directly.
proc TYPE_EDITABLE_TEXT*(): GType =
  result = editable_text_get_type()

proc IS_EDITABLE_TEXT*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_EDITABLE_TEXT())

proc EDITABLE_TEXT*(obj: pointer): PEditableText =
  result = cast[PEditableText](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_EDITABLE_TEXT()))

proc EDITABLE_TEXT_GET_IFACE*(obj: pointer): PEditableTextIface =
  result = cast[PEditableTextIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_EDITABLE_TEXT()))

