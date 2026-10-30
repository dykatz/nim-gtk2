# Included by headers/gtk2.nim; do not import directly.
proc btree_get_tags*(iter: PTextIter, num_tags: Pgint): PPGtkTextTag{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_get_tags".}
proc btree_get_text*(start: PTextIter, theEnd: PTextIter,
                          include_hidden: gboolean, include_nonchars: gboolean): cstring{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_get_text".}
