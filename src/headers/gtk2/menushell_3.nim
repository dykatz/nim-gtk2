# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MENU_SHELL*(): GType =
  result = menu_shell_get_type()

proc MENU_SHELL*(obj: pointer): PMenuShell =
  result = cast[PMenuShell](CHECK_CAST(obj, TYPE_MENU_SHELL()))

proc MENU_SHELL_CLASS*(klass: pointer): PMenuShellClass =
  result = cast[PMenuShellClass](CHECK_CLASS_CAST(klass, TYPE_MENU_SHELL()))

proc IS_MENU_SHELL*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_MENU_SHELL())

proc IS_MENU_SHELL_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_MENU_SHELL())

proc MENU_SHELL_GET_CLASS*(obj: pointer): PMenuShellClass =
  result = cast[PMenuShellClass](CHECK_GET_CLASS(obj, TYPE_MENU_SHELL()))

proc active*(a: PMenuShell): guint =
  result = (a.MenuShellflag0 and bm_TGtkMenuShell_active) shr
      bp_TGtkMenuShell_active

proc set_active*(a: PMenuShell, `active`: guint) =
  a.MenuShellflag0 = a.MenuShellflag0 or
      (uint16(`active` shl bp_TGtkMenuShell_active) and
      bm_TGtkMenuShell_active)

proc have_grab*(a: PMenuShell): guint =
  result = (a.MenuShellflag0 and bm_TGtkMenuShell_have_grab) shr
      bp_TGtkMenuShell_have_grab

proc set_have_grab*(a: PMenuShell, `have_grab`: guint) =
  a.MenuShellflag0 = a.MenuShellflag0 or
      (uint16(`have_grab` shl bp_TGtkMenuShell_have_grab) and
      bm_TGtkMenuShell_have_grab)

proc have_xgrab*(a: PMenuShell): guint =
  result = (a.MenuShellflag0 and bm_TGtkMenuShell_have_xgrab) shr
      bp_TGtkMenuShell_have_xgrab

proc set_have_xgrab*(a: PMenuShell, `have_xgrab`: guint) =
  a.MenuShellflag0 = a.MenuShellflag0 or
      (uint16(`have_xgrab` shl bp_TGtkMenuShell_have_xgrab) and
      bm_TGtkMenuShell_have_xgrab)

proc ignore_leave*(a: PMenuShell): guint =
  result = (a.MenuShellflag0 and bm_TGtkMenuShell_ignore_leave) shr
      bp_TGtkMenuShell_ignore_leave

proc set_ignore_leave*(a: PMenuShell, `ignore_leave`: guint) =
  a.MenuShellflag0 = a.MenuShellflag0 or
      (uint16(`ignore_leave` shl bp_TGtkMenuShell_ignore_leave) and
      bm_TGtkMenuShell_ignore_leave)

proc menu_flag*(a: PMenuShell): guint =
  result = (a.MenuShellflag0 and bm_TGtkMenuShell_menu_flag) shr
      bp_TGtkMenuShell_menu_flag

proc set_menu_flag*(a: PMenuShell, `menu_flag`: guint) =
  a.MenuShellflag0 = a.MenuShellflag0 or
      (uint16(`menu_flag` shl bp_TGtkMenuShell_menu_flag) and
      bm_TGtkMenuShell_menu_flag)

proc ignore_enter*(a: PMenuShell): guint =
  result = (a.MenuShellflag0 and bm_TGtkMenuShell_ignore_enter) shr
      bp_TGtkMenuShell_ignore_enter

proc set_ignore_enter*(a: PMenuShell, `ignore_enter`: guint) =
  a.MenuShellflag0 = a.MenuShellflag0 or
      (uint16(`ignore_enter` shl bp_TGtkMenuShell_ignore_enter) and
      bm_TGtkMenuShell_ignore_enter)

proc submenu_placement*(a: PMenuShellClass): guint =
  result = (a.MenuShellClassflag0 and bm_TGtkMenuShellClass_submenu_placement) shr
      bp_TGtkMenuShellClass_submenu_placement

proc set_submenu_placement*(a: PMenuShellClass, `submenu_placement`: guint) =
  a.MenuShellClassflag0 = a.MenuShellClassflag0 or
      (uint16(`submenu_placement` shl bp_TGtkMenuShellClass_submenu_placement) and
      bm_TGtkMenuShellClass_submenu_placement)

