# Included by headers/pango.nim; do not import directly.
proc context_get_type*(): GType{.cdecl, dynlib: lib,
                                 importc: "pango_context_get_type".}
proc list_families*(context: PContext,
                            families: openarray[ptr PFontFamily]){.cdecl,
    dynlib: lib, importc: "pango_context_list_families".}
proc load_font*(context: PContext, desc: PFontDescription): PFont{.
    cdecl, dynlib: lib, importc: "pango_context_load_font".}
proc load_fontset*(context: PContext, desc: PFontDescription,
                           language: PLanguage): PFontset{.cdecl, dynlib: lib,
    importc: "pango_context_load_fontset".}
proc get_metrics*(context: PContext, desc: PFontDescription,
                          language: PLanguage): PFontMetrics{.cdecl,
    dynlib: lib, importc: "pango_context_get_metrics".}
proc set_font_description*(context: PContext, desc: PFontDescription){.
    cdecl, dynlib: lib, importc: "pango_context_set_font_description".}
proc get_font_description*(context: PContext): PFontDescription{.cdecl,
    dynlib: lib, importc: "pango_context_get_font_description".}
proc get_language*(context: PContext): PLanguage{.cdecl, dynlib: lib,
    importc: "pango_context_get_language".}
proc set_language*(context: PContext, language: PLanguage){.cdecl,
    dynlib: lib, importc: "pango_context_set_language".}
proc set_base_dir*(context: PContext, direction: TDirection){.cdecl,
    dynlib: lib, importc: "pango_context_set_base_dir".}
proc get_base_dir*(context: PContext): TDirection{.cdecl, dynlib: lib,
    importc: "pango_context_get_base_dir".}
