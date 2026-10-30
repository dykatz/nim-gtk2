# Included by headers/gdk2pixbuf.nim; do not import directly.
proc TYPE_PIXBUF*(): GType
proc PIXBUF*(anObject: pointer): PPixbuf
proc IS_PIXBUF*(anObject: pointer): bool
proc TYPE_PIXBUF_ANIMATION*(): GType
proc PIXBUF_ANIMATION*(anObject: pointer): PPixbufAnimation
proc IS_PIXBUF_ANIMATION*(anObject: pointer): bool
proc TYPE_PIXBUF_ANIMATION_ITER*(): GType
proc PIXBUF_ANIMATION_ITER*(anObject: pointer): PPixbufAnimationIter
proc IS_PIXBUF_ANIMATION_ITER*(anObject: pointer): bool
proc PIXBUF_ERROR*(): TGQuark
proc pixbuf_error_quark*(): TGQuark{.cdecl, dynlib: pixbuflib,
                                     importc: "gdk_pixbuf_error_quark".}
proc pixbuf_get_type*(): GType{.cdecl, dynlib: pixbuflib,
                                importc: "gdk_pixbuf_get_type".}
