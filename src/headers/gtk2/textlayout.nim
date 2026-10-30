# Included by headers/gtk2.nim; do not import directly.
proc width*(a: PTextLineData): guint
proc set_width*(a: PTextLineData, NewWidth: guint)
proc valid*(a: PTextLineData): guint
proc set_valid*(a: PTextLineData, `valid`: guint)
proc get_number*(line: PTextLine): gint{.cdecl, dynlib: lib,
    importc: "_gtk_text_line_get_number".}
proc char_has_tag*(line: PTextLine, tree: PTextBTree,
                             char_in_line: gint, tag: PTextTag): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_text_line_char_has_tag".}
proc byte_has_tag*(line: PTextLine, tree: PTextBTree,
                             byte_in_line: gint, tag: PTextTag): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_text_line_byte_has_tag".}
proc is_last*(line: PTextLine, tree: PTextBTree): gboolean{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_is_last".}
proc contains_end_iter*(line: PTextLine, tree: PTextBTree): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_text_line_contains_end_iter".}
proc next*(line: PTextLine): PTextLine{.cdecl, dynlib: lib,
    importc: "_gtk_text_line_next".}
proc next_excluding_last*(line: PTextLine): PTextLine{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_next_excluding_last".}
proc previous*(line: PTextLine): PTextLine{.cdecl, dynlib: lib,
    importc: "_gtk_text_line_previous".}
proc add_data*(line: PTextLine, data: PTextLineData){.cdecl,
    dynlib: lib, importc: "_gtk_text_line_add_data".}
proc remove_data*(line: PTextLine, view_id: gpointer): gpointer{.
    cdecl, dynlib: lib, importc: "_gtk_text_line_remove_data".}
proc get_data*(line: PTextLine, view_id: gpointer): gpointer{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_get_data".}
proc invalidate_wrap*(line: PTextLine, ld: PTextLineData){.cdecl,
    dynlib: lib, importc: "_gtk_text_line_invalidate_wrap".}
proc char_count*(line: PTextLine): gint{.cdecl, dynlib: lib,
    importc: "_gtk_text_line_char_count".}
proc byte_count*(line: PTextLine): gint{.cdecl, dynlib: lib,
    importc: "_gtk_text_line_byte_count".}
proc char_index*(line: PTextLine): gint{.cdecl, dynlib: lib,
    importc: "_gtk_text_line_char_index".}
proc byte_to_segment*(line: PTextLine, byte_offset: gint,
                                seg_offset: Pgint): PTextLineSegment{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_byte_to_segment".}
proc char_to_segment*(line: PTextLine, char_offset: gint,
                                seg_offset: Pgint): PTextLineSegment{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_char_to_segment".}
proc byte_to_char_offsets*(line: PTextLine, byte_offset: gint,
                                     line_char_offset: Pgint,
                                     seg_char_offset: Pgint){.cdecl,
    dynlib: lib, importc: "_gtk_text_line_byte_to_char_offsets".}
proc char_to_byte_offsets*(line: PTextLine, char_offset: gint,
                                     line_byte_offset: Pgint,
                                     seg_byte_offset: Pgint){.cdecl,
    dynlib: lib, importc: "_gtk_text_line_char_to_byte_offsets".}
proc byte_to_any_segment*(line: PTextLine, byte_offset: gint,
                                    seg_offset: Pgint): PTextLineSegment{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_byte_to_any_segment".}
proc char_to_any_segment*(line: PTextLine, char_offset: gint,
                                    seg_offset: Pgint): PTextLineSegment{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_char_to_any_segment".}
proc byte_to_char*(line: PTextLine, byte_offset: gint): gint{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_byte_to_char".}
proc char_to_byte*(line: PTextLine, char_offset: gint): gint{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_char_to_byte".}
proc next_could_contain_tag*(line: PTextLine, tree: PTextBTree,
                                       tag: PTextTag): PTextLine{.cdecl,
    dynlib: lib, importc: "_gtk_text_line_next_could_contain_tag".}
proc previous_could_contain_tag*(line: PTextLine, tree: PTextBTree,
    tag: PTextTag): PTextLine{.cdecl, dynlib: lib, importc: "_gtk_text_line_previous_could_contain_tag".}
proc line_data_new*(layout: PTextLayout, line: PTextLine): PTextLineData{.
    cdecl, dynlib: lib, importc: "_gtk_text_line_data_new".}
