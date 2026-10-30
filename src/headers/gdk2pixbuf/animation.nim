# Included by headers/gdk2pixbuf.nim; do not import directly.
proc pixbuf_animation_get_type*(): GType{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_animation_get_type".}
proc pixbuf_animation_new_from_file*(filename: cstring, error: pointer): PPixbufAnimation{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_animation_new_from_file".}
