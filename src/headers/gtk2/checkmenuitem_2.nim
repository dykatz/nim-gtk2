# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CHECK_MENU_ITEM*(): GType =
  result = check_menu_item_get_type()

proc CHECK_MENU_ITEM*(obj: pointer): PCheckMenuItem =
  result = cast[PCheckMenuItem](CHECK_CAST(obj, TYPE_CHECK_MENU_ITEM()))

proc CHECK_MENU_ITEM_CLASS*(klass: pointer): PCheckMenuItemClass =
  result = cast[PCheckMenuItemClass](CHECK_CLASS_CAST(klass,
      TYPE_CHECK_MENU_ITEM()))

proc IS_CHECK_MENU_ITEM*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_CHECK_MENU_ITEM())

proc IS_CHECK_MENU_ITEM_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_CHECK_MENU_ITEM())

proc CHECK_MENU_ITEM_GET_CLASS*(obj: pointer): PCheckMenuItemClass =
  result = cast[PCheckMenuItemClass](CHECK_GET_CLASS(obj, TYPE_CHECK_MENU_ITEM()))

proc active*(a: PCheckMenuItem): guint =
  result = (a.CheckMenuItemflag0 and bm_TGtkCheckMenuItem_active) shr
      bp_TGtkCheckMenuItem_active

proc set_active*(a: PCheckMenuItem, `active`: guint) =
  a.CheckMenuItemflag0 = a.CheckMenuItemflag0 or
      (uint16(`active` shl bp_TGtkCheckMenuItem_active) and
      bm_TGtkCheckMenuItem_active)

proc always_show_toggle*(a: PCheckMenuItem): guint =
  result = (a.CheckMenuItemflag0 and bm_TGtkCheckMenuItem_always_show_toggle) shr
      bp_TGtkCheckMenuItem_always_show_toggle

proc set_always_show_toggle*(a: PCheckMenuItem, `always_show_toggle`: guint) =
  a.CheckMenuItemflag0 = a.CheckMenuItemflag0 or
      (uint16(`always_show_toggle` shl bp_TGtkCheckMenuItem_always_show_toggle) and
      bm_TGtkCheckMenuItem_always_show_toggle)

proc inconsistent*(a: PCheckMenuItem): guint =
  result = (a.CheckMenuItemflag0 and bm_TGtkCheckMenuItem_inconsistent) shr
      bp_TGtkCheckMenuItem_inconsistent

proc set_inconsistent*(a: PCheckMenuItem, `inconsistent`: guint) =
  a.CheckMenuItemflag0 = a.CheckMenuItemflag0 or
      (uint16(`inconsistent` shl bp_TGtkCheckMenuItem_inconsistent) and
      bm_TGtkCheckMenuItem_inconsistent)

