# Included by headers/gdk2.nim; do not import directly.
proc rgb_find_color*(colormap: PColormap, color: PColor){.cdecl, dynlib: lib,
    importc: "gdk_rgb_find_color".}
proc rgb_image*(drawable: PDrawable, gc: PGC, x: gint, y: gint,
                     width: gint, height: gint, dith: TRgbDither,
                     rgb_buf: Pguchar, rowstride: gint){.cdecl, dynlib: lib,
    importc: "gdk_draw_rgb_image".}
proc rgb_image_dithalign*(drawable: PDrawable, gc: PGC, x: gint, y: gint,
                               width: gint, height: gint, dith: TRgbDither,
                               rgb_buf: Pguchar, rowstride: gint, xdith: gint,
                               ydith: gint){.cdecl, dynlib: lib,
    importc: "gdk_draw_rgb_image_dithalign".}
proc rgb_32_image*(drawable: PDrawable, gc: PGC, x: gint, y: gint,
                        width: gint, height: gint, dith: TRgbDither,
                        buf: Pguchar, rowstride: gint){.cdecl, dynlib: lib,
    importc: "gdk_draw_rgb_32_image".}
proc rgb_32_image_dithalign*(drawable: PDrawable, gc: PGC, x: gint,
                                  y: gint, width: gint, height: gint,
                                  dith: TRgbDither, buf: Pguchar,
                                  rowstride: gint, xdith: gint, ydith: gint){.
    cdecl, dynlib: lib, importc: "gdk_draw_rgb_32_image_dithalign".}
proc gray_image*(drawable: PDrawable, gc: PGC, x: gint, y: gint,
                      width: gint, height: gint, dith: TRgbDither, buf: Pguchar,
                      rowstride: gint){.cdecl, dynlib: lib,
                                        importc: "gdk_draw_gray_image".}
proc indexed_image*(drawable: PDrawable, gc: PGC, x: gint, y: gint,
                         width: gint, height: gint, dith: TRgbDither,
                         buf: Pguchar, rowstride: gint, cmap: PRgbCmap){.cdecl,
    dynlib: lib, importc: "gdk_draw_indexed_image".}
proc rgb_cmap_new*(colors: Pguint32, n_colors: gint): PRgbCmap{.cdecl,
    dynlib: lib, importc: "gdk_rgb_cmap_new".}
proc free*(cmap: PRgbCmap){.cdecl, dynlib: lib,
                                     importc: "gdk_rgb_cmap_free".}
proc rgb_set_verbose*(verbose: gboolean){.cdecl, dynlib: lib,
    importc: "gdk_rgb_set_verbose".}
proc rgb_set_install*(install: gboolean){.cdecl, dynlib: lib,
    importc: "gdk_rgb_set_install".}
proc rgb_set_min_colors*(min_colors: gint){.cdecl, dynlib: lib,
    importc: "gdk_rgb_set_min_colors".}
