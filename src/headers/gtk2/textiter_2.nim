# Included by headers/gtk2.nim; do not import directly.
proc line_segment_split*(iter: PTextIter): PTextLineSegment{.cdecl,
    dynlib: lib, importc: "gtk_text_line_segment_split".}
proc char_segment_new*(text: cstring, len: guint): PTextLineSegment{.cdecl,
    dynlib: lib, importc: "_gtk_char_segment_new".}
proc char_segment_new_from_two_strings*(text1: cstring, len1: guint,
                                        text2: cstring, len2: guint): PTextLineSegment{.
    cdecl, dynlib: lib, importc: "_gtk_char_segment_new_from_two_strings".}
proc toggle_segment_new*(info: PTextTagInfo, StateOn: gboolean): PTextLineSegment{.
    cdecl, dynlib: lib, importc: "_gtk_toggle_segment_new".}
