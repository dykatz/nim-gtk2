# Included by headers/gtk2.nim; do not import directly.
proc TYPE_DIALOG*(): GType =
  result = dialog_get_type()

proc DIALOG*(obj: pointer): PDialog =
  result = cast[PDialog](CHECK_CAST(obj, TYPE_DIALOG()))

proc DIALOG_CLASS*(klass: pointer): PDialogClass =
  result = cast[PDialogClass](CHECK_CLASS_CAST(klass, TYPE_DIALOG()))

proc IS_DIALOG*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_DIALOG())

proc IS_DIALOG_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_DIALOG())

proc DIALOG_GET_CLASS*(obj: pointer): PDialogClass =
  result = cast[PDialogClass](CHECK_GET_CLASS(obj, TYPE_DIALOG()))

