# Included by headers/gdk2pixbuf.nim; do not import directly.
proc get_width*(animation: PPixbufAnimation): int32{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_animation_get_width".}
proc get_height*(animation: PPixbufAnimation): int32{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_animation_get_height".}
proc is_static_image*(animation: PPixbufAnimation): gboolean{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_animation_is_static_image".}
proc get_static_image*(animation: PPixbufAnimation): PPixbuf{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_animation_get_static_image".}
proc get_iter*(animation: PPixbufAnimation, e: var TGTimeVal): PPixbufAnimationIter{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_animation_get_iter".}
proc pixbuf_animation_iter_get_type*(): GType{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_animation_iter_get_type".}
proc iter_get_delay_time*(iter: PPixbufAnimationIter): int32{.
    cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_animation_iter_get_delay_time".}
proc iter_get_pixbuf*(iter: PPixbufAnimationIter): PPixbuf{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_animation_iter_get_pixbuf".}
proc pixbuf_animation_iter_on_currently_loading_frame*(
    iter: PPixbufAnimationIter): gboolean{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_animation_iter_on_currently_loading_frame".}
proc iter_advance*(iter: PPixbufAnimationIter, e: var TGTimeVal): gboolean{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_animation_iter_advance".}
