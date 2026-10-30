# Included by headers/gtk2.nim; do not import directly.
proc VBUTTON_BOX*(obj: pointer): PVButtonBox
proc VBUTTON_BOX_CLASS*(klass: pointer): PVButtonBoxClass
proc IS_VBUTTON_BOX*(obj: pointer): bool
proc IS_VBUTTON_BOX_CLASS*(klass: pointer): bool
proc VBUTTON_BOX_GET_CLASS*(obj: pointer): PVButtonBoxClass
proc vbutton_box_get_type*(): TType{.cdecl, dynlib: lib,
                                     importc: "gtk_vbutton_box_get_type".}
proc vbutton_box_new*(): PVButtonBox{.cdecl, dynlib: lib,
                                      importc: "gtk_vbutton_box_new".}
