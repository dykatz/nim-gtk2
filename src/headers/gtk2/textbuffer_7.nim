# Included by headers/gtk2.nim; do not import directly.
proc check*(tree: PTextBTree){.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_check".}
proc spew*(tree: PTextBTree){.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_spew".}
