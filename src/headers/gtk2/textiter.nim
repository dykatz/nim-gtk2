# Included by headers/gtk2.nim; do not import directly.
const
  TEXT_SEARCH_VISIBLE_ONLY* = 0
const
  TEXT_SEARCH_TEXT_ONLY* = 1

proc TYPE_TEXT_ITER*(): GType
proc get_buffer*(iter: PTextIter): PTextBuffer{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_buffer".}
proc copy*(iter: PTextIter): PTextIter{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_copy".}
proc free*(iter: PTextIter){.cdecl, dynlib: lib,
                                       importc: "gtk_text_iter_free".}
proc text_iter_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "gtk_text_iter_get_type".}
proc get_offset*(iter: PTextIter): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_offset".}
proc get_line*(iter: PTextIter): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_line".}
proc get_line_offset*(iter: PTextIter): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_line_offset".}
proc get_line_index*(iter: PTextIter): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_line_index".}
proc get_visible_line_offset*(iter: PTextIter): gint{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_get_visible_line_offset".}
proc get_visible_line_index*(iter: PTextIter): gint{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_get_visible_line_index".}
proc get_char*(iter: PTextIter): gunichar{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_char".}
proc get_slice*(start: PTextIter, theEnd: PTextIter): cstring{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_get_slice".}
proc get_text*(start: PTextIter, theEnd: PTextIter): cstring{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_get_text".}
proc get_visible_slice*(start: PTextIter, theEnd: PTextIter): cstring{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_get_visible_slice".}
proc get_visible_text*(start: PTextIter, theEnd: PTextIter): cstring{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_get_visible_text".}
proc get_pixbuf*(iter: PTextIter): gdk2pixbuf.PPixbuf{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_pixbuf".}
proc get_marks*(iter: PTextIter): PGSList{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_marks".}
proc get_child_anchor*(iter: PTextIter): PTextChildAnchor{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_get_child_anchor".}
proc get_toggled_tags*(iter: PTextIter, toggled_on: gboolean): PGSList{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_get_toggled_tags".}
proc begins_tag*(iter: PTextIter, tag: PTextTag): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_begins_tag".}
proc ends_tag*(iter: PTextIter, tag: PTextTag): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_ends_tag".}
proc toggles_tag*(iter: PTextIter, tag: PTextTag): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_toggles_tag".}
proc has_tag*(iter: PTextIter, tag: PTextTag): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_has_tag".}
proc get_tags*(iter: PTextIter): PGSList{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_tags".}
proc editable*(iter: PTextIter, default_setting: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_editable".}
proc can_insert*(iter: PTextIter, default_editability: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_can_insert".}
proc starts_word*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_starts_word".}
proc ends_word*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_ends_word".}
proc inside_word*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_inside_word".}
proc starts_sentence*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_starts_sentence".}
proc ends_sentence*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_ends_sentence".}
proc inside_sentence*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_inside_sentence".}
proc starts_line*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_starts_line".}
proc ends_line*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_ends_line".}
proc is_cursor_position*(iter: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_is_cursor_position".}
proc get_chars_in_line*(iter: PTextIter): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_chars_in_line".}
proc get_bytes_in_line*(iter: PTextIter): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_get_bytes_in_line".}
proc get_attributes*(iter: PTextIter, values: PTextAttributes): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_get_attributes".}
proc get_language*(iter: PTextIter): pango.PLanguage{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_get_language".}
proc is_end*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_is_end".}
proc is_start*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_is_start".}
proc forward_char*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_forward_char".}
proc backward_char*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_backward_char".}
proc forward_chars*(iter: PTextIter, count: gint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_forward_chars".}
proc backward_chars*(iter: PTextIter, count: gint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_backward_chars".}
proc forward_line*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_forward_line".}
proc backward_line*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_backward_line".}
proc forward_lines*(iter: PTextIter, count: gint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_forward_lines".}
proc backward_lines*(iter: PTextIter, count: gint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_backward_lines".}
proc forward_word_end*(iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_iter_forward_word_end".}
proc backward_word_start*(iter: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_backward_word_start".}
proc forward_word_ends*(iter: PTextIter, count: gint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_forward_word_ends".}
proc backward_word_starts*(iter: PTextIter, count: gint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_backward_word_starts".}
proc forward_sentence_end*(iter: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_forward_sentence_end".}
proc backward_sentence_start*(iter: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_backward_sentence_start".}
proc forward_sentence_ends*(iter: PTextIter, count: gint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_forward_sentence_ends".}
proc backward_sentence_starts*(iter: PTextIter, count: gint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_backward_sentence_starts".}
proc forward_cursor_position*(iter: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_forward_cursor_position".}
proc backward_cursor_position*(iter: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_backward_cursor_position".}
proc forward_cursor_positions*(iter: PTextIter, count: gint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_forward_cursor_positions".}
proc backward_cursor_positions*(iter: PTextIter, count: gint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_backward_cursor_positions".}
proc set_offset*(iter: PTextIter, char_offset: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_iter_set_offset".}
proc set_line*(iter: PTextIter, line_number: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_iter_set_line".}
proc set_line_offset*(iter: PTextIter, char_on_line: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_iter_set_line_offset".}
proc set_line_index*(iter: PTextIter, byte_on_line: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_iter_set_line_index".}
proc forward_to_end*(iter: PTextIter){.cdecl, dynlib: lib,
    importc: "gtk_text_iter_forward_to_end".}
proc forward_to_line_end*(iter: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_forward_to_line_end".}
proc set_visible_line_offset*(iter: PTextIter, char_on_line: gint){.
    cdecl, dynlib: lib, importc: "gtk_text_iter_set_visible_line_offset".}
proc set_visible_line_index*(iter: PTextIter, byte_on_line: gint){.
    cdecl, dynlib: lib, importc: "gtk_text_iter_set_visible_line_index".}
proc forward_to_tag_toggle*(iter: PTextIter, tag: PTextTag): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_forward_to_tag_toggle".}
proc backward_to_tag_toggle*(iter: PTextIter, tag: PTextTag): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_backward_to_tag_toggle".}
proc forward_find_char*(iter: PTextIter, pred: TTextCharPredicate,
                                  user_data: gpointer, limit: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_forward_find_char".}
proc backward_find_char*(iter: PTextIter, pred: TTextCharPredicate,
                                   user_data: gpointer, limit: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_backward_find_char".}
proc forward_search*(iter: PTextIter, str: cstring,
                               flags: TTextSearchFlags, match_start: PTextIter,
                               match_end: PTextIter, limit: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_forward_search".}
proc backward_search*(iter: PTextIter, str: cstring,
                                flags: TTextSearchFlags, match_start: PTextIter,
                                match_end: PTextIter, limit: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_backward_search".}
proc equal*(lhs: PTextIter, rhs: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_equal".}
proc compare*(lhs: PTextIter, rhs: PTextIter): gint{.cdecl,
    dynlib: lib, importc: "gtk_text_iter_compare".}
proc in_range*(iter: PTextIter, start: PTextIter, theEnd: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_iter_in_range".}
proc order*(first: PTextIter, second: PTextIter){.cdecl, dynlib: lib,
    importc: "gtk_text_iter_order".}
