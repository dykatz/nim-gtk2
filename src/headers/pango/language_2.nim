# Included by headers/pango.nim; do not import directly.
proc matches*(language: PLanguage, range_list: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "pango_language_matches".}
