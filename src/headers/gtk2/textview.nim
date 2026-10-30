# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_VIEW*(): GType
proc TEXT_VIEW*(obj: pointer): PTextView
proc TEXT_VIEW_CLASS*(klass: pointer): PTextViewClass
proc IS_TEXT_VIEW*(obj: pointer): bool
proc IS_TEXT_VIEW_CLASS*(klass: pointer): bool
proc TEXT_VIEW_GET_CLASS*(obj: pointer): PTextViewClass
proc editable*(a: PTextView): guint
proc set_editable*(a: PTextView, `editable`: guint)
proc overwrite_mode*(a: PTextView): guint
proc set_overwrite_mode*(a: PTextView, `overwrite_mode`: guint)
proc cursor_visible*(a: PTextView): guint
proc set_cursor_visible*(a: PTextView, `cursor_visible`: guint)
proc need_im_reset*(a: PTextView): guint
proc set_need_im_reset*(a: PTextView, `need_im_reset`: guint)
proc just_selected_element*(a: PTextView): guint
proc set_just_selected_element*(a: PTextView, `just_selected_element`: guint)
proc disable_scroll_on_focus*(a: PTextView): guint
proc set_disable_scroll_on_focus*(a: PTextView,
                                  `disable_scroll_on_focus`: guint)
proc onscreen_validated*(a: PTextView): guint
proc set_onscreen_validated*(a: PTextView, `onscreen_validated`: guint)
proc mouse_cursor_obscured*(a: PTextView): guint
proc set_mouse_cursor_obscured*(a: PTextView, `mouse_cursor_obscured`: guint)
proc set_accepts_tab*(view: PTextView, value: gboolean) {.cdecl, dynlib: lib,
    importc: "gtk_text_view_set_accepts_tab".}
proc get_accepts_tab*(view: PTextView): gboolean {.cdecl, dynlib: lib,
    importc: "gtk_text_view_get_accepts_tab".}
proc text_view_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_text_view_get_type".}
proc text_view_new*(): PTextView{.cdecl, dynlib: lib,
                                  importc: "gtk_text_view_new".}
proc text_view_new*(buffer: PTextBuffer): PTextView{.cdecl,
    dynlib: lib, importc: "gtk_text_view_new_with_buffer".}
proc set_buffer*(text_view: PTextView, buffer: PTextBuffer){.cdecl,
    dynlib: lib, importc: "gtk_text_view_set_buffer".}
proc get_buffer*(text_view: PTextView): PTextBuffer{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_buffer".}
proc scroll_to_iter*(text_view: PTextView, iter: PTextIter,
                               within_margin: gdouble, use_align: gboolean,
                               xalign: gdouble, yalign: gdouble): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_view_scroll_to_iter".}
proc scroll_to_mark*(text_view: PTextView, mark: PTextMark,
                               within_margin: gdouble, use_align: gboolean,
                               xalign: gdouble, yalign: gdouble){.cdecl,
    dynlib: lib, importc: "gtk_text_view_scroll_to_mark".}
proc scroll_mark_onscreen*(text_view: PTextView, mark: PTextMark){.
    cdecl, dynlib: lib, importc: "gtk_text_view_scroll_mark_onscreen".}
proc move_mark_onscreen*(text_view: PTextView, mark: PTextMark): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_view_move_mark_onscreen".}
proc place_cursor_onscreen*(text_view: PTextView): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_view_place_cursor_onscreen".}
proc get_visible_rect*(text_view: PTextView,
                                 visible_rect: gdk2.PRectangle){.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_visible_rect".}
proc set_cursor_visible*(text_view: PTextView, setting: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_text_view_set_cursor_visible".}
proc get_cursor_visible*(text_view: PTextView): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_cursor_visible".}
proc get_iter_location*(text_view: PTextView, iter: PTextIter,
                                  location: gdk2.PRectangle){.cdecl, dynlib: lib,
    importc: "gtk_text_view_get_iter_location".}
proc get_iter_at_location*(text_view: PTextView, iter: PTextIter,
                                     x: gint, y: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_view_get_iter_at_location".}
proc get_line_yrange*(text_view: PTextView, iter: PTextIter, y: Pgint,
                                height: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_text_view_get_line_yrange".}
proc get_line_at_y*(text_view: PTextView, target_iter: PTextIter,
                              y: gint, line_top: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_text_view_get_line_at_y".}
proc buffer_to_window_coords*(text_view: PTextView,
                                        win: TTextWindowType, buffer_x: gint,
                                        buffer_y: gint, window_x: Pgint,
                                        window_y: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_text_view_buffer_to_window_coords".}
proc window_to_buffer_coords*(text_view: PTextView,
                                        win: TTextWindowType, window_x: gint,
                                        window_y: gint, buffer_x: Pgint,
                                        buffer_y: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_text_view_window_to_buffer_coords".}
proc get_window*(text_view: PTextView, win: TTextWindowType): gdk2.PWindow{.
    cdecl, dynlib: lib, importc: "gtk_text_view_get_window".}
proc get_window_type*(text_view: PTextView, window: gdk2.PWindow): TTextWindowType{.
    cdecl, dynlib: lib, importc: "gtk_text_view_get_window_type".}
proc set_border_window_size*(text_view: PTextView,
                                       thetype: TTextWindowType, size: gint){.
    cdecl, dynlib: lib, importc: "gtk_text_view_set_border_window_size".}
proc get_border_window_size*(text_view: PTextView,
                                       thetype: TTextWindowType): gint{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_border_window_size".}
proc forward_display_line*(text_view: PTextView, iter: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_view_forward_display_line".}
proc backward_display_line*(text_view: PTextView, iter: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_view_backward_display_line".}
proc forward_display_line_end*(text_view: PTextView, iter: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_view_forward_display_line_end".}
proc backward_display_line_start*(text_view: PTextView,
    iter: PTextIter): gboolean{.cdecl, dynlib: lib, importc: "gtk_text_view_backward_display_line_start".}
proc starts_display_line*(text_view: PTextView, iter: PTextIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_view_starts_display_line".}
proc move_visually*(text_view: PTextView, iter: PTextIter, count: gint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_text_view_move_visually".}
proc add_child_at_anchor*(text_view: PTextView, child: PWidget,
                                    anchor: PTextChildAnchor){.cdecl,
    dynlib: lib, importc: "gtk_text_view_add_child_at_anchor".}
proc add_child_in_window*(text_view: PTextView, child: PWidget,
                                    which_window: TTextWindowType, xpos: gint,
                                    ypos: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_view_add_child_in_window".}
proc move_child*(text_view: PTextView, child: PWidget, xpos: gint,
                           ypos: gint){.cdecl, dynlib: lib,
                                        importc: "gtk_text_view_move_child".}
proc set_wrap_mode*(text_view: PTextView, wrap_mode: TWrapMode){.
    cdecl, dynlib: lib, importc: "gtk_text_view_set_wrap_mode".}
proc get_wrap_mode*(text_view: PTextView): TWrapMode{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_wrap_mode".}
proc set_editable*(text_view: PTextView, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_text_view_set_editable".}
proc get_editable*(text_view: PTextView): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_editable".}
proc set_pixels_above_lines*(text_view: PTextView,
                                       pixels_above_lines: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_view_set_pixels_above_lines".}
proc get_pixels_above_lines*(text_view: PTextView): gint{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_pixels_above_lines".}
proc set_pixels_below_lines*(text_view: PTextView,
                                       pixels_below_lines: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_view_set_pixels_below_lines".}
proc get_pixels_below_lines*(text_view: PTextView): gint{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_pixels_below_lines".}
proc set_pixels_inside_wrap*(text_view: PTextView,
                                       pixels_inside_wrap: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_view_set_pixels_inside_wrap".}
proc get_pixels_inside_wrap*(text_view: PTextView): gint{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_pixels_inside_wrap".}
proc set_justification*(text_view: PTextView,
                                  justification: TJustification){.cdecl,
    dynlib: lib, importc: "gtk_text_view_set_justification".}
proc get_justification*(text_view: PTextView): TJustification{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_justification".}
proc set_left_margin*(text_view: PTextView, left_margin: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_view_set_left_margin".}
proc get_left_margin*(text_view: PTextView): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_view_get_left_margin".}
proc set_right_margin*(text_view: PTextView, right_margin: gint){.
    cdecl, dynlib: lib, importc: "gtk_text_view_set_right_margin".}
proc get_right_margin*(text_view: PTextView): gint{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_right_margin".}
proc set_indent*(text_view: PTextView, indent: gint){.cdecl,
    dynlib: lib, importc: "gtk_text_view_set_indent".}
proc get_indent*(text_view: PTextView): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_view_get_indent".}
proc set_tabs*(text_view: PTextView, tabs: pango.PTabArray){.cdecl,
    dynlib: lib, importc: "gtk_text_view_set_tabs".}
proc get_tabs*(text_view: PTextView): pango.PTabArray{.cdecl,
    dynlib: lib, importc: "gtk_text_view_get_tabs".}
proc get_default_attributes*(text_view: PTextView): PTextAttributes{.
    cdecl, dynlib: lib, importc: "gtk_text_view_get_default_attributes".}
const
  bm_TGtkToolbar_style_set* = 0x0001'u16
const
  bp_TGtkToolbar_style_set* = 0'u16
const
  bm_TGtkToolbar_icon_size_set* = 0x0002'u16
const
  bp_TGtkToolbar_icon_size_set* = 1'u16

