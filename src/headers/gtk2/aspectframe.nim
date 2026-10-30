# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ASPECT_FRAME*(): GType
proc ASPECT_FRAME*(obj: pointer): PAspectFrame
proc ASPECT_FRAME_CLASS*(klass: pointer): PAspectFrameClass
proc IS_ASPECT_FRAME*(obj: pointer): bool
proc IS_ASPECT_FRAME_CLASS*(klass: pointer): bool
proc ASPECT_FRAME_GET_CLASS*(obj: pointer): PAspectFrameClass
proc aspect_frame_get_type*(): TType{.cdecl, dynlib: lib,
                                      importc: "gtk_aspect_frame_get_type".}
proc aspect_frame_new*(`label`: cstring, xalign: gfloat, yalign: gfloat,
                       ratio: gfloat, obey_child: gboolean): PAspectFrame{.
    cdecl, dynlib: lib, importc: "gtk_aspect_frame_new".}
proc set*(aspect_frame: PAspectFrame, xalign: gfloat,
                       yalign: gfloat, ratio: gfloat, obey_child: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_aspect_frame_set".}
