# Included by headers/gtk2.nim; do not import directly.
proc btree_char_is_invisible*(iter: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_char_is_invisible".}
