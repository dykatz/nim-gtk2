# Included by headers/pango.nim; do not import directly.
proc GET_CLASS*(obj: PContext): PContextClass =
  result = cast[PContextClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_CONTEXT()))

proc TYPE_FONTSET*(): GType =
  result = fontset_get_type()

