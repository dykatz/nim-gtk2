# Included by headers/gtk2.nim; do not import directly.
proc TYPE_BOX*(): GType
proc BOX*(obj: pointer): PBox
proc BOX_CLASS*(klass: pointer): PBoxClass
proc IS_BOX*(obj: pointer): bool
proc IS_BOX_CLASS*(klass: pointer): bool
proc BOX_GET_CLASS*(obj: pointer): PBoxClass
proc homogeneous*(a: PBox): guint
proc set_homogeneous*(a: PBox, `homogeneous`: guint)
proc expand*(a: PBoxChild): guint
proc set_expand*(a: PBoxChild, `expand`: guint)
proc fill*(a: PBoxChild): guint
proc set_fill*(a: PBoxChild, `fill`: guint)
proc pack*(a: PBoxChild): guint
proc set_pack*(a: PBoxChild, `pack`: guint)
proc is_secondary*(a: PBoxChild): guint
proc set_is_secondary*(a: PBoxChild, `is_secondary`: guint)
proc box_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_box_get_type".}
proc pack_start*(box: PBox, child: PWidget, expand: gboolean,
                     fill: gboolean, padding: guint){.cdecl, dynlib: lib,
    importc: "gtk_box_pack_start".}
proc pack_end*(box: PBox, child: PWidget, expand: gboolean, fill: gboolean,
                   padding: guint){.cdecl, dynlib: lib,
                                    importc: "gtk_box_pack_end".}
proc pack_start_defaults*(box: PBox, widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_box_pack_start_defaults".}
proc pack_end_defaults*(box: PBox, widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_box_pack_end_defaults".}
proc set_homogeneous*(box: PBox, homogeneous: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_box_set_homogeneous".}
proc get_homogeneous*(box: PBox): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_box_get_homogeneous".}
