# Included by headers/gtk2.nim; do not import directly.
proc get_insertion_cursor_gc*(widget: PWidget, is_primary: gboolean): gdk2.PGC{.
    cdecl, dynlib: lib, importc: "_gtk_get_insertion_cursor_gc".}
proc draw_insertion_cursor*(widget: PWidget, drawable: gdk2.PDrawable, gc: gdk2.PGC,
                            location: gdk2.PRectangle, direction: TTextDirection,
                            draw_arrow: gboolean){.cdecl, dynlib: lib,
    importc: "_gtk_draw_insertion_cursor".}
const
  bm_TGtkRange_inverted* = 0x0001'u16
const
  bp_TGtkRange_inverted* = 0'u16
const
  bm_TGtkRange_flippable* = 0x0002'u16
const
  bp_TGtkRange_flippable* = 1'u16
const
  bm_TGtkRange_has_stepper_a* = 0x0004'u16
const
  bp_TGtkRange_has_stepper_a* = 2'u16
const
  bm_TGtkRange_has_stepper_b* = 0x0008'u16
const
  bp_TGtkRange_has_stepper_b* = 3'u16
const
  bm_TGtkRange_has_stepper_c* = 0x0010'u16
const
  bp_TGtkRange_has_stepper_c* = 4'u16
const
  bm_TGtkRange_has_stepper_d* = 0x0020'u16
const
  bp_TGtkRange_has_stepper_d* = 5'u16
const
  bm_TGtkRange_need_recalc* = 0x0040'u16
const
  bp_TGtkRange_need_recalc* = 6'u16
const
  bm_TGtkRange_slider_size_fixed* = 0x0080'u16
const
  bp_TGtkRange_slider_size_fixed* = 7'u16
const
  bm_TGtkRange_trough_click_forward* = 0x0001'u16
const
  bp_TGtkRange_trough_click_forward* = 0'u16
const
  bm_TGtkRange_update_pending* = 0x0002'u16
const
  bp_TGtkRange_update_pending* = 1'u16

