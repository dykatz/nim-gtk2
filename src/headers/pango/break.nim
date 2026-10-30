# Included by headers/pango.nim; do not import directly.
proc is_line_break*(a: PLogAttr): guint
proc set_is_line_break*(a: PLogAttr, `is_line_break`: guint)
proc is_mandatory_break*(a: PLogAttr): guint
proc set_is_mandatory_break*(a: PLogAttr, `is_mandatory_break`: guint)
proc is_char_break*(a: PLogAttr): guint
proc set_is_char_break*(a: PLogAttr, `is_char_break`: guint)
proc is_white*(a: PLogAttr): guint
proc set_is_white*(a: PLogAttr, `is_white`: guint)
proc is_cursor_position*(a: PLogAttr): guint
proc set_is_cursor_position*(a: PLogAttr, `is_cursor_position`: guint)
proc is_word_start*(a: PLogAttr): guint
proc set_is_word_start*(a: PLogAttr, `is_word_start`: guint)
proc is_word_end*(a: PLogAttr): guint
proc set_is_word_end*(a: PLogAttr, `is_word_end`: guint)
proc is_sentence_boundary*(a: PLogAttr): guint
proc set_is_sentence_boundary*(a: PLogAttr, `is_sentence_boundary`: guint)
proc is_sentence_start*(a: PLogAttr): guint
proc set_is_sentence_start*(a: PLogAttr, `is_sentence_start`: guint)
proc is_sentence_end*(a: PLogAttr): guint
proc set_is_sentence_end*(a: PLogAttr, `is_sentence_end`: guint)
proc `break`*(text: cstring, length: int32, analysis: PAnalysis, attrs: PLogAttr,
            attrs_len: int32){.cdecl, dynlib: lib, importc: "pango_break".}
