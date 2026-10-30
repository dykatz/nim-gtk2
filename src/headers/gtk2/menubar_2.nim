# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MENU_BAR*(): GType =
  result = menu_bar_get_type()

proc MENU_BAR*(obj: pointer): PMenuBar =
  result = cast[PMenuBar](CHECK_CAST(obj, TYPE_MENU_BAR()))

proc MENU_BAR_CLASS*(klass: pointer): PMenuBarClass =
  result = cast[PMenuBarClass](CHECK_CLASS_CAST(klass, TYPE_MENU_BAR()))

proc IS_MENU_BAR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_MENU_BAR())

proc IS_MENU_BAR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_MENU_BAR())

proc MENU_BAR_GET_CLASS*(obj: pointer): PMenuBarClass =
  result = cast[PMenuBarClass](CHECK_GET_CLASS(obj, TYPE_MENU_BAR()))

