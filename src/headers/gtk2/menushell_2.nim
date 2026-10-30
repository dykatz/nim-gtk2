# Included by headers/gtk2.nim; do not import directly.
proc deactivate*(menu_shell: PMenuShell){.cdecl, dynlib: lib,
    importc: "gtk_menu_shell_deactivate".}
proc select_item*(menu_shell: PMenuShell, menu_item: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_menu_shell_select_item".}
proc deselect*(menu_shell: PMenuShell){.cdecl, dynlib: lib,
    importc: "gtk_menu_shell_deselect".}
proc activate_item*(menu_shell: PMenuShell, menu_item: PWidget,
                               force_deactivate: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_menu_shell_activate_item".}
proc select_first*(menu_shell: PMenuShell){.cdecl, dynlib: lib,
    importc: "_gtk_menu_shell_select_first".}
proc activate*(menu_shell: PMenuShell){.cdecl, dynlib: lib,
    importc: "_gtk_menu_shell_activate".}
const
  bm_TGtkMenu_needs_destruction_ref_count* = 0x0001'u16
const
  bp_TGtkMenu_needs_destruction_ref_count* = 0'u16
const
  bm_TGtkMenu_torn_off* = 0x0002'u16
const
  bp_TGtkMenu_torn_off* = 1'u16
const
  bm_TGtkMenu_tearoff_active* = 0x0004'u16
const
  bp_TGtkMenu_tearoff_active* = 2'u16
const
  bm_TGtkMenu_scroll_fast* = 0x0008'u16
const
  bp_TGtkMenu_scroll_fast* = 3'u16
const
  bm_TGtkMenu_upper_arrow_visible* = 0x0010'u16
const
  bp_TGtkMenu_upper_arrow_visible* = 4'u16
const
  bm_TGtkMenu_lower_arrow_visible* = 0x0020'u16
const
  bp_TGtkMenu_lower_arrow_visible* = 5'u16
const
  bm_TGtkMenu_upper_arrow_prelight* = 0x0040'u16
const
  bp_TGtkMenu_upper_arrow_prelight* = 6'u16
const
  bm_TGtkMenu_lower_arrow_prelight* = 0x0080'u16
const
  bp_TGtkMenu_lower_arrow_prelight* = 7'u16

