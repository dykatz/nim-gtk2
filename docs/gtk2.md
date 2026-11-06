# gtk2: a Nim-style layer inspired by gtkmm 2

`import gtk2` instead of the raw modules for a small, typed, ergonomic API.
Raw bindings are imported as `headers/gtk2`, `headers/glib2`, etc.; see
[source layout](source-layout.md). The former `gtk2ui` API is now exported by
`gtk2`; its implementation lives under `src/gtk2/`.
The raw `headers/gtk2` API remains available for low-level operations. Both layers may
change as this new SDK evolves; there is no legacy source-compatibility promise.
This is an initial subset, not a complete replacement or a source-compatible
port of gtkmm.
Requires Nim's ARC or ORC memory manager (ORC is the Nim 2 default).

## What gtkmm cleans up

This design was informed by the `gtkmm-2-24` branch of GNOME's gtkmm,
revision `85967ecc93d16892896626dfac54143b16ba9b9c`, especially:

- [Widget](https://github.com/GNOME/gtkmm/blob/85967ecc93d16892896626dfac54143b16ba9b9c/gtk/src/widget.hg):
  a typed object hierarchy with instance methods instead of casts and C macros.
- [Button](https://github.com/GNOME/gtkmm/blob/85967ecc93d16892896626dfac54143b16ba9b9c/gtk/src/button.hg):
  constructors, string-valued accessors, and callable-based `signal_clicked()`.
- [Box](https://github.com/GNOME/gtkmm/blob/85967ecc93d16892896626dfac54143b16ba9b9c/gtk/src/box.hg):
  `PackOptions` describes packing intent without boolean parameter puzzles.
- [Object/manage](https://github.com/GNOME/gtkmm/blob/85967ecc93d16892896626dfac54143b16ba9b9c/gtk/src/object.hg)
  and [Window](https://github.com/GNOME/gtkmm/blob/85967ecc93d16892896626dfac54143b16ba9b9c/gtk/src/window.hg):
  explicit lifetime rules, with parent-managed children and separate top-level
  window ownership.
- [Main](https://github.com/GNOME/gtkmm/blob/85967ecc93d16892896626dfac54143b16ba9b9c/gtk/src/main.hg):
  an application-facing entry point for initialization and the event loop.

The spiritual translation uses Nim conventions rather than copying C++ syntax:

| gtkmm 2 concept | Nim API |
| --- | --- |
| `Gtk::Window`, `Gtk::Button`, etc. | `newWindow()`, `newButton()`, etc. |
| `set_title()` / `get_title()` | `window.title = "Hello"` / `window.title` |
| `signal_clicked().connect(slot)` | `button.onClicked(proc () = ...)` |
| `sigc::connection` | `Connection.connected`, `.disconnect()` |
| `pack_start(child, Gtk::PACK_SHRINK)` | `box.packStart(child, packShrink)` |
| `gobj()` | `.raw` (typed, borrowed pointer) |
| `Gtk::Main` | `gtk2.init()`, `window.run()`, `gtk2.quit()` |
| stack widgets / `Gtk::manage()` | shared Nim handles plus GTK parent ownership |

There is deliberately no `manage(new ...)` ceremony, manual signal function
cast, `cstring` conversion, or `gboolean` conversion in normal application code.

## Example

```nim
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("Greeting", width = 360, height = 180)
  defer: window.destroy()
  window.borderWidth = 12
  let box = newVBox(spacing = 8)
  let name = newEntry("Nim")
  let output = newLabel()
  let button = newButton("Greet")
  window.add(box)
  box.packStart(name, packShrink)
  box.packStart(output)
  box.packEnd(button, packShrink)
  button.onClicked do ():
    output.text = "Hello, " & name.text
  window.run()

main()
```

See also [`examples/ergonomic.nim`](../examples/ergonomic.nim) and the larger
[MATE-style calculator](../examples/calculator.md).
Compile with `nim c --path:src examples/ergonomic.nim` from this checkout.

## Core API

- Hierarchy: `Widget`, `Container`, `Bin`, `Window`, `Button`, `Box`, `VBox`,
  `HBox`, `Label`, `Entry`. The hierarchy restricts operations at compile time:
  `onClicked` needs a `Button`, `onChanged`/`onActivate` need an `Entry`, and `add` needs a
  single-child `Bin`. A box uses `packStart` / `packEnd` instead.
- Constructors: `newWindow(title, width, height)`, `newButton(text, mnemonic)`,
  `newLabel(text)`, `newEntry(text)`, `newVBox(spacing, homogeneous)`,
  `newHBox(spacing, homogeneous)`; all arguments have defaults.
- Properties: window `title`, label/entry/button `text`; container `borderWidth`
  is write-only. Strings are copied on reads and must not contain NUL on writes.
- Common operations: `show`, `showAll`, `hide`, `focus`, `destroy`, `isDestroyed`.
  Entry `focus` preserves the cursor/selection instead of selecting all text.
- Entry editing: `selectAll`, `insertText` (replaces selection or inserts at the
  cursor), and `backspace` (deletes selection or previous Unicode character).
- Packing: `packShrink` (natural size), `packExpandPadding` (extra padding),
  `packExpandWidget` (grow widget, the default), with optional `padding`.
- Signals: `onClicked`, `onChanged`, `onActivate` (Entry's Enter key),
  `onDestroy`, all accepting `proc ()`
  closures. Call `button.click()` to emit clicked programmatically.

## Controls and simple containers

The first expansion adds these twelve concrete widgets. They use the same shared
handles, checked `.raw`, parenting, closure connections, and destruction tracking
as the core API; import only `gtk2`.

| Widgets / constructors | Ergonomic operations |
| --- | --- |
| `newToggleButton(text, mnemonic)`, `newCheckButton(text, mnemonic)` | Inherited button `text`, `click`, `onClicked`; `active`, `inconsistent`, `onToggled` |
| `newRadioButton(text, mnemonic)`, `newRadioButton(group, text, mnemonic)` | Same toggle/button operations; `joinGroup(other)` |
| `newLinkButton(uri)`, `newLinkButton(uri, text)` | Inherited button operations; `uri`, `visited` |
| `newProgressBar(fraction, text)` | `fraction`, `text`, `pulseStep`, `pulse()` |
| `newSpinner()` | `start()`, `stop()` |
| `newFrame(text)` | Single-child `add`, `text`, `labelAlignment`, `setLabelAlignment(x, y)` |
| `newAspectFrame(text, ratio, xalign, yalign, obeyChild)` | Frame operations; `setAspect(ratio, xalign, yalign, obeyChild)` |
| `newExpander(text, mnemonic)` | Single-child `add`, `text`, `expanded`, `spacing`, `onActivate` |
| `newHSeparator()`, `newVSeparator()` | Ordinary widget packing/lifecycle |
| `newDrawingArea(width, height)` | Size requests, scoped Cairo drawing and copied input callbacks; see the drawing/input extensions below |

All widgets now support `setSizeRequest(width, height)`, the read-only
`sizeRequest` tuple, and `queueDraw()`. A size request accepts `-1` for GTK's
natural size or a nonnegative `gint`; it is not a promise about the final allocated
size. Drawing areas default to `(-1, -1)`.

Progress fractions, pulse steps, and alignment coordinates must be finite and
in `[0, 1]`. Aspect ratios must be in GTK's `[0.0001, 10000]` range. Invalid
values (including NaN) raise `ValueError` before calling GTK. Aspect frames default
to ratio `1.0`, centered alignment, and `obeyChild = false` so the requested ratio
is honored. `setAspect` updates these settings together. Empty frame labels remove
the label; empty progress text hides the overlay.

Radio groups are represented by a live `RadioButton`, not a borrowed native list.
The first member starts active. For example:

```nim
let first = newRadioButton("First")
let second = newRadioButton(first, "Second")
second.active = true
assert not first.active
```

`onToggled` observes the new active state; assigning the same state does not emit
another toggle. `onActivate` on an expander runs **before** GTK's default
expand/collapse action and is not a property-change notification. Setting
`expanded` directly does not emit `activate`.

A link button retains native GTK behavior: clicking it may launch a URI handler
such as a browser. The return-valued `activate-link` interception signal is not
yet wrapped; `onClicked` alone does not suppress URI activation.

See [`examples/controls.nim`](../examples/controls.nim) for an interactive sampler.
It is compiled, but not launched, during current validation.

## Scrolling, notebook pages, and split panes

The layout expansion adds `ScrolledWindow`, `Viewport`, `Notebook`, `HPaned`,
and `VPaned`, with the same shared handles and typed borrowed `.raw` pointers.
`Paned` is their common split-pane base; unlike `Bin`, it does not offer `add`.
All widgets also have a read-only `visible` boolean (GTK's visibility flag, not
whether the widget is actually on screen).

| Constructor | Operations |
| --- | --- |
| `newScrolledWindow(horizontal = scrollAutomatic, vertical = scrollAutomatic)` | Single-child `add`; `policies` tuple, `setPolicies(horizontal, vertical)`, `shadow` |
| `newViewport()` | Single-child `add`; `shadow` |
| `newHPaned()`, `newVPaned()` | `packFirst`, `packSecond`, `hasFirstChild`, `hasSecondChild`, `removeFirst`, `removeSecond`, `position` |
| `newNotebook()` | `appendPage`, `insertPage`, `removePage`, `reorderPage`, `pageCount`, `pageIndex`, `currentPage`, tab operations, `onSwitchPage` |

Scroll policies are `scrollAlways`, `scrollAutomatic`, and `scrollNever`.
Shadow styles are `shadowNone`, `shadowIn`, `shadowOut`, `shadowEtchedIn`, and
`shadowEtchedOut`. Owned adjustment access is described in the input batch below.

`ScrolledWindow.add(content)` automatically inserts a native viewport for
ordinary widgets such as boxes and labels. Widgets implementing GTK2's native
`set-scroll-adjustments` signal protocol (including an explicit `Viewport`)
are added directly, without an extra viewport. This also works if the scrolled
window has been upcast to `Bin`. The implicit viewport is owned solely by GTK;
no independent Nim handle or borrowed adjustment pointer escapes. As with any
single-child container, a second child, a parented child, or a containment cycle
is rejected before GTK is called.

`packFirst(child, resize = false, shrink = true)` means left in `HPaned` and top
in `VPaned`. `packSecond(child, resize = true, shrink = true)` means right/bottom.
Each slot must be empty. Removing a child only unparents it: a retained Nim
handle remains live and can be packed elsewhere. Without another owner, GTK
releases the removed child. Divider `position` accepts nonnegative pixel values
or `-1` to restore automatic positioning; its final position also depends on
GTK's size allocation and child constraints.

Notebook pages use **zero-based indices**:

```nim
let book = newNotebook()
let first = newLabel("First page")
let second = newLabel("Second page")
book.appendPage(first, "First")
book.insertPage(1, second, "Second")
book.currentPage = 1
book.setTabText(second, "Updated")
book.setTabReorderable(second, true)
book.onSwitchPage do (index: int):
  echo "Selected page ", index
```

- `appendPage(child, tabText)` and `insertPage(index, child, tabText)` return the
  inserted index and are discardable. Insertion accepts `0 .. pageCount`;
  selection, removal, and reordering accept only `0 ..< pageCount`. Native
  negative-index sentinels are not silently accepted.
- Insertion shows **only the content root** so GTK2 can select the page before
  `window.run()`. It does not show descendants or the toplevel. `currentPage`
  reads `-1` when there is no selected page; selecting an explicitly hidden
  page raises `ValueError` until it is shown again.
- `pageIndex(child)` returns `-1` for a live widget that is not a page.
  `tabText(child)`, `setTabText(child, text)`, `tabReorderable(child)`,
  `setTabReorderable(child, enabled)`, and `reorderPage(child, index)` require
  that child to belong to the notebook.
- `removePage(index)` unparents retained content without destroying it, just
  like pane removal. Generated tab labels are GTK-owned. There is no page getter
  that creates a second independent handle for an existing widget: retain the
  content handle when you need to refer to it later.
- Boolean properties are `showTabs`, `showBorder`, and `scrollable`.
  `tabPosition` accepts `tabLeft`, `tabRight`, `tabTop`, or `tabBottom`.
- `onSwitchPage(proc (index: int) = ...)` runs after GTK's default switch handler,
  with the event's page index. It uses the normal disconnectable `Connection`,
  exception containment, and destruction cleanup. It exposes no borrowed opaque
  `GtkNotebookPage*`. Other handlers may change selection reentrantly; the event
  argument is not a persistent page identity.

See [`examples/layout.nim`](../examples/layout.nim) for an interactive sampler.
It is compiled, not launched, during current validation.

## Numeric and text-choice inputs

This batch adds **SpinButton**, **ComboBoxText**, and the non-widget
**Adjustment**. They share an `ObjectHandle` lifetime base and the usual
`Connection` machinery. `Adjustment` is a GTK2 `GtkObject`, not a `Widget`: it
cannot be packed, shown, or used as a container child. `ObjectHandle` is not a
universal wrapper for arbitrary GObjects.

| Constructor | Operations |
| --- | --- |
| `newAdjustment(value = 0, lower = 0, upper = 100, stepIncrement = 1, pageIncrement = 10, pageSize = 0)` | `value`, read-only bounds/increments/page size, atomic `configure`, `onChanged`, `onValueChanged` |
| `newSpinButton(lower = 0, upper = 100, step = 1)` | `value`, `digits`, `bounds`, `setRange`, `increments`, `setIncrements`, `numeric`, `wrap`, `snapToTicks`, `update`, `onValueChanged` |
| `newSpinButton(adjustment, climbRate = 0, digits = 0)` | Same operations; owned `adjustment` get/set |
| `newComboBoxText(items = [], editable = false)` | `itemCount`, `activeIndex`, `activeText`, `appendText`, `prependText`, `insertText`, `removeText`, `onChanged`; editable variants also have `entryText` |

SpinButton inherits Entry's `text`, editing helpers, `onChanged`, and `onActivate`.
`onChanged` reports entry text edits; `onValueChanged` reports numeric changes.
Call `update()` to parse programmatically edited text using GTK's locale-aware
rules. Native range constructors infer decimal precision from the step; set
`digits` explicitly when a specific display precision is needed (`0 .. 20`).

All numeric inputs must be finite. Bounds must be ordered and have a finite span;
adjustment increments and page sizes must be nonnegative, with page size no
larger than the span. The range-based spin constructor requires a positive step
and a finite derived page increment (`step * 10`). `value` is **clamped by GTK**,
not rejected when outside the bounds. An adjustment's effective maximum is
`upper - pageSize`. `configure(value, lower, upper, stepIncrement, pageIncrement,
pageSize = 0)` validates all fields before one native configuration call.

```nim
let amount = newAdjustment(5, 0, 100, 0.5, 10)
let first = newSpinButton(amount, digits = 1)
let second = newSpinButton(amount, digits = 2)
first.value = 12.5
assert second.value == 12.5
let choices = newComboBoxText(["Small", "Medium", "Large"])
choices.activeIndex = 1
assert choices.activeText == "Medium"
```

`SpinButton.adjustment`, `ScrolledWindow.horizontalAdjustment` /
`verticalAdjustment`, and the corresponding Viewport properties return **owning**
handles, not borrowed native references. Each property can also be assigned an
Adjustment. Live handles for the same native adjustment share their state,
connections, and destruction tracking through weak native object data. The live
cache is cleared when the last state owner releases it; a destroyed object keeps
a private tombstone until native finalization so getters cannot resurrect it.
Do not overwrite this layer's
private native object data. Releasing a wrapper never steals a widget's reference.
An adjustment retained by an application can outlive the widget that exposed it.
GTK may retain property references until widget finalization, beyond `destroy()`.

Scroll widgets and viewports own their sizing calculations and can overwrite
supplied adjustment bounds/page sizes during setup and layout. Do not treat
manual scroll-range configuration as persistent layout state.

Adjustments with self-capturing callbacks need explicit disconnection or
`destroy()` just as widgets do. Shared adjustments are **not destroyed with a
window**: disconnect their application callbacks before closing a window if those
callbacks capture its widgets. Do not destroy a shared adjustment while another
control still needs it. `onDestroy` and `isDestroyed` work on both handle kinds.

ComboBoxText uses a flat native text model. `activeIndex = -1` clears selection;
otherwise it must name an existing row. Insertion accepts `0 .. itemCount`, while
removal accepts only existing indices. `activeText` copies and frees GTK's
allocated result; an empty string can mean either no selection or an empty row.
With `editable = true`, it returns the entry text, including custom text that is
not a row. `entryText` requires an editable combo and does not create a second
handle for the internal Entry. Signals use normal native ordering and may also
fire as rows or editable text change.

`ComboBox` is the common selection base for ComboBoxText and ModelComboBox.
The flat-model batch below adds `newComboBox(model, textColumn)` with owned model
handles rather than exposing a raw-model pointer constructor.

See [`examples/inputs.nim`](../examples/inputs.nim) for a shared-value measurement
sampler. It is compiled, not launched, during current validation.

## Images, status messages, and information bars

The feedback batch adds `Image`, `Statusbar`, and `InfoBar`. All widgets also
have a `sensitive` boolean property: it is the widget's own flag, not its
effective sensitivity after taking ancestors into account.

### Image

- `newImage()` creates an empty image.
- `newImageFromFile(filename)`, `newImageFromIcon(name, size = iconButton)`, and
  `newImageFromStock(id, size = iconButton)` create file, themed-icon, and GTK2
  stock images. `setFromFile`, `setFromIcon`, and `setFromStock` replace a source;
  `clear()` removes it.
- Standard sizes are `iconMenu`, `iconSmallToolbar`, `iconLargeToolbar`,
  `iconButton`, `iconDrag`, and `iconDialog`. `pixelSize` accepts `-1` for the
  normal icon size or a nonnegative `gint`. It overrides named-icon sizing; it
  is not a general-purpose pixbuf/file scaling operation.
- `storageKind` reflects native storage, including `imageEmpty`, `imagePixbuf`,
  `imageStock`, and `imageIconName`. `iconName` and `stockId` return copied strings
  and require matching storage kinds; mismatches raise `ValueError` rather than
  reaching a GTK assertion.

Unreadable files retain native GTK2 behavior: the image displays the missing-image
stock icon rather than raising an I/O exception. File formats depend on installed
GdkPixbuf loaders. In-memory pixbuf support is described below. Animation, GIcon,
and custom registered icon size wrappers still require the raw API. GTK2
stock icons are intentionally retained despite later GTK3 deprecation.

### Statusbar

`newStatusbar(resizeGrip = true)` creates a status bar with a read/write
`resizeGrip` property. Contexts and message tokens are scoped to their bar:

```nim
let status = newStatusbar(resizeGrip = false)
let tasks = status.context("tasks")
let first = tasks.push("Working")
tasks.push("Finishing")
tasks.pop()       # Remove the latest message in this context.
first.remove()   # Remove this specific message; repeating this is a no-op.
```

Repeated `context(description)` calls share the native context ID. Messages from
all contexts share the native display stack; popping one context does not remove
another context's messages. Discarding a returned message token does not remove
its message. Tokens retain the shared statusbar state and can keep an unparented
bar alive; destruction through its window still invalidates every token.
Default/uninitialized tokens raise `ValueError` when used.

`onTextPushed(proc (text: string) = ...)` and `onTextPopped(...)` return ordinary
connections and run after GTK updates its label. The borrowed native string is
copied before invoking the callback. A pop's argument describes the newly
displayed message (or an empty string), not the removed message. These callbacks
observe the whole bar, not just one context. Native GTK2's bulk `remove_all`
implementation can leave messages or stale display text behind; this batch does
not expose a misleading high-level context `clear()` operation.

### InfoBar

`newInfoBar(kind = messageInfo)` exposes `messageKind`: `messageInfo`,
`messageWarning`, `messageQuestion`, `messageError`, or `messageOther`.
`packStart` / `packEnd` use the same options and padding as boxes but pack into
**the content area**. InfoBar deliberately inherits `Container`, not the public
`Box` surface, so upcasting cannot accidentally pack into GTK's private outer
HBox. Internal area widgets are not returned as independently wrapped handles.

- `addButton(text, response)` returns an owned Button already in the action area.
- `addActionWidget(button, response)` attaches an unparented Button (or subclass),
  making it eligible as a default action. Other arbitrary widgets are not accepted.
- `setResponseSensitive(response, enabled)` updates matching action buttons.
- Write-only `defaultResponse` selects a matching default action. **Attach the
  InfoBar to a window first**; otherwise the setter raises `ValueError` instead
  of GTK's "widget not within a GtkWindow" warning. The window need not be shown.
- `respond(response)` emits a response; it does not click a button or
  automatically hide/destroy the InfoBar.
- `onResponse(proc (id: ResponseId) = ...)` uses a signed C-width response ID,
  normal connection lifetime, and exception containment. Native negative GTK
  responses and nonnegative custom responses are preserved without truncation.

Predefined IDs are `responseNone`, `responseReject`, `responseAccept`,
`responseDeleteEvent`, `responseOk`, `responseCancel`, `responseClose`,
`responseYes`, `responseNo`, `responseApply`, and `responseHelp`.
Use `customResponse(nonnegativeInt)` for application-specific actions; invalid
or oversized values raise `ValueError`. Hiding or dismissing a notice is the
application's decision, typically inside `onResponse`.

See [`examples/feedback.nim`](../examples/feedback.nim) for a combined sampler.
It is compiled, not launched, during current validation.

## Nonblocking dialogs

This batch adds `Dialog`, `MessageDialog`, and `AboutDialog`, all derived from
`Window`. They inherit title, visibility, destruction tracking, and the explicit
**destroy every toplevel** rule. The shared signed `ResponseId` API works on
both Dialog and InfoBar.

- `newDialog(title = "", modal = false)` creates a general dialog.
- `newMessageDialog(text, kind = messageInfo, buttons = buttonsOk, title = "",
  modal = false)` creates a plain-text message. Button groups are `buttonsNone`,
  `buttonsOk`, `buttonsClose`, `buttonsCancel`, `buttonsYesNo`, and `buttonsOkCancel`.
- `newAboutDialog(programName = "", version = "", modal = false)` creates an
  about dialog. Empty constructor name/version arguments preserve GTK defaults.
- Each constructor also accepts a leading live `parent: Window`. Parented
  variants default to `destroyWithParent = true`; it can be disabled explicitly.

All Window handles now offer `modal`, `destroyWithParent`, write-only
`transientFor`, `clearTransientFor()`, and `present()`. Transient self-parenting
and cycles raise `ValueError`. Native transient links do not create independent
Nim wrappers for a parent window. `present()` shows the tree and raises the
window **without starting an event loop**; unlike the native present function,
it also shows child widgets for ergonomic dialog construction.

Dialogs use `packStart` / `packEnd` for their content area. Do not use inherited
single-child `add`: GTK already owns the dialog's internal VBox. `addButton`,
`addActionWidget`, `setResponseSensitive`, write-only `defaultResponse`, `respond`,
and `onResponse` mirror InfoBar. Returned action buttons have an owned reference;
internal content/action areas are not exposed as separately wrapped handles.
Since a Dialog is itself a Window, its default response can be set before showing
it. Add the matching action button first.

```nim
# Inside a button callback, while the main window's loop is already running:
let dialog = newDialog(window, "Edit", modal = true)
let entry = newEntry("Value")
dialog.packStart(entry, packShrink)
discard dialog.addButton("_Save", responseOk)
dialog.onResponse do (id: ResponseId):
  if id == responseOk: echo entry.text
  dialog.destroy()
dialog.present()
```

`respond` does not automatically close or hide a dialog. Handle responses in the
application, normally by destroying it. Native close requests retain GTK's normal
behavior. There is **no ergonomic binding to `gtk_dialog_run`** and no new nested
modal loop. The inherited `Window.run()` still means the ordinary toplevel loop;
do not call it from a response/click callback. Modal windows can block interaction
with their parent while the existing main loop continues processing responses.

MessageDialog has read/write `text`, `secondaryText`, and `messageKind`.
Application messages are always passed as data through a fixed `"%s"` format,
never as printf formats. Literal `%n`, `%s`, percent signs, and markup-looking
text remain literal. The main text setter disables markup even after raw
interop; secondary text uses the plain native formatter. Setting secondary text
to `""` removes it. Markup-formatted messages are deliberately not part of this
initial surface.

AboutDialog exposes string properties `programName`, `version`, `comments`,
`copyright`, `license`, `website`, `websiteLabel`, `translatorCredits`, and
`logoIconName`, plus `wrapLicense`. `authors`, `artists`, and `documenters` accept
string arrays/sequences and return copied `seq[string]` values. Setters validate
all entries before creating a temporary null-terminated vector; GTK copies it.
Getters copy borrowed native strings/vectors and never free them. Empty vectors
clear the corresponding credits. Pixbuf logos and return-valued link interception
remain raw APIs; clicking native website links may launch a browser.

See [`examples/dialogs.nim`](../examples/dialogs.nim) for an asynchronous dialog
sampler. It is compiled, not launched, during current validation.

## Multiline text: TextView and TextBuffer

`newTextBuffer(text = "")` creates an owned **non-floating GObject**, not a
GtkObject/widget. `newTextView(buffer)` displays an existing buffer;
`newTextView(text = "")` creates one implicitly. Multiple views can share it.
`view.buffer` returns an owning handle with shared cached state, not a stolen
view-owned reference. `view.buffer = otherBuffer` retains the replacement; old
buffer handles remain valid. `view.text` forwards to its current buffer.

### Buffer editing

- `text` is copied on reading; assigning it replaces all text. Constructor text
  starts with `modified = false`; subsequent edits follow native dirty-state
  behavior. `modified` is read/write.
- `characterCount` and `lineCount` are read-only. Even an empty buffer has one line.
- `textRange(first, last, includeHidden = true)` copies a half-open range.
- `insertText(offset, text)`, `appendText(text)`, `insertAtCursor(text)`, and
  `deleteRange(first, last)` perform programmatic edits. Inserting at the cursor
  does **not** implicitly replace an existing selection.
- `cursorOffset` reads/writes the insertion point. Setting it collapses selection.
- `selectRange(anchor, cursor)` preserves direction, including reversed ranges.
  `hasSelection`, `selectedText`, and `selectionBounds` query it. Bounds are
  `(hasSelection, first, last)` with ordered, half-open endpoints; without a
  selection both endpoints equal the cursor offset.
- `deleteSelection(interactive = false, defaultEditable = true)` reports whether
  a selection was removed. Interactive mode honors native editable-tag policy.
- `buffer.withUserAction: ...` balances native begin/end notifications even if
  the body raises. It is grouping, **not an undo stack or rollback transaction**.

All offsets are **Unicode character/code-point offsets**, not UTF-8 byte offsets
or grapheme indices. Valid offsets are `0..characterCount`; negative native
sentinels and reversed edit ranges are rejected. Text must be NUL-free, valid
UTF-8, with byte length fitting `gint`; malformed, overlong, surrogate, and
out-of-range encodings raise `ValueError` before GTK. Iterators are created
internally for each operation and never escape as persistent handles. Native
allocated strings are copied and freed. Text getters include invisible tagged
characters by default; embedded images/anchors are not returned by GTK's plain
text getter. Tags, marks, bounded Unicode search and embedded pixbufs are covered in the
rich-text extensions below. Plain-text clipboard integration is covered in the transfer guide below;
embedded child anchors and rich clipboard formats remain raw.

### View behavior

`editable`, `cursorVisible`, and `acceptsTab` are read/write booleans. Read-only
views still allow programmatic buffer editing. `wrapMode` accepts `wrapNone`,
`wrapChar`, `wrapWord`, and `wrapWordChar`. Nonnegative integer properties are
`leftMargin`, `rightMargin`, `pixelsAboveLines`, `pixelsBelowLines`, and
`pixelsInsideWrap`.

Pack a view directly into ScrolledWindow: it implements GTK's scroll-adjustments
protocol and does not need a viewport adapter. `scrollToCursor(withinMargin = 0,
useAlign = false, xalign = 0, yalign = 0)` scrolls to the native insertion mark,
allowing GTK to defer scrolling until layout is ready. The finite margin must be
in `[0, 0.5)` and alignments in `[0, 1]`.

### Buffer signals and lifetime

`onChanged`, `onModifiedChanged`, and `onCursorMoved` accept `proc ()` and return
normal connections. Changed callbacks run after the native default changed
handler; cursor callbacks use `notify::cursor-position` and can also occur during
editing. Native bulk replacement may emit multiple changes. Callbacks may
self-disconnect and exceptions are contained at the C boundary.

**A TextBuffer has no destroy signal or widget-style `destroy()`**. Calling its
inherited `onDestroy` raises `ValueError`, rather than triggering a GTK warning.
Destroying a view/window does not invalidate retained buffer handles.
`isDestroyed` is true for an uninitialized buffer; a live owning buffer stays
usable until its handles are released. Its constructor adopts the transfer-full
reference directly, without adding the extra reference a ref-sink would create.

Unlike widget callbacks, buffer callbacks are scoped to the shared Nim state:
they disconnect when its last handle/Connection disappears, even if a native view
still owns the buffer. Retain a buffer or Connection to keep these registrations.
Callbacks capturing their own buffer or widget trees can keep that state alive;
**disconnect them explicitly**. `buffer.disconnectSignals()` disconnects every
gtk2 callback tracked by that shared buffer state, including callbacks registered
through other aliases:

```nim
let buffer = newTextBuffer("Hello, λ🙂")
let view = newTextView(buffer)
window.add(view)
buffer.onChanged(proc () = window.title = buffer.text)
window.onDestroy(proc () = buffer.disconnectSignals())
```

This avoids buffer → closure → widget-tree cycles without disposing a buffer
still used by another view. The native state cache is weak and cleared when the
last state owner releases it, so later getters can safely rebuild state.
See [`examples/text.nim`](../examples/text.nim) for shared editable/read-only
views. It is compiled, not launched, during validation.

## Flat models, text columns, and model-backed choices

The first model batch adds owned **TreeModel/ListStore**, **TreeView**,
**TextColumn**, and **ModelComboBox**. This is a deliberately flat, string-cell
presentation layer; hierarchical support is described in the following section.

### Typed ListStore rows

```nim
let rows = newListStore([cellString, cellInt, cellBool, cellFloat])
discard rows.appendRow([cell("Nim"), cell(2008), cell(true), cell(9.5)])
rows.setValue(0, 0, cell("Nim language"))
echo rows.value(0, 0).stringValue
```

A schema has at least one column. Kinds map exactly to `G_TYPE_STRING`,
`G_TYPE_INT` (signed 32-bit), `G_TYPE_BOOLEAN`, `G_TYPE_DOUBLE`, and
`GDK_TYPE_PIXBUF` (`cellPixbuf`).
`cell(value)` builds a tagged `CellValue` with public `kind` and matching
`stringValue`, `intValue`, `boolValue`, `floatValue`, or `pixbufValue` field. Integer inputs must
fit `gint`, floating inputs must be finite, and strings must be valid, NUL-free
UTF-8. The same checks apply when accepting directly constructed CellValues.
No implicit cross-kind conversions occur. Pixbuf cells retain native objects;
reads return owning Pixbuf handles, including an empty handle for a NULL cell.
See the IconView section below.

- `columnCount`, `rowCount`, and `columnKind(column)` query the schema/data.
- `value(row, column)` returns a copied value; returned strings do not borrow GTK.
- `appendRow(values)` returns the new row's current zero-based index.
- `insertRow(index, values)` accepts `0..rowCount`.
- `setRow(index, values)` replaces all cells; `setValue(row, column, value)`
  changes one cell. `removeRow(index)` and `clear()` delete rows.

Whole-row writes require exactly one correctly typed value per column and
validate **every** cell before mutation. Temporary GValues are initialized and
unset explicitly. Native `insert_with_valuesv` / `set_valuesv` publish a fully
populated row and one native row notification, rather than exposing an empty
row followed by intermediate per-cell changes. This is not a multi-row transaction.

Indices are positions, **not stable identities**: insertion/deletion shifts them.
Native iterators and paths remain internal; each operation resolves a fresh
iterator and rejects missing rows, invalid columns, and negative sentinels.
Retain your original ListStore to mutate data; the TreeModel interface returned
by widget getters is read-only. Schemas are not mutable through this API.

### TreeView and TextColumn

```nim
let view = newTreeView(rows)
let nameColumn = view.appendTextColumn("Language", 0)
nameColumn.resizable = true
scroll.add(view) # Direct native scroll-adjustments protocol; no viewport needed.
```

`newTreeView(model)` accepts ListStore or TreeStore models. `appendTextColumn(title, modelColumn)`
creates, binds, and attaches an owned TextColumn. Alternatively use
`newTextColumn(title, modelColumn)` followed by `view.appendColumn(column)`.
Attachment validates that the binding refers to a string column and the column
is not already attached. The binding index is immutable. Text uses the renderer's
plain `text` property, not markup. Numeric/bool values can be stored and read, but
this initial renderer surface displays string columns only.

TextColumn exposes `title`, `resizable`, and `visible`. It owns a native reference
and can outlive its original view; its native renderer is retained by the column,
not exposed as a separately wrapped borrowed object. Retained columns do not
automatically become destroyed just because their view closes. For self-capturing
inherited `onDestroy` handlers, retain/disconnect the Connection or call
`column.disconnectSignals()`; do not dispose a column still used by a view.

TreeView exposes `headersVisible`, `rulesHint`, read-only owning `model`, and
single-selection `selectedIndex` for flat models (`-1` clears or means no selection).
`onSelectionChanged(proc () = ...)` returns a normal connection and coalesces
native changes into a final-state observation at UI idle, without an initial
notification. This applies to single and multiple selection alike; callbacks must
not assume they run before a selection setter returns. Selection signals originate
on a separate GtkTreeSelection GObject: the wrapper tracks IDs
against that object and automatically disconnects them on view destruction.
They are not incorrectly tracked as TreeView signal IDs. `onRowActivated(proc
(row: int) = ...)` reports a copied flat row index; `activateRow(index)` emits
native activation and invokes registered callbacks, without selecting the row.
Native multi/browse selection modes configured through raw interop are rejected
by the single-selection helpers.

### Model-backed ComboBox

`newComboBox(model, textColumn = 0)` returns **ModelComboBox**, a ComboBox subclass
with the common `itemCount`, `activeIndex`, and `onChanged` operations. It requires
a flat model with a valid string column and internally owns/installs a text renderer. `model`
returns an owning TreeModel; read the selected cell through
`combo.model.value(combo.activeIndex, column)` after checking selection is not `-1`.

Models may be shared by multiple views and combos. Sharing data does not share
selection. Native row references update each widget's selected position when
rows shift or disappear. Models/bindings are intentionally fixed after widget
construction in this batch: there is no generic model setter that could silently
invalidate column bindings or replace ComboBoxText's private model. Editable
model-backed combos are also deferred; ComboBoxText still supports editable text.

### Model signals and ownership

`onRowInserted`, `onRowChanged`, and `onRowDeleted` accept `proc (row: int)` and
return normal connections. They run after ordinary native signal consumers;
callbacks receive copied indices, never borrowed path/iterator pointers.
A deletion's index identifies the former row, which can no longer be read;
after shifting, that index may already refer to a different row.
`clear()` emits native per-row deletions. Avoid structural model mutations or
cross-widget selection synchronization during native model notifications; finish
the current operation first. Indices are snapshots and may become stale if
another callback edits the model.

ListStore is a non-floating **GObject**, not GtkObject: its transfer-full reference
is adopted without ref-sinking. Borrowed widget getters retain a reference and
share a weak cached state. As with TextBuffer, there is no widget-style `destroy`
and inherited `onDestroy` raises `ValueError`. Callbacks disconnect when the last
Nim handle/Connection for that state disappears. Callbacks capturing the model or
widget tree may themselves keep it alive; disconnect their connections or call
`model.disconnectSignals()`, normally from the owning window's `onDestroy`.
Closing views does not invalidate retained models.

See [`examples/models.nim`](../examples/models.nim) for shared TreeView/ComboBox
data. It is compiled, not launched, during validation. Proxies and stable row
references are covered below. Multiple TreeView selection and editable text/toggle
columns are covered in the extensions below. Arbitrary custom cell renderers,
editable renderer types beyond these fixed layouts, and model replacement remain
future work. Pixbuf-backed IconView is covered below.

## Hierarchical TreeStore and TreePath

`newTreeStore(columns)` uses the same CellKinds and validation as ListStore.
It is an owned non-floating GObject with shared cached state, normal owning
TreeModel getters, and explicit `disconnectSignals()` for captured callbacks.
It has no widget-style `destroy()` or native destroy signal.

### Copied paths, not row identities

`treePath(0, 2, 1)` constructs a value path with zero-based child indices.
Components and depth must fit nonnegative `gint` values. `depth`, `indices`,
`parentPath`, `childPath(index)`, equality, and `$` inspect/derive paths.
`indices` returns a fresh sequence; modifying it cannot mutate the path.
Formatting produces colon-separated indices such as `"0:2:1"`.

**`treePath()` (or an uninitialized TreePath) is the virtual root**, not an actual
row. `isRoot` tests this empty path; actual top-level rows have paths such as
`treePath(0)` and are not virtual roots. The virtual root is used as the default
parent for top-level insertion and as the no-selection sentinel. Its parent
raises `ValueError` and it cannot be read, edited, deleted, expanded, or activated
as a row.

Paths are model-independent **position snapshots**, not persistent references.
Inserting/deleting a sibling shifts later paths; deleting a parent removes its
entire subtree. A saved path can become invalid or point to a different row.
Native GtkTreePath pointers are allocated/freed internally for each operation;
no borrowed C iterator or path escapes into a callback or public value.

### Hierarchical editing and querying

```nim
let store = newTreeStore([cellString, cellInt])
let folder = store.appendRow([cell("Source"), cell(1)])
let file = store.appendRow([cell("main.nim"), cell(2)], parent = folder)
store.setValue(file, 0, cell("app.nim"))
echo store.value(file, 0).stringValue
```

- `appendRow(values, parent = treePath())` and
  `insertRow(index, values, parent = treePath())` return a copied insertion path.
  The index is relative to the parent's children and accepts `0..childCount`.
- `setRow(path, values)` and `setValue(path, column, value)` update existing rows.
  Whole rows are validated before mutation and use native values-vector APIs,
  so insert/changed notifications observe populated rows rather than intermediate
  empty/per-cell states. Native child-presence notifications may also occur.
- `removeRow(path)` removes that row **and its descendants**. `clear()` removes
  every root/subtree. GTK emits its normal deletion notifications, not a separate
  deletion event for every descendant of a removed subtree.
- The read-only TreeModel interface supports `value(path, column)`,
  `hasRow(path)`, and `childCount(parent = treePath())` for list or tree models.
  `hasRow` returns false for the virtual root or a missing position;
  `childCount` requires a live parent row unless given the virtual root.
- `rowCount` always counts **top-level rows**, not all descendants. `isFlat`
  distinguishes list models from hierarchical ones.

Methods resolve fresh native iterators, including after temporary value-array
preparation and ancestor expansion. Invalid parents/rows, non-row virtual-root
operations, kind mismatches, bad strings, and out-of-range insertion positions
raise `ValueError` without partial row writes.

### TreeView hierarchy operations

`newTreeView(store)` and text columns work unchanged. Its owning `model` getter
now returns a generic TreeModel interface for either flat or hierarchical data.
Use `selectedPath` for single selection: assigning a nonempty path validates the
row and expands its **ancestors**, then resolves it again before selecting.
Assigning `treePath()` clears selection; reading an empty path means no selection.
`onSelectionChanged` retains the same automatic cleanup on view destruction.

`expandPath(path, recursive = false)` and `collapsePath(path)` return native
success booleans. `pathExpanded(path)` queries current expansion;
`expandAll()` / `collapseAll()` operate on the entire view. Paths must identify
existing rows; a leaf cannot meaningfully expand and follows native false-result
behavior. No visible window or event loop is needed for these tree-state updates.

`onPathActivated(proc (path: TreePath) = ...)` and `activateRow(path)` work for
both model kinds. Activation does not select a row or require it to be visible.
`onPathInserted`, `onPathChanged`, and `onPathDeleted` on TreeModel deliver copied
full paths after ordinary native consumers. Deletion paths identify former
positions, not readable deleted row data. Callbacks can self-disconnect and
exceptions are contained at the C boundary. Avoid structural edits inside model
notification callbacks, just as with flat models.

Flat-only operations now explicitly reject hierarchical models: integer-indexed
`value`, `selectedIndex` (even `-1`), `activateRow(int)`, integer-row callbacks,
and model-backed ComboBox construction. Use path-based counterparts for trees;
there is no silent fallback to the first path component.

See [`examples/trees.nim`](../examples/trees.nim) for an editable hierarchy with
expansion and subtree deletion. It is compiled, not launched, during validation.

## Sorting, filtering, and stable row references

### Read-only proxy models

`newTreeModelSort(child, column, order = sortAscending)` and
`newTreeModelFilter(child, visibleColumn)` return owned TreeModel subclasses.
They retain their child model without modifying its source order or data. Both
work with ListStore or TreeStore and can be composed:

```nim
let source = newListStore([cellString, cellInt, cellBool])
discard source.appendRow([cell("Nim"), cell(95), cell(true)])
let filtered = newTreeModelFilter(source, 2)
let sorted = newTreeModelSort(filtered, 1, sortDescending)
let view = newTreeView(sorted)
discard view.appendTextColumn("Name", 0)
```

Sort proxies use GTK's built-in comparisons for the four supported scalar kinds.
`sortBy(column, order)` changes configuration; `sortColumn` and `sortOrder` read
it. Orders are `sortAscending` and `sortDescending`. Sorting a hierarchy sorts
siblings at each level, not a flattened list. String ordering follows GTK/GLib
collation, not a promised byte-wise order. Custom comparisons and special native
"default/unsorted" configurations are not part of this initial API.

Filter construction requires an actual boolean column (`cellBool`). True means
visible, false means hidden; descendants of a hidden ancestor are not accessible
through the proxy even if their own flags are true. Source value changes update
filtering through native notifications. `refilter()` explicitly reevaluates the
model when needed. The visibility column is fixed at construction. Arbitrary
predicates, modify functions, and virtual-root filtering are deferred.

`childModel` returns an **owning** TreeModel for the immediate child. Proxy
schemas inherit their child schemas; read-only model queries, path selection,
text columns, and model signals work normally. Flat proxies can be used by
model-backed ComboBox; hierarchical proxies still require path-based helpers.
Retain the original proxy handles to configure sorting/filtering: a widget's
`model` getter returns the generic, read-only TreeModel interface.

### Keep source and displayed paths distinct

- `proxy.toChildPath(displayPath)` requires an existing proxy row and returns
  its position in the **immediate child model**.
- `proxy.fromChildPath(childPath)` requires an existing child row and returns its
  proxy position, or `treePath()` if filtering makes the row/ancestor unavailable.
- Virtual-root paths and missing input rows raise `ValueError`; a hidden but
  existing child row is distinct from a nonexistent row.

Each conversion allocates/frees native paths internally. With a proxy chain,
convert **one hop at a time** before mutating source data:

```nim
let displayed = view.selectedPath
if not displayed.isRoot:
  let inFilter = sorted.toChildPath(displayed)
  let inSource = filtered.toChildPath(inFilter)
  source.setValue(inSource.indices[0], 0, cell("Renamed")) # Flat source here.
```

TreePath has no attached model identity. Passing a numerically valid path from
another coordinate space can identify the wrong row; the wrapper cannot infer
which space the caller intended. Sharing models also does not synchronize widget
selection. Do not mutate models or cross-synchronize selections from model
notification callbacks; complete the current native operation first.

### Stable TreeRowReference

`newTreeRowReference(model, path)` creates a boxed native row reference for an
existing, non-root row. Unlike a TreePath snapshot, it tracks that row through
sibling insertions/deletions and reorders **within its model**:

```nim
let remembered = newTreeRowReference(source, treePath(0))
# Other rows may be inserted, removed, or reordered here.
if remembered.valid:
  echo source.value(remembered.path, 0).stringValue
```

`valid` is false for an uninitialized reference or a deleted row. `path` returns
a copied current TreePath and raises `ValueError` if invalid. Deleting an ancestor
invalidates references into its subtree. A reference in a filtered model becomes
invalid when its row is hidden; showing the row again does **not** resurrect that
reference. Keep a reference in the **source** model if it must survive filtering,
then convert its current path through the proxies when needed.

References retain their native model; `reference.model` returns another owning
TreeModel, including after row deletion. Copying a TreeRowReference shares one
native boxed allocation, freed once when its last Nim alias disappears. It is
not a GObject/Widget and has no signals or widget-style destruction.
`.raw` is a typed borrowed boxed pointer: do not free it or retain it past the
handle's lifetime.

### Reorder notifications and lifetime

`model.onRowsReordered(proc (parent: TreePath, order: seq[int]) = ...)` delivers
copied paths/arrays after ordinary native consumers. `parent` is the virtual root
for root-level reorders, or the parent row for a child-level reorder.
`order[newPosition]` is the child's **old** position, not a source/proxy mapping.
The callback can self-disconnect; exceptions are contained at the C boundary.
GTK may discard unreferenced proxy cache levels and omit their reorder events:
merely calling `rowCount` is not a guarantee that a level remains observed.
Native view/node references or a TreeRowReference keep relevant levels referenced.

Sort/filter proxies use the same non-floating GObject ownership and weak shared
state cache as the stores. There is no destroy signal; callbacks capturing the
proxy, references, or widget trees need explicit Connection disconnection or
`proxy.disconnectSignals()`, normally from the owning window's `onDestroy`.
Closing a view does not invalidate retained proxies/source models.

See [`examples/proxies.nim`](../examples/proxies.nim) for sorting, visibility
updates, coordinate conversion, and a stable source bookmark. It is compiled,
not launched, during validation.

## Pixbufs and IconView

### Owned pixels and Image integration

- `newPixbuf(width, height, rgba = 0x00000000'u32)` allocates and initializes an
  8-bit RGBA buffer. The fill value is `0xRRGGBBAA`, not host-endian pixel bytes.
- `loadPixbuf(filename)` loads a file through installed native loaders. Unlike
  `newImageFromFile`, failures raise `PixbufError`, retaining the native numeric
  `domain`, `code`, and copied message; native GErrors are freed. Filesystem names
  reject embedded NUL. Supported formats depend on installed loaders.
- `width`, `height`, and `hasAlpha` query a nonempty handle. Loaded images can be
  RGB without alpha. `copy()` allocates independent pixels;
  `scaled(width, height, interpolation = interpolateBilinear)` returns a new
  buffer, with `interpolateNearest`, `interpolateTiles`, `interpolateBilinear`,
  and `interpolateHyper` available.

Construction/scaling require positive dimensions fitting `gint`; conservatively
limit four-byte rowstride and total allocation to signed-gint range before native
allocation. Allocation failure raises PixbufError. No mutable pixel slice or
borrowed Nim-memory constructor is exposed. Use copies/new buffers for changes;
raw pixel edits do not automatically notify model/view renderers.

`newImage(pixbuf)`, `image.pixbuf = value`, and `image.pixbuf` provide in-memory
image display. Setters retain pixels; getters return owning handles, never stolen
references. The getter accepts empty/pixbuf storage and rejects stock/icon-name/
animation storage before reaching native assertions.

`Pixbuf()` is an explicit empty/NULL value: `isEmpty` is true, setting it on an
Image clears the image, and `cell(Pixbuf())` represents a NULL pixbuf model cell.
Dimensions, copying, scaling, and `.raw` require a nonempty handle. Pixbuf is a
non-floating GObject using the shared weak ownership cache; it has no destroy
signal or widget-style `destroy()`. Native references are released on the UI
thread when their last owning handles disappear.

### IconView

`newIconView(model, pixbufColumn, textColumn = -1)` accepts a **flat** model with
an actual pixbuf column and an optional plain string caption column. Bindings and
model are fixed for its lifetime. No markup column is enabled, so captions such
as `<b>Literal</b>` are displayed literally. NULL pixbuf cells are permitted.

```nim
let tiles = newListStore([cellString, cellPixbuf])
discard tiles.appendRow([cell("Ruby"), cell(newPixbuf(48, 48, 0xd94141ff'u32))])
let icons = newIconView(tiles, pixbufColumn = 1, textColumn = 0)
scroll.add(icons) # Native GTK2 scrolling; no viewport adaptation.
```

`model` returns an owning read-only TreeModel. Flat sort/filter proxies work
normally, including pixbuf reads. Sort by scalar caption/rank columns: sorting a
pixbuf column is rejected before GTK's built-in comparator is called.

- `selectionMode` shares TreeView's TreeSelectionMode enum and its
  selectionNone/selectionSingle/selectionBrowse/selectionMultiple values.
- `selectedIndex` uses `-1` for no selection; assigning `-1` clears it.
  `selectedPath` uses the virtual root for no selection. These convenience
  helpers remain **SINGLE-only** rather than arbitrarily choosing among many rows.
- `selectedPaths`/`selectedIndices` copy all selected positions in ascending model
  order in every mode. Assignment requires MULTIPLE and validates the entire input
  before clearing existing selection. Duplicates select the same row once.
- `selectPath`/`unselectPath` validate existing flat positions; pathSelected checks
  membership. selectPath rejects NONE. `selectAll` requires MULTIPLE. unselectAll
  and unselectPath reject BROWSE because native browse selection cannot be cleared.
- `selectedRows` creates stable TreeRowReferences in the displayed model. `selection`
  copies IconSelection(mode,model,paths,rows), retaining the model and one stable
  reference per path. The paths remain positional snapshots; references track later
  reorder/insertion and become invalid on deletion or filtering out of that proxy.
- `onSelectionChanged(proc () = ...)` now coalesces native changes at UI idle;
  it no longer runs synchronously inside GTK's native item traversal.
  The typed overload `proc(value: IconSelection)` collects a copied final selection
  at idle, not a snapshot of every intermediate native emission. Neither overload
  delivers an initial event. Mode-only changes without a native selection-change
  emission do not generate an observation. Observers may mutate models or destroy
  windows after GTK has finished using its selected-item list.
- `onActivated(proc(value: IconActivation))` captures a positional path and stable
  row reference at emission and delivers each activation at idle, without coalescing.
  A row may already be invalid when delivered. `onItemActivated(proc(index:int))`
  and `onPathActivated(proc(path:TreePath))` likewise now deliver at idle but expose
  only historical positional values. Prefer the stable-row form for delayed edits.
  Activation works in all selection modes; `activateRow(index)` emits activation
  without selecting the row automatically.
- `cursorPath` copies GTK's focus cursor, independently of selection. Assignment
  validates a nonempty existing path and does not start editing. GTK has no public
  clear-cursor operation; an unset getter returns the virtual root.
- `scrollToRow(index)` asks GTK to bring a row into view, including deferred
  scrolling before realization.
- `columns` and `itemWidth` accept positive values or `-1` for automatic sizing.
  `spacing`, `rowSpacing`, `columnSpacing`, and `margin` accept nonnegative pixels.

Mode changes explicitly clear selected items; assigning the same mode is a no-op.
GTK2's BROWSE unselect_all is a no-op even inside set_selection_mode(NONE), so the
SDK first leaves BROWSE through SINGLE, then clears through NONE before selecting
the requested mode. This uses public API only. It does **not** claim to clear the
native keyboard cursor/range anchor: GtkIconView exposes no public anchor reset.
The fixed model is never rebound as a workaround, private fields are untouched,
and no fake input is synthesized. Ordinary unmodified navigation establishes a
fresh native anchor; Shift/Ctrl extension otherwise retains native semantics.

```nim
icons.selectionMode = selectionMultiple
icons.selectedIndices = [0, 2]
icons.onSelectionChanged(proc (value: IconSelection) =
  for row in value.rows:
    if row.valid: echo value.model.value(row.path, 0).stringValue)
```

Native selected-item lists, cursor paths and every allocated path are freed after
copying. All callbacks contain exceptions, support self-disconnection and cancel
pending delivery on disconnect or widget destruction. Payloads retain model/row
objects, not the view. The typed selection bridge weakly borrows the native view
until idle and pins it while collecting a snapshot; native destruction cancels the
bridge before that pointer can be used. Explicit widget destruction/disconnection
still breaks application self-capture cycles. All operations, callbacks and final
releases stay on the UI thread under ARC/ORC. Native/raw synchronous handlers remain
subject to GTK's reentrancy restrictions; do not use them to bypass these rules.

Coordinates refer to the displayed model: convert proxy paths one hop at a time
before source edits, and create stable **source** references before deleting many
rows. A proxy reference is not automatically a source reference. Custom/editable
renderers, model drag-and-drop and model replacement remain separate work.

[`examples/icons.nim`](../examples/icons.nim) demonstrates generated color tiles,
a scaled preview, multiple/single mode switching, select-all/clear, stable multi-row
source deletion through sort/filter proxies and safe activation. Hidden tests cover
modes, atomic validation, coalescing, reference invalidation, cancellation and
reentrant destruction without mapping windows. A native C probe checks the cursor
pointer-to-pointer/gboolean ABI. `testMappedIconSelection` additionally verifies real
Shift range selection, Ctrl+A, mode transitions, Unicode and Return activation with
XTEST on an explicitly isolated Unix X11 display. It refuses to run without
GTK2_TEST_VIRTUAL_DISPLAY=1; never run it on an ordinary desktop.

## Calendar and selector controls

`Calendar`, `ColorButton`, `FontButton`, `ScaleButton`, and `VolumeButton` share
ordinary widget ownership, typed borrowed `.raw`, and tracked safe connections.
See [`examples/selectors.nim`](../examples/selectors.nim).

### Calendar

```nim
let calendar = newCalendar(2024, 2, 29)
calendar.date = (2025, 12, 31)
calendar.selectDate(2025, 12, 0) # Explicitly clear the selected day.
calendar.options = calendar.options + {calendarWeekNumbers}
calendar.markDay(15)
calendar.onDaySelected(proc (date: CalendarDate) =
  echo date.year, "-", date.month, "-", date.day)
```

`CalendarDate` is a copied `(year, month, day: int)` tuple. Programmatic dates
use years 1..9999, **one-based months** 1..12, and actual Gregorian days (including
leap-year validation). Day 0 means no selection. `newCalendar()` initially uses
GTK's current local date. Native navigation is not restricted to the setter's
year range.

`date`, `selectDate`, `markDay`, `unmarkDay`, and `clearMarks` do not retain
native iterators or callback pointers. Mark/unmark require a day that exists in
the currently displayed month: GTK2 otherwise emits invalidation warnings for
e.g. February 31. Marks are day numbers, not dated events, and persist across
month changes. Use `clearMarks()` to remove all marks, including those not
currently visible.

`CalendarOptions` is a set of `calendarHeading`, `calendarDayNames`,
`calendarFixedMonth`, `calendarWeekNumbers`, and `calendarDetails`. `options=`
replaces the complete option set. Week start follows GTK's locale; the obsolete
Monday-start flag is not exposed. Custom detail/markup callbacks are deferred.

`onDaySelected`, `onMonthChanged`, and `onDayActivated` receive copied dates.
The last means native double-click activation. Native signals also fire during
programmatic date selection; changing month first clears the old selected day
so GTK2 never tries to invalidate January 31 in February. Notifications are
**not atomic** and may report day 0 before the final selection. Destruction from
these callbacks stops remaining native calls. Avoid recursively changing the
date inside its own notifications.

### Color and font buttons

```nim
let colors = newColorButton(rgba16(65535, 12000, 0, 32768), useAlpha = true)
colors.onColorSet(proc (color: Color) = echo color.red, " / ", color.alpha)
let fonts = newFontButton("Sans Bold 12")
fonts.useFont = true
fonts.onFontSet(proc (name: string) = echo name)
```

`Color` contains copied unsigned 16-bit `red`, `green`, `blue`, and `alpha`
channels. `rgba16` validates integer channels in 0..65535; it does **not** use
8-bit or floating-point channels. `color` reads/writes all four channels;
`useAlpha` controls alpha UI without discarding the stored alpha. No GDK pixel
or colormap identity escapes. Both buttons have copied UTF-8 `title` properties.

`FontButton.fontName` accepts nonempty valid UTF-8 Pango descriptions, not a
promise that a particular font is installed. GTK/Pango choose native fallbacks.
GTK2's setter result is not font validation: the cached description updates even
when no chooser has been created. `useFont`/`useSize` affect the button's own
label; `showStyle`/`showSize` control the displayed description, not application
text styling.

`onColorSet` and `onFontSet` represent user acceptance in GTK's native chooser.
Property assignments do not emit these signals. Callback colors/strings are
copied before user code runs, and remain valid after changes or destruction.
These buttons manage private child widgets; inherited `Button.text=` rejects
replacing those widgets, even after an upcast. To open a chooser, use normal
user interaction; tests never click them or launch a dialog.

### Scale and volume buttons

`newScaleButton(lower = 0, upper = 100, step = 1, icons = [],
size = iconSmallToolbar)` creates a popup scale. Bounds and their span must be
finite, lower < upper, and step positive with finite page increment. Icon names
must be nonempty UTF-8 strings; `setIcons` copies a null-terminated native vector.
An empty list clears custom icons. `newVolumeButton()` uses GTK's themed speaker
icons and native 0..1 adjustment defaults.

Both expose finite numeric `value`, with native clamping, and an owning shared
`adjustment` getter/setter. A retrieved adjustment survives widget destruction
and can be shared with `SpinButton`. Use the same UI-thread and explicit
self-capture cleanup rules as other Adjustment handles. `onValueChanged(proc
(value: float64) = ...)` receives the native double signal payload through a
typed C trampoline, with exception containment and self-disconnection support.
The popup, plus/minus buttons, and other private children are not exported as
reparentable widgets. Inherited `Button.text=` is rejected here too.

## Scales, scrollbars, and Arrow

`HScale`, `VScale`, `HScrollbar`, and `VScrollbar` derive from the public `Range`
handle. Scales also derive from `Scale`, and scrollbars from `Scrollbar`.
These bases have typed borrowed `.raw` but no abstract-widget constructors.
See [`examples/ranges.nim`](../examples/ranges.nim).

```nim
let amount = newAdjustment(25, 0, 100, 1, 10)
let slider = newHScale(amount)
let numeric = newSpinButton(amount)
slider.digits = 1
slider.valuePosition = valueRight
slider.addMark(50, "Middle <50> & center") # Plain text, not Pango markup.
slider.onValueChanged(proc (value: float64) = echo value)
let pages = newHScrollbar(pageSize = 20)
pages.value = 100 # Native clamp to 80 = upper - pageSize.
```

### Numeric ranges and ownership

Scales accept an existing `Adjustment` or numeric `lower`, `upper`, `step`
arguments (defaults 0, 100, 1). Numeric scale constructors require finite bounds
and span, lower < upper, and a positive finite step with finite ten-step page
increment. GTK computes the initial precision from the step.

Scrollbar constructors accept an existing Adjustment or named `value`, `lower`,
`upper`, `stepIncrement`, `pageIncrement`, and `pageSize` (defaults 0, 0, 100, 1,
10, 10). Their numeric validation matches `newAdjustment`. For scrollbars the
maximum value is `upper - pageSize`; the page also controls thumb size. Normally
use pageSize 0 for scales. Native allocation/scrolling can change adjustments
shared with other widgets.

`adjustment` returns an owning, shared handle, never a stolen native reference.
It survives range destruction; `adjustment=` replaces the model without
invalidating handles to the previous one. The same Adjustment can drive multiple
ranges and SpinButtons. Do not explicitly destroy an Adjustment still in use by
widgets; normally release its handles instead.

All ranges have finite `value` with native clamping, `inverted`, and `flippable`
(right-to-left mirroring eligibility). `setIncrements(step, page)` validates
both finite nonnegative values before changing anything. `setBounds(lower,
upper)` requires a positive finite span large enough for the current page size.
It preserves adjustment identity, increments, and page size, using the native
Adjustment configure operation to notify shared consumers safely.

### Scale display and marks

`digits` accepts -1 (no input rounding) or 0..64. It controls display precision
and native interactive input rounding, not decimal arithmetic or rounding of
all programmatic Adjustment writes. `drawValue` toggles the numeric label.
`valuePosition` uses `valueLeft`, `valueRight`, `valueTop`, and `valueBottom`.

`addMark(value, text = "", position = valueBottom)` accepts finite positions
and valid UTF-8 plain text. Labels are markup-escaped, copied by GTK, and the
temporary escaped native string is freed. Empty text produces a tick only;
`clearMarks()` removes all ticks and labels. Mark positions outside current
bounds are left to GTK's native clipping. Custom formatting callbacks, arbitrary
markup, fill-level overlays, and special update policies are deferred.

### Deferred value observers

Unlike ordinary synchronous widget signals, `Range.onValueChanged(proc (value:
float64) = ...)` delivers the **latest copied value on a subsequent UI idle
turn**. Repeated changes before delivery coalesce. Registration and value
setters do not start or pump a loop; delivery requires ordinary main-context
iteration (normally `window.run()`).

This is intentional: GTK2's keyboard/scroll handlers continue accessing a range
and its Adjustment after their native value-changed signals. Destroying a range
from those signals can crash inside GTK. Idle delivery permits closing windows,
destroying the emitter, or self-disconnecting without leaving GTK's input stack
using disposed objects. Do not attach raw callbacks and assume they have these
stronger safety semantics.

The observer follows `adjustment=` replacements, unregistering from the old
Adjustment. A replacement with a different value queues the new snapshot.
Assignments with no numeric change do not queue notifications. Disconnecting or
destroying the widget cancels pending delivery and releases captures. Exceptions
are contained as for other callbacks; a callback-triggered value change is
delivered on a later idle turn. Self-captures still require explicit cleanup.

### Decorative Arrow

`newArrow(direction = arrowDown, shadow = shadowOut)` creates a noninteractive
widget. `direction` uses `arrowUp`, `arrowDown`, `arrowLeft`, `arrowRight`, or
`arrowNone`; `shadow` reuses `ShadowStyle`. Properties preserve the other setting,
or set both with `setArrow(direction, shadow)`. Getters use native enum properties,
not private struct fields. Arrow has no button signals or child container API.

## Additional layout containers

`Alignment`, `HButtonBox`, `VButtonBox`, `Table`, `Fixed`, and `EventBox` are
supported GTK2.24 widgets, regardless of their later GTK3 deprecation status.
They use normal shared widget ownership and typed borrowed `.raw` access. See
[`examples/containers.nim`](../examples/containers.nim).

### Alignment and EventBox

`newAlignment(xalign = 0.5, yalign = 0.5, xscale = 0, yscale = 0)` is a
single-child `Bin`. Alignment fractions place the natural-size child, and scale
fractions control how much extra allocation it receives. All four values must
be finite and in 0..1. `alignment` returns a copied tuple; `setAlignment` validates
all four values before applying them. `setPadding(top, bottom, left, right)`
sets pixel padding, with a copied `padding` getter. Values and combined opposing
padding must fit a nonnegative native gint.

`newEventBox(visibleWindow = true, aboveChild = false)` is another single-child
Bin. `visibleWindow` controls whether GTK creates its own visible GDK window;
`aboveChild` controls event-window stacking relative to its child. A visible GDK
window does not show the widget by itself. These are native flags, not high-level
mouse/key callbacks; broader event APIs remain deferred. Both containers use
checked `add`, rejecting occupied bins, already-parented children, toplevels,
and cycles.

### Button boxes

`newHButtonBox(spacing = 6, style = buttonsEnd)` and `newVButtonBox(...)` derive
from `ButtonBox`, itself a `Box`. Use inherited `packStart`/`packEnd`, usually with
`packShrink`. `layoutStyle` accepts `buttonsDefault`, `buttonsSpread`,
`buttonsEdge`, `buttonsStart`, `buttonsEnd`, or `buttonsCenter`.
`setSecondary(child, value = true)` places a direct child in GTK's secondary
group; `secondary(child)` reads that flag. Nonmembers are rejected before GTK.
The actual placement of the secondary group depends on the chosen layout style
and native right-to-left direction.

`spacing` is 0..32767, matching GtkBox's signed 16-bit storage. All Box
constructors now enforce that bound, and inherited packing padding is restricted
to 0..65535 to prevent truncation in native GtkBoxChild storage.

### Table

```nim
let table = newTable(2, 2)
table.rowSpacing = 6
table.columnSpacing = 10
table.attach(newLabel("Name:"), 0, 1, 0, 1, xoptions = {}, yoptions = {})
table.attach(newEntry(), 1, 2, 0, 1, yoptions = {})
```

Dimensions are 1..65535, matching native 16-bit row/column storage. `dimensions`,
`rowCount`, `columnCount`, and `homogeneous` expose native state.
`attach(child, left, right, top, bottom, ...)` uses zero-based **half-open**
attachment rectangles. The entire rectangle must fit within current dimensions;
the wrapper never silently enlarges the table. Overlapping attachments are
legal GTK layouts and are not rejected.

`xoptions`/`yoptions` are sets of `attachExpand`, `attachShrink`, and `attachFill`,
defaulting to expand+fill. They map to native bit flags, not booleans.
`xpadding`/`ypadding`, default spacing, and per-row/column spacing are restricted
to 0..65535. `rowSpacing=`/`columnSpacing=` set all current row/column spacings and
the defaults. `setRowSpacing(row, spacing)` and `setColumnSpacing(column, spacing)`
set indexed overrides, with matching indexed getters. Indices must already exist.

`cellBounds(child)` returns a copied `(left, right, top, bottom)` tuple for a
direct child. `resize(rows, columns)` refuses to shrink across existing child
attachments rather than accepting GTK's implicit size correction. Validation
finishes before native mutation. Child lists and temporary GValues used for
inspection are freed; private GtkTable fields are never read by the wrapper.

### Fixed placement and removal

`newFixed()` supports `put(child, x, y)`, `move(child, x, y)`, and copied
`position(child)`. Coordinates are signed native gint pixels, including negative
positions. `put` requires an unparented child; moving/querying requires direct
membership. Absolute placement is useful for small special-purpose surfaces,
not a replacement for responsive box/table layouts or a scrollable virtual canvas.

`Container.remove(child)` validates direct membership and unparents without
destroying a child retained by a Nim handle. It can then be attached/packed into
another container. Use specialized notebook/pane APIs when their semantics are
needed; this generic method does not target private content-area grandchildren.
Dropping the last handle to an unparented child can finalize it normally.
Destroying a container still destroys its remaining descendants, releases their
callbacks, and invalidates retained aliases. No compatibility or raw-pointer
adoption helpers are introduced.

## Menu-bar trees and accelerator labels

The public menu family includes `MenuBar`, `Menu`, `MenuItem`, `CheckMenuItem`,
`RadioMenuItem`, `ImageMenuItem`, `SeparatorMenuItem`, `TearoffMenuItem`, and
`AccelLabel`. `Item`
and `MenuShell` are hierarchy bases with no abstract constructors. See
[`examples/menus.nim`](../examples/menus.nim).

Tearoff menus are supported for GTK2. Their later GTK3.4 deprecation does not
exclude them from this GTK2 API.

```nim
let bar = newMenuBar()
let file = newMenuItem("_File", mnemonic = true)
let actions = newMenu()
bar.append(file)
file.submenu = actions
let close = newMenuItem("_Close", mnemonic = true)
actions.append(close)
close.onActivate(proc () = window.destroy())
```

Pack a MenuBar into a normal box; native GTK handles menu navigation and label
mnemonics. Menu item constructors take checked UTF-8 text and optional
`mnemonic = true`. `text` copies strings and `useUnderline` toggles mnemonic
interpretation. Normal Label/AccelLabel text writes also validate UTF-8, including
after Label upcasts. Menu labels are not interpreted as markup.

### Insertion and submenu ownership

`append(item)`, `prepend(item)`, and `insert(item, index)` accept MenuItems, not
arbitrary widgets. Indices are zero-based; insertion accepts 0..itemCount.
`itemAt(index)` returns an owning generic MenuItem handle, sharing cached state
with an existing typed handle. Keep the original CheckMenuItem/RadioMenuItem/etc.
handle for specialized operations. Removing an item uses checked
`Container.remove(item)` and does not destroy an explicitly retained handle.

Assign `item.submenu = menu` to attach a Menu. Menus have private popup-window
parents in GTK2, so validation follows their **logical attach widgets**, not just
native widget-parent pointers. Already-owned menus and ownership cycles are
rejected, both when assigning a submenu and when inserting an item that already
owns the destination menu. Reassigning the same submenu to the same item is a
no-op. `clearSubmenu()` detaches it; retained submenu handles remain live.
`hasSubmenu` tests availability; `submenu` returns an empty Menu handle when absent
(`isDestroyed` is true). No borrowed pointer or private popup window escapes.

Separators belong only in Menus, not MenuBars. Even after upcasts they reject
text, activation, submenus, and child content. Tearoff items are also menu-only
and reject labels, mnemonics, submenus, and child content, but allow activation
once inserted into a Menu. General sensitivity and visibility operations remain
ordinary Widget methods.

### Tearoff menus

Prepend `newTearoffMenuItem()` to a Menu to provide GTK2's detachable-menu row.
User activation toggles its native floating window. Programmatic `activate()`
also works, but rejects unparented tearoff items before calling GTK. Both
activation and `tornOff = true` realize the Menu first when necessary: GTK2
otherwise dereferences a missing GdkWindow if the menu has never been opened.
As with other widgets, show the menu's intended items (`window.showAll()` or
`menu.showAll()`) before displaying it.

`menu.tornOff` reads/writes the native tearoff state. **Setting it true opens a
visible detached window**; false returns the menu to its normal state.
`menu.tearoffTitle` is a copied, checked UTF-8 string for that window's custom
title. Assign an empty string to restore GTK's automatic title from the attaching
menu item; the getter then returns empty, not the computed automatic title.
Destroying the menu destroys its native floating window as well. No separately
owned Window handle or private tearoff child is exposed.

`onTearoffChanged(proc (tornOff: bool) = ...)` observes copied native state after
a row activation, programmatic change, or window-manager close. Connections
support self-disconnection and exception containment; destruction cancels them.

The sampler includes the dashed tearoff row, a separate **Detach/Reattach File
menu** button, and a live state indicator. GTK initially leaves a detached menu
at the popup's position, which can look unchanged under window managers that
do not decorate menu windows. Click its arrow/dashed row to reattach, or use the
explicit button. `buildMenuExample()` builds the same UI for integration tests
without showing it or starting a loop.

Normal hidden tests only construct, insert/remove, validate titles, inspect
state, and set tornOff=false. Actual detach/reattach tests live separately in
`tests/tmappedmenus.nim` and must run on an isolated virtual display:

```sh
GTK2_TEST_VIRTUAL_DISPLAY=1 G_DEBUG=fatal-warnings xvfb-run -a nimble testMappedMenus
```

They exercise the actual example, first-popup realization, native menu-shell
activation, live title changes, reattachment, floating-window close/destruction,
and callback cleanup. Without the explicit environment opt-in, the test exits
before initializing GTK. Do not run these mapped tests on your desktop display.

### Stateful and image items

CheckMenuItem exposes `active`, `inconsistent`, and `drawAsRadio`. The last changes
appearance only; use RadioMenuItem for actual groups. `newRadioMenuItem(group,
text)` joins a live member's group without exposing a borrowed GSList.
`joinGroup(group)` normalizes GTK2's otherwise possible two-active-member merge,
keeping the existing group's choice before later explicit activation. Joining
the same group is a no-op.

`onActivate` and `onToggled` are tracked closure connections, run after native
signal defaults. They support self-disconnection, exception containment, and
closing/destroying the menu's owner tree. `activate()` is programmatic native
activation, not a promise to honor user-interaction eligibility such as
sensitivity. GTK2 implements CheckMenuItem `active=` through activation: a changed
assignment can emit **both toggled and activate**. Do not use activation callbacks
as an indication that only a physical user click occurred.

ImageMenuItem has an owning optional `image` getter, checked `image=` assignment,
`clearImage()`, and `alwaysShowImage`. Only unparented Images can be installed;
setting the current Image again is a no-op. The native theme can hide menu images
unless `alwaysShowImage` is true. GTK2 clears this private image slot on item
destruction: retained Image handles remain live and unparented, unlike ordinary
children destroyed recursively with a container. Dispose of unused retained
images normally.

### AccelLabel and lifetime

`newAccelLabel(text)` derives from Label. `accelWidget=` monitors a live widget;
self-monitoring is rejected. `accelWidget` returns an owning generic Widget handle,
or an empty handle when no target is installed. GTK holds a strong reference to
the monitored widget; `clearAccelWidget()` releases it. `refetch()` refreshes
native accelerator display state and `accelWidth` reads its native column width.
A destroyed monitored target is never resurrected through a getter: cached
destruction tombstones raise ValueError until the target is cleared/replaced.
Window-local action shortcuts are now covered by the actions/accelerators guide
below. AccelLabel.accelWidget monitors widget closures; action-created menu items
instead monitor the shared action closure directly. Ordinary menu mnemonics work
without extra registration.

Widget constructors now use the same weak native-state cache as borrowed
getters, so aliases share destruction tracking and connections without stealing
references or introducing a cache ownership cycle. GTK2 menu trees and accelerator
labels can themselves contain **native** reference cycles. Explicitly destroy
standalone/unattached menu roots and unused unparented menu items; do not rely on
merely dropping their Nim handles. For an attached menu bar, explicitly destroying
its window destroys the menu tree and releases captures. Also destroy standalone
AccelLabels or clear their monitored widgets when done. All operations and final
releases remain on the UI thread.

Standalone popup positioning, custom accelerator routing, menu grid attachment
remain raw APIs. Shared actions, window-local accelerator groups and UIManager
are covered below.
Tearoff floating-window internals remain owned and managed by GTK.

## Toolbars and tool palettes

[`examples/toolbars.nim`](../examples/toolbars.nim) demonstrates all nine widgets:
Toolbar, ToolItem, ToolButton, ToggleToolButton, RadioToolButton, MenuToolButton,
SeparatorToolItem, ToolPalette, and ToolItemGroup.

```nim
let toolbar = newToolbar()
toolbar.toolbarStyle = toolbarBothHorizontal
toolbar.iconSize = iconLargeToolbar
let open = newToolButton("_Open", mnemonic = true)
open.image = newImageFromIcon("document-open", iconLargeToolbar)
open.important = true
open.onClicked(proc () = echo "Open")
toolbar.append(open)
let pin = newToggleToolButton("Pin")
pin.important = true # Keep its label in toolbarBothHorizontal style.
toolbar.append(pin)
pin.onToggled(proc () = echo pin.active)
let custom = newToolItem()
custom.add(newEntry("Search"))
toolbar.append(custom)
```

### Toolbar items and presentation

`append`, `prepend`, and `insert(item, index)` accept ToolItems only and require
unparented children. Insertion indices are 0..itemCount; `itemAt(index)` accepts
0..<itemCount and returns an owning, cached **generic ToolItem** alias. Keep the
specialized constructor handle for button state and editing. `itemIndex(item)`
and inherited `remove(item)` require direct membership. Cycles, including those
through attached menus, are rejected before calling GTK. Only the modern GTK2
ToolItem-based toolbar API is used, never the incompatible legacy append APIs.

Toolbar exposes `orientation` (`horizontal`/`vertical`), `toolbarStyle`
(`toolbarIcons`, `toolbarText`, `toolbarBoth`, `toolbarBothHorizontal`), `iconSize`,
`showArrow`, and read-only `reliefStyle`. In `toolbarBothHorizontal`, GTK only
shows labels on important tools (or in vertical orientations); mark text-only
tools `important = true`, or use `toolbarText`/`toolbarBoth` for all labels.
`resetToolbarStyle()` and
`resetIconSize()` restore native settings/theme defaults. ToolItem exposes its
inherited orientation/style/icon size/relief, plus writable `homogeneous`,
`expand`, `visibleHorizontal`, `visibleVertical`, `important`, and plain UTF-8
`tooltipText`. For custom content, use `newToolItem().add(widget)`. ToolButtons
manage private native children; replacing them via Bin upcasts is rejected.
SeparatorToolItem rejects child content and exposes `draw`; setting it false and
`expand` true creates a flexible spacer.

ToolButton has copied UTF-8 `text`, `useUnderline`, `stockId`, `iconName`, and an
optional owning `image` getter/checked `image=` setter. Only an unparented Image
can be assigned; assigning the current image again is a no-op. `clearImage()`
clears it; empty stock/icon names clear those properties. Native GTK determines
image/stock/name precedence and theme rendering. Mnemonic underscores affect the
native overflow-menu entry, not an installed toolbar keyboard shortcut.

ToggleToolButton exposes native `active`; `newRadioToolButton(member, text)` and
`joinGroup(member)` create/join mutually exclusive native radio groups. No
borrowed GSLists or private GtkRadioButtons are exposed. Changing active state
can emit both `toggled` and `clicked`, including programmatic changes. `onClicked`
and `onToggled` use tracked, exception-contained closures after native defaults.
They permit self-disconnection and destruction. There is deliberately no fake
`click()` that merely emits the outer ToolButton signal without updating its
private native toggle/radio button.

### MenuToolButton

The main button's `onClicked` action is separate from its dropdown arrow. Assign
`menu = menu`, inspect `hasMenu`/the owning cached `menu` getter, or detach with
`clearMenu()`. Menus may have only one logical owner, shared with MenuItem's
submenu checks; cycles and multiple attachment are rejected. `arrowTooltipText`
is plain UTF-8. `onShowMenu` permits lazy population before native popup.

**Call `menu.showAll()` after populating dropdown items**: an attached menu is
not a normal MenuToolButton child, so the window's showAll does not traverse it.
This shows the menu's items without popping it up. GTK2 detaches, rather than
destroys, retained menus when a MenuToolButton is destroyed. Explicitly destroy
standalone dropdown menus when finished (the example uses `defer: menu.destroy()`).
Clearing/replacing a menu likewise leaves retained handles live.

### ToolPalette and ToolItemGroup

Add groups in display order with `palette.add(group)`, then insert ToolItems into
groups using `append`, `prepend`, or `insert`. `groupCount`, `groupAt`, and
`groupIndex` inspect native order with owning cached group getters. Groups expose
`itemCount`, `itemAt`, `itemIndex`, `moveItem(item, index)`, copied UTF-8 `text`,
`collapsed`, `ellipsize`, and `headerRelief`. Member operations require direct
membership, and movement indices must identify an existing position.

`setItemPacking(item, homogeneous=true, expand=false, fill=true, newRow=false)`
sets group child packing; `itemPacking(item)` copies all four values. These are
separate from ToolItem's toolbar packing properties. `setExclusive(group)` makes
opening that group collapse other groups; `setGroupExpand(group)` requests spare
space. Their corresponding getters are `exclusive(group)` and `groupExpand(group)`.
Removal disconnects GTK2's otherwise lingering exclusive-group notification.

Palette exposes orientation, toolbarStyle/iconSize with resets, and owning
`horizontalAdjustment`/`verticalAdjustment` getters. Adjustments are available
after adding the palette to a ScrolledWindow; before that they raise ValueError.
ScrolledWindow uses the palette's native scrolling protocol without a Viewport.
Palette destruction retains a child snapshot and destroys every group, avoiding
GTK2's native mutating-array traversal that otherwise skips alternate groups.
This also works when a containing window is destroyed or temporary Nim handles
have already been released. Group destruction also cancels native animation
sources whose user-data pointer is that group: GTK2 otherwise leaves borrowed
animation timeouts pointing at freed objects. This cleanup uses public GLib APIs,
not private struct layouts, and survives release of temporary handles.

Native GTK2 group-position reordering is defective and is not exposed here;
construct groups in order. Drag-and-drop, custom group-header widgets, custom
labels/overflow proxies, and GtkAction integration remain raw APIs. No hover
styling workaround is installed.

## Scrollable Layout and detachable HandleBox

[`examples/positioned.nim`](../examples/positioned.nim) combines a scrollable
positioned canvas with a detachable toolbar.

```nim
let scroller = newScrolledWindow()
let canvas = newLayout(1600, 1000)
scroller.add(canvas) # Native scrolling; no Viewport.
let button = newButton("Move me")
canvas.put(button, 40, 90)
canvas.move(button, 200, 120)
echo canvas.position(button)

let dock = newHandleBox(handleLeft, shadowOut, snapTop)
dock.add(newToolbar())
dock.onChildDetached(proc (child: Widget) = echo "Detached")
dock.onChildAttached(proc (child: Widget) = echo "Attached")
```

### Layout

`newLayout(width=100, height=100)` creates its own native adjustments. The overload
`newLayout(horizontalAdjustment, verticalAdjustment, width=100, height=100)` shares
live models. The owning `horizontalAdjustment`/`verticalAdjustment` getters retain
native references; corresponding setters replace models without invalidating old
retained handles. Adding to ScrolledWindow installs that scroller's adjustments,
so obtain the getters after parenting when observing the current scrolling models.
Native allocation may update adjustment bounds and page sizes.

`setSize(width, height)` sets the virtual canvas, and `dimensions` copies the stored
size, not the allocated viewport size. Dimensions accept 0..high(cint), conservatively
limiting GTK's unsigned fields to signed GDK geometry. Both values are validated
before any native change. Placing children does not enlarge the canvas automatically;
children may overlap or have coordinates outside its extents.

`put(child, x, y)` requires an unparented, non-window child and rejects containment
cycles. Coordinates must fit signed gint, including negative values. `move(child,
x, y)`, `position(child)`, and inherited `remove(child)` require direct membership.
Movement validates both coordinates before changing either. `childCount` and
`childAt(index)` inspect native insertion order; the latter returns an owning
cached generic Widget alias and accepts 0..<childCount. Retain the specialized
handle to edit a Button/Entry/etc. Removed retained children remain live; destroying
the Layout destroys its children and invalidates aliases. Freeze/thaw and direct
bin-window drawing remain outside this wrapper batch.

### HandleBox

HandleBox is a single-child Bin; `add(child)` and inherited `remove(child)` preserve
normal checked parenting. `hasChild` inspects its slot, and `child` returns an owning
cached generic Widget alias (empty when unoccupied). Retained removed content can
be reparented; destroying the box also destroys its child, including a toolbar tree.

`handlePosition` is `handleLeft`, `handleRight`, `handleTop`, or `handleBottom`;
`shadow` uses the shared ShadowStyle. `snapEdge` accepts `snapLeft`, `snapRight`,
`snapTop`, `snapBottom`, or `snapAutomatic`. Automatic snapping is native value -1,
not an unsigned bitfield value: the wrapper calls GTK methods and preserves that
sentinel. `childDetached` is a read-only native boolean. Drag the handle to detach;
drag back to snap, or close the native floating window to reattach. GTK owns that
floating GdkWindow; no public setter for detached state or private-window handle
is exposed. Detachment is meaningful only once the widget is realized by GTK.

**`onChildAttached` and `onChildDetached` are deferred to UI idle and coalesced per
connection**, unlike ordinary synchronous button callbacks. GTK2 drag handlers
continue accessing native windows after emitting these signals, so immediate user
code must not destroy the box there. Each observer retains the latest owning child
snapshot for its signal. An event payload is not a promise of the current attachment
state; query `childDetached` for that. Pending notifications are cancelled on
connection disconnection/box destruction, and destroyed children are not delivered.
Callbacks contain exceptions and permit self-disconnection, removal, and destruction.
All delivery and final releases remain on the UI thread.

Hidden tests inject attachment signals and pump bounded idle work; they never start
a drag, detach content, realize a floating window, or show the example. The raw
HandleBox binding now includes the native boolean getter and removes the obsolete
snap-edge bitfield helpers that collided with the real GTK setter.

## Standalone color/font choosers

[`examples/choosers.nim`](../examples/choosers.nim) demonstrates ColorSelection,
FontSelection, ColorSelectionDialog, and FontSelectionDialog. These complement,
not replace, the existing ColorButton/FontButton: use a button for a compact
control with its own popup, a panel for embedding, or a dialog for direct
nonblocking lifecycle and response control. GTK2.24 supports all four widgets.

```nim
let colors = newColorSelection(rgba16(12000, 28000, 48000, 50000), useAlpha = true)
root.packStart(colors)
colors.onColorChanged(proc (value: Color) = echo value.red)
let fonts = newFontSelection()
root.packStart(fonts) # root must already belong to a Window before setting font.
fonts.fontName = "Sans 12"
fonts.previewText = "The quick brown fox — café 123"
fonts.onFontChanged(proc (name: string) = echo name)
```

### Color panels and dialogs

`newColorSelection(color=rgba16(0,0,0), useAlpha=false, hasPalette=false)` creates an
embeddable VBox-derived panel. `newColorSelectionDialog(title="Pick a Color",
color=..., useAlpha=false, hasPalette=false, modal=false)` creates a hidden dialog;
the parent overload adds checked transient ownership and defaults
`destroyWithParent=true`. Both types expose copied `color`, `previousColor`,
`useAlpha`, `hasPalette`, and read-only `isAdjusting`. Constructors initialize
current and previous swatches to the supplied color.

Colors reuse the existing checked `rgba16`/Color value type (channels 0..65535).
**Native ColorSelection getters report alpha 65535 while opacity controls are
disabled**, for both current and previous colors. Stored opacity is preserved;
enable `useAlpha` to read or edit it. Assigning a full RGBA value updates native
RGB and alpha sequentially, not as an atomic GTK transaction. `previousColor`
updates the comparison swatch, not the current selection. `isAdjusting` is a
current native drag-state query, not a guarantee that an idle observer is still
inside that drag.

### Font panels and dialogs

`newFontSelection()` creates an embeddable VBox-derived panel;
`newFontSelectionDialog(title="Pick a Font", modal=false)` creates a hidden dialog,
with the same parent/destroyWithParent overload as other dialogs. Both expose
`fontName`, `setFontName(description)`, `fontName=`, and `previewText`.
Descriptions must be nonempty valid UTF-8 without NUL; previews accept empty
valid UTF-8 plain text. Font-name getters copy and free GTK's transfer-full string,
unlike the borrowed-string getter on FontButton.

**Parent a FontSelection into a Window before setting its font.** It needs a screen,
even though the window need not be realized, shown, or mapped. `setFontName` returns
GTK's boolean result (false for an unanchored panel); the property setter raises
ValueError on false. A FontSelectionDialog already anchors its managed panel.
GTK2 may normalize/substitute descriptions and may report true even for an unknown
family, so true is not an installed-font guarantee: read `fontName` for the actual
selection. Native font changes may restore GTK's sample text when the preview is
empty; empty previews are not guaranteed to remain empty across changes.

### Nonblocking dialogs and safe observers

Both dialogs inherit the normal Window/Dialog title, modal/transient, `present`,
`onResponse`, `respond`, and response-sensitivity APIs. No blocking dialog run loop
is introduced. **Read the selected value in onResponse before destroying the
dialog.** Responding does not close automatically, and Cancel does not roll back
programmatic/live changes; the example copies changes to its embedded panels only
on OK/Apply. Private managed selectors/buttons are not exposed as reparentable SDK
handles. Use the standalone panels for embedding instead.

ColorSelectionDialog's `showHelp` and FontSelectionDialog's `showApply` default
false and remain hidden under `present()`/`showAll()`. Setting either true shows
that standard response button; setting false hides it again. These options do not
install Help behavior or an Apply handler.

**`onColorChanged(proc (value: Color) = ...)` and
`onFontChanged(proc (value: string) = ...)` are deferred/coalesced at UI idle** on
both panels and dialogs. They report changed copied final values, not every
intermediate native event, and do not emit an initial value. Font observers watch
private selection/preview signals as well as font-name notification because GTK2
omits the latter on some user-list changes. Color observers also follow effective
alpha changes caused by `useAlpha`. These are live-selection notifications, not
user acceptance signals; programmatic changes can notify too.

Observers support self-disconnection, exception containment, reentrant changes,
and owner destruction. Disconnection/destruction cancels pending idle delivery,
releases captures, and disconnects private watched emitters. Cleanup remains valid
if temporary Nim wrapper states have already gone away. Observer delivery is
deferred out of GTK's native change handlers so those handlers can finish safely;
explicit `destroy()` remains immediate. All GTK
operations and final releases remain on the UI thread.

## Assistant wizard workflows

[`examples/assistant.nim`](../examples/assistant.nim) demonstrates a nonblocking
Assistant with validation, an optional settings page, confirmation, application,
and a final summary. Assistant derives from Window, not Dialog; it reuses Window
`modal`, checked transient ownership, `destroyWithParent`, `present`, and `run`.
It does not introduce a nested dialog loop.

```nim
let wizard = newAssistant("Setup")
let intro = newLabel("Welcome")
let settings = newVBox()
let final = newLabel("Finished")
wizard.appendPage(intro, "Welcome", assistantIntro, complete = true)
wizard.appendPage(settings, "Settings", assistantContent)
wizard.appendPage(final, "Finished", assistantSummary, complete = true)
wizard.setPageComplete(settings) # Typically driven by input validation.
wizard.onCancel(proc () = wizard.destroy())
wizard.onClose(proc () = wizard.destroy())
```

### Pages and navigation

`newAssistant(title="Assistant", width=640, height=480, modal=false)` creates a
hidden window. The parent overload adds checked transient ownership and defaults
`destroyWithParent=true`. Sizes must fit nonnegative gint; titles are checked
UTF-8. Assistant manages its own content: Bin.add, even via an upcast, rejects
replacement; use page methods instead.

`appendPage`, `prependPage`, and `insertPage(index, child, title="",
kind=assistantContent, complete=false)` require unparented non-window pages.
Insertion indices are 0..pageCount. Page kinds are `assistantContent`,
`assistantIntro`, `assistantConfirm`, `assistantSummary`, and `assistantProgress`.
Completion defaults false for every kind in this API, including summaries; set
it true explicitly when the page is ready. Insertions show only the page root,
not its descendants or the assistant/toplevel.

`pageCount`, `pageAt(index)`, and `pageIndex(child)` inspect pages. pageAt accepts
0..<pageCount and returns an owning cached **generic Widget** alias; retain the
specialized constructor handle for editing. pageIndex returns -1 for a live
non-page. `pageType`/`setPageType`, `pageTitle`/`setPageTitle`, and
`pageComplete`/`setPageComplete` require page membership and copy native values.
`pageHeaderImage`/`pageSideImage` return owning nullable Pixbuf handles; matching
setters retain native references, and an empty Pixbuf clears the image.

`currentPage` is -1 before GTK selects a page or when none is selected. Assigning
an existing visible index selects it; negative native sentinel indices and hidden
pages are rejected. This programmatic operation bypasses completion gating; it is
not a simulated Next/Back click. GTK's buttons maintain native visited-page history
and use the default flow to advance to the next visible page. End a visible flow
with a Confirm or Summary page, not an ordinary Content page with nowhere to go.

`pageVisible`/`setPageVisible` configure optional pages, preserving hidden state
under showAll. Hiding the current page is rejected: navigate away first. Original
indices remain positional across hidden pages. `removePage(index)` (or inherited
remove on a page handle) unparents the retained content and shifts later indices;
GTK chooses another current page if necessary. Custom forward-function routing,
synchronous prepare hooks, and direct access to private navigation buttons remain
raw APIs.

### Actions, lifecycle, and safe notifications

`addActionWidget(button)` adds an unparented Button to the private action area;
`removeActionWidget(button)` verifies SDK-recorded assistant ownership before
removal. Removed retained buttons remain live; private action controls are not
exposed. `updateButtons()` recomputes native state. `commit()` clears Back history
and removes cancellation after a point of no return; it does not apply application
settings or close the assistant itself.

**onPrepare, onApply, onCancel, and onClose deliver at UI idle.** GTK2 continues
accessing pages/private data after prepare/apply signals, so invoking destructive
user closures synchronously there would be unsafe. onPrepare receives an owning
Widget snapshot, coalesces to the latest page per idle, and skips destroyed pages.
It is an observation after native preparation, **not a pre-display hook**. Initialize
content or update validation before navigation; a retained snapshot may no longer
be the current page.

Apply/Cancel/Close observers take no arguments and queue each native event per
connection. Native Apply may already have advanced to a subsequent page when the
observer runs; it cannot veto that transition. Use completion state to gate actions
and a Progress page for asynchronous application work. Signal delivery does not
close the window automatically: install Cancel/Close handlers explicitly. GTK
normally disallows cancellation during an incomplete Progress page.

Observers contain exceptions, support self-disconnection, and may remove pages or
destroy the assistant safely. Disconnection or destruction cancels pending work.
All operations and final releases remain on the UI thread.

**GTK2 unparents retained page roots when an Assistant is destroyed instead of
destroying those roots.** Retained pages and their children remain live, as do
removed pages; destroy them explicitly when finished to release their callback
captures. The example defers destruction of every page in addition to the wizard.
Action-area buttons, by contrast, are destroyed with the assistant's private action
area. Page image references held by GTK are released on removal/destruction.
Hidden tests exercise native page transitions and signal delivery without mapping
a window or clicking private native navigation controls; the example is compiled
but not launched by tests.

## File choosers and filters

[`examples/filechoosers.nim`](../examples/filechoosers.nim) demonstrates an
embedded panel, file/folder chooser buttons, multiple selection, shared filters,
and nonblocking Open/Save dialogs. No example operation writes a selected file.

- `newFileChooserButton(title="Choose a File", action=fileOpen)` derives from
  HBox and supports only `fileOpen` and `fileSelectFolder`, single selection.
  `title`, nonnegative `widthChars`, and `focusOnClick` configure its native UI.
  Its popup stays GTK-owned and is not exposed as a reparentable dialog.
- `newFileChooserWidget(action=fileOpen)` derives from VBox for embedding.
- `newFileChooserDialog(title="Choose a File", action=fileOpen, modal=false)`
  derives from Dialog; the parent overload defaults `destroyWithParent=true`.
  Constructors install Cancel and action-appropriate Accept buttons, with signed
  `responseCancel`/`responseAccept` IDs. Window transient/modal/lifetime methods
  and Dialog button/response methods remain available. Changing action updates
  the constructor's Accept stock label. Titles are checked UTF-8.

The button/panel manage private content; Box packing into them is rejected even
through HBox/VBox upcasts. Pack them into an ordinary application container.
Shared interface methods are available on all three specialized handles; keep
those handles rather than generic Widget aliases for chooser operations.

### Configuration and copied selections

`action` accepts `fileOpen`, `fileSave`, `fileSelectFolder`, or `fileCreateFolder`.
`selectMultiple` is restricted to Open/SelectFolder panels/dialogs, and switching
a multiple-selection chooser to Save/CreateFolder is rejected before mutation.
The button rejects multiple selection; assigning false is a safe no-op (GTK2's
native button setter warns even for false). `localOnly`, `showHidden`,
`createFolders`, and `overwriteConfirmation` forward native boolean properties.

`filename`, `uri`, `filenames`, `uris`, `currentFolder`, and `currentFolderUri`
copy GTK-owned results and free all transfer-full strings/list nodes. An empty
string/list means unavailable/no selection. `selection` copies a FileSelection
with `filenames`, `uris`, `currentFolder`, and `currentFolderUri` fields.
These are snapshots, not live views or filesystem-access permissions.

**Unix filenames are native filesystem bytes, not necessarily UTF-8.** Windows
filenames use GTK's UTF-8 ABI exports (including 64-bit Windows). URI strings
provide portable, escaped names suitable for display. Nonlocal selections may
have URIs without local filenames; do not zip the two lists by index. Set
localOnly=false only when the application can handle nonlocal URIs.

`setFilename`, `setUri`, `setCurrentFolder`, and `setCurrentFolderUri` return
native booleans. Paths must be absolute/nonempty/NUL-free; Windows paths must
also be valid UTF-8. URIs need a valid absolute scheme, UTF-8 and escaped
whitespace/control bytes. No implicit relative-path resolution is performed. `filenameToUri(absolutePath)`
converts native filename bytes to an escaped local file URI without filesystem
I/O, checks the same path rules, copies/frees GLib's result and raises ValueError
on conversion failure.
**GTK loads directories asynchronously:** true is not proof that the target
exists, loading finished, or the eventual selection matches the request. A
current-folder update can arrive before its file model/selection is ready.
Observe subsequent state rather than spinning a nested main loop in applications.

For a new Save/CreateFolder target, request a current folder and call
`setCurrentName(utf8Basename)`; the name may be empty to clear it, but not a path,
`.` or `..`. Open/SelectFolder reject this operation. These methods never create
a directory or write a file. Actual writes, access checks, overwrite races, and
safe atomic/exclusive creation remain application responsibilities.

`selectAll` requires multiple selection. `unselectAll` also clears native pending
selection requests. `selectFilename`/`selectUri` require multiple mode and forward
native individual selection requests; **GTK2 may move its cursor and replace an
earlier selected row even in multiple mode**. They are not an atomic/additive
multi-selection builder. Native Ctrl/Shift interaction and selectAll support
multiple selections normally. `unselectFilename`/`unselectUri` unselect loaded
rows; an outstanding asynchronous request may still affect later selection.

### Filters and observers

`newFileFilter(name="", patterns=[])` creates a floating GtkObject that the SDK
sinks correctly; it is not a Widget. `name`, `addPattern`, `addMimeType`, and
`addPixbufFormats` support named shell-pattern, MIME and supported-image rules.
Rules are ORed, not ANDed; adding image formats allows images in addition to other
rules. Text/rules are checked UTF-8, rules must be nonempty. Custom C predicates
remain raw. Set the name before adding it: GTK2's filter-combo display does not
track subsequent name changes.

`addFilter`, `removeFilter`, `filters`, `filter`, and `filter=` check membership
and reject duplicates/foreign filters. filters returns owning cached handles;
filter returns an empty FileFilter when none exists. Add a filter before selecting
it; an empty FileFilter is not a filter-clearing sentinel. A filter can be shared
between choosers, survives removal if retained, and is normally released by
ordinary handle lifetime. Remove it from choosers before explicit filter.destroy;
destroy invalidates SDK aliases and prevents resurrection of disposed handles.

`onSelectionChanged(proc(value: FileSelection))` watches selection and current
folder changes. Delivery is deferred/coalesced to UI idle, with copied final
values, duplicate suppression, and no initial notification. It is **not an
acceptance signal**. `onFileSet` on the button reports native user acceptance;
programmatic requests do not synthesize it. `onFileActivated` observes native
activation. Both action observers copy a snapshot at signal time and queue each
event for safe idle delivery; neither automatically closes an owner.

`onResponse(proc(id: ResponseId, value: FileSelection))` on FileChooserDialog
copies the selection when GTK emits the validated response, before later edits.
An Accept response can be stopped by native validation or postponed during I/O.
The inherited single-argument onResponse is also deferred for file chooser
dialogs, **including through a Dialog upcast**. Native GTK continues using the
delegate after response emission, making synchronous destructive closures unsafe.
Prefer the two-argument form when accepting files. Call dialog.destroy explicitly
when finished; Cancel does not roll back application work or close automatically.

Observers contain exceptions, allow self-disconnection/reentrancy/destruction,
and cancel pending work on disconnect or owner destruction. Captures and native
references are released on the UI thread. Preview/extra-widget ownership, shortcut
folders, custom filter predicates, and confirm-overwrite return callbacks remain
raw APIs in this batch.

### Native GTK2/GIO completion compatibility

GTK2 2.24.33's filename-completion code requests only name/display-name/type
metadata, but its filesystem model reads is-hidden/is-backup too. Modern GIO
can emit `GFileInfo created without standard::is-hidden` or `...is-backup` in Save
mode or filename-entry completion, even in a plain C GTK application. This was
reproduced with the installed GTK2 2.24.33/GLib 2.82.5, independent of Nim.
With G_DEBUG=fatal-warnings it aborts. Some distributions may already patch this.

[`patches/gtk2-filechooser-completion-gio.patch`](../patches/gtk2-filechooser-completion-gio.patch)
adds the missing requested attributes to native GTK's gtkfilechooserentry.c.
It was dry-run checked against the upstream 2.24.33 source; it does **not** change
ABI, inspect private objects at runtime, suppress warnings, or modify the system
library automatically. Apply it to your GTK2 source/package and rebuild/reinstall
that library if affected. The SDK does not bundle or rebuild GTK itself.

The standalone diagnostic
[`tests/headers/filechooser_completion.c`](../tests/headers/filechooser_completion.c)
reproduces the issue without Nim or mapped windows:

```sh
cc -o /tmp/gtk2-completion tests/headers/filechooser_completion.c $(pkg-config --cflags --libs gtk+-2.0)
G_DEBUG=fatal-warnings /tmp/gtk2-completion /path/to/directory-containing-files
```

Use your C compiler (e.g. gcc) and matching architecture/pkg-config path; 64-bit
illumos uses `/usr/lib/64/pkgconfig`. The diagnostic intentionally fails on an
affected native runtime and is separate from testUi. SDK tests keep Save completion
in an empty temporary directory to avoid this known native defect; Open/multiple
selection tests use real files, including non-UTF-8 Unix names. No warnings are
suppressed and normal tests never map a chooser.

The SDK uses present/responses, never gtk_dialog_run. However **GTK2 itself may
enter nested loops for stock error dialogs and overwrite confirmation**. Enabling
overwriteConfirmation requests that native behavior; it defaults false. For
application-controlled asynchronous overwrite decisions, leave it false and
perform that decision outside the chooser using ordinary nonblocking dialogs.

## Recent-item choosers

[`examples/recents.nim`](../examples/recents.nim) demonstrates RecentChooserWidget,
RecentChooserMenu, and RecentChooserDialog with isolated demo history, copied
metadata, shared filters, and nonblocking activation/response handling. It neither
alters desktop history nor executes stored application commands.

### Manager and copied metadata

`newRecentManager(absoluteFilename)` creates a plain GObject backed by a specific
XBEL recent-items file. Empty/relative/NUL paths and existing directories are
rejected; Windows filenames must be UTF-8. Create the parent directory and keep
it available until all manager/chooser references have been released. GTK performs
native monitoring, delayed persistence and merging; malformed/unreadable storage,
monitoring or write failures can produce native GTK diagnostics. This is not a
transactional database or a filesystem-access grant.

`defaultRecentManager()` returns an owning view of GTK's borrowed singleton.
Mutating it intentionally changes shared desktop history. Chooser constructors
use that default when no manager is supplied. Prefer an explicit manager for
application-private history. `filename` copies its storage path. `addItem(uri,
mimeType, appName, appExec, displayName="", description="", groups=[],
isPrivate=false)` uses explicit validated metadata rather than asynchronous MIME
guessing. Required text fields and groups must be nonempty UTF-8; URIs use the
same checked absolute-scheme rules as file choosers. Use filenameToUri(path) to
register a native local filename without importing raw GLib. Native addItem's boolean
reports acceptance, not completion of the delayed XBEL write. Re-registering
merges groups/application history; empty optional displayName/description use
native defaults or preserve existing metadata rather than clearing it. isPrivate
is a chooser display hint, not encryption or filesystem access control.

`hasItem`, `lookupItem`, `items`, `removeItem`, `moveItem(oldUri, newUri)`, and
`purgeItems(): int` operate on the history. Removal/purge affect records, never the
underlying documents. lookup/remove/move/purge failures raise RecentError with
copied message, native `domain` and `code`, freeing GError correctly. No manager
limit wrapper is provided: GTK2's deprecated manager limit has no effect; configure
chooser limits instead.

`RecentItem` is **copied data**, not a RecentInfo pointer/GObject. It contains uri,
displayName, description, mimeType, shortName, uriDisplay, lastApplication,
applications/groups string sequences, age in days, isPrivate, and isLocal.
`isEmpty` means no URI/current item. Borrowed strings, transfer-full display
strings, string vectors, RecentInfo references and list nodes are handled with
their respective native ownership rules. Copies survive manager edits/removal
and widget destruction. They do not include guessed-width time_t timestamps,
live icon objects, or a cached proof that the resource exists. URI display text
can be unavailable when a native filename cannot be converted to UTF-8.

`onChanged(proc())` is deferred/coalesced until UI idle, after GTK's native change
handler. It has no initial notification and observes GTK's delayed persistence/
external updates rather than each addItem call. `disconnectSignals()` breaks
manager callback captures, including self-cycles. Final manager releases and all
operations/callbacks stay on the UI thread.

### Widget, menu and dialog

- `newRecentChooserWidget(manager=default)` derives from VBox for embedding.
- `newRecentChooserMenu(manager=default)` derives from Menu and can be attached
  using an ordinary MenuItem's submenu or MenuToolButton's menu. GTK owns its
  generated rows: insertion/packing and itemAt are rejected through upcasts too.
  Use `items`, not private menu widgets, to inspect history. Native MenuShell
  itemCount includes its private placeholder and is not an eligible-item count.
- `newRecentChooserDialog(title="Recent items", manager=default, modal=false)`
  derives from Dialog. The parent overload defaults destroyWithParent=true.
  Constructors add Cancel/Open buttons with responseCancel/responseAccept IDs;
  titles are checked UTF-8 and Window transient/modal/lifetime controls apply.

**GTK2 borrows recent managers.** SDK constructors retain a native manager
reference on the chooser until native finalization, after delegate disposal has
disconnected its manager signals. Temporary Nim manager handles are therefore
safe. `chooser.manager` returns an owning cached handle to that same manager.
An explicit manager's storage directory must outlive *all* chooser references,
not just its original Nim handle.

Shared properties include limit (-1=unlimited, otherwise nonnegative gint),
sortOrder (recentUnsorted/recentMostRecent/recentLeastRecent), showPrivate,
showNotFound, localOnly, showTips, and showIcons. Menus additionally have
showNumbers. Menu property setters request native repopulation via the public
filter property; `menu.refresh()` is also available. Native models load/reload at
idle, typically on mapping or configuration/manager changes. An item can appear
in the eligible metadata before its selectable native row has loaded.

**This ergonomic API is single-selection only.** Assigning selectMultiple=true
is rejected; false keeps/restores single mode and is a safe no-op on menus,
whose native setter warns for either value. Critically, GTK2 recent chooser get_items/get_uris return **all
eligible items**, not selected rows. `chooser.items` reflects filtering, sorting
and limit; it never claims to return a selected set.

`currentUri` copies the native current URI and `currentItem` copies its metadata;
a menu may report an active/default row before any acceptance. On panels/dialogs,
`selectUri(uri)` selects without activation, while `activateUri(uri)` explicitly
selects first and then uses native activation. This order avoids GTK2's
set_current_uri emitting activation before selecting its target. Selection and
activation can raise RecentError while an item is absent, filtered out or not yet
loaded. `unselectUri`/`unselectAll` apply to panels/dialogs. Programmatic menu
selection/activation remains raw: its native select_uri implementation can select
the wrong row. Use ordinary user menu activation and onItemActivated instead.

### Filters and safe observers

`newRecentFilter(name="", patterns=[])` owns a sunk floating GtkObject, not a
widget. name, addPattern, addMimeType, addPixbufFormats, addApplication, addGroup,
and addAge(nonnegativeDays) add native **OR** rules. Patterns match the supplied
**display name**, not necessarily the URI basename: a friendly title without an
extension won't match *.txt. Prefer MIME rules for that case. Custom predicates
remain raw.
Text is validated UTF-8 and rules must be nonempty. Name filters before adding
them; native combo labels don't follow later renames.

`addFilter`, `removeFilter`, `filters`, `filter`, and `filter=` use checked
membership and owning cached handles. Widget/dialog support a filter list; add a
filter before selecting it. Menus have **one** filter slot: addFilter rejects an
occupied slot; assigning filter replaces it, with same-value assignment a no-op.
Menu removal uses its nullable public filter property so visible rows refresh
correctly. Empty RecentFilter means no current filter, not a valid assignment.
Shared/removed retained filters survive. Normally release handles; remove filters
from choosers before explicitly destroying them to invalidate SDK aliases.

`onSelectionChanged(proc(item: RecentItem))` on panels/dialogs copies native
selection snapshots, defers/coalesces delivery at idle, suppresses duplicates and
has no initial notification. `onItemActivated(proc(item: RecentItem))` on all
three choosers copies each activation snapshot and queues it for safe delivery;
it is not inferred from browsing or registration.

Dialog `onResponse(proc(id: ResponseId, item: RecentItem))` copies metadata at
signal time before later selection changes. The inherited single-argument
onResponse is also deferred, **even through a Dialog upcast**. Native item
activation can activate the dialog's default/Accept button. Plain Accept responses
can still have an empty item; check id and item.isEmpty before opening anything.
Responses do not automatically close the dialog. All observers contain exceptions,
support reentrancy/self-disconnection/destruction, and cancel pending delivery
when disconnected or their owner is destroyed. They do not launch stored commands
or grant permission to trust a resource or its metadata.

### Native recent-chooser source cleanup

Unpatched GTK2 2.24.33 recent panels/dialogs call g_source_remove from their idle
source's own destroy notifier, including after an empty eligible list. Modern
GLib diagnoses `Source ID ... was not found when attempting to remove it`, which
aborts under G_DEBUG=fatal-warnings. Cancellation while loading can hit the same
path. This is reproducible in standalone C, independent of the SDK.

[`patches/gtk2-recentchooser-source-cleanup.patch`](../patches/gtk2-recentchooser-source-cleanup.patch)
removes that redundant removal. It was dry-run checked against upstream 2.24.33;
it is a native GTK package/source fix, not a warning suppression, SDK workaround,
ABI change or automatic modification of the installed library. Apply/rebuild the
GTK2 dependency if affected; distributions may already carry fixes.

[`tests/headers/recentchooser_cleanup.c`](../tests/headers/recentchooser_cleanup.c)
reproduces it without mapping windows:

```sh
cc -o /tmp/gtk2-recent-cleanup tests/headers/recentchooser_cleanup.c $(pkg-config --cflags --libs gtk+-2.0)
G_DEBUG=fatal-warnings /tmp/gtk2-recent-cleanup /existing/temporary/directory/empty.xbel
```

Use a fresh empty history filename, your C compiler and matching pkg-config
architecture (64-bit illumos uses `/usr/lib/64/pkgconfig`). The diagnostic is
separate from testUi and intentionally fails on an affected native library.
SDK tests use populated eligible panel/dialog fixtures and finish native loads
before destruction, with no warning suppression. Empty-menu behavior is tested
separately; its empty-list path does not have this panel cleanup defect.

## CellView, HSV and offscreen rendering

[`examples/displays.nim`](../examples/displays.nim) combines a normalized HSV
selector, a fixed-layout CellView, and an OffscreenWindow whose copied images
update a normal onscreen Image. All require GTK initialization and a display;
OffscreenWindow is not a display-independent/headless renderer.

### CellView

CellView derives directly from Widget. `newCellView(text="")` displays checked
UTF-8 **plain text**, never markup. `newCellView(image: Pixbuf)` displays an owning
pixbuf reference; an empty Pixbuf is valid. Assigning text or pixbuf replaces the
previous content/layout/model. The corresponding getter returns copied text or
an owning cached image handle; querying the wrong kind raises ValueError.
Static renderers are retained in SDK-owned native data rather than exposed as
widgets. GTK2's cell_layout_get_cells unconditionally calls set_cell_data and
warns on model-less views, so static SDK getters do not use that native path.
This neither inspects GTK private structures nor suppresses native diagnostics.

`newCellView(model, textColumn, pixbufColumn=-1)` binds one string renderer and an
optional pixbuf renderer. `setModel` replaces that fixed layout after validating
the complete schema, even for the same model. GTK and the SDK's private observer
retain the model; `model` returns an owning cached alias. Text is not interpreted
as markup. CellView-specific cell-data functions and arbitrary renderers remain raw;
TreeView text-column presentation functions are covered below.

`displayedPath` selects a checked TreePath in a list, tree or proxy model; an empty
path unsets the native row. `displayedRow` is the flat-model convenience with -1
for no row. Constructors and setModel start without a displayed row. GTK uses a
TreeRowReference internally, so insertion/reorder tracks the same row and deletion
invalidates the reference. Getters copy/free GTK's transfer-full path. A copied
TreePath remains a position, not a persistent identity. Native clearing/deletion
does not clear cached renderer values; don't treat it as resetting content.
Use text/pixbuf/setModel to replace content explicitly.

`rowSize(path)` returns a copied width/height requisition for a checked existing
row, restoring the native displayed-row reference afterwards. GTK's measurement
can update renderer caches; it is not a pure model-only calculation. Model
changes/insertion/deletion/reorder request coalesced native resize/redraw at UI
idle, after row-reference updates. `refresh()` explicitly requests both as well.
Replacement/destruction disconnects these private watches, releases retained
models and cancels pending work, including when the original Nim state is gone.
`backgroundColor=` sets native RGB (alpha is ignored); `clearBackground()` restores
the theme's default background behavior.

### HSV

HSV derives directly from Widget and is separate from ColorSelection/ColorButton.
`newHSV(color=hsvColor(0,0,0), diameter=174, ringWidth=15)` creates its hue ring and
saturation/value triangle. HSVColor contains normalized hue/saturation/value
float64 fields; hsvColor and every setter reject NaN, infinity and values outside
0..1. Hue includes both endpoints: 0 and 1 represent red. HSV has no alpha.
`toHSV(Color)` ignores alpha; `HSVColor.toColor(alpha=65535)` uses GTK's native
RGB conversion and rounds to the existing RGBA16 Color representation.

`color` copies the three doubles. `metrics` copies an HSVMetrics object with
diameter/ringWidth; assignment checks gint bounds and ringWidth > 0,
2*ringWidth+1 <= diameter using wide arithmetic before changing GTK.
`isAdjusting` queries native drag state. `onChanged(proc(value: HSVState))` observes
copied color **and** adjusting fields at UI idle, coalescing changes, suppressing
duplicates and emitting no initial value. This is final-state observation, not a
synchronous drag event stream. A final adjusting=false transition can notify even
when color is unchanged. Callbacks may reenter, disconnect or destroy their owner;
exceptions are contained and pending work is canceled on destruction/disconnection.

### OffscreenWindow

OffscreenWindow derives from Window/Bin, accepts one checked child, and owns a GDK
offscreen drawable rather than an onscreen toplevel. `newOffscreenWindow(width=320,
height=200)` requires positive gint dimensions and configures GTK's default size.
`showAll()` on the offscreen tree performs normal GTK layout/mapping/rendering
**offscreen**, while a normal application window runs the event loop. present/run,
modal input grabs and transient relationships are rejected, including through
Window upcasts. Native titles/window-manager behavior are not an onscreen UI.

`pixbuf` returns an empty Pixbuf before realization or when no image is available;
it neither realizes, shows, maps, drains events nor forces a synchronous repaint.
After rendering it adopts GTK's **transfer-full, non-floating** image without an
extra ref/sink. Each successful call produces an independent pixel copy that
survives future paints, resizes, unrealization and destruction. The borrowed,
resize-sensitive native pixmap remains raw.

`onSnapshot(proc(image: Pixbuf))` observes damage without consuming native events.
It coalesces damage and copies the latest pixels at UI idle, after native painting,
with no initial callback or pixel-equality suppression. The image may be empty if
the drawable was unrealized before delivery. Retain the handle to keep a frame.
Callbacks contain exceptions, support owner destruction/self-disconnection and
cancel pending delivery; the observer does not retain old images itself. Snapshot
images are not interactive widgets or a forwarding mechanism for input events.
Native GTK menus/popups/toplevel children are not necessarily part of the drawable.

The hidden tests realize an offscreen drawable without mapping it, exercise
transfer-full copies and C-allocated synthetic damage events, and assert that no
window is mapped. They do not claim to test an actual onscreen rendering session.

## Print and page-setup dialogs

[`examples/printing.nim`](../examples/printing.nim) demonstrates nonblocking
PrintUnixDialog and PageSetupUnixDialog with retained configuration. **This is
configuration, not job submission.** Accepting a dialog or creating/changing/saving
settings does not render a document, generate PDF/PS, write a print output file or
submit a printer job. PrintOperation/PrintJob/rendering remain outside this wrapper
batch; use an actual printing pipeline to implement accepted choices.

### Cross-platform configuration

PrintSettings and PageSetup are non-floating GObjects with owning typed raw
handles, independent copy(), and no widget destroy signal. PaperSize is instead
a boxed GTK value: its private ARC/ORC state frees it with paper_size_free, not
GObject unref. Ordinary PaperSize assignment shares its immutable SDK value;
copy() creates an independent native box. All final releases remain on the UI
thread under the SDK's normal ownership contract.

- `newPrintSettings()` creates settings. copies (positive gint), scale (positive
  finite percent), numberUp (1/2/4/6/9/16), resolution/setResolution(x,y), useColor,
  collate, reverse, duplex, quality, printPages, pageSet, printerName, orientation
  and paperSize cover common native configuration. Setting paperSize copies it.
- `pageRanges` is a copied sequence of PageRange(first,last), **zero-based and
  inclusive**. Complete input is validated before mutation; negative/reversed/
  overflowing ranges are rejected. An empty sequence clears ranges. The range list
  does not select printPages=printPageRanges for you. Native dialog text presents
  page numbers in its usual one-based form.
- `hasKey/get/set/unset` expose checked UTF-8/NUL-free backend keys and values.
  Keys must be nonempty key-file names without control characters, brackets,
  equals signs or surrounding ASCII whitespace. get returns empty for either absent or empty values;
  use hasKey to distinguish them. pairs() copies key/value strings during native
  foreach without invoking user code or allowing mutation inside hash iteration.
  Generic keys are an expert escape hatch: strings are checked, but backend
  semantics and malformed persisted/native values are not fully schema-validated.
- `newPaperSize()` uses GTK's locale default. `newPaperSize("iso_a4")` accepts
  canonical names from standardPaperSizes(); unknown names raise ValueError
  instead of GTK's warning-and-A4 substitution. Use newCustomPaperSize(name,
  displayName,width,height,unit=unitMillimeters) for other dimensions. Names are
  nonempty checked UTF-8 and dimensions positive/finite. name/displayName,
  isCustom, width(unit)/height(unit), and a typed borrowed raw pointer are available.
  Standard sizes exclude desktop custom-paper files. Boxed paper getters are
  owned copies, never pointers into a PageSetup.
- `newPageSetup()` provides orientation, paperSize, setPaperWithDefaultMargins,
  margins(unit)/setMargins(PageMargins(...),unit), paperWidth/Height and pageWidth/
  Height. PrintUnit is unitPoints, unitInches or unitMillimeters, never GTK's
  unsupported pixel unit. PageOrientation is pagePortrait/pageLandscape/
  pageReversePortrait/pageReverseLandscape. Paper dimensions account for native
  orientation; printable page dimensions also subtract margins. Margins are
  validated atomically as nonnegative finite lengths, but not clamped to the paper:
  excessively large margins can produce a nonpositive printable area. Changing
  paperSize preserves existing margins unless setPaperWithDefaultMargins is used.

`loadPrintSettings/loadPageSetup(absoluteFilename)` and save(filename) explicitly
read/write **configuration files**, using native Unix filename bytes / Windows
UTF-8 and the shared absolute/NUL path checks. They copy and free GError and raise
PrintError with native domain/code/message. Saving is a real file write, not a
print job. Loaded files use GTK's native parser; use trusted configuration, and
validate application/backend-specific values before printing. No user or desktop
configuration files are loaded/saved automatically by these helpers.

### Unix-only widgets and printer information

The dialog/Printer API exists only under `defined(posix) and not defined(macosx)`;
Windows/Quartz have no fake substitute. The common configuration types above
remain available on all supported targets.

`newPrintUnixDialog(title="Print",modal=false)` and
`newPageSetupUnixDialog(title="Page setup",modal=false)` derive from Dialog. Parent
overloads use destroyWithParent=true by default. Titles are checked UTF-8;
Window lifetime/transient/modal controls and nonblocking present/responses apply.
For both native print dialogs, SDK showAll/present show the toplevel **without
recursively showing private children**, including through Widget/Window upcasts.
GTK owns conditional visibility of the conflict banner, Preview button and
backend-specific pages. A recursive raw gtk_widget_show_all would reveal them
regardless of actual conflicts/capabilities. SDK addCustomTab shows the
application-owned content subtree separately. Genuine backend-reported conflicts
still display normally; this does not suppress diagnostics or force-hide warnings.
GTK supplies its native buttons; acceptance is **responseOk**, not responseAccept.
Responses do not automatically close dialogs, undo changes or persist settings.

Both expose settings and pageSetup. **Assignments detach inputs; getters detach
outputs.** Mutating the original or a returned object doesn't silently modify the
dialog. PrintUnixDialog's native settings getter already returns a fresh full
reference, adopted without an extra sink/ref. Its page setup is borrowed and
copied. PageSetupUnixDialog's settings are borrowed/nullable and copied; its page
setup getter actually returns a full reference in GTK2.24 despite an erroneous
transfer-none annotation. The SDK copies that setup and releases the original.

PrintUnixDialog additionally exposes currentPage (-1=unknown, otherwise zero-based
gint), manualCapabilities (a set of PrintCapability flags), supportSelection,
hasSelection, embedPageSetup, and pageSetupSet. Manual flags declare work the
**application** implements: setting capGeneratePdf doesn't create a PDF renderer,
nor does capCopies implement copying. Native printer capabilities and sensitivity
control which settings the getter reports; unsupported/disabled options can
normalize to defaults rather than round-trip their supplied values. These are not
permission checks or a promise that a print job will succeed.

`addCustomTab(child,label)` checks distinct, unparented, non-toplevel widgets and
native ancestry before inserting/showing them in the private notebook. GTK owns
their parenting and destroys them with the dialog. Ordinary Dialog packStart/
packEnd are rejected through upcasts on both print dialog types; private controls
remain unexposed. There is no SDK custom-tab removal API.

`selectedPrinter` on PrintUnixDialog returns an empty handle if none is selected,
or an owning cached alias of GTK's borrowed Printer GObject. name/info copy native
metadata; PrinterInfo contains name/description/location/stateMessage/iconName,
jobCount and active/paused/acceptingJobs/isVirtual/isDefault/acceptsPdf/acceptsPs
flags. These are observations, not printer availability guarantees. The handle
retains its native backend reference; live enumeration, backend operations,
asynchronous detail requests and job submission remain raw. PageSetupUnixDialog
has no public native selected-printer getter, so its snapshots have empty printer
information rather than inspecting private controls.

### Responses, native behavior and testing

`selection()` copies current PrintSelection(settings,pageSetup,printer).
`onResponse(proc(id: ResponseId,value: PrintSelection))` queues each signal-time
snapshot for UI-idle delivery. Accepted values survive later edits/destruction;
Cancel/Close also carry snapshots and must not be mistaken for acceptance.
Inherited single-argument onResponse uses the same deferred route, **including a
Dialog upcast**. Observers contain exceptions, support self-disconnection/owner
destruction and cancel pending values on destruction/disconnection. They retain no
previous snapshot after delivery unless the application keeps it.

GTK may discover printers/load backends as part of native dialog construction;
this is not printer enumeration implemented by the SDK. Native print-to-file
acceptance may show GTK's overwrite confirmation/nested prompt, and page setup
can open GTK's custom-paper editor. Such native UI behavior is not suppressed or
made nonblocking internally by this wrapper. A normal application should not
manually emit responseOk to bypass GTK's UI validation or capability handling.

`tests/tgtk2printing.nim` uses hidden dialogs, disables backend discovery for its
process, restores that setting, and sandboxes configuration-file I/O. It never
maps windows, submits jobs or touches printer output. The separate, explicitly
opted-in `nimble testMappedPrinting` checks actual presentation, hidden conflict/
Preview controls, application tab descendants and base-class upcasts on an
isolated virtual display with GTK2_TEST_VIRTUAL_DISPLAY=1. It is not part of
testUi and never submits jobs. Native ABI tests cover print
enum widths/values, PageRange layout and foreach's cdecl string/data callback.

**Native NULL-printer warning with real backends:** changing manualCapabilities
refilters GTK's printer list. With an initially selected printer (reproduced with
the lpr backend), GTK2.24.33 can temporarily have no selection and unconditionally
call gtk_printer_is_accepting_jobs(NULL) in selected_printer_changed. This emits
`GTK_IS_PRINTER (printer)` and aborts under G_DEBUG=fatal-warnings. It occurs in
standalone C before showing the dialog: it is not a Nim Printer lifetime failure.
The no-backend hidden fixtures above don't exercise that transition.

[`tests/headers/printdialog_null_printer.c`](../tests/headers/printdialog_null_printer.c)
is a separate no-window/no-job diagnostic requiring an installed lpr backend
(or another explicitly supplied backend with an initial selection). It exits 2
if that prerequisite is absent, rather than treating an unexercised path as a pass.
Build using pkg-config --cflags --libs gtk+-unix-print-2.0 and run with
G_DEBUG=fatal-warnings. The optional
[`patches/gtk2-print-dialog-null-printer.patch`](../patches/gtk2-print-dialog-null-printer.patch)
checks for NULL and disables the Print response while no printer is selected.
It was dry-run checked against upstream GTK2.24.33, not runtime-tested against a
rebuilt library. This is independent of the resource-leak patch below. The SDK
neither suppresses the warning, manipulates private GTK state, nor silently
disables printer backends to hide it.

Stock GTK2.24.33 leaks its final private PageSetupUnixDialog last_setup reference,
and repeated PrintUnixDialog set_settings can overwrite a format_for_printer
string without freeing it. Neither is an SDK reference-counting fix or a reason
to inspect GTK's private memory. The standalone no-window/no-backend diagnostic
[`tests/headers/printdialog_resources.c`](../tests/headers/printdialog_resources.c)
reproduces the retained setup independently of Nim (exit 1 on affected GTK).
The optional [`patches/gtk2-print-dialog-resources.patch`](../patches/gtk2-print-dialog-resources.patch)
frees those native resources; it was dry-run checked against upstream 2.24.33,
not rebuilt/installed or runtime-tested as a patched library. Apply/rebuild your
GTK dependency if needed; no warning suppression or installed-library change is
performed by the SDK. The diagnostic builds with your compiler and
pkg-config --cflags --libs gtk+-unix-print-2.0 (use matching architecture; 64-bit
illumos uses /usr/lib/64/pkgconfig). Regular SDK tests separately verify that
repeated getters add no references and replacement/cancellation release SDK-owned
configuration correctly.

## Desktop infrastructure: Invisible, Plug/Socket and StatusIcon

[`examples/desktop.nim`](../examples/desktop.nim) demonstrates local X11 embedding,
shared Misc layout and an Invisible resource. Pass --tray to explicitly enable a
real desktop StatusIcon. Tray availability is not guaranteed, and the normal
example does not create a tray icon unless requested.

### Screen, Invisible and Misc

`defaultScreen()` returns an owning cached view of GTK's borrowed GdkScreen;
Screen.raw is a typed borrowed PScreen. Initialize GTK first. Screen references
and all final releases follow the UI-thread-only contract.

`newInvisible()` / `newInvisible(screen)` create an Invisible directly deriving
from Widget, **not Window or Container**. GTK realizes its input-only native
window during construction, but does not map it. screen gets an owning handle;
screen= validates a nonempty handle and uses GTK's public screen-change API.
Invisible is intended for native selection/drag/event infrastructure, not visible
content. Those protocols remain raw. Explicit destroy() releases GTK's own user
reference as well as breaking SDK captures; final Nim release then unrefs the
wrapper's reference. Invisible cannot be packed as a child, including through a
Widget upcast: it is a native toplevel even though it is not a GtkWindow.

The abstract Misc API is shared by Label, Image and Arrow, which now derive from
Misc. alignment returns copied x/y fractions; setAlignment(x,y) validates finite
0..1 coordinates before mutation. padding returns copied x/y integers;
setPadding(x,y) checks 0..65535, matching GTK2's **16-bit internal storage** rather
than merely accepting all gint values. Generic Widget size/sensitivity/lifetime
APIs still apply. No abstract Misc constructor or fabricated Misc widget exists.

### X11 Plug and Socket

This SDK API exists on Unix X11 targets (`defined(posix) and not defined(macosx)`),
not Windows/Quartz. It uses GTK2's public XEmbed API and does not simulate embedding
with ordinary parenting. Native Win32 variants, custom displays and low-level
protocol operations remain raw.

EmbedId is a distinct **uint32 GdkNativeWindow**, not Xlib's unsigned-long Window.
embedId(integer) validates unsigned 32-bit bounds; zero is the empty/unattached
sentinel. $ formats a decimal ID for IPC. IDs identify native windows on a display,
not durable identities or owned resources; do not unref/destroy an ID. Foreign
IDs must come from a trusted peer on the same display. Invalid, stale, reused or
non-Plug foreign windows can produce native GTK/X errors; existence checks would
race peer teardown and the SDK cannot guarantee IPC success.

`newSocket()` derives from Container, and must be added to a normal Window tree
before requesting id or calling addId. An unparented socket or one inside
OffscreenWindow is rejected before GTK. id realizes the anchored socket if needed
but does not show/map it. addId(id) rejects empty/self IDs and occupied sockets;
hasPlug checks public native plug-window/child APIs, including local plugs not yet
realized. Normal Container.remove is rejected for a socket's embedded child: its
parenting is protocol-managed, not generic SDK packing.

`newPlug()` creates an unattached Plug deriving from Window. newPlug(socketId)
connects to an existing socket; newPlug(socket) is the checked local convenience,
rejecting an occupied socket. Plug.id realizes it without showing it. isEmbedded
queries native state. Add its ordinary content with Bin.add and showAll when
ready. For local embedding, run the host Window's event loop, not a nested Plug
run; a separate peer process can run its own Plug. Native same-process embedding
can change a Plug's toplevel status while its GtkWindow runtime type remains.
Do not try to manually pack a Plug into another container.

**SDK sockets remain reusable after plug removal.** GTK's default would destroy
its Socket. The constructor installs an internal plug-removed handler returning
TRUE; it runs after SDK observation handlers, which return FALSE without invoking
user code synchronously. This is an explicit lifetime policy, not a hover/input
workaround. Destroy the socket explicitly when no longer needed.

onPlugAdded(proc()), onPlugRemoved(proc()) and Plug.onEmbedded(proc()) queue each
native notification at UI idle. They are observations, not pre-attachment/veto
callbacks or current-state guarantees. Plug construction may already have emitted
embedded before a listener is registered; query isEmbedded for initial state.
Callbacks may disconnect/destroy their owner, and exceptions are contained.
Destroying a local Plug detaches it; foreign peer exit is handled through native
XEmbed. Do not rely on a remote process honoring shutdown requests or treating
an embedding ID as a security boundary. Disconnection/destruction cancels pending
observer delivery, rather than delivering events to a destroyed owner.

### StatusIcon (a GObject, not a widget)

newStatusIcon(visible=false), newStatusIcon(image: Pixbuf,visible=false),
newStatusIconFromIcon(name,visible=false) and newStatusIconFromStock(id,visible=false)
create owned **non-floating** GtkStatusIcon objects without an extra ref/sink.
The native constructor can briefly map its private tray widget **before** GTK's
non-construct visible property can be changed. Therefore even a hidden StatusIcon
is not safe to construct in no-mapping tests, and no no-map factory is promised.
Windows/Quartz/X11 behavior and tray availability depend on native GTK/the desktop.

visible controls native visibility; isEmbedded is an observation, not proof a
user can see the icon. title, setName and tooltipText use checked UTF-8/NUL-free
text (icon/stock/name identifiers must be nonempty). Tooltip text is plain text,
not markup, and the getter copies/frees GTK's transfer-full string. hasTooltip,
screen and size expose corresponding native controls/observations. size may be
zero before tray allocation; no scaling size is invented.

pixbuf= accepts an empty value to clear; pixbuf returns an owning cached alias
or raises for another storage kind. setFromIcon/setFromStock, iconName/stockId and
storageKind use native storage, with checked kind-specific getters. setFromFile
uses loadPixbuf and raises PixbufError for unreadable/invalid images rather than
silently claiming successful loading. geometry copies native screen/rectangle/
orientation outputs into StatusGeometry; check available first, and don't cache
coordinates as a guarantee against later tray movement/reparenting.

onActivate(proc()), onPopupMenu(proc(StatusPopup)) and onSizeChanged(proc(int))
copy/queue each event at idle. StatusPopup preserves unsigned 32-bit button/time
values, including timestamp wraparound; a keyboard request can have button=0.
Size observation returns FALSE synchronously to GTK so native scaling remains
active: it is not a rendering/veto hook. onEmbeddedChanged(proc(bool)) observes
coalesced final state with duplicate suppression and no initial notification.
All contain exceptions and allow self-disconnection/reentrancy/close. Advanced
button/scroll/query-tooltip return callbacks and menu positioning remain raw.
A raw status_icon_position_menu callback needs the native icon kept alive for the
menu's positioning lifetime; merely scheduling a popup is not an ownership grant.

A plain StatusIcon has no widget destroy signal. disconnectSignals() releases
callback captures/cancels pending delivery. close() hides it, disconnects its
signals and invalidates **all SDK aliases**, idempotently; final native unref
occurs when the last shared handle/Connection state leaves scope. It does not
call gtk_widget_destroy on a GObject. Use defer icon.close() to break self-capture
cycles deterministically. Drop closed handles normally; further raw/property
access raises ValueError. Retained pixbufs remain valid independently.

### Desktop ABI and tests

The raw audit corrected StatusIcon string constructors (cstring, not char**),
storage-type return (C enum, not enum pointer), screen geometry output (GdkScreen**)
and scroll-event callback type, and made platform-dependent private storage
opaque. Missing public Plug/Socket queries were added without using GTK private
embedding helpers. GdkNativeWindow is guint32 on X11 and pointer-sized on
Win32/Quartz; GdkAtom uses pointer-sized storage, including Win64 LLP64. Misc's
output parameters are single pointers, not pointer-to-pointer var parameters.
Native probes check instance/class layouts, IDs/selection-event offsets, Misc
padding and unsigned popup callback payloads against C headers.

testUi includes tests/tgtk2desktop.nim: only unmapped Invisible/local Plug/Socket
resources and Misc layout. It **never constructs a StatusIcon**. The separate
nimble testMappedDesktop requires an isolated virtual DISPLAY and explicit
GTK2_TEST_VIRTUAL_DISPLAY=1. It tests real foreign-process XEmbed exit/reuse and
tray object ownership, geometry and synthetic signal delivery. No tray manager
is required for those object tests, so they do not claim to verify actual tray
hosting or user input on every desktop. Never run mapped tests on a user's
ordinary desktop. No native library is modified and no compatibility warnings are
suppressed.

## Drawing/input, rich text and editable views

These extensions build on the existing DrawingArea, Widget, TextBuffer/TextView
and TreeView/TextColumn APIs. The expanded [controls](../examples/controls.nim),
[text editor](../examples/text.nim) and [models](../examples/models.nim) examples
show the features together rather than introducing another widget layer.

### Scoped Cairo rendering

DrawingArea.onDraw(proc(context: DrawContext, info: DrawInfo)) returns a Connection.
It runs **synchronously**, after the native expose handler, on the UI thread. A
new Cairo context is created for each callback and clipped to the expose region
**and** GTK's native drawable visibility clip. DrawInfo copies the allocated
width/height and damaged rectangle (x,y,width,height); coordinates are local to
the DrawingArea's own GdkWindow. It is not a general Widget expose wrapper, whose
coordinates/child-window semantics differ. GTK may combine damage notifications.

DrawContext provides setSource(Color), setLineWidth, moveTo/lineTo, rectangle,
circle, paint, fill, stroke and save/restore. Colors use rgba16; floating geometry
must be finite, dimensions/radii nonnegative and line widths positive. Cairo
errors and user exceptions are contained at the C boundary and reported.

DrawContext.raw is a **borrowed ptr Cairo.Context valid only during that callback**,
for advanced paths/patterns/Pango integration via the raw libraries. Never destroy
or retain it, or expand the expose clip with raw reset_clip. The SDK invalidates
all copied DrawContexts on callback exit, even after errors. Methods also reject
use after the DrawingArea is destroyed inside its callback. A saved DrawContext
cannot be used for later drawing, and does not keep a native context/widget alive
once the callback ends. Store application drawing data and call queueDraw instead.

Widget.allocation returns copied x/y/width/height. queueDrawArea(x,y,width,height)
checks signed coordinates, nonnegative sizes and endpoint overflow before native
invalidation; zero-sized areas are no-ops. GTK redraws later, not synchronously.
Normal queueDraw redraws the whole widget. Draw handlers return FALSE to GTK unless
the callback destroyed its owner, in which case propagation is stopped. Multiple
handlers can draw in native signal order, with independent contexts.

### Copied input events and propagation

All widgets support these synchronous, before-default-handler connections:

- onButtonPress/onButtonRelease: proc(ButtonEvent): bool, including native
  double/triple presses in ButtonEvent.kind.
- onMotion: proc(MotionEvent): bool, with copied coordinates and hint status.
- onScroll: proc(ScrollEvent): bool, using GTK2's four discrete directions.
- onKeyPress/onKeyRelease: proc(KeyEvent): bool.

Return true to consume the event/stop later handlers, false to let GTK handle it.
Exceptions are contained and normally propagate the event; destroying the widget
inside a callback forces true so GTK's default handler cannot use a destroyed
owner. Self-disconnection is supported. Each registration adds its native event
mask; disconnecting does not remove shared mask bits. Regular motion, not motion
hint subscription, is requested. Raw hint subscriptions require raw motion
requests. Native device/axes/window pointers are deliberately not exposed.

Button/motion/scroll copy local and root coordinates, unsigned 32-bit timestamps
and ModifierMask (all native bits, including unknown ones). has(mask,flags) tests
all requested bits; modifierShift/Control/Alt/Super and button masks are available.
Keyboard payloads copy keyval, modifiers, time, hardware keycode and group.
KeyEvent.unicode returns a Unicode code point or zero for a non-character key;
keyLeft/Up/Right/Down/Escape/Return/Space provide common keyvals. Native locale
key strings are not mislabeled as UTF-8. These are **not** text-input/IME APIs:
keep native Entry/TextView editing for composition, dead keys and input methods.
Widget.canFocus enables keyboard focus; pointer callbacks can call focus().

Input/render bindings do not implicitly pin a shared SDK owner state in their
native callback data. The current widget is retained for dispatch, and closure
captures are released on disconnect/native destruction. Capturing a widget in
its own closure still needs explicit destroy/disconnect as with other widgets.

### Text tags, marks, search and images

TextBuffer.createTag(name="") creates an owning **non-floating GObject** TextTag,
adds it to the buffer's tag table, and rejects duplicate nonempty names. An empty
name creates an anonymous tag. tag(name) gets an owning alias or raises if absent.
A tag retains its table, not its originating buffer. applyTag/removeTag(tag,first,last),
removeAllTags(first,last) and hasTag(tag,offset) validate ranges and table membership
before GTK; ranges are half-open Unicode code-point offsets. deleteTag removes
its definition and all native applications, but retained tag handles remain live.
They cannot be applied again through that buffer unless registered externally.
Raw removals are detected via the public table-foreach API, not private structs.

TextTag supports bold, italic, underline, editable and invisible properties,
setForeground/setBackground(Color), and clearForeground/clearBackground. Color
alpha must be 65535: GTK2 text colors are RGB, not RGBA. Explicit false style
values override lower-priority native tags; clearing a color unsets its override.
Native tag priorities/overlap policy still apply; arbitrary properties, font
layouts and tag event callbacks remain raw. Formatting/user actions do not add
an undo stack, and follow GTK's native modified-flag behavior.

findText(needle,first=0,last=-1,backwards=false,visibleOnly=false,textOnly=true)
returns TextMatch(found,first,last). -1 means the buffer end for last only. It
validates the complete range and nonempty UTF-8/NUL-free needle before searching.
Results are copied half-open offsets; a miss has found=false and endpoints -1.
It does not move selection, wrap, mutate or retain iterators. The text example
explicitly wraps its next-match search and selects the result. Search is GTK2's
case-sensitive native search, not regex/case-folding. visibleOnly skips invisible
tagged text; textOnly skips embedded objects when matching. Match spans may
therefore include skipped characters/objects. Raw TEXT_SEARCH_VISIBLE_ONLY and
TEXT_SEARCH_TEXT_ONLY were corrected to native bit values 1 and 2.

createMark(offset,name="",leftGravity=true) and mark(name) return owning TextMark
handles. Duplicate named marks are rejected; empty names are anonymous. Marks
track insertion/deletion, unlike integer offsets. Left gravity keeps a mark before
text inserted exactly at it; right gravity moves it after. name, visible,
leftGravity, deleted and offset expose native state. moveMark/deleteMark on a
buffer check ownership before GTK; GTK's built-in insert/selection_bound marks
cannot be deleted. Deleted marks remain valid objects, but offset/move/delete
raise. Mark handles do not retain the buffer: they become deleted on its final
release. TextView.scrollToMark validates the mark against its current buffer.

insertImage(offset,Pixbuf) inserts an owning native pixbuf segment occupying one
character. Ordinary text/textRange omit objects; slice(first,last,includeHidden)
returns U+FFFC object replacement characters, preserving offset correspondence.
All operations still resolve fresh native iterators and copy/free returned strings.
Embedded child widgets/anchors, rich clipboard protocols, serialization and undo
remain outside this batch. Plain-text clipboard integration is covered below.

### Editable columns and multiple selection

TextColumn.editable enables GTK's native entry editor. Register onEdited only
**after attaching the column**. Its proc(TextEdit) is an idle observation, never
an immediate model mutation. startEditing(view,column,path) validates attachment,
row, editable state and mapped view, expands ancestors, and asks GTK to start the
editor; it is not valid on a hidden/unmapped view. User-driven clicks work normally.

TextEdit copies text, bound column index and path at emission, and owns a stable
TreeRowReference named row. Insertion/reordering before delivery updates row.path;
deletion makes row.valid false. **path is only the old positional snapshot**.
Check row.valid and row.model before writing through your own ListStore/TreeStore.
Proxy edits reference the displayed proxy model; explicitly convert to its child
coordinates before mutation. The SDK never writes through a read-only proxy,
parses a user's edit into a guessed type, or chooses an application's validation
policy. Returning from the callback does not imply that an edit was committed.

TreeView.appendToggleColumn(title,index) / newToggleColumn plus appendColumn
provide the corresponding fixed boolean layout, checking the model column kind.
ToggleColumn has title, resizable, visible and activatable properties;
onToggled(proc(ToggleEdit)) uses the same copied/stable-row scheme. active is the
model value **at emission**, not an automatic new value. To honor every toggle
intent, the example inverts the current model value when processing each event.
Text/toggle callbacks queue every event, contain exceptions and support self-
disconnection/destruction. Disconnecting, destroying the column or destroying its
original view cancels pending events/captures. Retained columns survive view
closure but those connections do not; reconnect after raw column moves. Column
.disconnectSignals also clears its renderer callbacks. Renderers remain managed
implementation details, accessible only through the raw API if required.

TreeView.selectionMode supports selectionNone/Single/Browse/Multiple. **Changing
mode clears selection** (assigning the current mode is a no-op). A public native
NONE transition discards GTK2's stale multiple-selection anchor, which can otherwise
prevent later single selection. No private tree structures are inspected or altered.
selectedPaths copies all selected paths in native order; selectedIndices is the
flat-model convenience. In multiple mode, assigning selectedPaths validates all
rows before clearing/mutating selection, retains stable references through the
operation, and skips rows invalidated by native reentrant changes. selectAll
requires multiple mode; unselectAll clears native selection. Native browse policy
still applies. Existing selectedIndex/selectedPath remain strictly single-mode
helpers to avoid ambiguous behavior; model replacement remains raw.

TreeView.onSelectionChanged is now **coalesced at UI idle**, for all modes, with
no initial event. Read final selection/model state there. It does not synchronously
run inside set_mode/select_all/model-driven selection changes, where GTK continues
using internal state after emission. Disconnect/view destruction cancels pending
delivery; callbacks can disconnect/destroy their view safely. Row activation and
model row notifications retain their separately documented timing.

### Extension tests

Hidden tests/tgtk2extensions.nim is part of testUi and never maps widgets: it uses
explicitly realized, **unmapped** offscreen resources for context lifetime and
synthetic event dispatch. An unmapped drawable can have an empty visibility clip;
those tests do not claim to validate rendered pixels. Native probes check copied
event layouts, C-width scroll enums and search flag bits against C headers.

The separate nimble testMappedExtensions requires an isolated virtual DISPLAY and
GTK2_TEST_VIRTUAL_DISPLAY=1, rejecting runs without that opt-in. It checks actual
Cairo pixels, nonempty partial redraw clipping/snapshot independence, and a real
GtkEntry cell-editing lifecycle that emits a deferred edit and explicitly commits
Unicode text. Never run mapped tests on an ordinary desktop. No installed native
library is changed and no GTK warnings are suppressed.

## Clipboard and copy-only text drag/drop

The [text editor](../examples/text.nim) now has Copy/Cut/Paste buttons, and the
[controls example](../examples/controls.nim) has native drag/drop text pads.
Clipboard contents are shared desktop state; obtaining a handle is not permission
to overwrite a user's clipboard during tests or startup.

### Nonblocking clipboard requests

getClipboard(kind=clipboardStandard) returns an owning cached view of GTK's
borrowed **non-floating GObject** clipboard. clipboardPrimary selects PRIMARY;
its availability/behavior depends on the native backend. Clipboard.raw is a typed
borrowed PClipboard, not an untyped pointer. There is no widget destroy API for
Clipboard. All operations, callbacks, cancellation and final releases stay on the
UI thread and require GTK initialization/a display.

setText(text) copies validated UTF-8/NUL-free text into native GTK ownership.
clear() releases this application's ownership; it is not a guaranteed eraser for
another process's clipboard. Clipboard-manager persistence, images, arbitrary
formats, custom lazy owners, custom displays/selections and blocking wait_for_*
operations remain raw. No persistence guarantee is made when the application exits.

requestText(proc(ClipboardText)) returns a TextRequest; requestText(owner:Widget,fn)
also binds cancellation to owner destruction. **User callbacks always run at UI
idle**, even if the native clipboard owner replies synchronously. ClipboardText
copies available/text: available=false means no supported/valid text, while
available=true,text="" represents an actual empty text payload. No selection data
or callback C strings escape. Contents can change while a request is pending;
this is a received snapshot, not an ownership lock. Callback exceptions are contained; reentrant new
requests and cancellation are supported. No nested main loop is introduced.

The SDK uses public selection length/type/format/data getters and requests
UTF8_STRING, then COMPOUND_TEXT, then STRING as needed. GTK2's text getter can
return nil for an empty UTF8_STRING; explicit length/type preserve that distinction.
Nonempty recognized text uses GTK's native conversion, with UTF-8/NUL checks.
UTF-8 packets are validated **before** calling the native conversion, avoiding
malformed external text reaching a warning-producing UTF-8 conversion path.
Legacy encodings retain GTK's native conversion behavior; this is not a binary
transfer API. Unsupported/invalid results become unavailable rather than guessed
text. These checks do not sandbox native clipboard owners or impose a maximum
incoming selection size; GTK may already have allocated the transfer buffer.

TextRequest.pending is true until delivery or cancel(). cancel is idempotent,
releases application callback captures immediately, cancels queued idle delivery,
and disconnects its owner hook. Dropping a request handle **does not cancel** it.
GTK has no public cancellation mechanism for the outstanding selection request:
a small opaque bridge and clipboard reference remain until the real native reply
or timeout arrives, so callback data is never freed early. Canceling prevents
further fallback requests and application delivery, not the original wire request.
Owner-bound completion removes its destroy hook, rather than accumulating captures
for the lifetime of a long-lived window. Do not keep uncanceled ownerless requests
whose callbacks capture windows you have otherwise abandoned.

### Entry and TextView clipboard editing

Entry and TextView provide copySelection(clipboard), cutSelection(clipboard) and
pasteClipboard(clipboard), defaulting to the standard clipboard. The first two
return bool; paste returns the cancellable TextRequest and automatically binds
it to widget destruction. Plain-text transfer does not serialize tags or images.
TextView copy skips invisible tagged text and embedded objects. No selection
returns false without changing the clipboard; a selected empty/plain-text-free
range may copy an empty string.

Entry adds editable and textVisible properties. Copy/cut are refused for hidden
password entries, matching native protection; cut also requires editable=true.
Readonly entries can still copy visible selections, but paste does not write them.
Paste replaces the current selection/inserts at the current cursor **when the
reply is delivered**, not at a stale byte offset captured at request time.

TextView cut/paste honors native editable-tag policy and the view's default
editable setting. Cut copies visible text before interactive deletion; its bool
reports whether deletion happened, so protected text can have been copied even
when no text was removed. Partial editable selections can be partially deleted.
Paste checks native insertion policy, groups editing as a user action and rechecks
widget/buffer lifetime between edits. It is not transactional rollback or undo.
An outstanding paste is ignored if the view has switched to a different buffer;
it never silently writes a newly opened document. Copy/cut/paste can trigger the
usual native buffer/entry change observers. Rich-text paste, PRIMARY middle-click
behavior and IME/default keyboard shortcuts remain native GTK behavior, not
reimplemented by these button helpers.

### Ordinary text transfer pads

Widget.enableTextDrag(text) returns a TextDragSource; Widget.onTextDrop(proc(TextDrop))
returns a TextDropSite. Both persist when their handle is dropped and disconnect
idempotently via disconnect(); connected queries their state. Widget destruction
cleans them up and releases captures/pending deliveries. Re-register after
disconnection to configure a fresh site.

These methods **runtime-check exact ordinary DrawingArea/EventBox types**, including
Widget upcasts. They deliberately reject Entry/TextView, TreeView/IconView,
ToolPalette and other widgets with native/private drag/drop behavior, rather than
override internal editing, model reordering or source handlers. A duplicate SDK
site or an existing advertised native target list is rejected. Arbitrary raw
handlers/empty raw sites cannot all be detected; do not mix raw and SDK configuration
for the same source/destination role. One pad may independently be both source
and destination. GTK's public text-target helpers negotiate standard text formats.

Sources use button 1 and **COPY only**. Source.text gets/sets validated UTF-8;
changing it updates the next drag, while each active drag retains its drag-begin
snapshot through native data requests/end. No user data-provider closure executes
inside native selection-get. Source disconnection stops serving future requests
and releases snapshots; an active native drag may consequently fail. It does not
promise to cancel a platform drag/grab immediately. Source state has no permanent
owning widget back-reference; live context references are released at end/disconnect.

Destinations use native motion/highlight defaults, but **not DEFAULT_DROP**.
The SDK tracks each requested context, validates COPY and decoded text, and calls
gtk_drag_finish exactly once for each tracked result, always delete=false. Invalid
text/unsupported targets/actions fail without application delivery. Disconnection
fails tracked pending drops and releases their context references. Incoming text
uses the same format/UTF-8 checks as clipboard requests, including valid empty text.

TextDrop copies text, local destination x/y and unsigned 32-bit time. It queues
**each successful transfer** at UI idle, after native protocol completion; it is an
observation, **not an acceptance/veto/commit callback**. User exceptions do not turn
an already completed copy into a protocol failure. Observers may disconnect their
site or destroy widgets safely. MOVE/deletion, URI lists, arbitrary binary targets,
custom drag icons, model DnD and asynchronous application acceptance remain raw.
No raw context/selection pointers escape this API.

### Transfer validation

Hidden tests/tgtk2transfers.nim is included in testUi: it configures/destroys
unmapped pads, verifies captures/finalization and password/readonly properties,
but never claims/clears clipboard ownership or requests user clipboard data.
Native ABI probes check target/selection layouts, C-width flags and clipboard/drop
callback parameters. PClipboard now names an opaque native handle; public selection
accessors/text-target/context-action helpers were added with exact C signatures.

nimble testMappedTransfers requires an isolated virtual DISPLAY and explicit
GTK2_TEST_VIRTUAL_DISPLAY=1. It claims that display's CLIPBOARD/PRIMARY, tests local
and foreign-process replies, cancellation, empty/unavailable distinction, STRING
fallback, malformed/NUL UTF-8 and protected editing. On Unix X11 it additionally
requires libXtst and the XTEST server extension, using real pointer/button events
to verify native text drag/drop, drag-begin snapshots, completion and safe observer
disconnection/destruction. **Never run this suite on an ordinary desktop.** The
SDK does not suppress warnings, inspect GTK private structures or alter native
libraries to implement these transfers.

## Shared actions and window-local accelerators

[examples/menus.nim](../examples/menus.nim) now registers New/Quit commands and
Ctrl+N/Ctrl+Q. [examples/toolbars.nim](../examples/toolbars.nim) shares Open and Pin
commands between toolbar/menu proxies and Ctrl+O/Ctrl+P; a single group sensitivity
control updates every proxy. Existing tearoffs and native toolbar behavior remain.
GTK2 actions are within the GTK2.24 scope; their deprecation in GTK3 is not a reason
to omit them here. GtkBuilder, RadioAction and UIManager are covered below.

### Commands and native proxies

newAction(name,label,tooltip="") and newToggleAction(name,label,tooltip="",active=false)
create owning **non-floating GObjects**, not Widgets. Their raw pointers name opaque
PAction/PToggleAction records; do not sink/unref borrowed raw pointers or cast them
to widgets. Names must be nonempty; names/labels/tooltips/icon names are UTF-8 and
NUL-free. Text getters copy borrowed C strings.

Action exposes immutable name; mutable label, shortLabel, tooltip, iconName,
important, sensitive and visible; and effectiveSensitive/effectiveVisible including
its ActionGroup's state. Labels use GTK's native underscore mnemonics. ToggleAction
adds active. asToggleAction() checks native type when recovering a toggle through
a group's generic action lookup; it rejects ordinary actions without an unsafe cast.

createMenuItem() and createToolItem() create fresh native GtkActivatable proxies:
MenuItem/ToolButton for Action, CheckMenuItem/ToggleToolButton for ToggleAction.
Parent them normally. GTK synchronizes appearance, sensitivity and toggle state
across every proxy. These are native bindings, not independent closure handlers
that manually copy state. Prefer changing the action rather than independently
overriding its proxies. No public API for rebinding arbitrary existing widgets is
provided yet, so private/native editor content is not commandeered.

Action-managed proxies set public no-show-all=true: their visibility belongs to
the action. A parent's showAll() must not expose a command the action/group hid.
Normal action-visible proxies already have their native visible state; their parent
still controls actual mapping. Explicitly show()/hide() on a proxy can override
native state; use action.visible for the supported synchronized policy.

activate() invokes native action activation; insensitive commands do not activate.
Visibility is **not authorization**: GTK allows an invisible but sensitive action's
accelerator/programmatic activation. Disable sensitive to prevent activation.
Native toggle state/proxy updates happen synchronously. GTK's active setter can
emit both toggled and activate; assigning the existing active state is a no-op.

onActivate(proc()) and onToggled(proc(active:bool)) return ordinary Connections.
User callbacks are **deferred until UI idle**, after GTK's action/group/proxy emitter
has finished using its native data. Each activation/toggle is queued, not coalesced;
toggled carries the emission-time state and has no initial event. Commands queued
before a later sensitivity change remain queued. These are post-activation handlers,
not synchronous veto or pre-activation hooks. Callback exceptions are contained;
callbacks may disconnect themselves, reenter commands, or destroy windows safely.
Disconnecting cancels pending delivery. Dropping a Connection does not disconnect it.

### Group ownership and explicit callback cleanup

newActionGroup(name), add(action), action(name), remove(action), sensitive and visible
provide checked command collections. Names are unique within each group; an action
can belong to only one native group at a time. Duplicate membership/names, missing
lookups and removing a foreign action fail before native warnings. Group aliases
share the SDK member collection, which retains action handles and their callbacks.
Removing a command releases that membership but does not automatically disconnect
an action still retained elsewhere or unbind its shortcut.

Retain an Action or its ActionGroup while its command callbacks are needed. Native
proxy references alone are not SDK callback ownership: as with other plain GObjects,
the final shared SDK state disconnects its signals and cancels deferred work even
if raw/native clients still retain the object. Do not mutate group membership or
accelerator configuration through raw GTK while using the SDK collection.

Actions have no destroy signal and no widget destroy API. disconnectSignals(action)
breaks its callback captures; disconnectSignals(group) does this for its current
members without removing them or changing native toggle/shortcut behavior. A closure
capturing its own action/group/window can create a reference cycle. Explicitly
clean up on window destruction, as both examples do:

```nim
let commands = newActionGroup("editor")
let shortcuts = newAccelGroup()
shortcuts.attach(window)
window.onDestroy(proc () =
  commands.disconnectSignals()
  shortcuts.clearShortcuts())
let save = newAction("save", "_Save", "Save the document")
commands.add(save)
shortcuts.bindShortcut(save, "<Control>s")
save.onActivate(proc () = echo "Save requested")
menu.append(save.createMenuItem())
toolbar.append(save.createToolItem())
```

This cancellation matters even when callbacks do not form a cycle: an already queued
command must not attempt to update destroyed widgets. Explicitly destroy windows
and standalone menu roots as usual. All API calls, callbacks, cleanup and final
native unrefs stay on the UI thread under ARC/ORC.

### Checked shortcut values and registration

parseShortcut("<Control><Shift>s") produces an immutable Shortcut; newShortcut(keyval,
ModifierMask) accepts numeric GDK keyvals. keyval/modifiers read its components and
shortcutName returns a copied canonical GTK name. Invalid/default values, malformed
strings and button/lock/reserved masks are rejected. Portable Shift/Control/Alt and
virtual Super/Hyper/Meta bits are accepted; physical Mod2..Mod5 bindings remain raw.
Keys normalize through native keyval_to_lower, not byte/ASCII conversion. Parsing
uses GTK spelling, including native backend conventions; it is not a hotkey service.

newAccelGroup() owns a non-floating native accelerator group. attach(window),
detach(window) and attached(window) operate idempotently on live onscreen windows;
OffscreenWindow is rejected. One group can be attached to multiple windows. Window
destruction automatically detaches native groups. Keep the SDK AccelGroup alive
while its registrations are needed, even though GTK also references attached groups.

bindShortcut(action,Shortcut|string), shortcutFor(action), unbindShortcut(action)
and clearShortcuts() manage its registrations. The group retains SDK Action handles.
A shortcut already advertised in that group, an action already bound in any group,
or an existing native action accel path is rejected before GTK is modified. One
shortcut per action is supported; unbind before rebinding. Other groups can still
advertise the same key, and normal GTK dispatch order/enablement resolves those;
the SDK does not claim global conflict detection.

Bindings use the action's native borrowed accel closure and public accelerator
APIs. They do not install global accel-map paths, private trampolines, process-wide
mod masks or fake key handlers. Action menu labels monitor this closure through
public AccelLabel APIs, including proxies created before/after binding. Unbinding
clears the displayed shortcut. Label width is computed by GTK's size request/layout,
not immediately by merely reading accelWidth on an unlaid-out menu.

Releasing the final SDK AccelGroup handle unregisters its shortcuts before releasing
its retained actions; a private cleanup owner holds an extra native group reference
so this is independent of Nim field destruction order. GTK windows may still own
an empty native group until detachment/destruction. unbindShortcut is idempotent;
shortcutFor raises when no SDK binding exists.

Window.activateShortcut(Shortcut) explicitly dispatches through native window
accelerator groups and returns whether GTK handled the key. It does not synthesize
an input event or bypass sensitivity. Real key input/focus still follows GTK; Entry
bindings, IME, mnemonics and toolbar keyboard navigation are not reimplemented.
Global desktop hotkeys, arbitrary accelerator closures, editable/persistent accel
maps and synchronous action hooks remain
outside this batch.

### Action validation

The hidden tests/tgtk2actions.nim is part of testUi: it never maps a window. It tests
proxy synchronization, checked membership, group retention/finalization, C-width
native dispatch, duplicate/rebinding guards, disabled commands, deferred payloads,
exception containment and cancellation. Native C ABI probes pass action constructor
and gboolean getter/setter function pointers through real GTK prototypes without
requiring a display.

nimble testMappedActions requires an isolated virtual DISPLAY and explicit
GTK2_TEST_VIRTUAL_DISPLAY=1. It checks native menu shortcut display, hidden proxy
visibility across parent showAll, native toggle propagation and queued-work teardown.
On Unix X11 it requires libXtst/XTEST and sends real Ctrl+O with an Entry focused;
the command safely destroys its window from deferred delivery. Never run this input
suite on an ordinary desktop. No warnings are suppressed and no GTK private
structures or installed native libraries are modified.

## Owned GtkBuilder documents

The expanded [examples/ergonomic.nim](../examples/ergonomic.nim) embeds
[examples/ergonomic.ui](../examples/ergonomic.ui) at compile time. Its XML supplies
the window/layout/controls and signal handler names; Nim supplies checked handles
and closure implementations. No exported Nim symbol names, native autoconnection,
manual C casts or additional import paths are needed.

### Load and lifetime

newBuilder(xml,translationDomain="") creates a fresh Builder from UTF-8/NUL-free
XML. loadBuilder(filename,translationDomain="") loads a native path, relative or
absolute. Unix filenames retain native bytes; Windows filenames must be UTF-8.
Native file loading preserves GTK's relative resource-path semantics. Domain text
is checked before loading; XML domain declarations follow native GTK behavior.
translationDomain reads a copied current value. These are one-shot document
factories, not mutable append/reload operations; do not append XML through raw GTK
behind the wrapper's ownership/connection bookkeeping.

Builder.raw is a typed borrowed PBuilder. The native builder is a non-floating
GObject, but the public Builder is an **owned UI document**, not a Widget or a generic
ObjectHandle. Its aliases share closed state. close() is idempotent, and the last
Builder handle also closes the document if no reference cycle retains it.

Closing first cancels the document's declared-signal connections, then destroys
**every XML-created widget in the native builder table**, including standalone
windows/menus never looked up through the SDK. Ordinary widget destroy observers
still run. Retained widget handles share destruction state/tombstones and cannot
resurrect the UI. Reparenting an XML widget into another application container does
not transfer it out of document ownership: it is still destroyed at close. Children
subsequently added to document-owned containers follow normal GTK recursive teardown.
There is no detach/take-ownership API in this batch.

The SDK retains looked-up shared states so temporary get(...).onClicked(...) calls
do not immediately lose their callback owner. For non-widget objects, close
disconnects SDK callbacks tracked by those states and releases the builder's table;
independently retained plain objects (for example TextBuffer or Action) remain
valid data objects. Closing does not forcibly destroy every non-widget GObject.
The builder table is released on close, not merely when the final closed alias
is dropped. Lookup/metadata/wiring operations reject closed/uninitialized builders.

Always use explicit cleanup for UI documents:

```nim
let ui = newBuilder(xml)
defer: ui.close()
let window = ui.get("window", Window)
let name = ui.get("name", Entry)
let greeting = ui.get("greeting", Label)
ui.get("greet", Button).onClicked(proc () =
  greeting.text = "Hello, " & name.text)
window.run()
```

This also breaks native-widget → closure → Builder reference cycles when callbacks
capture their own document, as the example's Close UI handler does. Merely dropping
an external Builder variable cannot break such a cycle. Do not close a builder
prematurely expecting returned widgets to keep its UI alive independently. All
loading, lookup, callback delivery, close and final native releases stay on the UI
thread under ARC/ORC and require GTK initialization/a display.

### Checked lookups and copied metadata

get(id,Type) requires an existing, nonempty UTF-8/NUL-free ID and checks its native
GType before retaining the borrowed object. Missing/mismatched/destroyed objects
raise ValueError rather than becoming unsafe casts. Aliases use the existing weak
state cache and share signal/destruction tracking.

Audited widget lookup types currently are Widget, Window, Button, Label, Entry,
Box/VBox/HBox, ToggleButton/CheckButton/RadioButton, DrawingArea, ScrolledWindow,
Viewport, Notebook, HPaned/VPaned, SpinButton, ProgressBar, TextView, Image, Frame,
Alignment, Table, Fixed, EventBox, MenuBar/Menu/MenuItem/CheckMenuItem,
Toolbar/ToolButton/ToggleToolButton and Dialog. Base lookups accept compatible native
subtypes and retain the existing runtime guards on their operations. The non-widget
lookup types are Adjustment, TextBuffer, Action, ToggleAction and RadioAction.

Other SDK wrappers do **not** automatically become valid builder lookup types.
ActionGroup requires an SDK member collection; fixed model/cell/chooser wrappers
can require additional schema, renderer or lifetime metadata. Unsupported typed
lookups fail at compile time. Use a supported Widget view where appropriate or raw
GTK with its native ownership contract; do not fabricate specialized handles by
casting a named object. Native builder support is not a claim that every raw GTK
configuration has an ergonomic wrapper.

The loader explicitly registers core widget types and Action/ActionGroup,
Adjustment, TextBuffer, ListStore/TreeStore and TextTag/TextTagTable GTypes. Nim
loads GTK dynamically; GTK2's default lazy GModule search of executable-global
_get_type symbols is not a reliable way to discover every locally loaded type.
For other native classes, register their raw *_get_type() before loading the XML.
This registers types only; it does not construct widgets or map windows.

hasObject(id) reports table membership, not guaranteed widget liveness after an
independent destroy. objects() copies BuilderObjectInfo(id,typeName) entries in
unspecified native table order. IDs are obtained through public GtkBuildable;
a non-Buildable object can have an empty copied id rather than accessing GTK's
private name data. declarations() copies BuilderSignal metadata: objectId,
signalName, handlerName, connectObjectId, after and swapped. Copied metadata survives
close. No native list node, selection data or borrowed C string escapes.

### XML signal names mapped to closures

The loader collects XML signal declarations with gtk_builder_connect_signals_full;
it never calls the symbol-name autoconnection API. The public callback is scope-call:
its temporary collector stays alive for the complete synchronous native visit, and
all borrowed names are copied. GTK consumes its declaration list; the SDK keeps
its own immutable copy for validation and reconnecting.

connectSignals([BuilderHandler(name:"greet",fn:proc()=...), ...]) supplies named Nim
closures. A handler name may be reused by multiple XML objects/declarations, as
Entry.activate and Button.clicked share Greet in the example. Duplicate supplied
handler names, nil callbacks, unused names or missing mappings are rejected.
Every declaration is validated **before any handler is connected**, and a failed
connection phase rolls back its newly created connections. Repeated connectSignals
without disconnectSignals is rejected rather than duplicating handlers.

This initial named mapping supports **void, zero-argument, non-destroy signals**
only, validated through public GSignal metadata. Native after ordering is preserved.
Return-valued/event signals, parameterized signals such as Dialog.response,
notify::property, swapped closures and object-connected declarations require manual
existing typed SDK observers or raw GTK; their ABI is never guessed. Wire lifecycle
signals manually (for example window.onDestroy) rather than through deferred XML
Destroy handlers. There is no automatic string-to-code execution or arbitrary
method dispatch.

Mapped closures run **at UI idle after native emission**, queueing each occurrence
without coalescing. They receive no sender/extra arguments and are not synchronous
veto hooks or emission-time state snapshots. Use the existing typed observers when
copied payloads or synchronous input propagation are needed. Exceptions are
contained. Handlers may disconnect/reconnect or close their document safely;
closing/unwiring cancels pending delivery. disconnectSignals(builder) removes only
its mapped XML connections; direct typed connections remain until their normal
owner cleanup/document close. The builder retains mapped connections even when
no Connection token is returned to application code.

### Trust boundary and tests

**Load trusted application UI definitions, not untrusted XML.** GtkBuilder can create
native objects, invoke native constructors/property setters, load resources and map
windows if XML requests visibility. It is not a sandbox, schema validator or a
transactional parser for an existing live UI. Unknown properties, invalid child
relationships and invalid object-connected declarations can still cause GTK-native
warnings instead of GErrors; the SDK does not suppress them. Type registration does
not allow-list all classes that GTK might resolve. Custom native type-function
resolution remains GTK behavior; avoiding signal symbol autoconnection is not a
security boundary against malicious UI definitions.

On native parse/file GError failures the factory copies message/domain/code into
BuilderError, frees the GError and closes/destroys the partially constructed UI.
Invalid SDK strings/IDs/types/mappings raise ValueError. A failed fresh load never
modifies another live document. Native constructors can already have side effects
before failure, so this cleanup is not rollback of arbitrary native state.

Hidden tests/tgtk2builder.nim is included in testUi. Its XML leaves all windows
unmapped; it covers typed lookup, shared state, copied metadata/errors, mapping
validation, per-handler closure identity, cancellation/reentrancy, independent plain
data lifetime, last-document finalization and partial-load window cleanup. Native
ABI probes exercise the opaque constructor, pointer-sized gsize loader and the full
GtkBuilderConnectFunc calling convention without needing a display.

nimble testMappedBuilder requires an isolated DISPLAY and explicit
GTK2_TEST_VIRTUAL_DISPLAY=1. It maps the expanded example, verifies native Entry and
animated Button activation against repeated XML handler names, closes the document
from a deferred handler and checks queued callback cancellation. No installed GTK
libraries, private structures or native warning settings are modified.

## Radio commands and UIManager merges

The [menu example](../examples/menus.nim) now has a UIManager-generated menu bar
and toolbar with shared radio commands, native tearoffs, Ctrl+1/Ctrl+2 and a button
that adds/removes Refresh through a UI merge. Its original File menu/tearoff still
works independently. The [toolbar example](../examples/toolbars.nim) shares its
Select/Draw RadioActions with its dropdown menu instead of maintaining unrelated
radio widgets.

### RadioAction

RadioAction derives from ToggleAction and is an opaque non-floating GObject.
newRadioAction(name,label,value:int32,tooltip="") creates a selected singleton;
newRadioAction(peer,name,label,value,tooltip="") joins an existing group while
preserving that group's selection. value is an immutable SDK view of the native
signed gint property, not a row index. Duplicate values in a group and assigning
an unknown currentValue are rejected before native warnings.

joinGroup(peer) is idempotent for the same group, preserves the destination's
selection and selects a remaining old-group member when moving its active member.
The SDK normalizes GTK2's setter, which otherwise can leave two active members,
using public active setters even if the joining action is insensitive. No private
radio list fields are read. Group membership uses GTK's borrowed public GSList.

currentValue reads/selects the group value. active, activate, onActivate and onToggled
retain native ToggleAction behavior; native radio actions resist clearing the only
selected member. onChanged(proc(value:int32)) queues each emission-time selected
value at UI idle, with no initial event. It is not a synchronous selection veto.
Exceptions are contained and disconnection cancels pending delivery. asRadioAction
checks native type for generic Action lookups. createMenuItem/createToolItem inherit
the native CheckMenuItem/ToggleToolButton radio appearance, not fabricated
RadioMenuItem/RadioToolButton instance types.

Native radio membership is weak: keep members alive using ActionGroup or independent
handles/proxies. Releasing the final native owner of a member removes it; the SDK
does not invent a replacement-selection observer during native finalization.
GtkBuilder can look up RadioAction too. Builder-created native radio objects follow
XML/native initial grouping/selection rather than the SDK singleton constructor;
currentValue accepts a groupless object's own value and joinGroup initializes a
native groupless peer when necessary.

### Fixed-schema managed UI

newUIManager([groups...],tearoffs=false) owns a native GtkUIManager, retains SDK
ActionGroup handles, and reserves their membership until close. Group and action
names must be unique across the manager; groups cannot simultaneously belong to
another SDK manager. Existing native accel paths/shortcut bindings must be removed
before registration. These guards avoid native closure/group conflicts.

While registered, ActionGroup.add/remove raises ValueError. Labels, icons, visibility,
sensitivity, radio selection and existing command observers remain mutable. Dynamic
action-group insertion/shadowing is not supported in this first ergonomic layer:
construct the complete command schema first, then merge/unmerge its presentation.
Do not mutate these groups, paths or manager-owned nodes through raw GTK.

```nim
let commands = newActionGroup("editor")
commands.add(newAction("File", "_File"))
let open = newAction("Open", "_Open")
commands.add(open)
let ui = newUIManager([commands], tearoffs=true)
defer: ui.close()
ui.attach(window)
window.onDestroy(proc () = ui.close())
ui.bindShortcut(open, "<Control>o")
let merge = ui.addUi("""<ui><menubar name="Main"><menu action="File">
  <menuitem action="Open"/></menu></menubar></ui>""")
box.packStart(ui.get("/Main", MenuBar), packShrink)
# Later: ui.remove(merge)
```

addUi(xml) requires a complete <ui> root without attributes. The SDK parses the XML,
validates referenced commands and required menu/menuitem/toolitem/accelerator action
attributes, then calls native merging. This prevents GTK's lazy missing-action
warnings rather than suppressing them. Root serialization handles GTK2's peculiar
literal-<ui> detection, including XML declarations and an empty <ui/>. GTK validates
remaining UI grammar; these are trusted application definitions, not a security
sandbox or an arbitrary GtkBuilder object graph. Native failures copy message,
domain/code into UIManagerError; SDK schema/path mistakes raise ValueError.

A returned UIMerge is an opaque manager-specific token with a non-owning identity.
active(merge) tests current membership; remove(merge) is idempotent for an already
removed token from the same manager and rejects foreign tokens. Tokens do not keep
a manager alive and cannot accidentally target a newly allocated manager at a
reused native address. Multiple merges may overlay the same node; removing one
retains nodes referenced by another. Native parser failure removes its partial
merge without replacing prior successful merges.

ensureUpdate forces native lazy updates. get(path,WidgetType) retains a checked
widget view using the audited GtkBuilder widget lookup types; action(path) returns
a checked owning Action. Paths start with /; names and IDs are native UI node paths,
not widget indices. uiDescription returns a copied transfer-full native XML string.
UIManager retains looked-up states and generated toplevels until native destruction;
unmerging invalidates shared widget aliases and releases dead cache entries.
Parent generated MenuBar/Toolbar widgets normally. The manager owns them even when
parented elsewhere; do not independently edit their managed child trees. Native
tearoffs are enabled with tearoffs=true or the tearoffs property. Native Menu APIs
still realize before detaching; no hover or fake-click workaround is added.

### Shortcuts, visibility and teardown

UIManager.bindShortcut/unbindShortcut and attach/detach use the manager's native
accel group with the existing checked Shortcut/native action-closure machinery.
No global accel-map paths/default masks are installed or overwritten. Register
managed shortcuts through UIManager, not another SDK AccelGroup. Native action
menu labels are synchronized after updates, and action proxies use public
no-show-all so parent showAll cannot expose group-hidden commands. Visibility is
still not activation authorization; sensitivity controls native dispatch.

close is idempotent across aliases. It disconnects the registered groups' SDK
callbacks (including pending observations), unregisters shortcuts, detaches live
host windows, removes merges, forces native proxy destruction, clears native action
accel-group links and releases its native owner. Groups are then reusable; their
actions remain valid if independently retained, but their old SDK callbacks have
been disconnected. Host windows are retained while attached but are **not destroyed**
by closing the manager. Generated widget handles become destroyed, not independent
surviving UI. The final manager handle closes automatically only if no capture cycle
retains it; explicitly close on window destruction/defer to break such cycles.

Native update/unmerge traversal can emit synchronous widget destroy observers.
Reentrant mutation/lookup while updating is rejected, but close requests are accepted
and postponed until the active traversal returns. A temporary pin protects the
manager even if a destroy observer drops the caller's last handle. This avoids
recursive tree traversal/finalization through a borrowed native emitter. Ordinary
action/radio observers remain deferred and may safely remove merges or close hosts.
All operations, callbacks, native unrefs and final cleanup stay on the UI thread.

Raw-only extensions remain: mutable/shadowing action-group schemas, native persistent
accel-map paths, native merge IDs/programmatic add_ui node flags, arbitrary custom
proxy factories and UIManager lifecycle hooks. UIManager ownership is intentionally
separate from GtkBuilder lookup; do not fabricate a wrapper around a builder-created
native manager.

Hidden tests/tgtk2uimanager.nim joins testUi and maps nothing. It exercises signed
radio values/snapshots, joins/moves, builder lookup, schema/path/shortcut guards,
overlay removal, failed merges, group reuse and reentrant close/last-handle release.
Native C probes check radio constructor/changed callback ABI, GtkUIManagerItemType
width and signed pointer-width gssize loading. testMappedUIManager requires isolated
DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1; it checks live native proxies, shortcut
labels/dispatch, tearoffs, overlay teardown, conditional visibility and close from
an activation callback. No private GTK layouts, native warning suppression or
installed-library modifications are used.

## Popup text completion and editable combo entries

The expanded [inputs example](../examples/inputs.nim) attaches text completion to
its editable measurement-name combo. Existing editable ComboBoxText support is now
extended with a checked entry view and copied/coalesced text observations.

### Fixed text completion

newEntryCompletion(items=[]) creates an opaque, non-floating GtkEntryCompletion
with a private one-string-column ListStore and native text renderer. items() copies
its strings; setItems(items) validates every UTF-8/NUL-free string and constructs the
replacement before changing GTK. Callers do not receive mutable model/renderer
handles or borrowed iterators. Replacing the list cancels stale commits and queued
selection observations; returned item copies remain independent.

This initial wrapper is **popup-only**: GTK performs normalized, case-insensitive
prefix matching and native popup rendering/navigation. minimumKeyLength accepts a
nonnegative gint count; popupCompletion, popupSingleMatch and popupSetWidth control
native popup policy. refilter() requires an attached entry and updates matching;
it is not a public force-popup method. Normal user editing triggers GTK's popup
timeout. gtk_entry_set_text (and entryText=) intentionally suppresses automatic
popup scheduling in GTK2; do not confuse programmatic replacement with typing.
Inline completion/selection, custom match functions, arbitrary model columns,
action rows, markup providers and IME integration remain raw/separate work.

```nim
let suggestions = newEntryCompletion(["Length", "Length unit", "Width"])
defer: suggestions.close()
let choice = newComboBoxText(["Length", "Width"], editable=true)
choice.entry.completion = suggestions
suggestions.onSelected(proc (value: CompletionSelection) =
  echo value.index, ": ", value.text)
```

Entry.completion= accepts one ordinary exact GtkEntry, including the public entry
of an editable ComboBoxText. SpinButton/private subclasses are rejected rather
than overriding their editing. A completion may attach to only one entry at a time;
reassigning the same pair is a no-op and sharing across entries fails until detach.
completion reads a retained SDK handle; no completion returns an empty/closed handle.
Raw/native completion objects are not silently wrapped as fixed SDK text models.
Changing the fixed model/column or attachment through raw GTK is rejected on checked
SDK access; do not mix raw configuration with this wrapper.

Password entries cannot attach completion. Hiding an attached entry's text detaches
completion immediately through public visibility notification, removing its popup
and pending work. Read-only entries do not receive a deferred commit. These are
plain-text suggestions, not a suitable store for secrets. clearCompletion(entry)
or detach(completion) cancels pending work and disconnects that attachment's
selection observers, releasing their captures. Reattach and reconnect for a new
session. Entry destruction does the same automatically.

### Deferred selection commit and copied observations

GTK2's match-selected default writes entry text synchronously and then continues
using entry/popup state; its true-handled accumulator prevents ordinary after
handlers from observing that selection. The SDK's fixed bridge copies the selected
text/index and handles this signal, **deferring the actual text commit until UI
idle**. No application callback runs inside native matching/selection. Native popup
handling/navigation still runs normally; the commit runs only after its emitter
returns. This timing is intentionally different from raw GTK's synchronous default.

Only the latest pending selection is retained. Intervening text edits, model changes,
detach, password hiding or owner destruction cancel stale insertion. At delivery the
SDK checks live attachment, generation, editable/visible state and the current key,
retains native objects across the text setter and rechecks lifetime/text before
moving the cursor or reporting success. Reattachment from inside that native text
setter's synchronous changed callback is rejected until it returns (detach/close
remain safe), avoiding GTK trying to unblock a new entry's handler on the old entry.
GTK's public text setter already suppresses
reopening completion for the committed text. There is no private handler-ID access,
warning suppression or native-library modification.

onSelected(proc(CompletionSelection)) returns a CompletionConnection with connected
and idempotent disconnect. Dropping the token does not disconnect it. Each completed
commit queues a copied index/text observation at UI idle after native entry/combo
change handlers have returned. The index is a snapshot in the old suggestion list,
not a stable row handle or index into a combo's choice model. Observers may detach,
replace items, close completion or destroy windows; exceptions are contained.
Disconnection/teardown cancels queued observations. These are post-commit observers,
not veto callbacks or a contract to mutate native iterators.

Native entry ownership keeps the completion/bridge/observers alive even when the
last external SDK completion handle is dropped. close() is idempotent, detaches,
cancels work, releases observer captures and invalidates shared SDK aliases; its
native GObject is unreffed when retained handles finish. A callback capturing its
own completion/entry can form a reference cycle: explicitly close or destroy its
entry to break it. All API calls, callbacks, finalization and unrefs stay on the UI
thread with GTK initialized under ARC/ORC. GtkBuilder completion lookups are not
provided: this fixed private-model wrapper requires its own constructor.

### Editable ComboBoxText

newComboBoxText(...,editable=true) already uses GTK2.24's native with-entry constructor.
entry() now returns an owning checked Entry view of its public editable child;
noneditable combos reject it. Destroying the combo invalidates retained entry
aliases. The entry cannot be individually destroyed through Widget.destroy or
removed through Container.remove, including upcasts: the combo owns this editing
slot. Destroy the combo instead. Entry text/clipboard/focus/completion helpers can
be used normally on the retained view.

Entry construction/text assignment/insertion and ComboBoxText constructor items,
append/prepend/insert and entryText= now validate UTF-8 and NUL
before mutation. textState() copies ComboTextState(index,text). onTextChanged queues
a coalesced final state at idle, without an initial event, allowing safe downstream
updates/destruction. A free-form edit normally has index=-1 even if its text happens
to equal a listed choice; typing/completion does not implicitly select a row or add
one. It remains distinct from activeIndex and from a suggestion-list index.
The older ComboBox.onChanged timing remains unchanged; use onTextChanged for copied,
deferred text observations. Disconnect/destroy cancels pending delivery.

Hidden tests/tgtk2completion.nim configures unmapped entries and uses public native
signal emission to probe ownership, stale commits, password/readonly behavior,
reentrancy, Unicode, destruction and combo private-child guards. They never map a
popup. Native C ABI probes check the match-selected pointer/iter/gboolean callback.
The opt-in testMappedCompletion additionally maps real native completion popups on
an isolated virtual DISPLAY and requires GTK2_TEST_VIRTUAL_DISPLAY=1; Unix X11 uses
libXtst/XTEST Down/Return input to verify casefold matching, Unicode selection,
combo coherence and safe observer-driven window teardown. Never run it on an
ordinary desktop.

## Synchronous model functions and cell presentation

The expanded [proxies example](../examples/proxies.nim) combines a custom score
comparison, closure-controlled visibility, styled text and a pixbuf column without
changing source order. These functions return decisions to GTK synchronously;
they are not deferred observations like completion or selection notifications.

### Copied rows and pure-function contract

ModelRow contains a copied TreePath and a values sequence of typed CellValue copies,
one per supported model column. Strings and paths are independent of GTK iterators;
pixbuf values retain the image object, not a deep pixel copy. Snapshots may be kept
on the UI thread, but their paths are historical coordinates, not stable identities.
Use a separately created TreeRowReference when stable identity is required.

Functions must be short, deterministic computations using the supplied values and
ordinary application state. **Do not access live GUI/model handles, mutate GTK,
change GUI ownership, close document/controller owners, pump events, or call raw
GTK from these functions.** Checked ObjectHandle-based SDK access and function-token
disconnection reject reentrancy with ValueError. This guard is not a sandbox for
raw pointers, arbitrary native calls, constructors or custom user destructors.
Value-only helpers such as treePath/rgba16 and ordinary string/numeric operations
are suitable. Schedule application changes outside the function after the native
traversal returns; these functions are not application event handlers.

As additional protection, a last ordinary ObjectHandle state released inside a
function clears its weak state hook immediately but defers native signal cleanup
and its final unref until UI idle, after GTK's traversal. Keep the UI context
running/drain it normally to deliver those releases. This does not authorize
releasing other owned controllers with custom teardown inside a function.

Exceptions, including rejected handle access, never cross C. A failed comparison
returns equality, a failed predicate hides that row, and a failed text presentation
restores the bound model text with default styling. Failures are reported, not
silenced. A throwing/inconsistent comparison does not promise a meaningful order;
applications must supply a consistent strict weak ordering. No native warnings are
suppressed and no private GTK storage or handler IDs are used.

### Custom sorting

newTreeModelSort(child, ModelCompare, order=sortAscending) selects a native custom
default comparison. ModelCompare takes two ModelRow snapshots and returns int;
only its sign is passed to GTK as a signed gint. GTK handles ascending/descending
ordering and sibling groups. The paths/values are in the **immediate child model**,
which may itself be a proxy, not automatically in the original source model.

```nim
let sorted = newTreeModelSort(source, proc (a, b: ModelRow): int =
  cmp(a.values[1].intValue, b.values[1].intValue))
```

setCompare(fn,order) installs/replaces the custom function and selects it; the old
function connection becomes inactive. GTK2 ignores an order change while DEFAULT
is already selected, so the SDK uses its public UNSORTED/DEFAULT operations when
selecting a new comparison. sortColumn is -1 for the custom default; sortOrder
reports its native order. Existing sortBy(column,order) still selects the ordinary
per-column GTK comparison, without losing the registered custom function.

Source row changes drive GTK's normal proxy updates. Changes to captured application
state are not automatically observable: call resort() to rerun the selected custom
default comparison. resort rejects a currently selected ordinary column sort and
keeps the existing function connection active. Path conversion and stable source
references remain unchanged; translate through proxy layers one hop at a time.

### Custom visibility

newTreeModelFilter(child, ModelPredicate) creates a filter using one permanent native
visible-function bridge. ModelPredicate takes one ModelRow and returns bool. Child
paths/values refer to the immediate child model. GTK's hierarchical ancestor rules
still apply: a visible descendant cannot appear beneath an invisible ancestor.

setPredicate(fn) replaces the bridge's application function and invalidates the old
connection, without illegally calling GTK2's set-once visible-function setter again.
Call refilter() after replacement or changes to captured predicate state. Existing
visible-column filters cannot switch to this mechanism: construct a function filter
instead. They retain their existing boolean-column API.

### Function ownership and disconnection

setCompare, setPredicate and setCellData return ModelFunctionConnection tokens with
connected and idempotent disconnect. Constructor-installed functions are available
through functionConnection(model); text columns have functionConnection(column).
Dropping a token does not disconnect, and a token does not retain its native owner.
Native bridges retain the function even if SDK aliases are dropped while a view
still owns the model/column. Native finalization or replacement deactivates the old
connection and releases its captures.

Explicit disconnect immediately releases that function's captures and leaves a
safe native fallback installed: equal comparison, all-visible predicate, or bound
text/default presentation. It does not automatically invalidate native caches.
Use resort(), refilter() or refreshCells(column) respectively to apply the change
to existing cached rows. A registered comparator may be connected even when an
ordinary column sort is selected. disconnectSignals(model) continues to disconnect
signals only; use the function token for these functions. disconnectSignals(textColumn)
also clears its cell function, matching its existing renderer-callback cleanup.

A function capturing its own model/column can form a reference cycle. Explicitly
disconnect the function (or clearCellData for a column) before releasing that owner.
Keep operations, callbacks, snapshots containing handles and final releases on the
UI thread with GTK initialized under ARC/ORC.

### Text and pixbuf columns

setCellData(TextColumn, TextCellFunction) overrides the existing text renderer's
presentation using a copied ModelRow in the **view model's** coordinates. It returns
TextCellData(text,bold,italic,dimmed,foregroundSet,foreground). Each call resets all
these managed properties so style cannot leak from the previous row. False bold/
italic flags remove their overrides and inherit the native default; dimmed controls
renderer sensitivity. Optional foreground uses opaque rgba16 colors; alpha and
invalid UTF-8/NUL text are rejected before applying the presentation. Text is literal,
not markup. The source model is not changed and edit observations still require an
explicit application commit; applications own parsing of any formatted edit text.

refreshCells(column) requests native column size/layout recalculation, useful when
captured presentation state changes without a model notification. clearCellData()
removes the function and resets its managed styling to ordinary attribute binding.
Native GTK may request a presentation repeatedly for sizing and painting, not once
per row; functions must not rely on call counts/order or perform side effects.

newPixbufColumn(title,modelColumn) and appendPixbufColumn(view,title,modelColumn)
add an owned fixed GtkCellRendererPixbuf binding. Attachment checks a pixbuf model
column and rejects double parenting. NULL pixbuf cells are allowed. Retained columns
have typed borrowed raw pointers and title/visible/resizable properties, matching
existing text-column ownership. This batch does not expose mutable renderer handles,
arbitrary property bags, custom renderer subclasses, toggle-cell data functions or
arbitrary multi-renderer layouts. GtkBuilder specialized column lookups remain
unsupported because they lack constructor metadata.

### Validation

Hidden tests/tgtk2modelfunctions.nim checks copied values/coordinates, hierarchical
filters, replacement, refresh, disconnection/capture release, reentrancy rejection,
last-handle idle release, exception fallbacks, style reset and schema validation
without mapping windows. Native C probes verify comparison, visibility and cell-data
callback pointer/gint/gboolean/cdecl ABI. testMappedModelFunctions exercises real
TreeView sizing/painting, Unicode, pixbufs, filtering/resorting and refreshed styles
only on an explicitly isolated display with GTK2_TEST_VIRTUAL_DISPLAY=1. See TODO.md
for the remaining work and next proposed batch.

## Ownership and safety contract

Call `gtk2.init()` before creating widgets. It raises `IOError` if no display
is available rather than terminating the process. It does not parse application
command-line arguments. All operations, callbacks, and final handle releases
must happen on the GTK/UI thread; do not send handles to worker threads.

Each GTK object constructor returns a value handle sharing one owned native reference.
Copying a handle shares its state rather than creating another object. Releasing
the last handle drops that reference; adding a child also gives its container
a native reference, so a child may safely leave Nim scope after being packed.
This differs from gtkmm's stack-object destruction semantics.

**Explicitly destroy top-level windows**, normally with `defer: window.destroy()`.
GTK itself retains top-level windows, so losing the last Nim handle is not a
substitute for closing a window. Destroying a container also destroys its
children. All surviving copies detect destruction (including destruction through
the raw API) and raise `ValueError` rather than using a destroyed widget.
`destroy()` is idempotent; a default/uninitialized handle is considered destroyed.

Widget closures remain alive until disconnected or the widget is destroyed. Discarding
a returned `Connection` does not disconnect it. Retaining one keeps the shared
widget state alive. It is safe to disconnect from inside a callback; disconnect
is idempotent. Capturing widgets is supported, but captures can create native/Nim
reference cycles: explicitly destroy the widget or disconnect the signal to
break them. Destruction releases this layer's callbacks after running ordinary
`onDestroy` handlers. Exceptions in callbacks are reported to stderr and are
not allowed to unwind through GTK's C stack.

`.raw` is an escape hatch for APIs not wrapped yet. It returns a borrowed pointer:
do not unref/dispose it, wrap it independently, or keep it after releasing its handle.
Raw operations bypass this layer's argument/containment checks. Import raw GTK
with a module alias and qualify raw names to avoid Nim's case-insensitive name
collisions (e.g. `rawGtk.WIDGET` versus `gtk2.Widget`).

`window.run()` shows the widget tree and runs until that window is destroyed.
Native close requests use GTK's normal default destruction behavior; unlike
some gtkmm window usage patterns, this API does not substitute hide-on-close.
`hide()` alone does not stop `run()`. `quit()` stops the current GTK main loop
without destroying windows. Prefer one top-level run loop; nested modal/event
loops and custom close-event handling are not part of this initial layer.

## Validation and scope

`nimble testBindings` checks compilation without a display. `nimble testUi` runs
integration tests using hidden widgets and requires a display; on headless Linux
hosts, use `xvfb-run -a nimble testUi`. The tests also run under `--mm:arc`.

`testUi` includes the core tests, `tests/tgtk2controls.nim`,
`tests/tgtk2layout.nim`, `tests/tgtk2inputs.nim`,
`tests/tgtk2feedback.nim`, `tests/tgtk2dialogs.nim`,
`tests/tgtk2text.nim`, `tests/tgtk2models.nim`, and
`tests/tgtk2trees.nim`, `tests/tgtk2proxies.nim`, and
`tests/tgtk2icons.nim`, `tests/tgtk2selectors.nim`, `tests/tgtk2ranges.nim`, and
`tests/tgtk2containers.nim`, `tests/tgtk2menus.nim`, and
`tests/tgtk2toolbars.nim`, `tests/tgtk2positioned.nim`, and
`tests/tgtk2choosers.nim`, `tests/tgtk2assistant.nim`, and
`tests/tgtk2filechoosers.nim`, `tests/tgtk2recents.nim`, and
`tests/tgtk2displays.nim`, `tests/tgtk2printing.nim`, `tests/tgtk2desktop.nim`, and
`tests/tgtk2extensions.nim`, `tests/tgtk2transfers.nim`, `tests/tgtk2actions.nim`,
`tests/tgtk2builder.nim`, `tests/tgtk2uimanager.nim`, `tests/tgtk2completion.nim`, `tests/tgtk2modelfunctions.nim`, and `tests/tgtk2iconselection.nim`.
Desktop tests cover unmapped infrastructure and checked layout; mapped tray/foreign
embedding tests are a separate explicit opt-in task described above. Print tests cover isolated
configuration, boxed/GObject copies, native ownership, range/geometry validation,
checked custom tabs and deferred response/capture lifetime. Display tests cover fixed cell models/paths, observer and
renderer/model ownership, normalized HSV, safe callbacks, and hidden offscreen
snapshot/damage ownership. Recent chooser tests
cover isolated history, copied metadata/vector ownership, native errors, manager
retention, filtering, selection/activation, menu attachment/refresh, deferred
responses and capture/native finalization. File chooser tests cover native/URI path handling,
asynchronous snapshots, selection modes, filter ownership/membership, deferred
responses (including Dialog upcasts), cancellation and native finalization.
Assistant tests cover
page metadata, visibility, navigation, image ownership, action membership,
retained-page lifetimes, deferred events, and callback/native finalization.
Chooser tests cover copied selections, alpha semantics,
screen anchoring, native font-list changes, nonblocking responses, hidden response
buttons, observer cancellation, and native/heap finalization. Positioned-container
tests check geometry, native scrolling, automatic snap-edge values, deferred
owning child snapshots, cancellation, and recursive cleanup. Toolbar tests cover
checked membership, native radio
groups, image/menu aliases, palette packing/scrolling, recursive destruction,
and closure/native finalization without showing windows. These check menu logical
ownership/cycles, tearoff parenting/title/state without opening detached windows,
activation cleanup, image slots, cached owning getters, validated
layout geometry, native child
properties, table bounds, retained-child removal/reparenting, range adjustment ownership/replacement, deferred coalesced observers,
keyboard-action destruction, literal scale marks, arrow enums, calendar
validation, copied chooser values, scale signals/shared adjustments, controls,
scrolling adapters, pane slots, notebook callbacks, retained-child reparenting,
shared adjustment ownership/cache cleanup, numeric editing, text choices, image
sources, status-message stacks, signed response callbacks, dialog parenting,
literal message formatting, copied credits, Unicode editing/selection, shared
text-buffer lifetime, typed atomic model rows, selection/activation callbacks,
shared model ownership, hierarchical paths, expansion and subtree deletion,
proxy coordinate mapping, reorder snapshots, stable references, pixbuf ownership,
NULL cells, icon selection/activation, native destruction,
heap-closure cycles, and invalid inputs. `testUi` never opens a visible window or
enters the GTK main loop. Separate opt-in testMappedMenus, testMappedPrinting and
testMappedDesktop/testMappedExtensions/testMappedTransfers/testMappedActions/testMappedBuilder/testMappedUIManager/testMappedCompletion/testMappedModelFunctions/testMappedIconSelection tasks map windows only on an isolated virtual display, as
described above.

All non-deprecated concrete core GTK2 widgets in the audited inventory now have
an ergonomic entry point. StatusIcon (a GObject, not a widget) and the abstract
Misc API are also covered; optional HtmlView remains outside the core layer.
Other gaps include standalone popup positioning and arbitrary/custom cell renderers beyond the audited
text/pixbuf/toggle column APIs, broader event argument/return-value APIs,
rich/binary clipboard formats, URI/MOVE/model drag-and-drop,
rich-text child anchors/serialization, actual print jobs,
arbitrary GObject properties,
widget subclass virtual methods, or gtkmm's broader GDK/Pango abstractions.
Use the raw API for those while this layer grows. No gtkmm C++ runtime is needed.
