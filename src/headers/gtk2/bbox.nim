# Included by headers/gtk2.nim; do not import directly.
proc set_spacing*(box: PBox, spacing: gint){.cdecl, dynlib: lib,
    importc: "gtk_box_set_spacing".}
proc get_spacing*(box: PBox): gint{.cdecl, dynlib: lib,
                                        importc: "gtk_box_get_spacing".}
