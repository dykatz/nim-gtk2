# Included by headers/gdk2pixbuf.nim; do not import directly.
proc get_option*(pixbuf: PPixbuf, key: cstring): cstring{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_get_option".}
