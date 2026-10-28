# Compile/check only: importing these modules must not require external Nim
# Cairo, X11 or FreeType packages, nor open a window or load native libraries.
import gtk2, cairo, cairoft, freetype, gtk2ui

static:
  doAssert declared(gtk2ui.newWindow)
  doAssert declared(gtk2.PWidget)
  doAssert declared(cairo.Context)
  doAssert declared(freetype.FT_Face)
  doAssert compiles(block:
    let face: freetype.FT_Face = nil
    let fontFace: cairo.PFontFace = cairoft.ftFontFaceCreateForFtFace(face, 0)
    let lockedFace: freetype.FT_Face = cairoft.ftScaledFontLockFace(nil)
    discard fontFace
    discard lockedFace)

when defined(posix) and not defined(macosx):
  import gdk2x, cairoxlib, x, xlib, xutil

  static:
    doAssert declared(gdk2x.x11_drawable_get_xdisplay)
    doAssert declared(cairoxlib.xlibSurfaceCreate)
    doAssert declared(x.XID)
    doAssert declared(xlib.PDisplay)
    doAssert declared(xutil.XVisualInfo)
