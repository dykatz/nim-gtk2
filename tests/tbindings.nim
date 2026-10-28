# Compile/check only: importing these modules must not require external Nim
# Cairo or X11 packages, nor open a window or load optional native libraries.
import gtk2, cairo

static:
  doAssert declared(gtk2.PWidget)
  doAssert declared(cairo.Context)

when defined(posix) and not defined(macosx):
  import gdk2x, cairoxlib, x, xlib, xutil

  static:
    doAssert declared(gdk2x.x11_drawable_get_xdisplay)
    doAssert declared(cairoxlib.xlibSurfaceCreate)
    doAssert declared(x.XID)
    doAssert declared(xlib.PDisplay)
    doAssert declared(xutil.XVisualInfo)
