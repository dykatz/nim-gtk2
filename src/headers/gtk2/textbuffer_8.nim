# Included by headers/gtk2.nim; do not import directly.
proc release_mark_segment*(tree: PTextBTree,
                                      segment: PTextLineSegment){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_release_mark_segment".}
proc notify_will_remove_tag*(tree: PTextBTree, tag: PTextTag){.cdecl,
    dynlib: lib, importc: "_gtk_text_btree_notify_will_remove_tag".}
const
  bm_TGtkTextBuffer_modified* = 0x0001'u16
const
  bp_TGtkTextBuffer_modified* = 0'u16

proc TYPE_TEXT_BUFFER*(): GType
proc TEXT_BUFFER*(obj: pointer): PTextBuffer
proc TEXT_BUFFER_CLASS*(klass: pointer): PTextBufferClass
proc IS_TEXT_BUFFER*(obj: pointer): bool
proc IS_TEXT_BUFFER_CLASS*(klass: pointer): bool
proc TEXT_BUFFER_GET_CLASS*(obj: pointer): PTextBufferClass
proc modified*(a: PTextBuffer): guint
proc set_modified*(a: PTextBuffer, `modified`: guint)
proc text_buffer_get_type*(): GType{.cdecl, dynlib: lib,
                                     importc: "gtk_text_buffer_get_type".}
proc text_buffer_new*(table: PTextTagTable): PTextBuffer{.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_new".}
proc get_line_count*(buffer: PTextBuffer): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_get_line_count".}
proc get_char_count*(buffer: PTextBuffer): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_get_char_count".}
proc get_tag_table*(buffer: PTextBuffer): PTextTagTable{.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_get_tag_table".}
proc set_text*(buffer: PTextBuffer, text: cstring, len: gint){.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_set_text".}
proc insert*(buffer: PTextBuffer, iter: PTextIter, text: cstring,
                         len: gint){.cdecl, dynlib: lib,
                                     importc: "gtk_text_buffer_insert".}
proc insert_at_cursor*(buffer: PTextBuffer, text: cstring, len: gint){.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_insert_at_cursor".}
proc insert_interactive*(buffer: PTextBuffer, iter: PTextIter,
                                     text: cstring, len: gint,
                                     default_editable: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_insert_interactive".}
proc insert_interactive_at_cursor*(buffer: PTextBuffer,
    text: cstring, len: gint, default_editable: gboolean): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_insert_interactive_at_cursor".}
proc insert_range*(buffer: PTextBuffer, iter: PTextIter,
                               start: PTextIter, theEnd: PTextIter){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_insert_range".}
proc insert_range_interactive*(buffer: PTextBuffer, iter: PTextIter,
    start: PTextIter, theEnd: PTextIter, default_editable: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_insert_range_interactive".}
proc delete*(buffer: PTextBuffer, start: PTextIter,
                         theEnd: PTextIter){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_delete".}
proc delete_interactive*(buffer: PTextBuffer, start_iter: PTextIter,
                                     end_iter: PTextIter,
                                     default_editable: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_delete_interactive".}
proc get_text*(buffer: PTextBuffer, start: PTextIter,
                           theEnd: PTextIter, include_hidden_chars: gboolean): cstring{.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_get_text".}
proc get_slice*(buffer: PTextBuffer, start: PTextIter,
                            theEnd: PTextIter, include_hidden_chars: gboolean): cstring{.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_get_slice".}
proc insert_pixbuf*(buffer: PTextBuffer, iter: PTextIter,
                                pixbuf: gdk2pixbuf.PPixbuf){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_insert_pixbuf".}
proc insert_child_anchor*(buffer: PTextBuffer, iter: PTextIter,
                                      anchor: PTextChildAnchor){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_insert_child_anchor".}
proc create_child_anchor*(buffer: PTextBuffer, iter: PTextIter): PTextChildAnchor{.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_create_child_anchor".}
proc create_mark*(buffer: PTextBuffer, mark_name: cstring,
                              `where`: PTextIter, left_gravity: gboolean): PTextMark{.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_create_mark".}
proc move_mark*(buffer: PTextBuffer, mark: PTextMark,
                            `where`: PTextIter){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_move_mark".}
proc delete_mark*(buffer: PTextBuffer, mark: PTextMark){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_delete_mark".}
proc get_mark*(buffer: PTextBuffer, name: cstring): PTextMark{.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_get_mark".}
proc move_mark_by_name*(buffer: PTextBuffer, name: cstring,
                                    `where`: PTextIter){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_move_mark_by_name".}
proc delete_mark_by_name*(buffer: PTextBuffer, name: cstring){.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_delete_mark_by_name".}
proc get_insert*(buffer: PTextBuffer): PTextMark{.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_get_insert".}
proc get_selection_bound*(buffer: PTextBuffer): PTextMark{.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_get_selection_bound".}
proc place_cursor*(buffer: PTextBuffer, `where`: PTextIter){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_place_cursor".}
proc apply_tag*(buffer: PTextBuffer, tag: PTextTag,
                            start: PTextIter, theEnd: PTextIter){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_apply_tag".}
proc remove_tag*(buffer: PTextBuffer, tag: PTextTag,
                             start: PTextIter, theEnd: PTextIter){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_remove_tag".}
proc apply_tag_by_name*(buffer: PTextBuffer, name: cstring,
                                    start: PTextIter, theEnd: PTextIter){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_apply_tag_by_name".}
proc remove_tag_by_name*(buffer: PTextBuffer, name: cstring,
                                     start: PTextIter, theEnd: PTextIter){.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_remove_tag_by_name".}
proc remove_all_tags*(buffer: PTextBuffer, start: PTextIter,
                                  theEnd: PTextIter){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_remove_all_tags".}
proc get_iter_at_line_offset*(buffer: PTextBuffer, iter: PTextIter,
    line_number: gint, char_offset: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_get_iter_at_line_offset".}
proc get_iter_at_line_index*(buffer: PTextBuffer, iter: PTextIter,
    line_number: gint, byte_index: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_get_iter_at_line_index".}
proc get_iter_at_offset*(buffer: PTextBuffer, iter: PTextIter,
                                     char_offset: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_get_iter_at_offset".}
proc get_iter_at_line*(buffer: PTextBuffer, iter: PTextIter,
                                   line_number: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_get_iter_at_line".}
proc get_start_iter*(buffer: PTextBuffer, iter: PTextIter){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_get_start_iter".}
proc get_end_iter*(buffer: PTextBuffer, iter: PTextIter){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_get_end_iter".}
proc get_bounds*(buffer: PTextBuffer, start: PTextIter,
                             theEnd: PTextIter){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_get_bounds".}
proc get_iter_at_mark*(buffer: PTextBuffer, iter: PTextIter,
                                   mark: PTextMark){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_get_iter_at_mark".}
proc get_iter_at_child_anchor*(buffer: PTextBuffer, iter: PTextIter,
    anchor: PTextChildAnchor){.cdecl, dynlib: lib, importc: "gtk_text_buffer_get_iter_at_child_anchor".}
proc get_modified*(buffer: PTextBuffer): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_get_modified".}
proc set_modified*(buffer: PTextBuffer, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_set_modified".}
proc add_selection_clipboard*(buffer: PTextBuffer,
    clipboard: PClipboard){.cdecl, dynlib: lib,
                            importc: "gtk_text_buffer_add_selection_clipboard".}
proc remove_selection_clipboard*(buffer: PTextBuffer,
    clipboard: PClipboard){.cdecl, dynlib: lib, importc: "gtk_text_buffer_remove_selection_clipboard".}
proc cut_clipboard*(buffer: PTextBuffer, clipboard: PClipboard,
                                default_editable: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_cut_clipboard".}
proc copy_clipboard*(buffer: PTextBuffer, clipboard: PClipboard){.
    cdecl, dynlib: lib, importc: "gtk_text_buffer_copy_clipboard".}
proc paste_clipboard*(buffer: PTextBuffer, clipboard: PClipboard,
                                  override_location: PTextIter,
                                  default_editable: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_paste_clipboard".}
proc get_selection_bounds*(buffer: PTextBuffer, start: PTextIter,
                                       theEnd: PTextIter): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_get_selection_bounds".}
proc delete_selection*(buffer: PTextBuffer, interactive: gboolean,
                                   default_editable: gboolean): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_delete_selection".}
proc begin_user_action*(buffer: PTextBuffer){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_begin_user_action".}
proc end_user_action*(buffer: PTextBuffer){.cdecl, dynlib: lib,
    importc: "gtk_text_buffer_end_user_action".}
proc spew*(buffer: PTextBuffer){.cdecl, dynlib: lib,
    importc: "_gtk_text_buffer_spew".}
proc get_btree*(buffer: PTextBuffer): PTextBTree{.cdecl,
    dynlib: lib, importc: "_gtk_text_buffer_get_btree".}
proc get_line_log_attrs*(buffer: PTextBuffer,
                                     anywhere_in_line: PTextIter,
                                     char_len: Pgint): pango.PLogAttr{.cdecl,
    dynlib: lib, importc: "_gtk_text_buffer_get_line_log_attrs".}
proc notify_will_remove_tag*(buffer: PTextBuffer, tag: PTextTag){.
    cdecl, dynlib: lib, importc: "_gtk_text_buffer_notify_will_remove_tag".}
proc get_has_selection*(buffer: PTextBuffer): gboolean {.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_get_has_selection".}
proc select_range*(buffer: PTextBuffer, ins,
    bound: PTextIter) {.cdecl, dynlib: lib, importc: "gtk_text_buffer_select_range".}
proc backspace*(buffer: PTextBuffer, iter: PTextIter,
    interactive, defaultEditable: gboolean): gboolean {.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_backspace".}

