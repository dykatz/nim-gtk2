# Included by headers/gtk2.nim; do not import directly.
proc btree_unregister_child_anchor*(anchor: PTextChildAnchor){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_unregister_child_anchor".}
