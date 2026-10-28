# Bundled bindings

The Nim source modules from the following MIT-licensed projects are copied into
`src/`, retaining their original module names and source copyright notices:

| Project | Upstream | Revision | Sources |
| --- | --- | --- | --- |
| Cairo | https://github.com/nim-lang/cairo | `87c56bfce4be5ed978a8a7520503d0e76a7995dd` | `src/*.nim` |
| X11 | https://github.com/nim-lang/x11 | `29aca5e519ebf5d833f63a6a2769e62ec7bfb83a` | `x11/*.nim` |
| FreeType | https://github.com/jangko/freetype | `22b81d059d17ebb393469a3ee11e6f443e18ad5e` | `freetype.nim`, `freetype/*.nim` |

Upstream license texts are preserved in `cairo/LICENSE`, `x11/LICENSE` and
`freetype/LICENSE.TXT`.
Local changes: `cairoxlib.nim` uses the current X11 type names `Drawable` and
`Pixmap` instead of the obsolete `TDrawable` and `TPixmap` aliases. The GTK
`gdk2x` adapter likewise uses `XID` instead of `TXID`. `cairoft.nim` imports
`freetype` and uses its `FT_Face` pointer type in place of the unavailable
`freetypeh` module's `TFT_Face`. The FreeType sources are otherwise unmodified
and retain their upstream directory structure.
X11 modules live directly in `src/` to support the existing unqualified imports
in `gdk2x` and `cairoxlib`.

These are Nim bindings, not bundled native libraries. GTK2, Cairo and (when
using the X11 backend) X11 shared libraries must still be installed on the host.
The FreeType Nim bindings are bundled as well; the `cairoft` adapter requires
the native FreeType library, not a separate Nim package. The smoke test checks
this adapter without loading native libraries. Platform-specific adapters
require their corresponding platform.
