# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ITEM*(): GType
proc ITEM*(obj: pointer): PItem
proc ITEM_CLASS*(klass: pointer): PItemClass
proc IS_ITEM*(obj: pointer): bool
proc IS_ITEM_CLASS*(klass: pointer): bool
proc ITEM_GET_CLASS*(obj: pointer): PItemClass
proc item_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_item_get_type".}
proc select*(item: PItem){.cdecl, dynlib: lib, importc: "gtk_item_select".}
proc deselect*(item: PItem){.cdecl, dynlib: lib,
                                  importc: "gtk_item_deselect".}
proc toggle*(item: PItem){.cdecl, dynlib: lib, importc: "gtk_item_toggle".}
const
  bm_TGtkMenuItem_show_submenu_indicator* = 0x0001'u16
const
  bp_TGtkMenuItem_show_submenu_indicator* = 0'u16
const
  bm_TGtkMenuItem_submenu_placement* = 0x0002'u16
const
  bp_TGtkMenuItem_submenu_placement* = 1'u16
const
  bm_TGtkMenuItem_submenu_direction* = 0x0004'u16
const
  bp_TGtkMenuItem_submenu_direction* = 2'u16
const
  bm_TGtkMenuItem_right_justify* = 0x0008'u16
const
  bp_TGtkMenuItem_right_justify* = 3'u16
const
  bm_TGtkMenuItem_timer_from_keypress* = 0x0010'u16
const
  bp_TGtkMenuItem_timer_from_keypress* = 4'u16
const
  bm_TGtkMenuItemClass_hide_on_activate* = 0x0001'u16
const
  bp_TGtkMenuItemClass_hide_on_activate* = 0'u16

