# Included by headers/gtk2.nim; do not import directly.
proc line_count*(tree: PTextBTree): gint{.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_line_count".}
proc char_count*(tree: PTextBTree): gint{.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_char_count".}
