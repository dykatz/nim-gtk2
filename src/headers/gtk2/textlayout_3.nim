# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_LAYOUT*(): GType
proc TEXT_LAYOUT*(obj: pointer): PTextLayout
proc TEXT_LAYOUT_CLASS*(klass: pointer): PTextLayoutClass
proc IS_TEXT_LAYOUT*(obj: pointer): bool
proc IS_TEXT_LAYOUT_CLASS*(klass: pointer): bool
proc TEXT_LAYOUT_GET_CLASS*(obj: pointer): PTextLayoutClass
const
  bm_TGtkTextLayout_cursor_visible* = 0x0001'u16
const
  bp_TGtkTextLayout_cursor_visible* = 0'u16
const
  bm_TGtkTextLayout_cursor_direction* = 0x0006'u16
const
  bp_TGtkTextLayout_cursor_direction* = 1'u16

proc cursor_visible*(a: PTextLayout): guint
proc set_cursor_visible*(a: PTextLayout, `cursor_visible`: guint)
proc cursor_direction*(a: PTextLayout): guint

const
  bm_TGtkTextCursorDisplay_is_strong* = 0x0001'u16
const
  bp_TGtkTextCursorDisplay_is_strong* = 0'u16
const
  bm_TGtkTextCursorDisplay_is_weak* = 0x0002'u16
const
  bp_TGtkTextCursorDisplay_is_weak* = 1'u16

proc is_strong*(a: PTextCursorDisplay): guint
proc set_is_strong*(a: PTextCursorDisplay, `is_strong`: guint)
proc is_weak*(a: PTextCursorDisplay): guint
proc set_is_weak*(a: PTextCursorDisplay, `is_weak`: guint)
proc text_layout_get_type*(): GType{.cdecl, dynlib: lib,
                                     importc: "gtk_text_layout_get_type".}
proc text_layout_new*(): PTextLayout{.cdecl, dynlib: lib,
                                      importc: "gtk_text_layout_new".}
proc set_buffer*(layout: PTextLayout, buffer: PTextBuffer){.cdecl,
    dynlib: lib, importc: "gtk_text_layout_set_buffer".}
proc get_buffer*(layout: PTextLayout): PTextBuffer{.cdecl,
    dynlib: lib, importc: "gtk_text_layout_get_buffer".}
proc set_default_style*(layout: PTextLayout, values: PTextAttributes){.
    cdecl, dynlib: lib, importc: "gtk_text_layout_set_default_style".}
proc set_contexts*(layout: PTextLayout, ltr_context: pango.PContext,
                               rtl_context: pango.PContext){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_set_contexts".}
proc set_cursor_direction*(layout: PTextLayout,
                                       direction: TTextDirection){.cdecl,
    dynlib: lib, importc: "gtk_text_layout_set_cursor_direction".}
proc default_style_changed*(layout: PTextLayout){.cdecl,
    dynlib: lib, importc: "gtk_text_layout_default_style_changed".}
proc set_screen_width*(layout: PTextLayout, width: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_layout_set_screen_width".}
proc set_preedit_string*(layout: PTextLayout,
                                     preedit_string: cstring,
                                     preedit_attrs: pango.PAttrList,
                                     cursor_pos: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_set_preedit_string".}
proc set_cursor_visible*(layout: PTextLayout,
                                     cursor_visible: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_text_layout_set_cursor_visible".}
proc get_cursor_visible*(layout: PTextLayout): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_layout_get_cursor_visible".}
proc get_size*(layout: PTextLayout, width: Pgint, height: Pgint){.
    cdecl, dynlib: lib, importc: "gtk_text_layout_get_size".}
proc get_lines*(layout: PTextLayout, top_y: gint, bottom_y: gint,
                            first_line_y: Pgint): PGSList{.cdecl, dynlib: lib,
    importc: "gtk_text_layout_get_lines".}
proc wrap_loop_start*(layout: PTextLayout){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_wrap_loop_start".}
proc wrap_loop_end*(layout: PTextLayout){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_wrap_loop_end".}
proc get_line_display*(layout: PTextLayout, line: PTextLine,
                                   size_only: gboolean): PTextLineDisplay{.
    cdecl, dynlib: lib, importc: "gtk_text_layout_get_line_display".}
proc free_line_display*(layout: PTextLayout,
                                    display: PTextLineDisplay){.cdecl,
    dynlib: lib, importc: "gtk_text_layout_free_line_display".}
proc get_line_at_y*(layout: PTextLayout, target_iter: PTextIter,
                                y: gint, line_top: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_get_line_at_y".}
proc get_iter_at_pixel*(layout: PTextLayout, iter: PTextIter,
                                    x: gint, y: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_get_iter_at_pixel".}
proc invalidate*(layout: PTextLayout, start: PTextIter,
                             theEnd: PTextIter){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_invalidate".}
proc free_line_data*(layout: PTextLayout, line: PTextLine,
                                 line_data: PTextLineData){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_free_line_data".}
proc is_valid*(layout: PTextLayout): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_layout_is_valid".}
proc validate_yrange*(layout: PTextLayout, anchor_line: PTextIter,
                                  y0: gint, y1: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_validate_yrange".}
proc validate*(layout: PTextLayout, max_pixels: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_layout_validate".}
proc wrap*(layout: PTextLayout, line: PTextLine,
                       line_data: PTextLineData): PTextLineData{.cdecl,
    dynlib: lib, importc: "gtk_text_layout_wrap".}
proc changed*(layout: PTextLayout, y: gint, old_height: gint,
                          new_height: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_changed".}
proc get_iter_location*(layout: PTextLayout, iter: PTextIter,
                                    rect: gdk2.PRectangle){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_get_iter_location".}
proc get_line_yrange*(layout: PTextLayout, iter: PTextIter,
                                  y: Pgint, height: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_get_line_yrange".}
proc get_line_xrange*(layout: PTextLayout, iter: PTextIter,
                                  x: Pgint, width: Pgint){.cdecl, dynlib: lib,
    importc: "_gtk_text_layout_get_line_xrange".}
proc get_cursor_locations*(layout: PTextLayout, iter: PTextIter,
                                       strong_pos: gdk2.PRectangle,
                                       weak_pos: gdk2.PRectangle){.cdecl,
    dynlib: lib, importc: "gtk_text_layout_get_cursor_locations".}
proc clamp_iter_to_vrange*(layout: PTextLayout, iter: PTextIter,
                                       top: gint, bottom: gint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_layout_clamp_iter_to_vrange".}
proc move_iter_to_line_end*(layout: PTextLayout, iter: PTextIter,
                                        direction: gint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_layout_move_iter_to_line_end".}
proc move_iter_to_previous_line*(layout: PTextLayout,
    iter: PTextIter): gboolean{.cdecl, dynlib: lib, importc: "gtk_text_layout_move_iter_to_previous_line".}
proc move_iter_to_next_line*(layout: PTextLayout, iter: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_layout_move_iter_to_next_line".}
proc move_iter_to_x*(layout: PTextLayout, iter: PTextIter, x: gint){.
    cdecl, dynlib: lib, importc: "gtk_text_layout_move_iter_to_x".}
proc move_iter_visually*(layout: PTextLayout, iter: PTextIter,
                                     count: gint): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_layout_move_iter_visually".}
proc iter_starts_line*(layout: PTextLayout, iter: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_layout_iter_starts_line".}
proc get_iter_at_line*(layout: PTextLayout, iter: PTextIter,
                                   line: PTextLine, byte_offset: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_layout_get_iter_at_line".}
proc anchor_register_child*(anchor: PTextChildAnchor, child: PWidget,
                                       layout: PTextLayout){.cdecl, dynlib: lib,
    importc: "gtk_text_child_anchor_register_child".}
proc anchor_unregister_child*(anchor: PTextChildAnchor,
    child: PWidget){.cdecl, dynlib: lib,
                     importc: "gtk_text_child_anchor_unregister_child".}
proc anchor_queue_resize*(anchor: PTextChildAnchor,
                                     layout: PTextLayout){.cdecl, dynlib: lib,
    importc: "gtk_text_child_anchor_queue_resize".}
proc text_anchored_child_set_layout*(child: PWidget, layout: PTextLayout){.
    cdecl, dynlib: lib, importc: "gtk_text_anchored_child_set_layout".}
proc spew*(layout: PTextLayout){.cdecl, dynlib: lib,
    importc: "gtk_text_layout_spew".}
