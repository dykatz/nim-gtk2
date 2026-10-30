# Included by headers/gdk2.nim; do not import directly.
proc COLORMAP*(anObject: pointer): PColormap
proc COLORMAP_CLASS*(klass: pointer): PColormapClass
proc IS_COLORMAP*(anObject: pointer): bool
proc IS_COLORMAP_CLASS*(klass: pointer): bool
proc COLORMAP_GET_CLASS*(obj: pointer): PColormapClass
proc TYPE_COLOR*(): GType
proc colormap_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "gdk_colormap_get_type".}
proc colormap_new*(visual: PVisual, allocate: gboolean): PColormap{.cdecl,
    dynlib: lib, importc: "gdk_colormap_new".}
proc alloc_colors*(colormap: PColormap, colors: PColor, ncolors: gint,
                            writeable: gboolean, best_match: gboolean,
                            success: Pgboolean): gint{.cdecl, dynlib: lib,
    importc: "gdk_colormap_alloc_colors".}
proc alloc_color*(colormap: PColormap, color: PColor,
                           writeable: gboolean, best_match: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_colormap_alloc_color".}
proc free_colors*(colormap: PColormap, colors: PColor, ncolors: gint){.
    cdecl, dynlib: lib, importc: "gdk_colormap_free_colors".}
proc query_color*(colormap: PColormap, pixel: gulong, result: PColor){.
    cdecl, dynlib: lib, importc: "gdk_colormap_query_color".}
proc get_visual*(colormap: PColormap): PVisual{.cdecl, dynlib: lib,
    importc: "gdk_colormap_get_visual".}
proc copy*(color: PColor): PColor{.cdecl, dynlib: lib,
    importc: "gdk_color_copy".}
proc free*(color: PColor){.cdecl, dynlib: lib, importc: "gdk_color_free".}
proc color_parse*(spec: cstring, color: PColor): bool{.cdecl, dynlib: lib,
    importc: "gdk_color_parse".}
proc to_string*(color: PColor): cstring{.cdecl, dynlib: lib,
    importc: "gdk_color_to_string".}
proc hash*(colora: PColor): guint{.cdecl, dynlib: lib,
    importc: "gdk_color_hash".}
proc equal*(colora: PColor, colorb: PColor): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_color_equal".}
proc color_get_type*(): GType{.cdecl, dynlib: lib, importc: "gdk_color_get_type".}
