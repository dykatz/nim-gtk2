# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CHECK_BUTTON*(): GType =
  result = check_button_get_type()

proc CHECK_BUTTON*(obj: pointer): PCheckButton =
  result = cast[PCheckButton](CHECK_CAST(obj, TYPE_CHECK_BUTTON()))

proc CHECK_BUTTON_CLASS*(klass: pointer): PCheckButtonClass =
  result = cast[PCheckButtonClass](CHECK_CLASS_CAST(klass, TYPE_CHECK_BUTTON()))

proc IS_CHECK_BUTTON*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_CHECK_BUTTON())

proc IS_CHECK_BUTTON_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_CHECK_BUTTON())

proc CHECK_BUTTON_GET_CLASS*(obj: pointer): PCheckButtonClass =
  result = cast[PCheckButtonClass](CHECK_GET_CLASS(obj, TYPE_CHECK_BUTTON()))

