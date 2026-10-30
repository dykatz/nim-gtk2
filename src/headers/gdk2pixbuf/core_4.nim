# Included by headers/gdk2pixbuf.nim; do not import directly.
proc TYPE_PIXBUF_LOADER*(): GType
proc PIXBUF_LOADER*(obj: pointer): PPixbufLoader
proc PIXBUF_LOADER_CLASS*(klass: pointer): PPixbufLoaderClass
proc IS_PIXBUF_LOADER*(obj: pointer): bool
proc IS_PIXBUF_LOADER_CLASS*(klass: pointer): bool
proc PIXBUF_LOADER_GET_CLASS*(obj: pointer): PPixbufLoaderClass
