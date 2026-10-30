# Included by headers/gdk2pixbuf.nim; do not import directly.
proc get_colorspace*(pixbuf: PPixbuf): TColorspace{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_get_colorspace".}
proc get_n_channels*(pixbuf: PPixbuf): int32{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_get_n_channels".}
proc get_has_alpha*(pixbuf: PPixbuf): gboolean{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_get_has_alpha".}
proc get_bits_per_sample*(pixbuf: PPixbuf): int32{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_get_bits_per_sample".}
proc get_pixels*(pixbuf: PPixbuf): Pguchar{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_get_pixels".}
proc get_width*(pixbuf: PPixbuf): int32{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_get_width".}
proc get_height*(pixbuf: PPixbuf): int32{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_get_height".}
proc get_rowstride*(pixbuf: PPixbuf): int32{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_get_rowstride".}
proc pixbuf_new*(colorspace: TColorspace, has_alpha: gboolean,
                 bits_per_sample: int32, width: int32, height: int32): PPixbuf{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_new".}
proc copy*(pixbuf: PPixbuf): PPixbuf{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_copy".}
proc new_subpixbuf*(src_pixbuf: PPixbuf, src_x: int32, src_y: int32,
                           width: int32, height: int32): PPixbuf{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_new_subpixbuf".}
proc pixbuf_new_from_file*(filename: cstring, error: ptr ptr GError): PPixbuf{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_new_from_file".}
proc pixbuf_new_from_data*(data: Pguchar, colorspace: TColorspace,
                           has_alpha: gboolean, bits_per_sample: int32,
                           width: int32, height: int32, rowstride: int32,
                           destroy_fn: TPixbufDestroyNotify,
                           destroy_fn_data: gpointer): PPixbuf{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_new_from_data".}
proc pixbuf_new_from_xpm_data*(data: PPchar): PPixbuf{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_new_from_xpm_data".}
proc pixbuf_new_from_inline*(data_length: gint, a: var guint8,
                             copy_pixels: gboolean, error: pointer): PPixbuf{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_new_from_inline".}
proc pixbuf_new_from_file_at_size*(filename: cstring, width, height: gint,
                                   error: pointer): PPixbuf{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_new_from_file_at_size".}
proc pixbuf_new_from_file_at_scale*(filename: cstring, width, height: gint,
                                    preserve_aspect_ratio: gboolean,
                                    error: pointer): PPixbuf{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_new_from_file_at_scale".}
proc fill*(pixbuf: PPixbuf, pixel: guint32){.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_fill".}
proc save*(pixbuf: PPixbuf, filename: cstring, `type`: cstring,
                  error: pointer): gboolean{.cdecl, varargs, dynlib: pixbuflib,
    importc: "gdk_pixbuf_save".}
proc savev*(pixbuf: PPixbuf, filename: cstring, `type`: cstring,
                   option_keys: PPchar, option_values: PPchar, error: pointer): gboolean{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_savev".}
proc add_alpha*(pixbuf: PPixbuf, substitute_color: gboolean, r: guchar,
                       g: guchar, b: guchar): PPixbuf{.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_add_alpha".}
proc copy_area*(src_pixbuf: PPixbuf, src_x: int32, src_y: int32,
                       width: int32, height: int32, dest_pixbuf: PPixbuf,
                       dest_x: int32, dest_y: int32){.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_copy_area".}
proc saturate_and_pixelate*(src: PPixbuf, dest: PPixbuf,
                                   saturation: gfloat, pixelate: gboolean){.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_saturate_and_pixelate".}
