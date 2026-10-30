# Included by headers/gdk2.nim; do not import directly.
type
  TDrawableClass* = object of TGObjectClass
    create_gc*: proc (drawable: PDrawable, values: PGCValues,
                      mask: TGCValuesMask): PGC{.cdecl.}
    draw_rectangle*: proc (drawable: PDrawable, gc: PGC, filled: gint, x: gint,
                           y: gint, width: gint, height: gint){.cdecl.}
    draw_arc*: proc (drawable: PDrawable, gc: PGC, filled: gint, x: gint,
                     y: gint, width: gint, height: gint, angle1: gint,
                     angle2: gint){.cdecl.}
    draw_polygon*: proc (drawable: PDrawable, gc: PGC, filled: gint,
                         points: PPoint, npoints: gint){.cdecl.}
    draw_text*: proc (drawable: PDrawable, font: PFont, gc: PGC, x: gint,
                      y: gint, text: cstring, text_length: gint){.cdecl.}
    draw_text_wc*: proc (drawable: PDrawable, font: PFont, gc: PGC, x: gint,
                         y: gint, text: PWChar, text_length: gint){.cdecl.}
    draw_drawable*: proc (drawable: PDrawable, gc: PGC, src: PDrawable,
                          xsrc: gint, ysrc: gint, xdest: gint, ydest: gint,
                          width: gint, height: gint){.cdecl.}
    draw_points*: proc (drawable: PDrawable, gc: PGC, points: PPoint,
                        npoints: gint){.cdecl.}
    draw_segments*: proc (drawable: PDrawable, gc: PGC, segs: PSegment,
                          nsegs: gint){.cdecl.}
    draw_lines*: proc (drawable: PDrawable, gc: PGC, points: PPoint,
                       npoints: gint){.cdecl.}
    draw_glyphs*: proc (drawable: PDrawable, gc: PGC, font: PFont, x: gint,
                        y: gint, glyphs: PGlyphString){.cdecl.}
    draw_image*: proc (drawable: PDrawable, gc: PGC, image: PImage, xsrc: gint,
                       ysrc: gint, xdest: gint, ydest: gint, width: gint,
                       height: gint){.cdecl.}
    get_depth*: proc (drawable: PDrawable): gint{.cdecl.}
    get_size*: proc (drawable: PDrawable, width: Pgint, height: Pgint){.cdecl.}
    set_colormap*: proc (drawable: PDrawable, cmap: PColormap){.cdecl.}
    get_colormap*: proc (drawable: PDrawable): PColormap{.cdecl.}
    get_visual*: proc (drawable: PDrawable): PVisual{.cdecl.}
    get_screen*: proc (drawable: PDrawable): PScreen{.cdecl.}
    get_image*: proc (drawable: PDrawable, x: gint, y: gint, width: gint,
                      height: gint): PImage{.cdecl.}
    get_clip_region*: proc (drawable: PDrawable): PRegion{.cdecl.}
    get_visible_region*: proc (drawable: PDrawable): PRegion{.cdecl.}
    get_composite_drawable*: proc (drawable: PDrawable, x: gint, y: gint,
                                   width: gint, height: gint,
                                   composite_x_offset: Pgint,
                                   composite_y_offset: Pgint): PDrawable{.cdecl.}
    `draw_pixbuf`*: proc (drawable: PDrawable, gc: PGC, pixbuf: PPixbuf,
                          src_x: gint, src_y: gint, dest_x: gint, dest_y: gint,
                          width: gint, height: gint, dither: TRgbDither,
                          x_dither: gint, y_dither: gint){.cdecl.}
    `copy_to_image`*: proc (drawable: PDrawable, image: PImage, src_x: gint,
                            src_y: gint, dest_x: gint, dest_y: gint,
                            width: gint, height: gint): PImage{.cdecl.}
    `reserved1`: proc (){.cdecl.}
    `reserved2`: proc (){.cdecl.}
    `reserved3`: proc (){.cdecl.}
    `reserved4`: proc (){.cdecl.}
    `reserved5`: proc (){.cdecl.}
    `reserved6`: proc (){.cdecl.}
    `reserved7`: proc (){.cdecl.}
    `reserved9`: proc (){.cdecl.}
    `reserved10`: proc (){.cdecl.}
    `reserved11`: proc (){.cdecl.}
    `reserved12`: proc (){.cdecl.}
    `reserved13`: proc (){.cdecl.}
    `reserved14`: proc (){.cdecl.}
    `reserved15`: proc (){.cdecl.}
    `reserved16`: proc (){.cdecl.}

  PDrawableClass* = ptr TDrawableClass
