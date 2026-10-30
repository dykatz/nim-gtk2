# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CHECK_BUTTON*(): GType
proc CHECK_BUTTON*(obj: pointer): PCheckButton
proc CHECK_BUTTON_CLASS*(klass: pointer): PCheckButtonClass
proc IS_CHECK_BUTTON*(obj: pointer): bool
proc IS_CHECK_BUTTON_CLASS*(klass: pointer): bool
proc CHECK_BUTTON_GET_CLASS*(obj: pointer): PCheckButtonClass
proc check_button_get_type*(): TType{.cdecl, dynlib: lib,
                                      importc: "gtk_check_button_get_type".}
proc check_button_new*(): PCheckButton{.cdecl, dynlib: lib,
                                        importc: "gtk_check_button_new".}
proc check_button_new*(`label`: cstring): PCheckButton{.cdecl,
    dynlib: lib, importc: "gtk_check_button_new_with_label".}
proc check_button_new_with_mnemonic*(`label`: cstring): PCheckButton{.cdecl,
    dynlib: lib, importc: "gtk_check_button_new_with_mnemonic".}
proc get_props*(check_button: PCheckButton, indicator_size: Pgint,
                             indicator_spacing: Pgint){.cdecl, dynlib: lib,
    importc: "_gtk_check_button_get_props".}
const
  bm_TGtkCheckMenuItem_active* = 0x0001'u16
const
  bp_TGtkCheckMenuItem_active* = 0'u16
const
  bm_TGtkCheckMenuItem_always_show_toggle* = 0x0002'u16
const
  bp_TGtkCheckMenuItem_always_show_toggle* = 1'u16
const
  bm_TGtkCheckMenuItem_inconsistent* = 0x0004'u16
const
  bp_TGtkCheckMenuItem_inconsistent* = 2'u16

