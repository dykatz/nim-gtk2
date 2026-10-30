# Included by headers/gtk2.nim; do not import directly.
proc get_iter_at_char*(tree: PTextBTree, iter: PTextIter,
                                  char_index: gint){.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_get_iter_at_char".}
proc get_iter_at_line_char*(tree: PTextBTree, iter: PTextIter,
                                       line_number: gint, char_index: gint){.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_get_iter_at_line_char".}
proc get_iter_at_line_byte*(tree: PTextBTree, iter: PTextIter,
                                       line_number: gint, byte_index: gint){.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_get_iter_at_line_byte".}
proc get_iter_from_string*(tree: PTextBTree, iter: PTextIter,
                                      `string`: cstring): gboolean{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_iter_from_string".}
proc get_iter_at_mark_name*(tree: PTextBTree, iter: PTextIter,
                                       mark_name: cstring): gboolean{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_iter_at_mark_name".}
proc get_iter_at_mark*(tree: PTextBTree, iter: PTextIter,
                                  mark: PTextMark){.cdecl, dynlib: lib,
    importc: "_gtk_text_btree_get_iter_at_mark".}
proc get_end_iter*(tree: PTextBTree, iter: PTextIter){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_end_iter".}
proc get_iter_at_line*(tree: PTextBTree, iter: PTextIter,
                                  line: PTextLine, byte_offset: gint){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_iter_at_line".}
proc get_iter_at_first_toggle*(tree: PTextBTree, iter: PTextIter,
    tag: PTextTag): gboolean{.cdecl, dynlib: lib, importc: "_gtk_text_btree_get_iter_at_first_toggle".}
proc get_iter_at_last_toggle*(tree: PTextBTree, iter: PTextIter,
    tag: PTextTag): gboolean{.cdecl, dynlib: lib, importc: "_gtk_text_btree_get_iter_at_last_toggle".}
proc get_iter_at_child_anchor*(tree: PTextBTree, iter: PTextIter,
    anchor: PTextChildAnchor){.cdecl, dynlib: lib, importc: "_gtk_text_btree_get_iter_at_child_anchor".}
proc set_mark*(tree: PTextBTree, existing_mark: PTextMark,
                          name: cstring, left_gravity: gboolean,
                          index: PTextIter, should_exist: gboolean): PTextMark{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_set_mark".}
proc remove_mark_by_name*(tree: PTextBTree, name: cstring){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_remove_mark_by_name".}
proc remove_mark*(tree: PTextBTree, segment: PTextMark){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_remove_mark".}
proc get_selection_bounds*(tree: PTextBTree, start: PTextIter,
                                      theEnd: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_get_selection_bounds".}
proc place_cursor*(tree: PTextBTree, `where`: PTextIter){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_place_cursor".}
proc mark_is_insert*(tree: PTextBTree, segment: PTextMark): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_mark_is_insert".}
proc mark_is_selection_bound*(tree: PTextBTree, segment: PTextMark): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_mark_is_selection_bound".}
proc get_mark_by_name*(tree: PTextBTree, name: cstring): PTextMark{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_get_mark_by_name".}
proc first_could_contain_tag*(tree: PTextBTree, tag: PTextTag): PTextLine{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_first_could_contain_tag".}
proc last_could_contain_tag*(tree: PTextBTree, tag: PTextTag): PTextLine{.
    cdecl, dynlib: lib, importc: "_gtk_text_btree_last_could_contain_tag".}
const
  bm_TGtkTextLineData_width* = 0x00FFFFFF'u32
const
  bp_TGtkTextLineData_width* = 0'u32
const
  bm_TGtkTextLineData_valid* = 0xFF000000'u32
const
  bp_TGtkTextLineData_valid* = 24'u32

