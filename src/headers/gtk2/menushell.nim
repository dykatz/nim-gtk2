# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MENU_SHELL*(): GType
proc MENU_SHELL*(obj: pointer): PMenuShell
proc MENU_SHELL_CLASS*(klass: pointer): PMenuShellClass
proc IS_MENU_SHELL*(obj: pointer): bool
proc IS_MENU_SHELL_CLASS*(klass: pointer): bool
proc MENU_SHELL_GET_CLASS*(obj: pointer): PMenuShellClass
proc active*(a: PMenuShell): guint
proc set_active*(a: PMenuShell, `active`: guint)
proc have_grab*(a: PMenuShell): guint
proc set_have_grab*(a: PMenuShell, `have_grab`: guint)
proc have_xgrab*(a: PMenuShell): guint
proc set_have_xgrab*(a: PMenuShell, `have_xgrab`: guint)
proc ignore_leave*(a: PMenuShell): guint
proc set_ignore_leave*(a: PMenuShell, `ignore_leave`: guint)
proc menu_flag*(a: PMenuShell): guint
proc set_menu_flag*(a: PMenuShell, `menu_flag`: guint)
proc ignore_enter*(a: PMenuShell): guint
proc set_ignore_enter*(a: PMenuShell, `ignore_enter`: guint)
proc submenu_placement*(a: PMenuShellClass): guint
proc set_submenu_placement*(a: PMenuShellClass, `submenu_placement`: guint)
proc menu_shell_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_menu_shell_get_type".}
