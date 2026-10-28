#
# Translation of cairo-xlib.h version 1.4
# by Jeffrey Pohlmeyer
# updated to version 1.4 by Luiz Américo Pereira Câmara 2007
#

import
  cairo, x, xlib, xrender

include "cairo_pragma.nim"

proc xlibSurfaceCreate*(dpy: PDisplay, drawable: Drawable, visual: PVisual, width, height: int32): ptr Surface {.cdecl, importc: "cairo_xlib_surface_create", libcairo.}
proc xlibSurfaceCreateForBitmap*(dpy: PDisplay, bitmap: Pixmap, screen: PScreen, width, height: int32): ptr Surface {.cdecl, importc: "cairo_xlib_surface_create_for_bitmap", libcairo.}
proc xlibSurfaceCreateWithXrenderFormat*(dpy: PDisplay, drawable: Drawable, screen: PScreen, format: PXRenderPictFormat, width, height: int32): ptr Surface {.cdecl, importc: "cairo_xlib_surface_create_with_xrender_format", libcairo.}
proc xlibSurfaceGetDepth*(surface: ptr Surface): int32 {.cdecl, importc: "cairo_xlib_surface_get_depth", libcairo.}
proc xlibSurfaceGetDisplay*(surface: ptr Surface): PDisplay {.cdecl, importc: "cairo_xlib_surface_get_display", libcairo.}
proc xlibSurfaceGetDrawable*(surface: ptr Surface): Drawable {.cdecl, importc: "cairo_xlib_surface_get_drawable", libcairo.}
proc xlibSurfaceGetHeight*(surface: ptr Surface): int32 {.cdecl, importc: "cairo_xlib_surface_get_height", libcairo.}
proc xlibSurfaceGetScreen*(surface: ptr Surface): PScreen {.cdecl, importc: "cairo_xlib_surface_get_screen", libcairo.}
proc xlibSurfaceGetVisual*(surface: ptr Surface): PVisual {.cdecl, importc: "cairo_xlib_surface_get_visual", libcairo.}
proc xlibSurfaceGetWidth*(surface: ptr Surface): int32 {.cdecl, importc: "cairo_xlib_surface_get_width", libcairo.}
proc xlibSurfaceSetSize*(surface: ptr Surface, width, height: int32) {.cdecl, importc: "cairo_xlib_surface_set_size", libcairo.}
proc xlibSurfaceSetDrawable*(surface: ptr Surface, drawable: Drawable, width, height: int32) {.cdecl, importc: "cairo_xlib_surface_set_drawable", libcairo.}
