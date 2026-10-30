# Included by headers/gtk2.nim; do not import directly.
proc FONT_SELECTION*(obj: pointer): PFontSelection =
  result = cast[PFontSelection](CHECK_CAST(obj, TYPE_FONT_SELECTION()))

proc FONT_SELECTION_CLASS*(klass: pointer): PFontSelectionClass =
  result = cast[PFontSelectionClass](CHECK_CLASS_CAST(klass,
      TYPE_FONT_SELECTION()))

proc IS_FONT_SELECTION*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_FONT_SELECTION())

proc IS_FONT_SELECTION_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_FONT_SELECTION())

proc FONT_SELECTION_GET_CLASS*(obj: pointer): PFontSelectionClass =
  result = cast[PFontSelectionClass](CHECK_GET_CLASS(obj, TYPE_FONT_SELECTION()))

proc TYPE_FONT_SELECTION_DIALOG*(): GType =
  result = font_selection_dialog_get_type()

proc FONT_SELECTION_DIALOG*(obj: pointer): PFontSelectionDialog =
  result = cast[PFontSelectionDialog](CHECK_CAST(obj,
      TYPE_FONT_SELECTION_DIALOG()))

proc FONT_SELECTION_DIALOG_CLASS*(klass: pointer): PFontSelectionDialogClass =
  result = cast[PFontSelectionDialogClass](CHECK_CLASS_CAST(klass,
      TYPE_FONT_SELECTION_DIALOG()))

proc IS_FONT_SELECTION_DIALOG*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_FONT_SELECTION_DIALOG())

proc IS_FONT_SELECTION_DIALOG_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_FONT_SELECTION_DIALOG())

proc FONT_SELECTION_DIALOG_GET_CLASS*(obj: pointer): PFontSelectionDialogClass =
  result = cast[PFontSelectionDialogClass](CHECK_GET_CLASS(obj,
      TYPE_FONT_SELECTION_DIALOG()))

