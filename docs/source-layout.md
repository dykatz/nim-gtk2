# Source layout

`src/gtk2ui.nim` and `src/gtk2ui/` contain the ergonomic ARC/ORC API.
All raw bindings, platform adapters, and vendored Nim dependencies live under
`src/headers/`. These are Nim declarations, not bundled native C headers.

```text
src/
  gtk2ui.nim
  gtk2ui/
  headers/
    gtk2.nim                  # Raw GTK umbrella
    gtk2/
      window.nim              # Window declarations
      window_types.nim        # Native types
      window_2.nim            # Later declaration/implementation phases
      shared_types.nim        # Cross-header recursive ABI types
      ...
      newwidgets.nim          # Generated additions umbrella
      newwidgets/
        types.nim
        aboutdialog.nim
        iconview.nim
        ...
    glib2.nim                 # GLib/GObject umbrella
    glib2/
    gdk2.nim
    gdk2/
    atk.nim
    atk/
    pango.nim
    pango/
    gdk2pixbuf.nim
    gdk2pixbuf/
    xkb.nim
    xkb/
    cairo.nim                 # Already focused on cairo.h
    xlib.nim                  # Already focused on Xlib.h
    freetype.nim
    freetype/                 # Existing upstream header-oriented modules
    ...                       # Other focused bindings/adapters
```

## Importing

Applications using only `gtk2ui` need no import changes. Raw imports now use the
`headers/` namespace, with the same public symbol names:

```nim
import gtk2ui
import headers/gtk2 as rawGtk
import headers/glib2 as g
import headers/gdk2pixbuf as rawPixbuf
```

Other raw modules follow the same rule, e.g. `headers/cairo`, `headers/xlib`,
and `headers/freetype`. Keep `--path:src`; do not add `src/headers` as a separate
search path or mix old and new import styles. No compatibility modules remain
at the old `src/gtk2.nim`, `src/glib2.nim`, etc. paths.

## Include fragments and dependencies

Import the umbrella, **not** its internal fragments. The umbrellas use Nim
`include` so overloads, private helpers, ABI declarations, and public symbols
remain in the same module rather than becoming independent submodule APIs.

Combined GTK, GDK, GLib/GObject, ATK, Pango, Pixbuf, and XKB bindings are divided
by native-header family. Numbered parts preserve separate declaration and
implementation phases. They are not compatibility layers or duplicate APIs.
Type-only parts have a `_types` suffix. Header names follow native spelling
(e.g. `gtktreeview.h` becomes `gtk2/treeview*.nim`).

Nim requires mutually recursive types in one `type` section. Some native
structs and callback signatures reference types from several C headers; those
strongly connected declarations remain together in `shared_types*.nim`.
Independent type groups are ordered after their dependencies. Struct fields,
inheritance, callbacks, enum widths, calling conventions, and pointer semantics
are unchanged. Smaller bindings already corresponding to a native header and
the vendored FreeType hierarchy retain their focused layout.

Use `rg` within the corresponding header family to locate a declaration. Edit
hand-maintained fragments directly; retain the umbrella's phase ordering.
Generated fragments under `gtk2/newwidgets/` must instead be regenerated with:

```sh
python3 tools/generate_widgets.py
python3 tools/generate_widgets.py --check
```

The generator reads the legacy include tree while excluding its own additions,
then produces a shared generated type section and per-header function files.
The symbol manifest remains `tests/new_widget_symbols.txt`.

## Checks

`nimble testHeaderLayout` checks that raw modules stay under `headers`, includes
resolve without cycles/duplicates, and no split fragments are orphaned. It needs
Python 3.9+, but no native libraries or C headers. Existing binding, ABI, hidden
UI, calculator, and example checks use the new import paths.
