
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
[`examples/selectors.nim`](examples/selectors.nim). HScale/VScale,
HScrollbar/VScrollbar, shared range models, safe deferred value observers,
plain-text scale marks, and decorative Arrow widgets are demonstrated in
[`examples/ranges.nim`](examples/ranges.nim). Alignment, HButtonBox/VButtonBox,
Table, Fixed, and EventBox provide padded placement, action groups, checked grid
spans, signed pixel positioning, and native event-window flags; see
[`examples/containers.nim`](examples/containers.nim). MenuBar/Menu trees, checked
submenu ownership, standard/check/radio/image/separator/tearoff items, activation
closures, and AccelLabel are demonstrated in [`examples/menus.nim`](examples/menus.nim).
GTK2 tearoff menus include checked detached-window title/state properties and
state callbacks; the sampler has an explicit Detach/Reattach control.
The nine modern toolbar/palette widgets provide checked ToolItem insertion,
custom content, toggle/radio tools, dropdown menus, and collapsible groups; see
[`examples/toolbars.nim`](examples/toolbars.nim) and the
[toolbar guide](docs/gtk2.md#toolbars-and-tool-palettes).
Scrollable Layout canvases and detachable HandleBox content add checked pixel
geometry, shared scrolling models, and safe deferred attachment observers; see
[`examples/positioned.nim`](examples/positioned.nim) and the
[positioned-container guide](docs/gtk2.md#scrollable-layout-and-detachable-handlebox).
Standalone ColorSelection/FontSelection panels and directly managed chooser
dialogs complement the existing selector buttons with embedding, copied values,
and safe deferred live observers; see [`examples/choosers.nim`](examples/choosers.nim)
and the [chooser guide](docs/gtk2.md#standalone-colorfont-choosers).
Assistant adds checked nonblocking wizard pages, validation/completion, optional
steps, page images, custom actions, and safe deferred lifecycle observers; see
[`examples/assistant.nim`](examples/assistant.nim) and the
[Assistant guide](docs/gtk2.md#assistant-wizard-workflows).
FileChooserButton/Widget/Dialog add native-path and URI selections, multiple
selection, shared FileFilter rules, and deferred response snapshots; see
[`examples/filechoosers.nim`](examples/filechoosers.nim) and the
[file chooser guide](docs/gtk2.md#file-choosers-and-filters). Older GTK2 packages
with modern GIO may need the documented native
[completion fix](docs/gtk2.md#native-gtk2gio-completion-compatibility).
RecentChooserWidget/Menu/Dialog add isolated or shared RecentManager history,
copied metadata, RecentFilter rules and safe activation/response observers; see
[`examples/recents.nim`](examples/recents.nim) and the
[recent chooser guide](docs/gtk2.md#recent-item-choosers). The guide also documents
GTK2's native [idle cleanup fix](docs/gtk2.md#native-recent-chooser-source-cleanup)
for empty recent panels/dialogs on modern GLib.
CellView, HSV and OffscreenWindow add fixed plain-text/pixbuf/model cells,
normalized color selection and owned offscreen snapshots; see
[`examples/displays.nim`](examples/displays.nim) and the
[display widget guide](docs/gtk2.md#cellview-hsv-and-offscreen-rendering).
Unix PrintUnixDialog/PageSetupUnixDialog provide nonblocking print configuration,
with cross-platform PrintSettings/PageSetup/PaperSize and copied response values.
See [`examples/printing.nim`](examples/printing.nim) and the
[printing guide](docs/gtk2.md#print-and-page-setup-dialogs); these configure choices,
not render or submit print jobs.
The remaining desktop widgets are covered too: Invisible, X11 Plug/Socket,
StatusIcon and the shared Misc API. See [`examples/desktop.nim`](examples/desktop.nim)
and the [desktop guide](docs/gtk2.md#desktop-infrastructure-invisible-plugsocket-and-statusicon).
Tray constructors can briefly map native windows even with visible=false;
tray/foreign-embedding tests therefore require explicit isolated-display opt-in.
Existing [controls](examples/controls.nim), [text](examples/text.nim), and
[models](examples/models.nim) examples now include scoped Cairo drawing and input,
text tags/marks/search/images, editable text/toggle columns and multiple TreeView
selection. See the [extension guide](docs/gtk2.md#drawinginput-rich-text-and-editable-views).
TreeView selection observers are deferred/coalesced; edits are copied observations,
not automatic commits. Pixel/native-editor tests use the separate opt-in
`nimble testMappedExtensions` task on an isolated virtual display.
A larger [MATE-style scientific calculator example](examples/calculator.md)
demonstrates expression entry, memory, history, and closure-based controls.

Requires ARC or ORC (Nim 2's default). Run `nimble testUi` for hidden-widget
integration tests; a display is required, but no visible windows are opened.
For actual tearoff window transitions, use the separate opt-in virtual-display
[menu integration tests](docs/gtk2.md#tearoff-menus), never your desktop display.

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
