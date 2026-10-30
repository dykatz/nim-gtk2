# Included by headers/gdk2.nim; do not import directly.
proc render_threshold_alpha*(pixbuf: PPixbuf, bitmap: PBitmap,
                                    src_x: int32, src_y: int32, dest_x: int32,
                                    dest_y: int32, width: int32, height: int32,
                                    alpha_threshold: int32){.cdecl, dynlib: lib,
    importc: "gdk_pixbuf_render_threshold_alpha".}
proc render_to_drawable*(pixbuf: PPixbuf, drawable: PDrawable, gc: PGC,
                                src_x: int32, src_y: int32, dest_x: int32,
                                dest_y: int32, width: int32, height: int32,
                                dither: TRgbDither, x_dither: int32,
                                y_dither: int32){.cdecl, dynlib: lib,
    importc: "gdk_pixbuf_render_to_drawable".}
proc render_to_drawable_alpha*(pixbuf: PPixbuf, drawable: PDrawable,
                                      src_x: int32, src_y: int32, dest_x: int32,
                                      dest_y: int32, width: int32,
                                      height: int32,
                                      alpha_mode: TPixbufAlphaMode,
                                      alpha_threshold: int32,
                                      dither: TRgbDither, x_dither: int32,
                                      y_dither: int32){.cdecl, dynlib: lib,
    importc: "gdk_pixbuf_render_to_drawable_alpha".}
proc render_pixmap_and_mask_for_colormap*(pixbuf: PPixbuf,
    colormap: PColormap, n: var PPixmap, nasdfdsafw4e: var PBitmap,
    alpha_threshold: int32){.cdecl, dynlib: lib, importc: "gdk_pixbuf_render_pixmap_and_mask_for_colormap".}
proc get_from_drawable*(dest: PPixbuf, src: PDrawable, cmap: PColormap,
                               src_x: int32, src_y: int32, dest_x: int32,
                               dest_y: int32, width: int32, height: int32): PPixbuf{.
    cdecl, dynlib: lib, importc: "gdk_pixbuf_get_from_drawable".}
proc get_from_image*(dest: PPixbuf, src: PImage, cmap: PColormap,
                            src_x: int32, src_y: int32, dest_x: int32,
                            dest_y: int32, width: int32, height: int32): PPixbuf{.
    cdecl, dynlib: lib, importc: "gdk_pixbuf_get_from_image".}
