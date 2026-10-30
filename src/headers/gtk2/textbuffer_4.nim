# Included by headers/gtk2.nim; do not import directly.
proc get_line*(tree: PTextBTree, line_number: gint,
                          real_line_number: Pgint): PTextLine{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_line".}
proc get_line_no_last*(tree: PTextBTree, line_number: gint,
                                  real_line_number: Pgint): PTextLine{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_line_no_last".}
proc get_end_iter_line*(tree: PTextBTree): PTextLine{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_end_iter_line".}
proc get_line_at_char*(tree: PTextBTree, char_index: gint,
                                  line_start_index: Pgint,
                                  real_char_index: Pgint): PTextLine{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_line_at_char".}
