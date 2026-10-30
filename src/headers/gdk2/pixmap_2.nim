# Included by headers/gdk2.nim; do not import directly.
proc PIXMAP_CLASS*(klass: pointer): PPixmapObjectClass
proc IS_PIXMAP*(anObject: pointer): bool
proc IS_PIXMAP_CLASS*(klass: pointer): bool
proc PIXMAP_GET_CLASS*(obj: pointer): PPixmapObjectClass
proc PIXMAP_OBJECT*(anObject: pointer): PPixmapObject
proc pixmap_get_type*(): GType{.cdecl, dynlib: lib,
                                importc: "gdk_pixmap_get_type".}
proc pixmap_new*(window: PWindow, width: gint, height: gint, depth: gint): PPixmap{.
    cdecl, dynlib: lib, importc: "gdk_pixmap_new".}
proc bitmap_create_from_data*(window: PWindow, data: cstring, width: gint,
                              height: gint): PBitmap{.cdecl, dynlib: lib,
    importc: "gdk_bitmap_create_from_data".}
proc pixmap_create_from_data*(window: PWindow, data: cstring, width: gint,
                              height: gint, depth: gint, fg: PColor, bg: PColor): PPixmap{.
    cdecl, dynlib: lib, importc: "gdk_pixmap_create_from_data".}
proc pixmap_create_from_xpm*(window: PWindow, k: var PBitmap,
                             transparent_color: PColor, filename: cstring): PPixmap{.
    cdecl, dynlib: lib, importc: "gdk_pixmap_create_from_xpm".}
proc pixmap_colormap_create_from_xpm*(window: PWindow, colormap: PColormap,
                                      k: var PBitmap, transparent_color: PColor,
                                      filename: cstring): PPixmap{.cdecl,
    dynlib: lib, importc: "gdk_pixmap_colormap_create_from_xpm".}
proc pixmap_create_from_xpm_d*(window: PWindow, k: var PBitmap,
                               transparent_color: PColor, data: PPgchar): PPixmap{.
    cdecl, dynlib: lib, importc: "gdk_pixmap_create_from_xpm_d".}
proc pixmap_colormap_create_from_xpm_d*(window: PWindow, colormap: PColormap,
                                        k: var PBitmap,
                                        transparent_color: PColor, data: PPgchar): PPixmap{.
    cdecl, dynlib: lib, importc: "gdk_pixmap_colormap_create_from_xpm_d".}
proc pixmap_foreign_new_for_display*(display: PDisplay, anid: TNativeWindow): PPixmap{.
    cdecl, dynlib: lib, importc: "gdk_pixmap_foreign_new_for_display".}
proc pixmap_lookup_for_display*(display: PDisplay, anid: TNativeWindow): PPixmap{.
    cdecl, dynlib: lib, importc: "gdk_pixmap_lookup_for_display".}
