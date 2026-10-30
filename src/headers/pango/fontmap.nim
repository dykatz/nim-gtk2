# Included by headers/pango.nim; do not import directly.
proc FONT_MAP*(anObject: pointer): PFontMap
proc IS_FONT_MAP*(anObject: pointer): bool
proc font_map_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "pango_font_map_get_type".}
proc load_font*(fontmap: PFontMap, context: PContext,
                         desc: PFontDescription): PFont{.cdecl, dynlib: lib,
    importc: "pango_font_map_load_font".}
proc load_fontset*(fontmap: PFontMap, context: PContext,
                            desc: PFontDescription, language: PLanguage): PFontset{.
    cdecl, dynlib: lib, importc: "pango_font_map_load_fontset".}
proc list_families*(fontmap: PFontMap,
                             families: var openarray[ptr PFontFamily]){.cdecl,
    dynlib: lib, importc: "pango_font_map_list_families".}
const
  bm_TPangoGlyphVisAttr_is_cluster_start* = 0x0001'u16
const
  bp_TPangoGlyphVisAttr_is_cluster_start* = 0'u16

