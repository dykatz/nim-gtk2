# Included by headers/gdk2.nim; do not import directly.
proc cursor_new_from_pixmap*(source: PPixmap, mask: PPixmap, fg: PColor,
                             bg: PColor, x: gint, y: gint): PCursor{.cdecl,
    dynlib: lib, importc: "gdk_cursor_new_from_pixmap".}
proc get_screen*(cursor: PCursor): PScreen{.cdecl, dynlib: lib,
    importc: "gdk_cursor_get_screen".}
proc reference*(cursor: PCursor): PCursor{.cdecl, dynlib: lib,
    importc: "gdk_cursor_ref".}
proc unref*(cursor: PCursor){.cdecl, dynlib: lib,
                                     importc: "gdk_cursor_unref".}
