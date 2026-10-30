# Included by headers/gtk2.nim; do not import directly.
proc TYPE_BIN*(): GType
proc BIN*(obj: pointer): PBin
proc BIN_CLASS*(klass: pointer): PBinClass
proc IS_BIN*(obj: pointer): bool
proc IS_BIN_CLASS*(klass: pointer): bool
proc BIN_GET_CLASS*(obj: pointer): PBinClass
proc bin_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_bin_get_type".}
proc get_child*(bin: PBin): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_bin_get_child".}
const
  bm_TGtkWindow_allow_shrink* = 0x00000001'u32
const
  bp_TGtkWindow_allow_shrink* = 0'u32
const
  bm_TGtkWindow_allow_grow* = 0x00000002'u32
const
  bp_TGtkWindow_allow_grow* = 1'u32
const
  bm_TGtkWindow_configure_notify_received* = 0x00000004'u32
const
  bp_TGtkWindow_configure_notify_received* = 2'u32
const
  bm_TGtkWindow_need_default_position* = 0x00000008'u32
const
  bp_TGtkWindow_need_default_position* = 3'u32
const
  bm_TGtkWindow_need_default_size* = 0x00000010'u32
const
  bp_TGtkWindow_need_default_size* = 4'u32
const
  bm_TGtkWindow_position* = 0x000000E0'u32
const
  bp_TGtkWindow_position* = 5'u32
const
  bm_TGtkWindow_type* = 0x00000F00'u32
const
  bp_TGtkWindow_type* = 8'u32
const
  bm_TGtkWindow_has_user_ref_count* = 0x00001000'u32
const
  bp_TGtkWindow_has_user_ref_count* = 12'u32
const
  bm_TGtkWindow_has_focus* = 0x00002000'u32
const
  bp_TGtkWindow_has_focus* = 13'u32
const
  bm_TGtkWindow_modal* = 0x00004000'u32
const
  bp_TGtkWindow_modal* = 14'u32
const
  bm_TGtkWindow_destroy_with_parent* = 0x00008000'u32
const
  bp_TGtkWindow_destroy_with_parent* = 15'u32
const
  bm_TGtkWindow_has_frame* = 0x00010000'u32
const
  bp_TGtkWindow_has_frame* = 16'u32
const
  bm_TGtkWindow_iconify_initially* = 0x00020000'u32
const
  bp_TGtkWindow_iconify_initially* = 17'u32
const
  bm_TGtkWindow_stick_initially* = 0x00040000'u32
const
  bp_TGtkWindow_stick_initially* = 18'u32
const
  bm_TGtkWindow_maximize_initially* = 0x00080000'u32
const
  bp_TGtkWindow_maximize_initially* = 19'u32
const
  bm_TGtkWindow_decorated* = 0x00100000'u32
const
  bp_TGtkWindow_decorated* = 20'u32
const
  bm_TGtkWindow_type_hint* = 0x00E00000'u32
const
  bp_TGtkWindow_type_hint* = 21'u32
const
  bm_TGtkWindow_gravity* = 0x1F000000'u32
const
  bp_TGtkWindow_gravity* = 24'u32

