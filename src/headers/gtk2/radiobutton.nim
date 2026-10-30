# Included by headers/gtk2.nim; do not import directly.
proc TYPE_RADIO_BUTTON*(): GType
proc RADIO_BUTTON*(obj: pointer): PRadioButton
proc RADIO_BUTTON_CLASS*(klass: pointer): PRadioButtonClass
proc IS_RADIO_BUTTON*(obj: pointer): bool
proc IS_RADIO_BUTTON_CLASS*(klass: pointer): bool
proc RADIO_BUTTON_GET_CLASS*(obj: pointer): PRadioButtonClass
proc radio_button_get_type*(): TType{.cdecl, dynlib: lib,
                                      importc: "gtk_radio_button_get_type".}
proc radio_button_new*(group: PGSList): PRadioButton{.cdecl, dynlib: lib,
    importc: "gtk_radio_button_new".}
proc new_from_widget*(group: PRadioButton): PRadioButton{.cdecl,
    dynlib: lib, importc: "gtk_radio_button_new_from_widget".}
proc radio_button_new*(group: PGSList, `label`: cstring): PRadioButton{.
    cdecl, dynlib: lib, importc: "gtk_radio_button_new_with_label".}
proc radio_button_new_with_label_from_widget*(group: PRadioButton,
    `label`: cstring): PRadioButton{.cdecl, dynlib: lib, importc: "gtk_radio_button_new_with_label_from_widget".}
proc radio_button_new_with_mnemonic*(group: PGSList, `label`: cstring): PRadioButton{.
    cdecl, dynlib: lib, importc: "gtk_radio_button_new_with_mnemonic".}
proc radio_button_new_with_mnemonic_from_widget*(group: PRadioButton,
    `label`: cstring): PRadioButton{.cdecl, dynlib: lib, importc: "gtk_radio_button_new_with_mnemonic_from_widget".}
proc get_group*(radio_button: PRadioButton): PGSList{.cdecl,
    dynlib: lib, importc: "gtk_radio_button_get_group".}
proc set_group*(radio_button: PRadioButton, group: PGSList){.cdecl,
    dynlib: lib, importc: "gtk_radio_button_set_group".}
