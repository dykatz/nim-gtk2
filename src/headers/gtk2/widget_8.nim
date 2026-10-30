# Included by headers/gtk2.nim; do not import directly.
proc menu_item_is_selectable*(menu_item: PWidget): gboolean{.cdecl, dynlib: lib,
    importc: "_gtk_menu_item_is_selectable".}
const
  bm_TGtkToggleButton_active* = 0x0001'u16
const
  bp_TGtkToggleButton_active* = 0'u16
const
  bm_TGtkToggleButton_draw_indicator* = 0x0002'u16
const
  bp_TGtkToggleButton_draw_indicator* = 1'u16
const
  bm_TGtkToggleButton_inconsistent* = 0x0004'u16
const
  bp_TGtkToggleButton_inconsistent* = 2'u16

