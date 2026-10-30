# Included by headers/gtk2.nim; do not import directly.
proc TYPE_FRAME*(): GType
proc FRAME*(obj: pointer): PFrame
proc FRAME_CLASS*(klass: pointer): PFrameClass
proc IS_FRAME*(obj: pointer): bool
proc IS_FRAME_CLASS*(klass: pointer): bool
proc FRAME_GET_CLASS*(obj: pointer): PFrameClass
proc frame_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_frame_get_type".}
proc frame_new*(`label`: cstring): PFrame{.cdecl, dynlib: lib,
    importc: "gtk_frame_new".}
proc set_label*(frame: PFrame, `label`: cstring){.cdecl, dynlib: lib,
    importc: "gtk_frame_set_label".}
proc get_label*(frame: PFrame): cstring{.cdecl, dynlib: lib,
    importc: "gtk_frame_get_label".}
proc set_label_widget*(frame: PFrame, label_widget: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_frame_set_label_widget".}
proc get_label_widget*(frame: PFrame): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_frame_get_label_widget".}
proc set_label_align*(frame: PFrame, xalign: gfloat, yalign: gfloat){.
    cdecl, dynlib: lib, importc: "gtk_frame_set_label_align".}
proc get_label_align*(frame: PFrame, xalign: Pgfloat, yalign: Pgfloat){.
    cdecl, dynlib: lib, importc: "gtk_frame_get_label_align".}
proc set_shadow_type*(frame: PFrame, thetype: TShadowType){.cdecl,
    dynlib: lib, importc: "gtk_frame_set_shadow_type".}
proc get_shadow_type*(frame: PFrame): TShadowType{.cdecl, dynlib: lib,
    importc: "gtk_frame_get_shadow_type".}
