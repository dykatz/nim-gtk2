# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEAROFF_MENU_ITEM*(): GType =
  result = tearoff_menu_item_get_type()

proc TEAROFF_MENU_ITEM*(obj: pointer): PTearoffMenuItem =
  result = cast[PTearoffMenuItem](CHECK_CAST(obj, TYPE_TEAROFF_MENU_ITEM()))

proc TEAROFF_MENU_ITEM_CLASS*(klass: pointer): PTearoffMenuItemClass =
  result = cast[PTearoffMenuItemClass](CHECK_CLASS_CAST(klass,
      TYPE_TEAROFF_MENU_ITEM()))

proc IS_TEAROFF_MENU_ITEM*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TEAROFF_MENU_ITEM())

proc IS_TEAROFF_MENU_ITEM_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TEAROFF_MENU_ITEM())

proc TEAROFF_MENU_ITEM_GET_CLASS*(obj: pointer): PTearoffMenuItemClass =
  result = cast[PTearoffMenuItemClass](CHECK_GET_CLASS(obj,
      TYPE_TEAROFF_MENU_ITEM()))

proc torn_off*(a: PTearoffMenuItem): guint =
  result = (a.TearoffMenuItemflag0 and bm_TGtkTearoffMenuItem_torn_off) shr
      bp_TGtkTearoffMenuItem_torn_off

proc set_torn_off*(a: PTearoffMenuItem, `torn_off`: guint) =
  a.TearoffMenuItemflag0 = a.TearoffMenuItemflag0 or
      (uint16(`torn_off` shl bp_TGtkTearoffMenuItem_torn_off) and
      bm_TGtkTearoffMenuItem_torn_off)

