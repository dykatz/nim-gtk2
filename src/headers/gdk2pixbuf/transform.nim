# Included by headers/gdk2pixbuf.nim; do not import directly.
proc scale*(src: PPixbuf, dest: PPixbuf, dest_x: int32, dest_y: int32,
                   dest_width: int32, dest_height: int32, offset_x: float64,
                   offset_y: float64, scale_x: float64, scale_y: float64,
                   interp_type: TInterpType){.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_scale".}
proc composite*(src: PPixbuf, dest: PPixbuf, dest_x: int32,
                       dest_y: int32, dest_width: int32, dest_height: int32,
                       offset_x: float64, offset_y: float64, scale_x: float64,
                       scale_y: float64, interp_type: TInterpType,
                       overall_alpha: int32){.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_composite".}
proc composite_color*(src: PPixbuf, dest: PPixbuf, dest_x: int32,
                             dest_y: int32, dest_width: int32,
                             dest_height: int32, offset_x: float64,
                             offset_y: float64, scale_x: float64,
                             scale_y: float64, interp_type: TInterpType,
                             overall_alpha: int32, check_x: int32,
                             check_y: int32, check_size: int32, color1: guint32,
                             color2: guint32){.cdecl, dynlib: pixbuflib,
    importc: "gdk_pixbuf_composite_color".}
proc scale_simple*(src: PPixbuf, dest_width: int32, dest_height: int32,
                          interp_type: TInterpType): PPixbuf{.cdecl,
    dynlib: pixbuflib, importc: "gdk_pixbuf_scale_simple".}
proc composite_color_simple*(src: PPixbuf, dest_width: int32,
                                    dest_height: int32,
                                    interp_type: TInterpType,
                                    overall_alpha: int32, check_size: int32,
                                    color1: guint32, color2: guint32): PPixbuf{.
    cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_composite_color_simple".}
