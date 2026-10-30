# Included by headers/gtk2.nim; do not import directly.
proc bindings_activate_event*(anObject: PObject, event: gdk2.PEventKey): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_bindings_activate_event".}
proc binding_reset_parsed*(){.cdecl, dynlib: lib,
                              importc: "_gtk_binding_reset_parsed".}
const
  bm_TGtkBox_homogeneous* = 0x0001'u16
const
  bp_TGtkBox_homogeneous* = 0'u16
const
  bm_TGtkBoxChild_expand* = 0x0001'u16
const
  bp_TGtkBoxChild_expand* = 0'u16
const
  bm_TGtkBoxChild_fill* = 0x0002'u16
const
  bp_TGtkBoxChild_fill* = 1'u16
const
  bm_TGtkBoxChild_pack* = 0x0004'u16
const
  bp_TGtkBoxChild_pack* = 2'u16
const
  bm_TGtkBoxChild_is_secondary* = 0x0008'u16
const
  bp_TGtkBoxChild_is_secondary* = 3'u16

