# Included by headers/gtk2.nim; do not import directly.
proc get_vadjustment*(scrolled_window: PTextView): PAdjustment{.
    cdecl, dynlib: lib, importc: "gtk_text_view_get_vadjustment".}

proc get_hadjustment*(text_view: PTextView): PAdjustment{.cdecl,
    importc: "gtk_text_view_get_hadjustment", dynlib: lib.}

