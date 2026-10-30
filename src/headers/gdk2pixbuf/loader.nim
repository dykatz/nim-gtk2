# Included by headers/gdk2pixbuf.nim; do not import directly.
proc pixbuf_loader_get_type*(): GType{.cdecl, dynlib: pixbuflib,
                                       importc: "gdk_pixbuf_loader_get_type".}
proc pixbuf_loader_new*(): PPixbufLoader{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_loader_new".}
proc pixbuf_loader_new*(image_type: cstring, error: pointer): PPixbufLoader{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_loader_new_with_type".}
proc write*(loader: PPixbufLoader, buf: Pguchar, count: gsize,
                          error: pointer): gboolean{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_loader_write".}
proc get_pixbuf*(loader: PPixbufLoader): PPixbuf{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_loader_get_pixbuf".}
proc get_animation*(loader: PPixbufLoader): PPixbufAnimation{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_loader_get_animation".}
proc close*(loader: PPixbufLoader, error: pointer): gboolean{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_loader_close".}
proc TYPE_PIXBUF_LOADER*(): GType =
  result = pixbuf_loader_get_type()

proc PIXBUF_LOADER*(obj: pointer): PPixbufLoader =
  result = cast[PPixbufLoader](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_PIXBUF_LOADER()))

proc PIXBUF_LOADER_CLASS*(klass: pointer): PPixbufLoaderClass =
  result = cast[PPixbufLoaderClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_PIXBUF_LOADER()))

proc IS_PIXBUF_LOADER*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_PIXBUF_LOADER())

proc IS_PIXBUF_LOADER_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_PIXBUF_LOADER())

proc PIXBUF_LOADER_GET_CLASS*(obj: pointer): PPixbufLoaderClass =
  result = cast[PPixbufLoaderClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_PIXBUF_LOADER()))

proc TYPE_PIXBUF*(): GType =
  result = pixbuf_get_type()

proc PIXBUF*(anObject: pointer): PPixbuf =
  result = cast[PPixbuf](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_PIXBUF()))

proc IS_PIXBUF*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_PIXBUF())

proc TYPE_PIXBUF_ANIMATION*(): GType =
  result = pixbuf_animation_get_type()

proc PIXBUF_ANIMATION*(anObject: pointer): PPixbufAnimation =
  result = cast[PPixbufAnimation](G_TYPE_CHECK_INSTANCE_CAST(anObject,
      TYPE_PIXBUF_ANIMATION()))

proc IS_PIXBUF_ANIMATION*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_PIXBUF_ANIMATION())

proc TYPE_PIXBUF_ANIMATION_ITER*(): GType =
  result = pixbuf_animation_iter_get_type()

proc PIXBUF_ANIMATION_ITER*(anObject: pointer): PPixbufAnimationIter =
  result = cast[PPixbufAnimationIter](G_TYPE_CHECK_INSTANCE_CAST(anObject,
      TYPE_PIXBUF_ANIMATION_ITER()))

proc IS_PIXBUF_ANIMATION_ITER*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_PIXBUF_ANIMATION_ITER())

proc PIXBUF_ERROR*(): TGQuark =
  result = pixbuf_error_quark()
