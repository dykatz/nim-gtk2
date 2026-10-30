# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MENU_ITEM*(): GType =
  result = menu_item_get_type()

proc MENU_ITEM*(obj: pointer): PMenuItem =
  result = cast[PMenuItem](CHECK_CAST(obj, TYPE_MENU_ITEM()))

proc MENU_ITEM_CLASS*(klass: pointer): PMenuItemClass =
  result = cast[PMenuItemClass](CHECK_CLASS_CAST(klass, TYPE_MENU_ITEM()))

proc IS_MENU_ITEM*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_MENU_ITEM())

proc IS_MENU_ITEM_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_MENU_ITEM())

proc MENU_ITEM_GET_CLASS*(obj: pointer): PMenuItemClass =
  result = cast[PMenuItemClass](CHECK_GET_CLASS(obj, TYPE_MENU_ITEM()))

proc show_submenu_indicator*(a: PMenuItem): guint =
  result = (a.MenuItemflag0 and bm_TGtkMenuItem_show_submenu_indicator) shr
      bp_TGtkMenuItem_show_submenu_indicator

proc set_show_submenu_indicator*(a: PMenuItem,
                                 `show_submenu_indicator`: guint) =
  a.MenuItemflag0 = a.MenuItemflag0 or
      (uint16(`show_submenu_indicator` shl
      bp_TGtkMenuItem_show_submenu_indicator) and
      bm_TGtkMenuItem_show_submenu_indicator)

proc submenu_placement*(a: PMenuItem): guint =
  result = (a.MenuItemflag0 and bm_TGtkMenuItem_submenu_placement) shr
      bp_TGtkMenuItem_submenu_placement

proc set_submenu_placement*(a: PMenuItem, `submenu_placement`: guint) =
  a.MenuItemflag0 = a.MenuItemflag0 or
      (uint16(`submenu_placement` shl bp_TGtkMenuItem_submenu_placement) and
      bm_TGtkMenuItem_submenu_placement)

proc submenu_direction*(a: PMenuItem): guint =
  result = (a.MenuItemflag0 and bm_TGtkMenuItem_submenu_direction) shr
      bp_TGtkMenuItem_submenu_direction

proc set_submenu_direction*(a: PMenuItem, `submenu_direction`: guint) =
  a.MenuItemflag0 = a.MenuItemflag0 or
      (uint16(`submenu_direction` shl bp_TGtkMenuItem_submenu_direction) and
      bm_TGtkMenuItem_submenu_direction)

proc right_justify*(a: PMenuItem): guint =
  result = (a.MenuItemflag0 and bm_TGtkMenuItem_right_justify) shr
      bp_TGtkMenuItem_right_justify

proc set_right_justify*(a: PMenuItem, `right_justify`: guint) =
  a.MenuItemflag0 = a.MenuItemflag0 or
      (uint16(`right_justify` shl bp_TGtkMenuItem_right_justify) and
      bm_TGtkMenuItem_right_justify)

proc timer_from_keypress*(a: PMenuItem): guint =
  result = (a.MenuItemflag0 and bm_TGtkMenuItem_timer_from_keypress) shr
      bp_TGtkMenuItem_timer_from_keypress

proc set_timer_from_keypress*(a: PMenuItem, `timer_from_keypress`: guint) =
  a.MenuItemflag0 = a.MenuItemflag0 or
      (uint16(`timer_from_keypress` shl bp_TGtkMenuItem_timer_from_keypress) and
      bm_TGtkMenuItem_timer_from_keypress)

proc hide_on_activate*(a: PMenuItemClass): guint =
  result = (a.MenuItemClassflag0 and bm_TGtkMenuItemClass_hide_on_activate) shr
      bp_TGtkMenuItemClass_hide_on_activate

proc set_hide_on_activate*(a: PMenuItemClass, `hide_on_activate`: guint) =
  a.MenuItemClassflag0 = a.MenuItemClassflag0 or
      (uint16(`hide_on_activate` shl bp_TGtkMenuItemClass_hide_on_activate) and
      bm_TGtkMenuItemClass_hide_on_activate)

proc right_justify*(menu_item: PMenuItem) =
  set_right_justified(menu_item, system.true)

