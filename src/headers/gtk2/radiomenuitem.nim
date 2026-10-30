# Included by headers/gtk2.nim; do not import directly.
proc TYPE_RADIO_MENU_ITEM*(): GType
proc RADIO_MENU_ITEM*(obj: pointer): PRadioMenuItem
proc RADIO_MENU_ITEM_CLASS*(klass: pointer): PRadioMenuItemClass
proc IS_RADIO_MENU_ITEM*(obj: pointer): bool
proc IS_RADIO_MENU_ITEM_CLASS*(klass: pointer): bool
proc RADIO_MENU_ITEM_GET_CLASS*(obj: pointer): PRadioMenuItemClass
proc radio_menu_item_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_radio_menu_item_get_type".}
proc radio_menu_item_new*(group: PGSList): PRadioMenuItem{.cdecl, dynlib: lib,
    importc: "gtk_radio_menu_item_new".}
proc radio_menu_item_new*(group: PGSList, `label`: cstring): PRadioMenuItem{.
    cdecl, dynlib: lib, importc: "gtk_radio_menu_item_new_with_label".}
proc radio_menu_item_new_with_mnemonic*(group: PGSList, `label`: cstring): PRadioMenuItem{.
    cdecl, dynlib: lib, importc: "gtk_radio_menu_item_new_with_mnemonic".}
proc item_get_group*(radio_menu_item: PRadioMenuItem): PGSList{.
    cdecl, dynlib: lib, importc: "gtk_radio_menu_item_get_group".}
proc item_set_group*(radio_menu_item: PRadioMenuItem, group: PGSList){.
    cdecl, dynlib: lib, importc: "gtk_radio_menu_item_set_group".}
const
  bm_TGtkScrolledWindow_hscrollbar_policy* = 0x0003'u16
const
  bp_TGtkScrolledWindow_hscrollbar_policy* = 0'u16
const
  bm_TGtkScrolledWindow_vscrollbar_policy* = 0x000C'u16
const
  bp_TGtkScrolledWindow_vscrollbar_policy* = 2'u16
const
  bm_TGtkScrolledWindow_hscrollbar_visible* = 0x0010'u16
const
  bp_TGtkScrolledWindow_hscrollbar_visible* = 4'u16
const
  bm_TGtkScrolledWindow_vscrollbar_visible* = 0x0020'u16
const
  bp_TGtkScrolledWindow_vscrollbar_visible* = 5'u16
const
  bm_TGtkScrolledWindow_window_placement* = 0x00C0'u16
const
  bp_TGtkScrolledWindow_window_placement* = 6'u16
const
  bm_TGtkScrolledWindow_focus_out* = 0x0100'u16
const
  bp_TGtkScrolledWindow_focus_out* = 8'u16

