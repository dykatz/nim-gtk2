# Included by headers/atk.nim; do not import directly.
proc TYPE_HYPERLINK*(): GType =
  result = hyperlink_get_type()

proc HYPERLINK*(obj: pointer): PHyperlink =
  result = cast[PHyperlink](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_HYPERLINK()))

proc HYPERLINK_CLASS*(klass: pointer): PHyperlinkClass =
  result = cast[PHyperlinkClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_HYPERLINK()))

proc IS_HYPERLINK*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_HYPERLINK())

proc IS_HYPERLINK_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_HYPERLINK())

proc HYPERLINK_GET_CLASS*(obj: pointer): PHyperlinkClass =
  result = cast[PHyperlinkClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_HYPERLINK()))

