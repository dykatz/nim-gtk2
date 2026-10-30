{.push gcsafe.}
import
  glib2

when defined(win32):
  const
    pixbuflib = "libgdk_pixbuf-2.0-0.dll"
elif defined(macosx):
  const
    pixbuflib = "libgdk_pixbuf-2.0.0.dylib"
  # linklib gtk-x11-2.0
  # linklib gdk-x11-2.0
  # linklib pango-1.0.0
  # linklib glib-2.0.0
  # linklib gobject-2.0.0
  # linklib gdk_pixbuf-2.0.0
  # linklib atk-1.0.0
else:
  const
    pixbuflib = "libgdk_pixbuf-2.0.so"
include "gdk2pixbuf/shared_types"
include "gdk2pixbuf/core"
when not declared(PIXBUF_DISABLE_DEPRECATED):
  proc pixbuf_ref*(pixbuf: PPixbuf): PPixbuf{.cdecl, dynlib: pixbuflib,
      importc: "gdk_pixbuf_ref".}
  proc pixbuf_unref*(pixbuf: PPixbuf){.cdecl, dynlib: pixbuflib,
                                       importc: "gdk_pixbuf_unref".}
include "gdk2pixbuf/core_2"
include "gdk2pixbuf/transform"
include "gdk2pixbuf/animation"
when not declared(PIXBUF_DISABLE_DEPRECATED):
  proc pixbuf_animation_ref*(animation: PPixbufAnimation): PPixbufAnimation{.
      cdecl, dynlib: pixbuflib, importc: "gdk_pixbuf_animation_ref".}
  proc pixbuf_animation_unref*(animation: PPixbufAnimation){.cdecl,
      dynlib: pixbuflib, importc: "gdk_pixbuf_animation_unref".}
include "gdk2pixbuf/animation_2"
include "gdk2pixbuf/core_3"
include "gdk2pixbuf/shared_types_2"
include "gdk2pixbuf/core_4"
include "gdk2pixbuf/loader"
{.pop.}
