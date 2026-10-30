# Included by headers/gdk2.nim; do not import directly.
proc pango_context_get_for_screen*(screen: PScreen): pango.PContext{.cdecl,
    dynlib: lib, importc: "gdk_pango_context_get_for_screen".}
proc pango_context_set_colormap*(context: pango.PContext, colormap: PColormap){.
    cdecl, dynlib: lib, importc: "gdk_pango_context_set_colormap".}
proc pango_layout_line_get_clip_region*(line: PLayoutLine, x_origin: gint,
                                        y_origin: gint, index_ranges: Pgint,
                                        n_ranges: gint): PRegion{.cdecl,
    dynlib: lib, importc: "gdk_pango_layout_line_get_clip_region".}
proc pango_layout_get_clip_region*(layout: PLayout, x_origin: gint,
                                   y_origin: gint, index_ranges: Pgint,
                                   n_ranges: gint): PRegion{.cdecl, dynlib: lib,
    importc: "gdk_pango_layout_get_clip_region".}
proc pango_attr_stipple_new*(stipple: PBitmap): PAttribute{.cdecl,
    dynlib: lib, importc: "gdk_pango_attr_stipple_new".}
proc pango_attr_embossed_new*(embossed: gboolean): PAttribute{.cdecl,
    dynlib: lib, importc: "gdk_pango_attr_embossed_new".}
