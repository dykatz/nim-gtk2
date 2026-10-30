# Included by headers/pango.nim; do not import directly.
proc is_line_break*(a: PLogAttr): guint =
  result = (a.flag0 and bm_TPangoLogAttr_is_line_break) shr
      bp_TPangoLogAttr_is_line_break

proc set_is_line_break*(a: PLogAttr, `is_line_break`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_line_break` shl bp_TPangoLogAttr_is_line_break) and
      bm_TPangoLogAttr_is_line_break)

proc is_mandatory_break*(a: PLogAttr): guint =
  result = ((a.flag0 and bm_TPangoLogAttr_is_mandatory_break) shr
      bp_TPangoLogAttr_is_mandatory_break).guint

proc set_is_mandatory_break*(a: PLogAttr, `is_mandatory_break`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_mandatory_break` shl bp_TPangoLogAttr_is_mandatory_break) and
      bm_TPangoLogAttr_is_mandatory_break)

proc is_char_break*(a: PLogAttr): guint =
  result = ((a.flag0 and bm_TPangoLogAttr_is_char_break) shr
      bp_TPangoLogAttr_is_char_break).guint

proc set_is_char_break*(a: PLogAttr, `is_char_break`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_char_break` shl bp_TPangoLogAttr_is_char_break) and
      bm_TPangoLogAttr_is_char_break)

proc is_white*(a: PLogAttr): guint =
  result = ((a.flag0 and bm_TPangoLogAttr_is_white) shr
      bp_TPangoLogAttr_is_white).guint

proc set_is_white*(a: PLogAttr, `is_white`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_white` shl bp_TPangoLogAttr_is_white) and
      bm_TPangoLogAttr_is_white)

proc is_cursor_position*(a: PLogAttr): guint =
  result = ((a.flag0 and bm_TPangoLogAttr_is_cursor_position) shr
      bp_TPangoLogAttr_is_cursor_position).guint

proc set_is_cursor_position*(a: PLogAttr, `is_cursor_position`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_cursor_position` shl bp_TPangoLogAttr_is_cursor_position) and
      bm_TPangoLogAttr_is_cursor_position)

proc is_word_start*(a: PLogAttr): guint =
  result = ((a.flag0 and bm_TPangoLogAttr_is_word_start) shr
      bp_TPangoLogAttr_is_word_start).guint

proc set_is_word_start*(a: PLogAttr, `is_word_start`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_word_start` shl bp_TPangoLogAttr_is_word_start) and
      bm_TPangoLogAttr_is_word_start)

proc is_word_end*(a: PLogAttr): guint =
  result = ((a.flag0 and bm_TPangoLogAttr_is_word_end) shr
      bp_TPangoLogAttr_is_word_end).guint

proc set_is_word_end*(a: PLogAttr, `is_word_end`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_word_end` shl bp_TPangoLogAttr_is_word_end) and
      bm_TPangoLogAttr_is_word_end)

proc is_sentence_boundary*(a: PLogAttr): guint =
  result = ((a.flag0 and bm_TPangoLogAttr_is_sentence_boundary) shr
      bp_TPangoLogAttr_is_sentence_boundary).guint

proc set_is_sentence_boundary*(a: PLogAttr, `is_sentence_boundary`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_sentence_boundary` shl bp_TPangoLogAttr_is_sentence_boundary) and
      bm_TPangoLogAttr_is_sentence_boundary)

proc is_sentence_start*(a: PLogAttr): guint =
  result = ((a.flag0 and bm_TPangoLogAttr_is_sentence_start) shr
      bp_TPangoLogAttr_is_sentence_start).guint

proc set_is_sentence_start*(a: PLogAttr, `is_sentence_start`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_sentence_start` shl bp_TPangoLogAttr_is_sentence_start) and
      bm_TPangoLogAttr_is_sentence_start)

proc is_sentence_end*(a: PLogAttr): guint =
  result = ((a.flag0 and bm_TPangoLogAttr_is_sentence_end) shr
      bp_TPangoLogAttr_is_sentence_end).guint

proc set_is_sentence_end*(a: PLogAttr, `is_sentence_end`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_sentence_end` shl bp_TPangoLogAttr_is_sentence_end) and
      bm_TPangoLogAttr_is_sentence_end)

proc TYPE_CONTEXT*(): GType =
  result = context_get_type()

