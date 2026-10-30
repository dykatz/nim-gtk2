
# Installation

Requires Nim 2.0 or newer (tested with Nim 2.3.1) and native GTK 2.24 libraries.
Cairo, X11 and FreeType Nim bindings are bundled; no separate Nimble packages
are needed for these bindings. Native Cairo, X11 and FreeType libraries are
still required when used. See [bundled binding details and licenses](third_party/README.md)
for provenance and optional adapter dependencies.

Install directly from this repository using [Nimble](https://github.com/nim-lang/nimble),
not the older `gtk2` package in the Nimble registry:

```bash
nimble install 'https://github.com/dykatz/nim-gtk2.git#head'
```

# Use this wrapper as part of your nimble package

If you wish to add this wrapper as a dependency to your nimble package then add the following to your .nimble file.

```nim
requires "nim >= 2.0.0", "https://github.com/dykatz/nim-gtk2.git#head"
```

# Ergonomic API

For new applications, `import gtk2` provides a small gtkmm-inspired layer:
typed widgets, Nim properties, layout helpers, and closure-based signals.
Raw bindings remain available for low-level access. This SDK has no legacy
source-compatibility requirement; the calculator is the primary regression target.
GTK2-deprecated widget families are intentionally excluded; see the
[removal inventory and replacements](docs/deprecated-widgets.md).
See the
[API guide and ownership rules](docs/gtk2.md) and
[`examples/ergonomic.nim`](examples/ergonomic.nim).
The control wrappers include toggle/check/radio/link buttons, progress bars,
spinners, frames, expanders, separators, and basic drawing-area handles; see
[`examples/controls.nim`](examples/controls.nim). ScrolledWindow, Viewport,
Notebook, HPaned, and VPaned add scrolling, tabs, and split layouts; see
[`examples/layout.nim`](examples/layout.nim). SpinButton and ComboBoxText add
numeric/text-choice input, with owned Adjustment handles for shared values and
scroll controls; see [`examples/inputs.nim`](examples/inputs.nim). Image, Statusbar,
and InfoBar provide display and feedback, including typed response callbacks;
see [`examples/feedback.nim`](examples/feedback.nim). Dialog, MessageDialog, and
AboutDialog use nonblocking response callbacks and checked parent relationships;
see [`examples/dialogs.nim`](examples/dialogs.nim). TextView and owned TextBuffer
add Unicode-aware multiline editing, shared views, selection, and change signals;
see [`examples/text.nim`](examples/text.nim). Typed ListStore models can be shared
by flat TreeView text columns and model-backed ComboBox choices;
see [`examples/models.nim`](examples/models.nim). TreeStore extends TreeView to
hierarchies with copied paths, selection, expansion, and subtree editing;
see [`examples/trees.nim`](examples/trees.nim). Sorting/filtering proxies and
stable row references add independent views without changing source order;
see [`examples/proxies.nim`](examples/proxies.nim). Owned Pixbuf handles, image
previews, and model-backed IconView are demonstrated in
[`examples/icons.nim`](examples/icons.nim). Calendar, ColorButton, FontButton,
ScaleButton, and VolumeButton add checked dates, copied chooser selections, and
popup values with shared adjustments; see
[`examples/selectors.nim`](examples/selectors.nim).
A larger [MATE-style scientific calculator example](examples/calculator.md)
demonstrates expression entry, memory, history, and closure-based controls.

Requires ARC or ORC (Nim 2's default). Run `nimble testUi` for hidden-widget
integration tests; a display is required, but no visible windows are opened.

# Additional raw widgets

Raw bindings live under `src/headers/`; import `headers/gtk2`, `headers/glib2`,
`headers/cairo`, etc. The large combined bindings are split into native-header
include fragments. See [source layout](docs/source-layout.md) for the organization
and migration details. `import gtk2` is the public ergonomic API; the former
`gtk2ui` module has been renamed without a compatibility shim.

`import headers/gtk2` now includes raw bindings for the non-deprecated widget gaps:
assistants, expanders, icon views, color/font buttons, recent-document choosers,
modern toolbar items and palettes, spinners, scale/volume buttons, and Unix print
dialogs. Ergonomic coverage is still a subset of these raw APIs. See the
[coverage, ownership, platform, and regeneration guide](docs/raw-widgets.md).

# Validation

Run `nimble testModernBindings` for deprecation-as-error checks of the calculator
and core raw binding tests (no display required). See the
[raw binding modernization and migration notes](docs/modern-bindings.md),
including the corrected pointer-sized GLib size types.

Run `nimble testRawWidgets` for the added raw APIs and hidden-widget tests
(display required), or `nimble testRawWidgetAbi` for the optional native header
ABI checks (development headers required, no display).

Run `nimble testBindings` to check the core bindings and the bundled
Cairo/X11/FreeType integration without opening windows. To compile an example from this checkout:

```sh
nim c --path:src examples/ex1.nim
```

# Notes

## OSX

As of version 1.1 this binding will use [GTK-Quartz][1] if it is available,
otherwise it will fallback to the X11 version of GTK.

 [1]: https://wiki.gnome.org/action/show/Projects/GTK+/OSX
