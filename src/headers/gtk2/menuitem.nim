# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MENU_ITEM*(): GType
proc MENU_ITEM*(obj: pointer): PMenuItem
proc MENU_ITEM_CLASS*(klass: pointer): PMenuItemClass
proc IS_MENU_ITEM*(obj: pointer): bool
proc IS_MENU_ITEM_CLASS*(klass: pointer): bool
proc MENU_ITEM_GET_CLASS*(obj: pointer): PMenuItemClass
proc show_submenu_indicator*(a: PMenuItem): guint
proc set_show_submenu_indicator*(a: PMenuItem,
                                 `show_submenu_indicator`: guint)
proc submenu_placement*(a: PMenuItem): guint
proc set_submenu_placement*(a: PMenuItem, `submenu_placement`: guint)
proc submenu_direction*(a: PMenuItem): guint
proc set_submenu_direction*(a: PMenuItem, `submenu_direction`: guint)
proc right_justify*(a: PMenuItem): guint
proc set_right_justify*(a: PMenuItem, `right_justify`: guint)
proc timer_from_keypress*(a: PMenuItem): guint
proc set_timer_from_keypress*(a: PMenuItem, `timer_from_keypress`: guint)
proc hide_on_activate*(a: PMenuItemClass): guint
proc set_hide_on_activate*(a: PMenuItemClass, `hide_on_activate`: guint)
proc menu_item_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_menu_item_get_type".}
proc menu_item_new*(): PMenuItem{.cdecl, dynlib: lib,
                                  importc: "gtk_menu_item_new".}
proc menu_item_new*(`label`: cstring): PMenuItem{.cdecl, dynlib: lib,
    importc: "gtk_menu_item_new_with_label".}
proc menu_item_new_with_mnemonic*(`label`: cstring): PMenuItem{.cdecl,
    dynlib: lib, importc: "gtk_menu_item_new_with_mnemonic".}
proc set_submenu*(menu_item: PMenuItem, submenu: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_menu_item_set_submenu".}
proc get_submenu*(menu_item: PMenuItem): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_menu_item_get_submenu".}
proc remove_submenu*(menu_item: PMenuItem){.cdecl, dynlib: lib,
    importc: "gtk_menu_item_remove_submenu".}
proc select*(menu_item: PMenuItem){.cdecl, dynlib: lib,
    importc: "gtk_menu_item_select".}
proc deselect*(menu_item: PMenuItem){.cdecl, dynlib: lib,
    importc: "gtk_menu_item_deselect".}
proc activate*(menu_item: PMenuItem){.cdecl, dynlib: lib,
    importc: "gtk_menu_item_activate".}
proc toggle_size_request*(menu_item: PMenuItem, requisition: Pgint){.
    cdecl, dynlib: lib, importc: "gtk_menu_item_toggle_size_request".}
proc toggle_size_allocate*(menu_item: PMenuItem, allocation: gint){.
    cdecl, dynlib: lib, importc: "gtk_menu_item_toggle_size_allocate".}
proc set_right_justified*(menu_item: PMenuItem,
                                    right_justified: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_menu_item_set_right_justified".}
proc get_right_justified*(menu_item: PMenuItem): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_menu_item_get_right_justified".}
proc set_accel_path*(menu_item: PMenuItem, accel_path: cstring){.
    cdecl, dynlib: lib, importc: "gtk_menu_item_set_accel_path".}
proc refresh_accel_path*(menu_item: PMenuItem, prefix: cstring,
                                   accel_group: PAccelGroup,
                                   group_changed: gboolean){.cdecl, dynlib: lib,
    importc: "_gtk_menu_item_refresh_accel_path".}
