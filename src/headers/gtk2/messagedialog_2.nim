# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MESSAGE_DIALOG*(): GType =
  result = message_dialog_get_type()

proc MESSAGE_DIALOG*(obj: pointer): PMessageDialog =
  result = cast[PMessageDialog](CHECK_CAST(obj, TYPE_MESSAGE_DIALOG()))

proc MESSAGE_DIALOG_CLASS*(klass: pointer): PMessageDialogClass =
  result = cast[PMessageDialogClass](CHECK_CLASS_CAST(klass,
      TYPE_MESSAGE_DIALOG()))

proc IS_MESSAGE_DIALOG*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_MESSAGE_DIALOG())

proc IS_MESSAGE_DIALOG_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_MESSAGE_DIALOG())

proc MESSAGE_DIALOG_GET_CLASS*(obj: pointer): PMessageDialogClass =
  result = cast[PMessageDialogClass](CHECK_GET_CLASS(obj, TYPE_MESSAGE_DIALOG()))

