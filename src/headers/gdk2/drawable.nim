# Included by headers/gdk2.nim; do not import directly.
proc TYPE_DRAWABLE*(): GType
proc DRAWABLE*(anObject: pointer): PDrawable
proc DRAWABLE_CLASS*(klass: pointer): PDrawableClass
proc IS_DRAWABLE*(anObject: pointer): bool
proc IS_DRAWABLE_CLASS*(klass: pointer): bool
proc DRAWABLE_GET_CLASS*(obj: pointer): PDrawableClass
proc drawable_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "gdk_drawable_get_type".}
proc get_size*(drawable: PDrawable, width: Pgint, height: Pgint){.
    cdecl, dynlib: lib, importc: "gdk_drawable_get_size".}
proc set_colormap*(drawable: PDrawable, colormap: PColormap){.cdecl,
    dynlib: lib, importc: "gdk_drawable_set_colormap".}
proc get_colormap*(drawable: PDrawable): PColormap{.cdecl, dynlib: lib,
    importc: "gdk_drawable_get_colormap".}
proc get_visual*(drawable: PDrawable): PVisual{.cdecl, dynlib: lib,
    importc: "gdk_drawable_get_visual".}
proc get_depth*(drawable: PDrawable): gint{.cdecl, dynlib: lib,
    importc: "gdk_drawable_get_depth".}
proc get_screen*(drawable: PDrawable): PScreen{.cdecl, dynlib: lib,
    importc: "gdk_drawable_get_screen".}
proc get_display*(drawable: PDrawable): PDisplay{.cdecl, dynlib: lib,
    importc: "gdk_drawable_get_display".}
proc point*(drawable: PDrawable, gc: PGC, x: gint, y: gint){.cdecl,
    dynlib: lib, importc: "gdk_draw_point".}
proc line*(drawable: PDrawable, gc: PGC, x1: gint, y1: gint, x2: gint,
                y2: gint){.cdecl, dynlib: lib, importc: "gdk_draw_line".}
proc rectangle*(drawable: PDrawable, gc: PGC, filled: bool, x: gint,
                     y: gint, width: gint, height: gint){.cdecl, dynlib: lib,
    importc: "gdk_draw_rectangle".}
proc arc*(drawable: PDrawable, gc: PGC, filled: bool, x: gint, y: gint,
               width: gint, height: gint, angle1: gint, angle2: gint){.cdecl,
    dynlib: lib, importc: "gdk_draw_arc".}
proc polygon*(drawable: PDrawable, gc: PGC, filled: bool, points: PPoint,
                   npoints: gint){.cdecl, dynlib: lib,
                                   importc: "gdk_draw_polygon".}
proc drawable*(drawable: PDrawable, gc: PGC, src: PDrawable, xsrc: gint,
                    ysrc: gint, xdest: gint, ydest: gint, width: gint,
                    height: gint){.cdecl, dynlib: lib,
                                   importc: "gdk_draw_drawable".}
proc image*(drawable: PDrawable, gc: PGC, image: PImage, xsrc: gint,
                 ysrc: gint, xdest: gint, ydest: gint, width: gint, height: gint){.
    cdecl, dynlib: lib, importc: "gdk_draw_image".}
proc points*(drawable: PDrawable, gc: PGC, points: PPoint, npoints: gint){.
    cdecl, dynlib: lib, importc: "gdk_draw_points".}
proc segments*(drawable: PDrawable, gc: PGC, segs: PSegment, nsegs: gint){.
    cdecl, dynlib: lib, importc: "gdk_draw_segments".}
proc lines*(drawable: PDrawable, gc: PGC, points: PPoint, npoints: gint){.
    cdecl, dynlib: lib, importc: "gdk_draw_lines".}
proc glyphs*(drawable: PDrawable, gc: PGC, font: PFont, x: gint,
                  y: gint, glyphs: PGlyphString){.cdecl, dynlib: lib,
    importc: "gdk_draw_glyphs".}
proc layout_line*(drawable: PDrawable, gc: PGC, x: gint, y: gint,
                       line: PLayoutLine){.cdecl, dynlib: lib,
    importc: "gdk_draw_layout_line".}
proc layout*(drawable: PDrawable, gc: PGC, x: gint, y: gint,
                  layout: PLayout){.cdecl, dynlib: lib,
    importc: "gdk_draw_layout".}
proc layout_line*(drawable: PDrawable, gc: PGC, x: gint,
                                   y: gint, line: PLayoutLine,
                                   foreground: PColor, background: PColor){.
    cdecl, dynlib: lib, importc: "gdk_draw_layout_line_with_colors".}
proc layout*(drawable: PDrawable, gc: PGC, x: gint, y: gint,
                              layout: PLayout, foreground: PColor,
                              background: PColor){.cdecl, dynlib: lib,
    importc: "gdk_draw_layout_with_colors".}
proc get_image*(drawable: PDrawable, x: gint, y: gint, width: gint,
                         height: gint): PImage{.cdecl, dynlib: lib,
    importc: "gdk_drawable_get_image".}
proc get_clip_region*(drawable: PDrawable): PRegion{.cdecl,
    dynlib: lib, importc: "gdk_drawable_get_clip_region".}
proc get_visible_region*(drawable: PDrawable): PRegion{.cdecl,
    dynlib: lib, importc: "gdk_drawable_get_visible_region".}
proc text*(drawable: PDrawable, font: PFont, gc: PGC, x: gint,
                      y: gint, text: cstring, text_length: gint){.cdecl, dynlib: lib,
    importc: "gdk_draw_text".}
proc text_wc*(drawable: PDrawable, font: PFont, gc: PGC, x: gint,
                      y: gint, text: cstring, text_length: gint){.cdecl, dynlib: lib,
    importc: "gdk_draw_text_wc".}
proc string*(drawable: PDrawable, font: PFont, gc: PGC, x: gint,
                      y: gint, text: cstring, text_length: gint){.cdecl, dynlib: lib,
    importc: "gdk_draw_string".}
