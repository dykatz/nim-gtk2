# Included by headers/gtk2.nim; do not import directly.
proc HBUTTON_BOX*(obj: pointer): PHButtonBox
proc HBUTTON_BOX_CLASS*(klass: pointer): PHButtonBoxClass
proc IS_HBUTTON_BOX*(obj: pointer): bool
proc IS_HBUTTON_BOX_CLASS*(klass: pointer): bool
proc HBUTTON_BOX_GET_CLASS*(obj: pointer): PHButtonBoxClass
proc hbutton_box_get_type*(): TType{.cdecl, dynlib: lib,
                                     importc: "gtk_hbutton_box_get_type".}
proc hbutton_box_new*(): PHButtonBox{.cdecl, dynlib: lib,
                                      importc: "gtk_hbutton_box_new".}
