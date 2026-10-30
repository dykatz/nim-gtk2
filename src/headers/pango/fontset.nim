# Included by headers/pango.nim; do not import directly.
proc FONTSET*(anObject: pointer): PFontset
proc IS_FONTSET*(anObject: pointer): bool
proc fontset_get_type*(): GType{.cdecl, dynlib: lib,
                                 importc: "pango_fontset_get_type".}
proc get_font*(fontset: PFontset, wc: guint): PFont{.cdecl, dynlib: lib,
    importc: "pango_fontset_get_font".}
proc get_metrics*(fontset: PFontset): PFontMetrics{.cdecl, dynlib: lib,
    importc: "pango_fontset_get_metrics".}
