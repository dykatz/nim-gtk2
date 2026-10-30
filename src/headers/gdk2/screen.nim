# Included by headers/gdk2.nim; do not import directly.
proc cursor_new_for_screen*(screen: PScreen, cursor_type: TCursorType): PCursor{.
    cdecl, dynlib: lib, importc: "gdk_cursor_new_for_screen".}
