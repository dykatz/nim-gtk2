# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEAROFF_MENU_ITEM*(): GType
proc TEAROFF_MENU_ITEM*(obj: pointer): PTearoffMenuItem
proc TEAROFF_MENU_ITEM_CLASS*(klass: pointer): PTearoffMenuItemClass
proc IS_TEAROFF_MENU_ITEM*(obj: pointer): bool
proc IS_TEAROFF_MENU_ITEM_CLASS*(klass: pointer): bool
proc TEAROFF_MENU_ITEM_GET_CLASS*(obj: pointer): PTearoffMenuItemClass
proc torn_off*(a: PTearoffMenuItem): guint
proc set_torn_off*(a: PTearoffMenuItem, `torn_off`: guint)
proc tearoff_menu_item_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_tearoff_menu_item_get_type".}
proc tearoff_menu_item_new*(): PTearoffMenuItem{.cdecl, dynlib: lib,
    importc: "gtk_tearoff_menu_item_new".}
