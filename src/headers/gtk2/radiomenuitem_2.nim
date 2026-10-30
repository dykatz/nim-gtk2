# Included by headers/gtk2.nim; do not import directly.
proc TYPE_RADIO_MENU_ITEM*(): GType =
  result = radio_menu_item_get_type()

proc RADIO_MENU_ITEM*(obj: pointer): PRadioMenuItem =
  result = cast[PRadioMenuItem](CHECK_CAST(obj, TYPE_RADIO_MENU_ITEM()))

proc RADIO_MENU_ITEM_CLASS*(klass: pointer): PRadioMenuItemClass =
  result = cast[PRadioMenuItemClass](CHECK_CLASS_CAST(klass,
      TYPE_RADIO_MENU_ITEM()))

proc IS_RADIO_MENU_ITEM*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_RADIO_MENU_ITEM())

proc IS_RADIO_MENU_ITEM_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_RADIO_MENU_ITEM())

proc RADIO_MENU_ITEM_GET_CLASS*(obj: pointer): PRadioMenuItemClass =
  result = cast[PRadioMenuItemClass](CHECK_GET_CLASS(obj, TYPE_RADIO_MENU_ITEM()))

