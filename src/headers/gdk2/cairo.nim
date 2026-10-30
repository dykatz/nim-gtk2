# Included by headers/gdk2.nim; do not import directly.
proc cairo_create*(drawable: PDrawable): ptr cairo.Context {.
    cdecl, dynlib: lib, importc: "gdk_cairo_create".}
proc cairo_reset_clip*(cr: ptr cairo.Context, drawable: PDrawable) {.
    cdecl, dynlib: lib, importc: "gdk_cairo_reset_clip".}
proc cairo_set_source_color*(cr: ptr cairo.Context, color: PColor) {.
    cdecl, dynlib: lib, importc: "gdk_cairo_set_source_color".}
proc cairo_set_source_pixbuf*(cr: ptr cairo.Context, pixbuf: PPixbuf, pixbuf_x, pixbuf_y: float64) {.
    cdecl, dynlib: lib, importc: "gdk_cairo_set_source_pixbuf".}
proc cairo_set_source_pixmap*(cr: ptr cairo.Context, pixmap: PPixmap, pixmap_x, pixmap_y: float64) {.
    cdecl, dynlib: lib, importc: "gdk_cairo_set_source_pixmap".}
proc cairo_set_source_window*(cr: ptr cairo.Context, window: PWindow, x,y: float64) {.
    cdecl, dynlib: lib, importc: "gdk_cairo_set_source_window".}
proc cairo_rectangle*(cr: ptr cairo.Context, rectangle: PRectangle) {.
    cdecl, dynlib: lib, importc: "gdk_cairo_rectangle".}
proc cairo_region*(cr: ptr cairo.Context, region: PRegion) {.
    cdecl, dynlib: lib, importc: "gdk_cairo_region".}
