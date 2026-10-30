# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ARROW*(): GType
proc ARROW*(obj: pointer): PArrow
proc ARROW_CLASS*(klass: pointer): PArrowClass
proc IS_ARROW*(obj: pointer): bool
proc IS_ARROW_CLASS*(klass: pointer): bool
proc ARROW_GET_CLASS*(obj: pointer): PArrowClass
proc arrow_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_arrow_get_type".}
proc arrow_new*(arrow_type: TArrowType, shadow_type: TShadowType): PArrow{.
    cdecl, dynlib: lib, importc: "gtk_arrow_new".}
proc set*(arrow: PArrow, arrow_type: TArrowType, shadow_type: TShadowType){.
    cdecl, dynlib: lib, importc: "gtk_arrow_set".}
const
  bm_TGtkBindingSet_parsed* = 0x0001'u16
const
  bp_TGtkBindingSet_parsed* = 0'u16
const
  bm_TGtkBindingEntry_destroyed* = 0x0001'u16
const
  bp_TGtkBindingEntry_destroyed* = 0'u16
const
  bm_TGtkBindingEntry_in_emission* = 0x0002'u16
const
  bp_TGtkBindingEntry_in_emission* = 1'u16

