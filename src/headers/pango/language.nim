# Included by headers/pango.nim; do not import directly.
proc language_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "pango_language_get_type".}
proc language_from_string*(language: cstring): PLanguage{.cdecl, dynlib: lib,
    importc: "pango_language_from_string".}
