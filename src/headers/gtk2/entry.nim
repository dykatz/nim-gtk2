# Included by headers/gtk2.nim; do not import directly.
proc set_alignment*(misc: PWidget, xalign: gfloat){.cdecl,
    dynlib: lib, importc: "gtk_entry_set_alignment".}
