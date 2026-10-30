# Included by headers/gtk2.nim; do not import directly.
proc COLOR_SELECTION*(obj: pointer): PColorSelection =
  result = cast[PColorSelection](CHECK_CAST(obj, TYPE_COLOR_SELECTION()))

proc COLOR_SELECTION_CLASS*(klass: pointer): PColorSelectionClass =
  result = cast[PColorSelectionClass](CHECK_CLASS_CAST(klass,
      TYPE_COLOR_SELECTION()))

proc IS_COLOR_SELECTION*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_COLOR_SELECTION())

proc IS_COLOR_SELECTION_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_COLOR_SELECTION())

proc COLOR_SELECTION_GET_CLASS*(obj: pointer): PColorSelectionClass =
  result = cast[PColorSelectionClass](CHECK_GET_CLASS(obj,
      TYPE_COLOR_SELECTION()))

proc TYPE_COLOR_SELECTION_DIALOG*(): GType =
  result = color_selection_dialog_get_type()

