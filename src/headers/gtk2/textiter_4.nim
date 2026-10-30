# Included by headers/gtk2.nim; do not import directly.
proc btree_tag*(start: PTextIter, theEnd: PTextIter, tag: PTextTag,
                     apply: gboolean){.cdecl, dynlib: lib,
                                       importc: "_gtk_text_btree_tag".}
