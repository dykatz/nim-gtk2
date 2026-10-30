# Included by headers/gtk2.nim; do not import directly.
proc insert_with_tags*(buffer: PTextBuffer, iter: PTextIter,
                                   text: cstring, length: gint,
                                   first_tag: PTextTag){.varargs,
    importc: "gtk_text_buffer_insert_with_tags", cdecl, dynlib: lib.}
proc insert_with_tags_by_name*(buffer: PTextBuffer, iter: PTextIter,
    text: cstring, length: gint, first_tag_name: cstring){.varargs,
    importc: "gtk_text_buffer_insert_with_tags_by_name", cdecl, dynlib: lib.}
proc create_tag*(buffer: PTextBuffer, tag_name: cstring,
                             first_property_name: cstring): PTextTag{.varargs,
    importc: "gtk_text_buffer_create_tag", cdecl, dynlib: lib.}
