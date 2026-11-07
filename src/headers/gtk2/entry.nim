# Included by headers/gtk2.nim; do not import directly.
proc set_alignment*(entry: PEntry, xalign: gfloat){.cdecl,
    dynlib: lib, importc: "gtk_entry_set_alignment".}
proc get_alignment*(entry: PEntry): gfloat {.cdecl,
    dynlib: lib, importc: "gtk_entry_get_alignment".}
