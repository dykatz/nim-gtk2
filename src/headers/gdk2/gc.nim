# Included by headers/gdk2.nim; do not import directly.
const
  GC_FOREGROUND* = 1 shl 0
const
  GC_BACKGROUND* = 1 shl 1
const
  GC_FONT* = 1 shl 2
const
  GC_FUNCTION* = 1 shl 3
const
  GC_FILL* = 1 shl 4
const
  GC_TILE* = 1 shl 5
const
  GC_STIPPLE* = 1 shl 6
const
  GC_CLIP_MASK* = 1 shl 7
const
  GC_SUBWINDOW* = 1 shl 8
const
  GC_TS_X_ORIGIN* = 1 shl 9
const
  GC_TS_Y_ORIGIN* = 1 shl 10
const
  GC_CLIP_X_ORIGIN* = 1 shl 11
const
  GC_CLIP_Y_ORIGIN* = 1 shl 12
const
  GC_EXPOSURES* = 1 shl 13
const
  GC_LINE_WIDTH* = 1 shl 14
const
  GC_LINE_STYLE* = 1 shl 15
const
  GC_CAP_STYLE* = 1 shl 16
const
  GC_JOIN_STYLE* = 1 shl 17
const
  CLIP_BY_CHILDREN* = 0
const
  INCLUDE_INFERIORS* = 1

proc TYPE_GC*(): GType
proc GC*(anObject: pointer): PGC
proc GC_CLASS*(klass: pointer): PGCClass
proc IS_GC*(anObject: pointer): bool
proc IS_GC_CLASS*(klass: pointer): bool
proc GC_GET_CLASS*(obj: pointer): PGCClass
proc gc_get_type*(): GType{.cdecl, dynlib: lib, importc: "gdk_gc_get_type".}
proc gc_new*(drawable: PDrawable): PGC{.cdecl, dynlib: lib,
                                        importc: "gdk_gc_new".}
proc gc_new*(drawable: PDrawable, values: PGCValues,
                         values_mask: TGCValuesMask): PGC{.cdecl, dynlib: lib,
    importc: "gdk_gc_new_with_values".}
proc get_values*(gc: PGC, values: PGCValues){.cdecl, dynlib: lib,
    importc: "gdk_gc_get_values".}
proc set_values*(gc: PGC, values: PGCValues, values_mask: TGCValuesMask){.
    cdecl, dynlib: lib, importc: "gdk_gc_set_values".}
proc set_foreground*(gc: PGC, color: PColor){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_foreground".}
proc set_background*(gc: PGC, color: PColor){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_background".}
proc set_function*(gc: PGC, `function`: TFunction){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_function".}
proc set_fill*(gc: PGC, fill: TFill){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_fill".}
proc set_tile*(gc: PGC, tile: PPixmap){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_tile".}
proc set_stipple*(gc: PGC, stipple: PPixmap){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_stipple".}
proc set_ts_origin*(gc: PGC, x: gint, y: gint){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_ts_origin".}
proc set_clip_origin*(gc: PGC, x: gint, y: gint){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_clip_origin".}
proc set_clip_mask*(gc: PGC, mask: PBitmap){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_clip_mask".}
proc set_clip_rectangle*(gc: PGC, rectangle: PRectangle){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_clip_rectangle".}
proc set_clip_region*(gc: PGC, region: PRegion){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_clip_region".}
proc set_subwindow*(gc: PGC, mode: TSubwindowMode){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_subwindow".}
proc set_exposures*(gc: PGC, exposures: gboolean){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_exposures".}
proc set_line_attributes*(gc: PGC, line_width: gint, line_style: TLineStyle,
                             cap_style: TCapStyle, join_style: TJoinStyle){.
    cdecl, dynlib: lib, importc: "gdk_gc_set_line_attributes".}
proc set_dashes*(gc: PGC, dash_offset: gint, dash_list: openarray[gint8]){.
    cdecl, dynlib: lib, importc: "gdk_gc_set_dashes".}
proc offset*(gc: PGC, x_offset: gint, y_offset: gint){.cdecl, dynlib: lib,
    importc: "gdk_gc_offset".}
proc copy*(dst_gc: PGC, src_gc: PGC){.cdecl, dynlib: lib,
    importc: "gdk_gc_copy".}
proc set_colormap*(gc: PGC, colormap: PColormap){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_colormap".}
proc get_colormap*(gc: PGC): PColormap{.cdecl, dynlib: lib,
    importc: "gdk_gc_get_colormap".}
proc set_rgb_fg_color*(gc: PGC, color: PColor){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_rgb_fg_color".}
proc set_rgb_bg_color*(gc: PGC, color: PColor){.cdecl, dynlib: lib,
    importc: "gdk_gc_set_rgb_bg_color".}
proc get_screen*(gc: PGC): PScreen{.cdecl, dynlib: lib,
                                       importc: "gdk_gc_get_screen".}
