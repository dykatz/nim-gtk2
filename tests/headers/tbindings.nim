# Compile/check only: no external Nim Cairo/X11/FreeType packages, no windows,
# and no calls into native libraries. Use actual typed expressions to check API
# boundaries rather than just testing whether an old name happens to exist.
import headers/gtk2, headers/cairo, headers/cairoft, headers/freetype, gtk2ui

static:
  doAssert compiles(block:
    let window: gtk2ui.Window = gtk2ui.newWindow()
    let widget: gtk2.PWidget = cast[gtk2.PWidget](window.raw)
    let face: freetype.FT_Face = nil
    let fontFace: ptr cairo.FontFace = cairoft.ftFontFaceCreateForFtFace(face, 0)
    let lockedFace: freetype.FT_Face = cairoft.ftScaledFontLockFace(nil)
    discard widget
    discard fontFace
    discard lockedFace)

when defined(posix) and not defined(macosx):
  import headers/gdk2x, headers/cairoxlib, headers/x, headers/xlib, headers/xutil

  static:
    doAssert compiles(block:
      let display: xlib.PDisplay = gdk2x.x11_drawable_get_xdisplay(nil)
      let xid: x.XID = gdk2x.x11_drawable_get_xid(nil)
      let info = default(xutil.XVisualInfo)
      let surface: ptr cairo.Surface = cairoxlib.xlibSurfaceCreate(
        display, x.Drawable(xid), nil, 1, 1)
      discard info
      discard surface)
