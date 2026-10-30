# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CHECK_MENU_ITEM*(): GType
proc CHECK_MENU_ITEM*(obj: pointer): PCheckMenuItem
proc CHECK_MENU_ITEM_CLASS*(klass: pointer): PCheckMenuItemClass
proc IS_CHECK_MENU_ITEM*(obj: pointer): bool
proc IS_CHECK_MENU_ITEM_CLASS*(klass: pointer): bool
proc CHECK_MENU_ITEM_GET_CLASS*(obj: pointer): PCheckMenuItemClass
proc active*(a: PCheckMenuItem): guint
proc set_active*(a: PCheckMenuItem, `active`: guint)
proc always_show_toggle*(a: PCheckMenuItem): guint
proc set_always_show_toggle*(a: PCheckMenuItem, `always_show_toggle`: guint)
proc inconsistent*(a: PCheckMenuItem): guint
proc set_inconsistent*(a: PCheckMenuItem, `inconsistent`: guint)
proc check_menu_item_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_check_menu_item_get_type".}
proc check_menu_item_new*(): PCheckMenuItem{.cdecl, dynlib: lib,
                                      importc: "gtk_check_menu_item_new".}
proc check_menu_item_new*(`label`: cstring): PCheckMenuItem{.cdecl,
    dynlib: lib, importc: "gtk_check_menu_item_new_with_label".}
proc check_menu_item_new_with_mnemonic*(`label`: cstring): PCheckMenuItem{.cdecl,
    dynlib: lib, importc: "gtk_check_menu_item_new_with_mnemonic".}
proc item_set_active*(check_menu_item: PCheckMenuItem,
                                 is_active: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_check_menu_item_set_active".}
proc item_get_active*(check_menu_item: PCheckMenuItem): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_check_menu_item_get_active".}
proc item_toggled*(check_menu_item: PCheckMenuItem){.cdecl,
    dynlib: lib, importc: "gtk_check_menu_item_toggled".}
proc item_set_inconsistent*(check_menu_item: PCheckMenuItem,
                                       setting: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_check_menu_item_set_inconsistent".}
proc item_get_inconsistent*(check_menu_item: PCheckMenuItem): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_check_menu_item_get_inconsistent".}
