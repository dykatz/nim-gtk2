# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MESSAGE_DIALOG*(): GType
proc MESSAGE_DIALOG*(obj: pointer): PMessageDialog
proc MESSAGE_DIALOG_CLASS*(klass: pointer): PMessageDialogClass
proc IS_MESSAGE_DIALOG*(obj: pointer): bool
proc IS_MESSAGE_DIALOG_CLASS*(klass: pointer): bool
proc MESSAGE_DIALOG_GET_CLASS*(obj: pointer): PMessageDialogClass
proc message_dialog_get_type*(): TType{.cdecl, dynlib: lib,
                                        importc: "gtk_message_dialog_get_type".}
const
  bm_TGtkNotebook_show_tabs* = 0x0001'u16
const
  bp_TGtkNotebook_show_tabs* = 0'u16
const
  bm_TGtkNotebook_homogeneous* = 0x0002'u16
const
  bp_TGtkNotebook_homogeneous* = 1'u16
const
  bm_TGtkNotebook_show_border* = 0x0004'u16
const
  bp_TGtkNotebook_show_border* = 2'u16
const
  bm_TGtkNotebook_tab_pos* = 0x0018'u16
const
  bp_TGtkNotebook_tab_pos* = 3'u16
const
  bm_TGtkNotebook_scrollable* = 0x0020'u16
const
  bp_TGtkNotebook_scrollable* = 5'u16
const
  bm_TGtkNotebook_in_child* = 0x00C0'u16
const
  bp_TGtkNotebook_in_child* = 6'u16
const
  bm_TGtkNotebook_click_child* = 0x0300'u16
const
  bp_TGtkNotebook_click_child* = 8'u16
const
  bm_TGtkNotebook_button* = 0x0C00'u16
const
  bp_TGtkNotebook_button* = 10'u16
const
  bm_TGtkNotebook_need_timer* = 0x1000'u16
const
  bp_TGtkNotebook_need_timer* = 12'u16
const
  bm_TGtkNotebook_child_has_focus* = 0x2000'u16
const
  bp_TGtkNotebook_child_has_focus* = 13'u16
const
  bm_TGtkNotebook_have_visible_child* = 0x4000'u16
const
  bp_TGtkNotebook_have_visible_child* = 14'u16
const
  bm_TGtkNotebook_focus_out* = 0x8000'u16
const
  bp_TGtkNotebook_focus_out* = 15'u16

