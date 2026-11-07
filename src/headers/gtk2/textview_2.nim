# Included by headers/gtk2.nim; do not import directly.
# Public GType checks/casts only; no private TextView flag access.
proc TYPE_TEXT_VIEW*(): GType =
  result = text_view_get_type()

proc TEXT_VIEW*(obj: pointer): PTextView =
  result = cast[PTextView](CHECK_CAST(obj, TYPE_TEXT_VIEW()))

proc TEXT_VIEW_CLASS*(klass: pointer): PTextViewClass =
  result = cast[PTextViewClass](CHECK_CLASS_CAST(klass, TYPE_TEXT_VIEW()))

proc IS_TEXT_VIEW*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TEXT_VIEW())

proc IS_TEXT_VIEW_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TEXT_VIEW())

proc TEXT_VIEW_GET_CLASS*(obj: pointer): PTextViewClass =
  result = cast[PTextViewClass](CHECK_GET_CLASS(obj, TYPE_TEXT_VIEW()))
