# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ALIGNMENT*(): GType
proc ALIGNMENT*(obj: pointer): PAlignment
proc ALIGNMENT_CLASS*(klass: pointer): PAlignmentClass
proc IS_ALIGNMENT*(obj: pointer): bool
proc IS_ALIGNMENT_CLASS*(klass: pointer): bool
proc ALIGNMENT_GET_CLASS*(obj: pointer): PAlignmentClass
proc alignment_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_alignment_get_type".}
proc alignment_new*(xalign: gfloat, yalign: gfloat, xscale: gfloat,
                    yscale: gfloat): PAlignment{.cdecl, dynlib: lib,
    importc: "gtk_alignment_new".}
proc set*(alignment: PAlignment, xalign: gfloat, yalign: gfloat,
                    xscale: gfloat, yscale: gfloat){.cdecl, dynlib: lib,
    importc: "gtk_alignment_set".}
