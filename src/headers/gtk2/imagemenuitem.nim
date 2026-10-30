# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IMAGE_MENU_ITEM*(): GType
proc IMAGE_MENU_ITEM*(obj: pointer): PImageMenuItem
proc IMAGE_MENU_ITEM_CLASS*(klass: pointer): PImageMenuItemClass
proc IS_IMAGE_MENU_ITEM*(obj: pointer): bool
proc IS_IMAGE_MENU_ITEM_CLASS*(klass: pointer): bool
proc IMAGE_MENU_ITEM_GET_CLASS*(obj: pointer): PImageMenuItemClass
proc image_menu_item_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_image_menu_item_get_type".}
proc image_menu_item_new*(): PImageMenuItem{.cdecl, dynlib: lib,
    importc: "gtk_image_menu_item_new".}
proc image_menu_item_new*(`label`: cstring): PImageMenuItem{.cdecl,
    dynlib: lib, importc: "gtk_image_menu_item_new_with_label".}
proc image_menu_item_new_with_mnemonic*(`label`: cstring): PImageMenuItem{.
    cdecl, dynlib: lib, importc: "gtk_image_menu_item_new_with_mnemonic".}
proc image_menu_item_new_from_stock*(stock_id: cstring, accel_group: PAccelGroup): PImageMenuItem{.
    cdecl, dynlib: lib, importc: "gtk_image_menu_item_new_from_stock".}
proc item_set_image*(image_menu_item: PImageMenuItem, image: PWidget){.
    cdecl, dynlib: lib, importc: "gtk_image_menu_item_set_image".}
proc item_get_image*(image_menu_item: PImageMenuItem): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_image_menu_item_get_image".}
const
  bm_TGtkIMContextSimple_in_hex_sequence* = 0x0001'u16
const
  bp_TGtkIMContextSimple_in_hex_sequence* = 0'u16

