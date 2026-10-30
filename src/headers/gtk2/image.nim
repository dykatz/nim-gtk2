# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IMAGE*(): GType
proc IMAGE*(obj: pointer): PImage
proc IMAGE_CLASS*(klass: pointer): PImageClass
proc IS_IMAGE*(obj: pointer): bool
proc IS_IMAGE_CLASS*(klass: pointer): bool
proc IMAGE_GET_CLASS*(obj: pointer): PImageClass
proc image_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_image_get_type".}
proc image_new*(): PImage{.cdecl, dynlib: lib, importc: "gtk_image_new".}
proc image_new_from_pixmap*(pixmap: gdk2.PPixmap, mask: gdk2.PBitmap): PImage{.
    cdecl, dynlib: lib, importc: "gtk_image_new_from_pixmap".}
proc image_new_from_image*(image: gdk2.PImage, mask: gdk2.PBitmap): PImage{.cdecl,
    dynlib: lib, importc: "gtk_image_new_from_image".}
proc image_new_from_file*(filename: cstring): PImage{.cdecl, dynlib: lib,
    importc: "gtk_image_new_from_file".}
proc image_new_from_pixbuf*(pixbuf: gdk2pixbuf.PPixbuf): PImage{.cdecl, dynlib: lib,
    importc: "gtk_image_new_from_pixbuf".}
proc image_new_from_stock*(stock_id: cstring, size: TIconSize): PImage{.cdecl,
    dynlib: lib, importc: "gtk_image_new_from_stock".}
proc image_new_from_icon_name*(filename: cstring, size: TIconSize): PImage{.cdecl,
    dynlib: lib, importc: "gtk_image_new_from_icon_name".}
proc image_new_from_icon_set*(icon_set: PIconSet, size: TIconSize): PImage{.
    cdecl, dynlib: lib, importc: "gtk_image_new_from_icon_set".}
proc image_new_from_animation*(animation: gdk2pixbuf.PPixbufAnimation): PImage{.cdecl,
    dynlib: lib, importc: "gtk_image_new_from_animation".}
proc set_from_pixmap*(image: PImage, pixmap: gdk2.PPixmap, mask: gdk2.PBitmap){.
    cdecl, dynlib: lib, importc: "gtk_image_set_from_pixmap".}
proc set_from_image*(image: PImage, gdk_image: gdk2.PImage, mask: gdk2.PBitmap){.
    cdecl, dynlib: lib, importc: "gtk_image_set_from_image".}
proc set_from_file*(image: PImage, filename: cstring){.cdecl, dynlib: lib,
    importc: "gtk_image_set_from_file".}
proc set_from_pixbuf*(image: PImage, pixbuf: gdk2pixbuf.PPixbuf){.cdecl,
    dynlib: lib, importc: "gtk_image_set_from_pixbuf".}
proc set_from_stock*(image: PImage, stock_id: cstring, size: TIconSize){.
    cdecl, dynlib: lib, importc: "gtk_image_set_from_stock".}
proc set_from_icon_set*(image: PImage, icon_set: PIconSet, size: TIconSize){.
    cdecl, dynlib: lib, importc: "gtk_image_set_from_icon_set".}
proc set_from_animation*(image: PImage, animation: gdk2pixbuf.PPixbufAnimation){.
    cdecl, dynlib: lib, importc: "gtk_image_set_from_animation".}
proc clear*(image: PImage) {.cdecl, dynlib: lib, importc: "gtk_image_clear".}
proc set_from_icon_name*(image: PImage, icon_name: cstring, size: TIconSize) {.cdecl,
    dynlib: lib, importc: "gtk_image_set_from_icon_name".}
proc get_icon_name*(image: PImage, icon_name: ptr cstring, size: PIconSize) {.cdecl,
    dynlib: lib, importc: "gtk_image_get_icon_name".}
proc set_pixel_size*(image: PImage, pixel_size: gint) {.cdecl, dynlib: lib,
    importc: "gtk_image_set_pixel_size".}
proc get_pixel_size*(image: PImage): gint {.cdecl, dynlib: lib,
    importc: "gtk_image_get_pixel_size".}
proc get_storage_type*(image: PImage): TImageType{.cdecl, dynlib: lib,
    importc: "gtk_image_get_storage_type".}
proc get_pixbuf*(image: PImage): gdk2pixbuf.PPixbuf{.cdecl, dynlib: lib,
    importc: "gtk_image_get_pixbuf".}
proc get_stock*(image: PImage, stock_id: PPgchar, size: PIconSize){.cdecl,
    dynlib: lib, importc: "gtk_image_get_stock".}
proc get_animation*(image: PImage): gdk2pixbuf.PPixbufAnimation{.cdecl,
    dynlib: lib, importc: "gtk_image_get_animation".}
