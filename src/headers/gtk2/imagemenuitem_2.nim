# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IMAGE_MENU_ITEM*(): GType =
  result = image_menu_item_get_type()

proc IMAGE_MENU_ITEM*(obj: pointer): PImageMenuItem =
  result = cast[PImageMenuItem](CHECK_CAST(obj, TYPE_IMAGE_MENU_ITEM()))

proc IMAGE_MENU_ITEM_CLASS*(klass: pointer): PImageMenuItemClass =
  result = cast[PImageMenuItemClass](CHECK_CLASS_CAST(klass,
      TYPE_IMAGE_MENU_ITEM()))

proc IS_IMAGE_MENU_ITEM*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_IMAGE_MENU_ITEM())

proc IS_IMAGE_MENU_ITEM_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_IMAGE_MENU_ITEM())

proc IMAGE_MENU_ITEM_GET_CLASS*(obj: pointer): PImageMenuItemClass =
  result = cast[PImageMenuItemClass](CHECK_GET_CLASS(obj, TYPE_IMAGE_MENU_ITEM()))

