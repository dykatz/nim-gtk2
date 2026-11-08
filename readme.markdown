
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
URI pads now also accept an optional copied-data `UriDropPredicate` before native
completion. False/errors reject without observation; checked GTK access is forbidden
inside the synchronous policy. The desktop example demonstrates a namespace filter.

URI COPY-only drag/drop pads now provide drag-begin snapshots and copied idle
observations, with safe pending-reply teardown and no file opening, text fallback
or MOVE deletion. See the [URI pad guide](docs/gtk2.md#uri-copy-only-dragdrop-pads)
and [desktop example](examples/desktop.nim). `testMappedUriDrag` requires an
isolated display, `GTK2_TEST_VIRTUAL_DISPLAY=1` and X11/XTEST for real input.

Explicitly trusted COPY-only image pads now provide private begin snapshots, bounded
post-decode copies, pure metadata acceptance and post-finish owned observations.
Pending receivers drain after teardown. See the [image pad guide](docs/gtk2.md#explicitly-trusted-copy-only-image-dragdrop-pads)
and desktop's separate initially-off drop trust control. `testMappedImageDrag` uses
real isolated XTEST with trusted tiny fixtures, not a codec sandbox.

Explicitly trusted image clipboard requests now provide idle owned Pixbuf copies,
post-decode copy limits and weak-owner cancellation. Trust is required before native
codecs run; cancellation/limits do not sandbox decoding or native memory. See the
[trusted image guide](docs/gtk2.md#explicitly-trusted-copied-image-clipboard-requests)
and the desktop's initially-off trust/preview controls. Isolated regressions decode
only trusted tiny fixtures.

Copied drag-source Pixbuf icons now support text/URI/binary/image pads: setIcon copies
pixels, clearIcon restores actual native defaults on later drags, and active contexts
retain their own icons. See the [icon guide](docs/gtk2.md#copied-drag-source-pixbuf-icons).
`testMappedDragIcons` adds genuine XTEST cursor/popup pixel checks (isolated opt-in
X11/XTEST/XFixes, GTK2 development headers).

COPY-only binary pads now provide fixed-MIME begin snapshots, bounded opaque byte
receipts, guarded copied acceptance and post-finish idle observations. Pending replies
drain safely after disconnect/destruction. See the [binary pad guide](docs/gtk2.md#binary-copy-only-dragdrop-pads)
and desktop count-only pads. `testMappedBinaryDrag` requires isolated opt-in X11/XTEST.

Binary clipboard requests now provide bounded, idle-delivered copied bytes with
explicit result kinds, cancellation and non-retaining owner bindings. Limits cap
application copying, not native transport allocation; no parsing or fallback is added.
See the [request guide](docs/gtk2.md#bounded-copied-binary-requests).

Copied binary clipboard offers now publish opaque byte snapshots to explicit
application MIME targets, including NUL/non-UTF-8 and valid empty data, without
parsing or fallback. See the [binary guide](docs/gtk2.md#copied-binary-clipboard-offers)
and explicit desktop copy/clear buttons. `testMappedBinaryClipboard` requires an
isolated display and opt-in.

Copied image clipboard offers now publish private Pixbuf snapshots through native
writable encoders, with explicit offer tokens/clear and no automatic decoding or
persistence. The desktop example adds user-triggered copy-image/clear buttons.
See the [image guide](docs/gtk2.md#copied-image-clipboard-offers);
`testMappedImageClipboard` requires an isolated display and explicit opt-in.

URI clipboard transfers now offer copied URI-only lists and cancelable asynchronous
reads, with distinct empty/unavailable/rejected results and no automatic file opening
or text fallback. See the [URI guide](docs/gtk2.md#uri-clipboard-transfers) and
[desktop example](examples/desktop.nim). `testMappedUriClipboard` requires an
isolated display plus `GTK2_TEST_VIRTUAL_DISPLAY=1`; normal tests never request
selections or claim clipboard ownership.

Plain-text clipboard requests are cancellable and always deliver at UI idle;
Entry/TextView add protected Copy/Cut/Paste helpers. DrawingArea/EventBox can be
copy-only text drag/drop pads, without replacing native editor/model DnD. See the
[transfer guide](docs/gtk2.md#clipboard-and-copy-only-text-dragdrop) and the expanded
text/controls examples. `nimble testMappedTransfers` changes clipboard ownership
and drives XTEST input: run it only on an explicitly opted-in isolated display.
Shared Action/ToggleAction commands now create synchronized native menu/toolbar
proxies. ActionGroup controls command collections, and AccelGroup registers checked
window-local shortcuts without global accel-map changes. See the
[command guide](docs/gtk2.md#shared-actions-and-window-local-accelerators) and expanded
menu/toolbar examples. `testMappedActions` sends real XTEST keyboard input and must
only run on an explicitly opted-in isolated display.
Owned GtkBuilder documents now provide checked typed lookups, copied load errors,
explicit UI teardown and validated XML-handler-to-closure mappings without signal
symbol autoconnection. The [ergonomic example](examples/ergonomic.nim) embeds its
[XML layout](examples/ergonomic.ui); see the [builder guide](docs/gtk2.md#owned-gtkbuilder-documents).
Only load trusted application UI definitions. `testMappedBuilder` requires an
explicitly opted-in isolated display.
RadioAction adds checked signed-value groups and copied selection observations.
UIManager owns native menu/toolbar layouts with removable merge tokens, checked
paths, scoped shortcuts and native tearoffs. See the
[managed UI guide](docs/gtk2.md#radio-commands-and-uimanager-merges) and expanded
menu/toolbar examples. `testMappedUIManager` is isolated-display opt-in only.
Private text-line/segment imports, guessed bodies/vtables and line-data flags are
removed; see [public traversal/ownership](docs/raw-widgets.md#gtktextline-and-segment-removal-opaque-internals-public-iteration).
The text example toggles display wrapping without changing logical lines.
Private GtkTextBTree entry points are removed, without cache/validation shims.
Use [public positions/geometry](docs/raw-widgets.md#gtktextbtree-private-entry-point-removal)
and stable marks after edits; IconSet pointer typing and TextWindowType width are corrected.
GtkTextBuffer modified-bit helpers are removed; public dirty/selection/user-action
semantics and native lifetime pins are covered by [the buffer audit](docs/raw-widgets.md#gtktextbuffer-raw-migration-public-state-and-signal-lifetimes).
The native paste_done class slot/opaque guint storage are corrected without SDK subclassing.
GtkTextTagTable private registration hooks are removed; native public construction
and final release manage buffers. See [ownership/traversal](docs/raw-widgets.md#gtktexttagtable-raw-migration-public-construction-and-traversal)
and the text example's table-wide highlight deletion.
GtkTextTag unsafe flags are removed; public override-clearing helpers and checked
native priority distinguish unset from false. See [tag policy/lifetimes](docs/raw-widgets.md#gtktexttag-raw-migration-real-override-properties),
including native priority caching limitations and the text example's unset control.
TextAttributes/Appearance unsafe helpers/masks are removed and native ref-return
ABI is corrected. See [boxed ownership/effective style](docs/raw-widgets.md#gtktextattributesappearance-raw-migration-and-ownership)
for alias-vs-copy semantics and the source-only copy_values leak patch.
Raw GtkTextMark guessed body types/helpers/masks are removed; createMark now owns
before native insertion, making synchronous deletion safe. See
[mark ownership/migration](docs/raw-widgets.md#gtktextmark-raw-migration-no-guessed-private-body)
and the text example's explicit bookmark cursor.
Raw GtkTextView private-bitfield helpers/masks are removed; native class slots and
public boolean policies are audited, with pinned setters and native overwrite.
See [TextView migration](docs/raw-widgets.md#gtktextview-raw-migration-public-policy-not-private-flags)
for its unrealized-overwrite precondition, source-only patch and isolated tests.
Raw GtkEntry private-bitfield helpers/constants are removed without shims; public
boolean/property replacements and non-replaceable internal state are documented in
the [raw migration guide](docs/raw-widgets.md#gtkentry-raw-migration-no-private-bitfield-helpers).
Native Entry class slots now match GTK2 headers, with layout/signature regression probes.
Entry progress now has checked native double-precision fraction/pulse-step controls
and an explicit pulse operation—no timer or private activity state. See
[Entry progress feedback](docs/gtk2.md#entry-progress-feedback), the inputs controls
and opt-in isolated `testMappedEntryProgress` rendering tests.
Entry now exposes native overwrite/frame and checked Unicode mask/default policies,
with password-copy safeguards and native Insert/PRIMARY semantics documented.
See [editing and concealed text](docs/gtk2.md#entry-editing-and-concealed-text-presentation),
expanded inputs and opt-in isolated `testMappedEntryEditing`.
Entry now supports owned pixbuf/named icons, plain tooltips and per-icon policy,
with copied deferred native press/release observations (not synthesized clicks).
See the [icon guide](docs/gtk2.md#entry-icons-and-deferred-icon-events), expanded
inputs example and opt-in isolated `testMappedEntryIcons`.
Entry now exposes checked maxLength, widthChars, alignment and activatesDefault
policies, with safe deferred truncation observations and native default activation.
See [the policy guide](docs/gtk2.md#entry-limits-and-presentation-policy), expanded
inputs/dialog examples, and opt-in isolated `testMappedEntryPolicy`.
Entry selection observations now coalesce copied final coordinates at UI idle,
with optional initial delivery, non-owning tokens and prompt cancellation/cleanup.
The inputs example updates from real keyboard selection; see the
[observation guide](docs/gtk2.md#entry-cursorselection-observations) and isolated
`testMappedEntryObservations` task.
Entry now has checked Unicode cursor/selection snapshots and helpers, including
reverse ranges, copied selected text and direction-preserving focus. Realized
selection uses native PRIMARY ownership; normal tests stay unrealized.
See the [selection guide](docs/gtk2.md#entry-unicode-cursor-and-selection) and
`testMappedEntrySelection` (explicit isolated-display opt-in only).
EntryCompletion also supports owned literal action rows with copied deferred
activation payloads and explicit detached-only replacement. See the
[action-row guide](docs/gtk2.md#completion-action-rows) and expanded inputs example.
`testMappedCompletionActions` requires an explicitly opted-in isolated display.
EntryCompletion now supports pure custom matching from copied key/text/index
inputs, non-owning connections, explicit refiltering and an exact native-default
reset. See [examples/inputs.nim](examples/inputs.nim) and the
[matching guide](docs/gtk2.md#custom-completion-matching).
`testMappedCompletionMatch` requires an explicitly opted-in isolated display.
EntryCompletion now supports opt-in native inline common prefixes and popup
previews, with copied idle observations and safe deferred entry/combo callbacks.
See [examples/inputs.nim](examples/inputs.nim) and the
[inline completion guide](docs/gtk2.md#inline-common-prefix-and-popup-selection),
including GTK2's documented Unicode preview limitation/optional source patch.
`testMappedInlineCompletion` requires an explicitly opted-in isolated display.
Rich clipboard document transfer now offers immutable snapshots and cancellable
requests with explicit native-parser trust and text fallback. Imports remain
detached until the application commits them; plain copy/paste is unchanged.
See the [rich clipboard guide](docs/gtk2.md#rich-clipboard-negotiation) and expanded
[examples/text.nim](examples/text.nim). `testMappedRichClipboard` requires an
explicitly opted-in isolated display.
Native rich-text save/load now uses explicit owned formats, copied binary data,
checked tag policy and detached imports. See [examples/text.nim](examples/text.nim)
and the [serialization guide](docs/gtk2.md#native-rich-text-serialization). This is
trusted GTK2 data, not RTF/HTML or an untrusted-file parser; widgets are not saved.
`testMappedTextSerialization` requires an explicitly opted-in isolated display.
TextView now supports owned buffer-bound child anchors and checked inline widgets,
including different widgets in shared-buffer views and one-shot idle deletion
observations. See the expanded [text example](examples/text.nim) and
[anchor guide](docs/gtk2.md#text-child-anchors-and-inline-widgets).
`testMappedTextAnchors` requires an explicitly opted-in isolated display.
IconView now supports checked multiple selection, copied/coalesced idle observations,
stable row references and deferred activation. See the expanded
[icon example](examples/icons.nim) and [IconView guide](docs/gtk2.md#iconview).
`testMappedIconSelection` requires an opted-in isolated display and XTEST on Unix X11.
Custom model comparison/visibility functions and text cell presentation now take
copied typed rows with synchronous reentrancy guards and explicit refresh/cleanup.
Fixed pixbuf columns are also available. See the expanded
[proxy example](examples/proxies.nim), [model-function guide](docs/gtk2.md#synchronous-model-functions-and-cell-presentation),
and [work plan](TODO.md). `testMappedModelFunctions` validates native painting only
on an explicitly opted-in isolated display.
Popup text EntryCompletion now supports owned UTF-8 suggestions, checked entry
attachment and deferred safe selection commits/observations. Editable ComboBoxText
exposes its protected entry and copied text state. See the
[input guide](docs/gtk2.md#popup-text-completion-and-editable-combo-entries) and expanded
[inputs example](examples/inputs.nim). `testMappedCompletion` requires an explicitly
opted-in isolated display and uses XTEST on Unix X11.
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
