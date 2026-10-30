# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MISC*(): GType
proc MISC*(obj: pointer): PMisc
proc MISC_CLASS*(klass: pointer): PMiscClass
proc IS_MISC*(obj: pointer): bool
proc IS_MISC_CLASS*(klass: pointer): bool
proc MISC_GET_CLASS*(obj: pointer): PMiscClass
proc misc_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_misc_get_type".}
proc set_alignment*(misc: PMisc, xalign: gfloat, yalign: gfloat){.cdecl,
    dynlib: lib, importc: "gtk_misc_set_alignment".}
proc get_alignment*(misc: PMisc, xalign, yalign: var Pgfloat){.cdecl,
    dynlib: lib, importc: "gtk_misc_get_alignment".}
proc set_padding*(misc: PMisc, xpad: gint, ypad: gint){.cdecl, dynlib: lib,
    importc: "gtk_misc_set_padding".}
proc get_padding*(misc: PMisc, xpad, ypad: var Pgint){.cdecl, dynlib: lib,
    importc: "gtk_misc_get_padding".}
