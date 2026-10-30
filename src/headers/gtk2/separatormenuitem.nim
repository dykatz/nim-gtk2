# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SEPARATOR_MENU_ITEM*(): GType
proc SEPARATOR_MENU_ITEM*(obj: pointer): PSeparatorMenuItem
proc SEPARATOR_MENU_ITEM_CLASS*(klass: pointer): PSeparatorMenuItemClass
proc IS_SEPARATOR_MENU_ITEM*(obj: pointer): bool
proc IS_SEPARATOR_MENU_ITEM_CLASS*(klass: pointer): bool
proc SEPARATOR_MENU_ITEM_GET_CLASS*(obj: pointer): PSeparatorMenuItemClass
proc separator_menu_item_get_type*(): GType{.cdecl, dynlib: lib,
    importc: "gtk_separator_menu_item_get_type".}
proc separator_menu_item_new*(): PSeparatorMenuItem{.cdecl, dynlib: lib,
    importc: "gtk_separator_menu_item_new".}
const
  bm_TGtkSizeGroup_have_width* = 0x0001'u16
const
  bp_TGtkSizeGroup_have_width* = 0'u16
const
  bm_TGtkSizeGroup_have_height* = 0x0002'u16
const
  bp_TGtkSizeGroup_have_height* = 1'u16

