# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VBOX*(): GType =
  result = vbox_get_type()

proc VBOX*(obj: pointer): PVBox =
  result = cast[PVBox](CHECK_CAST(obj, TYPE_VBOX()))

proc VBOX_CLASS*(klass: pointer): PVBoxClass =
  result = cast[PVBoxClass](CHECK_CLASS_CAST(klass, TYPE_VBOX()))

proc IS_VBOX*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_VBOX())

proc IS_VBOX_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_VBOX())

proc VBOX_GET_CLASS*(obj: pointer): PVBoxClass =
  result = cast[PVBoxClass](CHECK_GET_CLASS(obj, TYPE_VBOX()))

proc TYPE_COLOR_SELECTION*(): GType =
  result = color_selection_get_type()

