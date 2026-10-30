# Included by headers/gtk2.nim; do not import directly.
proc COLOR_SELECTION_DIALOG*(obj: pointer): PColorSelectionDialog =
  result = cast[PColorSelectionDialog](CHECK_CAST(obj,
      TYPE_COLOR_SELECTION_DIALOG()))

proc COLOR_SELECTION_DIALOG_CLASS*(klass: pointer): PColorSelectionDialogClass =
  result = cast[PColorSelectionDialogClass](CHECK_CLASS_CAST(klass,
      TYPE_COLOR_SELECTION_DIALOG()))

proc IS_COLOR_SELECTION_DIALOG*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_COLOR_SELECTION_DIALOG())

proc IS_COLOR_SELECTION_DIALOG_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_COLOR_SELECTION_DIALOG())

proc COLOR_SELECTION_DIALOG_GET_CLASS*(obj: pointer): PColorSelectionDialogClass =
  result = cast[PColorSelectionDialogClass](CHECK_GET_CLASS(obj,
      TYPE_COLOR_SELECTION_DIALOG()))

