# Included by headers/gtk2.nim; do not import directly.
proc set_text*(entry: PEntry, text: cstring){.cdecl, dynlib: lib,
    importc: "gtk_entry_set_text".}
proc append_text*(entry: PEntry, text: cstring){.cdecl, dynlib: lib,
    importc: "gtk_entry_append_text".}
proc get_text*(entry: PEntry): cstring{.cdecl, dynlib: lib,
    importc: "gtk_entry_get_text".}
proc get_layout*(entry: PEntry): pango.PLayout{.cdecl, dynlib: lib,
    importc: "gtk_entry_get_layout".}
proc get_layout_offsets*(entry: PEntry, x: Pgint, y: Pgint){.cdecl,
    dynlib: lib, importc: "gtk_entry_get_layout_offsets".}
