# Included by headers/gtk2.nim; do not import directly.
proc button_box_child_requisition*(widget: PWidget, nvis_children: var int32,
                                   nvis_secondaries: var int32,
                                   width: var int32, height: var int32){.cdecl,
    dynlib: lib, importc: "_gtk_button_box_child_requisition".}
const
  bm_TGtkButton_constructed* = 0x0001'u16
const
  bp_TGtkButton_constructed* = 0'u16
const
  bm_TGtkButton_in_button* = 0x0002'u16
const
  bp_TGtkButton_in_button* = 1'u16
const
  bm_TGtkButton_button_down* = 0x0004'u16
const
  bp_TGtkButton_button_down* = 2'u16
const
  bm_TGtkButton_relief* = 0x0018'u16
const
  bp_TGtkButton_relief* = 3'u16
const
  bm_TGtkButton_use_underline* = 0x0020'u16
const
  bp_TGtkButton_use_underline* = 5'u16
const
  bm_TGtkButton_use_stock* = 0x0040'u16
const
  bp_TGtkButton_use_stock* = 6'u16
const
  bm_TGtkButton_depressed* = 0x0080'u16
const
  bp_TGtkButton_depressed* = 7'u16
const
  bm_TGtkButton_depress_on_activate* = 0x0100'u16
const
  bp_TGtkButton_depress_on_activate* = 8'u16

