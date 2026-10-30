# Included by headers/gtk2.nim; do not import directly.
proc reference*(tree: PTextBTree){.cdecl, dynlib: lib,
                                   importc: "_gtk_text_btree_ref".}
proc unref*(tree: PTextBTree){.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_unref".}
proc get_buffer*(tree: PTextBTree): PTextBuffer{.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_get_buffer".}
proc get_chars_changed_stamp*(tree: PTextBTree): guint{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_chars_changed_stamp".}
proc get_segments_changed_stamp*(tree: PTextBTree): guint{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_segments_changed_stamp".}
proc segments_changed*(tree: PTextBTree){.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_segments_changed".}
proc is_end*(tree: PTextBTree, line: PTextLine,
                        seg: PTextLineSegment, byte_index: int32,
                        char_offset: int32): gboolean{.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_is_end".}
