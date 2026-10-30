# Included by headers/gtk2.nim; do not import directly.
proc VBUTTON_BOX*(obj: pointer): PVButtonBox =
  result = cast[PVButtonBox](CHECK_CAST(obj, TYPE_VBUTTON_BOX()))

proc VBUTTON_BOX_CLASS*(klass: pointer): PVButtonBoxClass =
  result = cast[PVButtonBoxClass](CHECK_CLASS_CAST(klass, TYPE_VBUTTON_BOX()))

proc IS_VBUTTON_BOX*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_VBUTTON_BOX())

proc IS_VBUTTON_BOX_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_VBUTTON_BOX())

proc VBUTTON_BOX_GET_CLASS*(obj: pointer): PVButtonBoxClass =
  result = cast[PVButtonBoxClass](CHECK_GET_CLASS(obj, TYPE_VBUTTON_BOX()))

