# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SETTINGS*(): GType =
  result = settings_get_type()

proc SETTINGS*(obj: pointer): PSettings =
  result = cast[PSettings](CHECK_CAST(obj, TYPE_SETTINGS()))

proc SETTINGS_CLASS*(klass: pointer): PSettingsClass =
  result = cast[PSettingsClass](CHECK_CLASS_CAST(klass, TYPE_SETTINGS()))

proc IS_SETTINGS*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_SETTINGS())

proc IS_SETTINGS_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_SETTINGS())

proc SETTINGS_GET_CLASS*(obj: pointer): PSettingsClass =
  result = cast[PSettingsClass](CHECK_GET_CLASS(obj, TYPE_SETTINGS()))

proc TYPE_RC_STYLE*(): GType =
  result = rc_style_get_type()

