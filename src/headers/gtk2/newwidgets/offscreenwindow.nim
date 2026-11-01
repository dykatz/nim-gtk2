# Generated from gtkoffscreenwindow.h; included by headers/gtk2.nim.
proc offscreen_window_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_offscreen_window_get_type".}
proc offscreen_window_new*(): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_offscreen_window_new".}
proc offscreen_window_get_pixmap*(`offscreen`: ptr OffscreenWindow): ptr gdk2.TPixmap {.cdecl, gcsafe, dynlib: lib, importc: "gtk_offscreen_window_get_pixmap".}
proc offscreen_window_get_pixbuf*(`offscreen`: ptr OffscreenWindow): gdk2pixbuf.PPixbuf {.cdecl, gcsafe, dynlib: lib, importc: "gtk_offscreen_window_get_pixbuf".}
