# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VSEPARATOR*(): GType =
  result = vseparator_get_type()

proc VSEPARATOR*(obj: pointer): PVSeparator =
  result = cast[PVSeparator](CHECK_CAST(obj, TYPE_VSEPARATOR()))

proc VSEPARATOR_CLASS*(klass: pointer): PVSeparatorClass =
  result = cast[PVSeparatorClass](CHECK_CLASS_CAST(klass, TYPE_VSEPARATOR()))

proc IS_VSEPARATOR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_VSEPARATOR())

proc IS_VSEPARATOR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_VSEPARATOR())

proc VSEPARATOR_GET_CLASS*(obj: pointer): PVSeparatorClass =
  # these were missing:
  result = cast[PVSeparatorClass](CHECK_GET_CLASS(obj, TYPE_VSEPARATOR()))

