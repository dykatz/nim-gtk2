# Included by headers/pango.nim; do not import directly.
proc find_paragraph_boundary*(text: cstring, length: gint,
                              paragraph_delimiter_index: Pgint,
                              next_paragraph_start: Pgint){.cdecl, dynlib: lib,
    importc: "pango_find_paragraph_boundary".}
