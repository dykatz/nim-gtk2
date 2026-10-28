# Bundled bindings

The Nim source modules from the following MIT-licensed projects are copied into
`src/`, retaining their original module names and source copyright notices:

| Project | Upstream | Revision | Sources |
| --- | --- | --- | --- |
| Cairo | https://github.com/nim-lang/cairo | `87c56bfce4be5ed978a8a7520503d0e76a7995dd` | `src/*.nim` |
| X11 | https://github.com/nim-lang/x11 | `29aca5e519ebf5d833f63a6a2769e62ec7bfb83a` | `x11/*.nim` |

Upstream license texts are preserved in `cairo/LICENSE` and `x11/LICENSE`.
Local changes: `cairoxlib.nim` uses the current X11 type names `Drawable` and
`Pixmap` instead of the obsolete `TDrawable` and `TPixmap` aliases. The GTK
`gdk2x` adapter likewise uses `XID` instead of `TXID`.
X11 modules live directly in `src/` to support the existing unqualified imports
in `gdk2x` and `cairoxlib`.

These are Nim bindings, not bundled native libraries. GTK2, Cairo and (when
using the X11 backend) X11 shared libraries must still be installed on the host.
The optional FreeType adapter `cairoft` also requires the separate Nim
`freetypeh` module; it is not imported by the core GTK2 bindings or the smoke
test. Platform-specific adapters require their corresponding platform.
