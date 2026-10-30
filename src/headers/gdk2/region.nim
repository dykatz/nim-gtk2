# Included by headers/gdk2.nim; do not import directly.
proc region_new*(): PRegion{.cdecl, dynlib: lib, importc: "gdk_region_new".}
proc region_polygon*(points: PPoint, npoints: gint, fill_rule: TFillRule): PRegion{.
    cdecl, dynlib: lib, importc: "gdk_region_polygon".}
proc copy*(region: PRegion): PRegion{.cdecl, dynlib: lib,
    importc: "gdk_region_copy".}
proc region_rectangle*(rectangle: PRectangle): PRegion{.cdecl, dynlib: lib,
    importc: "gdk_region_rectangle".}
proc destroy*(region: PRegion){.cdecl, dynlib: lib,
                                       importc: "gdk_region_destroy".}
proc get_clipbox*(region: PRegion, rectangle: PRectangle){.cdecl,
    dynlib: lib, importc: "gdk_region_get_clipbox".}
proc get_rectangles*(region: PRegion, s: var PRectangle,
                            n_rectangles: Pgint){.cdecl, dynlib: lib,
    importc: "gdk_region_get_rectangles".}
proc empty*(region: PRegion): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_region_empty".}
proc equal*(region1: PRegion, region2: PRegion): gboolean{.cdecl,
    dynlib: lib, importc: "gdk_region_equal".}
proc point_in*(region: PRegion, x: int32, y: int32): gboolean{.cdecl,
    dynlib: lib, importc: "gdk_region_point_in".}
proc rect_in*(region: PRegion, rect: PRectangle): TOverlapType{.cdecl,
    dynlib: lib, importc: "gdk_region_rect_in".}
proc offset*(region: PRegion, dx: gint, dy: gint){.cdecl, dynlib: lib,
    importc: "gdk_region_offset".}
proc shrink*(region: PRegion, dx: gint, dy: gint){.cdecl, dynlib: lib,
    importc: "gdk_region_shrink".}
proc union*(region: PRegion, rect: PRectangle){.cdecl,
    dynlib: lib, importc: "gdk_region_union_with_rect".}
proc intersect*(source1: PRegion, source2: PRegion){.cdecl, dynlib: lib,
    importc: "gdk_region_intersect".}
proc union*(source1: PRegion, source2: PRegion){.cdecl, dynlib: lib,
    importc: "gdk_region_union".}
proc subtract*(source1: PRegion, source2: PRegion){.cdecl, dynlib: lib,
    importc: "gdk_region_subtract".}
proc `xor`*(source1: PRegion, source2: PRegion){.cdecl, dynlib: lib,
    importc: "gdk_region_xor".}
proc spans_intersect_foreach*(region: PRegion, spans: PSpan,
                                     n_spans: int32, sorted: gboolean,
                                     `function`: TSpanFunc, data: gpointer){.
    cdecl, dynlib: lib, importc: "gdk_region_spans_intersect_foreach".}
