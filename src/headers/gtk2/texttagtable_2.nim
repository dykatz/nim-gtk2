# Included by headers/gtk2.nim; do not import directly.
proc btree_new*(table: PTextTagTable, buffer: PTextBuffer): PTextBTree{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_new".}
