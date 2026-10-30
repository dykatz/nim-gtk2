# Included by headers/gtk2.nim; do not import directly.
proc find_line_by_y*(tree: PTextBTree, view_id: gpointer,
                                ypixel: gint, line_top_y: Pgint): PTextLine{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_find_line_by_y".}
proc find_line_top*(tree: PTextBTree, line: PTextLine,
                               view_id: gpointer): gint{.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_find_line_top".}
proc add_view*(tree: PTextBTree, layout: PTextLayout){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_add_view".}
proc remove_view*(tree: PTextBTree, view_id: gpointer){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_remove_view".}
proc invalidate_region*(tree: PTextBTree, start: PTextIter,
                                   theEnd: PTextIter){.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_invalidate_region".}
proc get_view_size*(tree: PTextBTree, view_id: gpointer,
                               width: Pgint, height: Pgint){.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_get_view_size".}
proc is_valid*(tree: PTextBTree, view_id: gpointer): gboolean{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_is_valid".}
proc validate*(tree: PTextBTree, view_id: gpointer, max_pixels: gint,
                          y: Pgint, old_height: Pgint, new_height: Pgint): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_validate".}
proc validate_line*(tree: PTextBTree, line: PTextLine,
                               view_id: gpointer){.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_validate_line".}
