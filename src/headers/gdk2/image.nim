# Included by headers/gdk2.nim; do not import directly.
proc TYPE_IMAGE*(): GType
proc IMAGE*(anObject: pointer): PImage
proc IMAGE_CLASS*(klass: pointer): PImageClass
proc IS_IMAGE*(anObject: pointer): bool
proc IS_IMAGE_CLASS*(klass: pointer): bool
proc IMAGE_GET_CLASS*(obj: pointer): PImageClass
proc image_get_type*(): GType{.cdecl, dynlib: lib, importc: "gdk_image_get_type".}
proc image_new*(`type`: TImageType, visual: PVisual, width: gint, height: gint): PImage{.
    cdecl, dynlib: lib, importc: "gdk_image_new".}
proc put_pixel*(image: PImage, x: gint, y: gint, pixel: guint32){.cdecl,
    dynlib: lib, importc: "gdk_image_put_pixel".}
proc get_pixel*(image: PImage, x: gint, y: gint): guint32{.cdecl,
    dynlib: lib, importc: "gdk_image_get_pixel".}
proc set_colormap*(image: PImage, colormap: PColormap){.cdecl,
    dynlib: lib, importc: "gdk_image_set_colormap".}
proc get_colormap*(image: PImage): PColormap{.cdecl, dynlib: lib,
    importc: "gdk_image_get_colormap".}
