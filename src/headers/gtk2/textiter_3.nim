# Included by headers/gtk2.nim; do not import directly.
proc btree_delete*(start: PTextIter, theEnd: PTextIter){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_delete".}
proc btree_insert*(iter: PTextIter, text: cstring, len: gint){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_insert".}
proc btree_insert_pixbuf*(iter: PTextIter, pixbuf: gdk2pixbuf.PPixbuf){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_insert_pixbuf".}
proc btree_insert_child_anchor*(iter: PTextIter, anchor: PTextChildAnchor){.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_insert_child_anchor".}
