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
  a nonempty selection existed, **not edit success**. Interactive mode honors native
  editable-tag policy and can return true without changing readonly text; explicit
  non-interactive deletion does not enforce interactive permissions.
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
Text child anchors/embedded widgets and explicit native rich clipboard document
transfer have dedicated guides below.

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

### Private line/segment removal and public traversal

Private line/segment operations, line-data bitfield helpers/masks and guessed
concrete bodies/callback types are removed without shims. Even the unprefixed
line_segment_split belonged to GTK's private headers. Only opaque private line/
line-data pointers needed by pending TextLayout signatures remain, not allocatable
objects or public ABI layouts. Public instance/class storage and table foreach
callback signature remain unchanged. See [line migration](raw-widgets.md#gtktextline-and-segment-removal-opaque-internals-public-iteration).

Logical iterator line counts/CRLF boundaries and UTF-8 bytes differ from native
wrapped display-line navigation. Use public GtkTextView operations on genuine
realized views and actual wrap policy, never width/valid cache writes. Iterator
copies own only storage, not a buffer/document snapshot; edits/release invalidate
all copies. Public mark/tag/widget list containers are owned, their elements
borrowed. Free containers and reacquire iterators from stable marks/checked offsets.
Public anchor/view embedding APIs—not widget-segment refcount/layout hooks—manage
children. No private subclass, repair, preedit, rebind or history API is added.

Fourteen native signature checks, public iterator/anchor storage/alignment and
above-BMP gunichar callback probes accompany unrealized removal/Unicode/ownership/
list/anchor tests. Existing isolated testMappedTextGeometry now verifies display
navigation and real wrap-mode changes; normal tests never realize widgets or claim
PRIMARY. The text example adds Wrap display for both views without editing text.

### Private tree removal and public positions

All 57 private BTree imports and five adjacent buffer/debug/mark-segment hooks are
removed, without aliases or validation/reset substitutes. Use public buffer edits,
iterators/tag toggles/slices, stable marks and TextView geometry instead. There is
no public tree ref/stamp/cache-validity/segment-registration interface. Iterators
are invalidated by edits: reacquire from marks/checked offsets, never repair them.
Logical line/code-point offsets differ from UTF-8 byte indices and wrapped display
geometry. Raw public get_tags owns GSList nodes but borrows its tag elements.

Typed opaque PIconSet prevents old tree ref/unref calls accidentally resolving to
unrelated pointer overloads. Native GtkTextWindowType geometry uses sizeof(cint),
not a byte enum. Seventeen public signature checks, native enum width and signed
coordinate/out-pointer probes extend existing ABI tests; no private tree layout
is guessed or accessed. The line/segment audit above removes those APIs;
remaining TextLayout/line-display/cursor internals are not a public replacement. See [tree removal](raw-widgets.md#gtktextbtree-private-entry-point-removal).

Unrealized removal/Unicode/tag/mark/object tests accompany opt-in
testMappedTextGeometry for actual wrapped geometry, coordinate round-trips and
post-edit mark reacquisition. No implicit realization, synthetic invalidation,
buffer rebinding or history reset is added. The text example uses public logical
counts and stable bookmarks, and labels clean state without implying file save.

### Buffer signals and lifetime

Raw modified-bit helpers/masks are removed without shims; use native gboolean
get_modified/set_modified. Native opaque storage uses guint, and TextBufferClass
now correctly names paste_done followed by five reserved slots. Full native
instance/class offsets, sixteen signature checks and signed callback probes preserve
ABI; this is not a subclass/paste-observer API. See [raw buffer migration](raw-widgets.md#gtktextbuffer-raw-migration-public-state-and-signal-lifetimes).

Modified state is a dirty flag only. Its setter changes no text/files/history and
emits modified-changed only on transitions; there is no modified GObject property
or notify::modified. Marks/tags/selection/style-only changes do not inherently dirty
text. Public cursor-position/has-selection metadata is readonly. Cursor notification
may occur during intermediate native edits, not just actual final movement, and is
not a general selection observer. No extra history/IME/undo/reset is synthesized.

Basic text/insert/delete/dirty/cursor/selection operations and removeAllTags pin native
buffer lifetime through callbacks. User actions retain/pin the original target,
even if a public alias is dropped/reassigned or the body raises: nested actions
emit only outermost begin/end, with immediate edits and no rollback. This is not a
license for destructive BTree reentrancy or nested event pumping in raw observers.
Tests use viewless buffers normally; opt-in testMappedTextBufferState isolates
actual realized-view selection/paint behavior because even unmapped realized views
can claim PRIMARY. The example's Mark clean action explicitly is not persistence.

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

### Copied RGBA8 pixel values

`RgbaPixels` is a pure owning, tightly packed row-major **R,G,B,A byte** value.
Channels are 8-bit, straight/unpremultiplied; no integer endianness conversion,
color-management/ICC processing, gamma change, orientation or codec is applied.

- `newRgbaPixels(width, height, bytes)` validates positive dimensions/exact byte count
  and copies its input. `.width/.height/.len/.isEmpty/.bytes` need no GTK access;
  len is byte count, and bytes returns another independent sequence.
- `pixbuf.rgbaPixels(maxBytes = 16*1024*1024)` snapshots native RGB8/RGBA8 samples.
  RGB gets alpha=255; RGBA keeps all channel bits, including RGB under alpha=0.
- `newPixbuf(value: RgbaPixels)` or `newPixbuf(width, height, rgba: openArray[byte])`
  allocates native-owned RGBA8 storage and copies rows. No Nim buffer is borrowed.
  Each construction is independent, unlike aliasing ordinary Pixbuf handles.

```nim
let pixels = newRgbaPixels(2, 1, [255'u8, 0, 128, 0, 17, 34, 51, 127])
let image = newPixbuf(pixels)
let before = image.rgbaPixels(maxBytes = 8)
var edited = before.bytes
edited[0] = 64
let changed = newPixbuf(before.width, before.height, edited)
# image, changed, pixels, before and edited do not share mutable pixel storage.
```

Default RgbaPixels has zero dimensions/length and empty bytes/isEmpty=true; it is
not a constructible zero-size image and cannot become a Pixbuf. Dimensions must be
positive and total width*height*4 must fit signed gint (at most 2147483644 actual
bytes, since length is a multiple of four). Short-circuit division validates before
multiplication, even for high(int) on Windows i386/amd64. Length must match exactly;
no partial rows, padded input, silent truncation or alpha inference is accepted.
Invalid dimensions/count/capacity raise ValueError before payload/native allocation.

Snapshots require valid native RGB colorspace, 8-bit samples and channels matching
hasAlpha (3 or 4). Native stride must contain actual row samples, with final address
span fitting Nim int. Only width*channels bytes of each native row are read: padding
is omitted and the final row need not contain trailing padding. Subpixbufs may share
a larger parent stride; snapshots do not retain them or their backing. Native objects
are pinned during reads; allocation/copy errors never expose a partial value.

maxBytes accepts 0..2147483647 and is checked against normalized RGBA byte count
**before** pixel retrieval/output allocation. Zero rejects every nonempty image;
negative/excessive bounds or empty handles reject. It limits this output only, not
source/parent allocation, native lazy pixel materialization, prior decoding, aggregate
copies, retained values or other memory/CPU. It is not untrusted-decoder protection.
The native Pixbuf/public storage contract must be valid; forged raw buffers/layouts
are not made safe by size checks. No private GdkPixbuf body is read or repaired.

Pure values/constructors/getters work before GTK initialization and in synchronous
model/drop functions. Native snapshot/construction operations reject checked pure
scope before copying/allocating, and run/finalize on the UI thread. Native-created
pixels use ordinary nonfloating transfer-full ownership; no native destroy callback
points into Nim payload memory. Returning/mutating bytes, dropping inputs or releasing
source Pixbufs cannot affect independent values/native images. Snapshots are historical,
not live views, and do not automatically replace displayed/model/drag/clipboard images.
Create a new Pixbuf and explicitly assign/publish/update it using the existing APIs.

Desktop now constructs its gradient through copied RGBA values and counts normalized
snapshot bytes only after trusted incoming decoding. Hidden tests use actual RGB/RGBA
storage, odd row padding, unpadded final rows, subpixbuf stride, all byte values/alpha,
mutation/release/weak external backing, bounds/overflow and pure guards, without maps,
selections or codecs. `testMappedRgbaPixels` requires isolated DISPLAY and
GTK2_TEST_VIRTUAL_DISPLAY=1, and observes actual native offscreen opaque color rendering,
replacement, native GtkImage ownership and retained snapshots. Nine public native
constructor/accessor prototypes, colorspace width and unsigned-row/signed callback ABI
plus source guards accompany ARC/ORC/cross-target checks. No simulated native rendering,
borrowed writable pixel API, parser or automatic untrusted decoding is added.

### Copied Pixbuf geometry transforms

`image.cropped(x, y, width, height)`, `image.flipped(horizontal = true|false)` and
`image.rotated(rotation)` return owning Pixbufs with **independent pixels**. Even a
full-image crop or rotateNone makes a copy. Sources, existing clipboard/drag offers,
active drag snapshots and icons are not automatically changed. Ordinary aliases to
a returned handle still share that result's mutable pixels; use `.copy()` if another
independent application image is needed.

```nim
let tile = image.cropped(1, 2, 8, 12) # Positive half-open rectangle, entirely in source.
let mirror = tile.flipped(horizontal = true)
let portrait = mirror.rotated(rotateClockwise)
# Explicit application choice, not a transform side effect:
preview.pixbuf = portrait
source.setImage(portrait)
```

Crops reject negative origins, nonpositive dimensions, non-gint values and any rectangle
outside source bounds. Ends use subtraction checks, not overflowing x+width/y+height;
there is no clipping or silent coordinate normalization. Native RGB8/RGBA8 channels,
straight alpha/transparent RGB samples and native quarter-turn orientations are
preserved. Rotation values are rotateNone, rotateCounterclockwise, rotateUpsideDown,
rotateClockwise (native 0/90/180/270 respectively; native 90 is counterclockwise).
Quarter turns swap dimensions. No arbitrary-angle interpolation, EXIF orientation,
metadata/encoded-file preservation or color-management promise is added.

Input format/rowstride and actual sample span are checked through public getters.
Unpadded final rows and subpixbuf strides are supported; source sample spans and
padded destination allocations conservatively fit signed gint (2GiB-minus-one) to
avoid native gint offset/allocation overflow. This is a checked range, not an allocation
quota: native allocation can still fail. Size/format/geometry/invalid enum and early
pure-function failures raise ValueError; NULL native allocation raises PixbufError
without invented GError domain/code (these native transform APIs have no GError).

Crops allocate an independent native image and use native copy_area, not an exported
shared subpixbuf. Rotations use native rotate_simple; zero uses its real native copy.
Horizontal flips use native flip(TRUE). **Vertical flips are defined as native 180°
rotation followed by native horizontal flip**, with an additional temporary image.
Inspected native GdkPixbuf 2.24.1 and 2.42.12 flip(FALSE) copies destination rowstride
bytes, which can read past a valid unpadded final RGB row. The SDK never calls that
branch. This is an explicit composition of real public transforms, not patched native
state, layout access, symbol interposition or replacement of raw native semantics;
raw flip(FALSE) still has its own native behavior. No installed library is changed.
Padding byte contents/rowstride equality are not part of the copied-pixel contract.

Native source references and the vertical temporary are pinned/released on the UI
thread on success/error; outputs keep no source/subpixbuf/backing/controller roots.
No GUI event loop is pumped. Pins are not immutable snapshots against unsafe raw
reentrant pixel mutation: native hooks must not mutate aliases or tear down controllers.
No codec, file IO, automatic source installation or mutable borrowed pixel pointer is
introduced. Desktop adds explicit crop/flip/rotate/reset controls and explicitly
installs results into preview/future image drags; existing transfers stay independent.

Hidden ARC/ORC tests cover exact nonsquare orientations/alpha/all-byte samples, RGB
padding/subpixbufs, no-op copies, source/result mutations, external-backing disposal,
argument/overflow/pure rejection and source pin cleanup. `testMappedPixbufTransforms`
requires isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1: actual native rendering,
GtkImage ownership/replacement and retained snapshots, plus POSIX guard pages whose
valid unpadded final RGB sample ends at inaccessible memory. All transforms pass;
after source disposal even its former readable page is protected, proving outputs do
not alias it. Windows skips this POSIX fixture; cross-target semantic checks are not
native Windows/macOS runtime claims. Three native prototypes, C-width rotation enum/
values and signed/full-width/callback ABI plus source guards cover the bridge. Broader
compositing/options/formats, transactions/persistence and private audits stay separate.

### Copied PNG byte encoding

`pixbuf.encodePng(maxBytes = 16 * 1024 * 1024)` synchronously returns a pure owning
`PngBytes` value using native non-varargs `gdk_pixbuf_save_to_bufferv`, fixed `png`
and NULL option vectors. `.len`, `.isEmpty` and `.bytes` need no GTK access; `.bytes`
always makes an independent byte sequence, preserving embedded NUL/non-UTF-8 bytes.
Assignments share only the value's private immutable payload, never writable native
storage. Default PngBytes is empty; successful encoding is nonempty. No public
arbitrary-byte constructor, native pointer, format guessing, decoder, file output or
automatic clipboard/drag offer is added.

```nim
let png = image.encodePng(maxBytes = 1024 * 1024)
let applicationCopy = png.bytes # Own bytes; the native buffer is already freed.
# Decide explicitly whether/how to use these bytes. No file or clipboard changes.
```

`maxBytes` accepts 0..high(int), bounds **only this call's completed application
payload copy**, and is checked as unsigned native gsize before conversion/allocation.
Negative bounds, empty handles and pure-function encoding raise ValueError before
native work. Zero is valid but a successful nonempty native result exceeds it;
excess raises ValueError("PNG encoding exceeds maxBytes"). This does **not** stop
native encoding or constrain its buffer allocation/reallocation, CPU, codec behavior,
source pixels, aggregate memory or later `.bytes` getter copies. At peak the completed
native buffer and SDK copy coexist. There is no cancellation, streaming or codec sandbox.

Native image lifetime is pinned through encoding; this is not a frozen pixel snapshot
and native codec hooks must not mutate aliases/pump events/tear down controllers.
All native calls and final releases remain on the UI thread. Transfer-full native
buffers are always freed with g_free; GError storage is freed on SDK exits, including
policy rejection and exceptions. Native GErrors propagate copied PixbufError message,
exact domain/code; a false result without GError or successful NULL/empty output gets
a generic PixbufError with default zero domain/code, not fabricated native diagnostics.
Native encoder errors take precedence over output-size policy. No roots to an image,
callback, native buffer or controller remain in a completed PngBytes value.

The installed PNG writer determines bytes/pixel/color/metadata behavior. An encoder
result is not a bitstream validator, codec security boundary or authority to decode
unknown input; absence/failure is propagated, never repaired/fallback-encoded. This
API does not introduce generic rich/image parsing or alter savePng's non-atomic file
semantics. Desktop's explicit Encode PNG bytes button reports a bounded in-memory
result; no file or clipboard ownership changes occur.

Hidden tests use default pure values/pre-native validation only. `testMappedPngBytes`
requires isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1: actual tiny RGB/RGBA/
transparent-RGB/all-byte pixel encoding, trusted self-produced PNG raw-loader round
trips (test-only decoder), copied result retention after source release/mutation,
zero/short/exact/high-int bounds, pure copied access and success/rejection native pin
cleanup. A real raw unsupported-format call probes native GError ownership; it is
**not** a forced SDK fixed-PNG failure. Native PNG absence/allocator failure are not
simulated or claimed runtime-covered on PNG-capable installations. Header prototype,
NULL vectors/GError double pointer/unsigned full-width gsize outputs/signed gboolean
ABI and source guards plus ARC/ORC/cross-target checks cover the bridge. No native
codecs/caches or installed libraries are changed. Options/formats, asynchronous work,
transactional files and persistence remain separate.

### Explicit PNG file encoding

`pixbuf.savePng(filename)` synchronously writes **PNG**, regardless of the filename's
extension. It uses the installed native writer through non-varargs `gdk_pixbuf_savev`,
with NULL option vectors: no format guessing, extension append, options, codec fallback,
implicit decoding or clipboard publication is added. A PNG writer must be installed.

```nim
let pixels = newRgbaPixels(2, 1, [255'u8, 0, 128, 0, 17, 34, 51, 127])
let image = newPixbuf(pixels)
image.savePng(explicitlyChosenFilename) # Caller decides authority and replacement policy.
```

Filenames reject embedded NUL **before** native file access; empty names and other
OS/path failures are delegated to native errors. Unix/POSIX paths retain native
filename bytes (not forced UTF-8). Windows uses public `savev_utf8`; loadPixbuf now
also uses native `new_from_file_utf8` there, matching GTK chooser UTF-8 filenames
instead of old GdkPixbuf locale-ABI exports. These are actual platform entry points,
not fallback/compatibility emulation. Raw savev remains available, with corrected
GError** type. Other platforms use their native savev/new_from_file directly. Native
Windows/macOS behavior is semantically checked, not claimed runtime-tested here.

The SDK owns a copied filename buffer and a native image reference for the entire
encoder call, releasing both on success/error. The pin preserves object lifetime,
**not pixel immutability**: do not mutate aliased pixels, pump events or tear down
controllers from native codec/module hooks. The SDK does not pump a nested loop.
GTK calls and final releases remain on the UI thread. Early pure-function guards
reject save and load before filename/handle/codecs/file work. No encoded buffer or
file handle escapes; completed saves do not retain image/controller/filename roots.

Actual native GErrors raise `PixbufError` with copied message and exact numeric
`.domain/.code`; native error storage is freed on all SDK error exits. The domain may
be G_FILE_ERROR or a GdkPixbuf/encoder error; no custom errno/quark remapping or global
error reconstruction occurs. If native false supplies no GError, a generic PixbufError
has default domain/code zero, not invented native diagnostics. Empty handles/NUL and
pure-scope violations raise ValueError before file access. Encoding RGB preserves
native RGB behavior; RGBA PNG pixels, metadata/options and encoded bytes follow the
installed writer, not an original encoded-file or general color-management guarantee.

**This is not atomic save or durable persistence.** Native GdkPixbuf opens/truncates
the path before encoder success is known. It may follow symlinks, replace existing
contents, remove the target after encoder failure, or leave partial data on close/
I/O failure. Even a missing writer/module can therefore damage an existing path.
The SDK does not preflight filesystem permissions/encoder availability, unlink,
restore old contents, fsync, rename a temporary file or roll back. Success reports
native encoder/close success, not power-loss durability. Filename/URI/MIME validity
is not authority; applications must decide path/overwrite policy. A chooser's
confirmation is UX, not race-free authorization. Use an application-owned transaction
protocol when atomic replacement or stronger filesystem guarantees are required.

Desktop adds an explicit Save sample PNG chooser action, local filename checks and
native error display; no startup writes occur. Hidden tests only validate pre-I/O
errors/purity. `testMappedPngFiles` requires isolated DISPLAY and
GTK2_TEST_VIRTUAL_DISPLAY=1 and writes only private temporary tiny fixtures: fixed
format despite suffix, exact RGBA/transparent RGB/all byte values, RGB, Unicode/native
POSIX filename bytes, overwrite, real missing-parent/directory/non-directory/empty-name
GErrors compared with raw native results, retained copies and successful/failed image
pin cleanup. Only these self-produced trusted PNG files are decoded. Runtime tests
require PNG support; encoder absence/forced close failure are not simulated or claimed
exercised on every build. Native save/load prototypes, NULL vectors/GError double-
pointer/signed gboolean ABI and source guards plus ARC/ORC/cross-target checks cover
the bridge. Native codecs/installed caches are never changed. Copied PNG bytes are
available separately via encodePng; broader formats/options, asynchronous saving and
clipboard-manager persistence stay separate.

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
Embedded child widgets/anchors and native rich-text serialization are covered in
their dedicated guides below, alongside explicit rich clipboard document transfer.
Undo remains separate work. Plain-text clipboard integration is covered below.

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

## URI clipboard transfers

`newUriList(openArray[string])` makes a copied, immutable-by-API value; `.uris`
returns a copied sequence and `.len` its count. Order, duplicates, scheme spelling
and escapes are preserved. Tokens require an absolute scheme and ASCII URI
characters with complete `%HH` escapes. Encode UTF-8/non-ASCII bytes yourself;
tokens without a scheme, whitespace, NUL, malformed escapes and IRIs are rejected. This is a
**token check, not a full authority/scheme-specific URI parser or authorization**.
Arbitrary schemes (even drive-looking `C:/path`), remote file authorities and encoded
bytes (including `%00`) remain data. No normalization, percent decoding, stat, file reads or application
launch occurs. Applications must independently validate schemes/hosts/paths and
user intent before using received URIs; do not infer a safe local filename.

```nim
let clipboard = getClipboard()
let offer = clipboard.offerUris(["file:///tmp/a%20b", "https://example.invalid/%CE%BB"])
let request = clipboard.requestUris(window, proc (value: ClipboardUris) =
  case value.kind
  of urisAvailable: echo value.uris # Copied tokens; empty is a valid result.
  of urisUnavailable: echo "No URI target available"
  of urisRejected: echo value.error)
# request.cancel() suppresses delivery; offer.clear() revokes only this active offer.
```

`offerUris` also accepts `UriList`. It validates the whole list before claiming
ownership, advertises **only text/uri-list**, and uses native `set_uris` to copy
CRLF framing. `UriClipboardOffer.active` follows native clear/replacement; dropping
the token does not clear ownership. GTK pins copied data independently until clear.
After native clear notification, a stale token's `clear()` is a no-op. `active`
reflects those notifications, **not an atomic cross-process ownership lock**;
server ownership changes/events can race with GTK's native clear operation. Empty
lists are publishable.
No source widget, file descriptor or lazy application callback is retained.
No clipboard-manager persistence or data survival after process exit is promised.

`requestUris(fn)` / `requestUris(owner: Widget, fn)` return a `UriRequest` with
`pending` and idempotent `cancel`. Application delivery always occurs at UI idle,
including synchronous local replies; errors are contained and reentrant new
requests supported. Cancel/owner destruction promptly release captures and queued
payloads and disconnect owner hooks. Dropping a token does **not** cancel. GTK has
no wire cancellation: a separate small native callback pin/clipboard ref survives
until the real reply/timeout. Callbacks never expose selection data or C arrays.

A missing/refused target is `urisUnavailable`; a correctly typed format-8 empty
payload is `urisAvailable` with no entries. Successful wrong-type/format or invalid
data is `urisRejected`, with no partial entries and an error. UTF-8/NUL checks run
before native conversion; GTK's public `get_uris` handles comments, whitespace and
line endings, then each copied token is checked. Its transfer-full `gchar**` is
freed with `g_strfreev`. There is **no text fallback**, rich parsing, implicit paste,
file permission promise or automatic drop acceptance. Native transfer memory is
already allocated by GTK; this does not impose an incoming size cap or sandbox
hostile desktop owners. The UI-thread and synchronous-model-function guards apply
to all clipboard operations; pure `UriList` construction/access needs no GTK calls.

[examples/desktop.nim](../examples/desktop.nim) adds explicit Copy sample URIs and
Inspect URI clipboard buttons; startup only configures controls. Hidden
`tests/tgtk2uriclipboard.nim` covers copied values, validation, pure guards and invalid
handles without realizing widgets, claiming PRIMARY or requesting selections.
`nimble testMappedUriClipboard` requires isolated DISPLAY and
`GTK2_TEST_VIRTUAL_DISPLAY=1`: it owns CLIPBOARD/PRIMARY and covers local/foreign
owners, malformed/empty/unavailable results, cancellation, replacement, dropped
tokens, owner destruction and reentrant/throwing callbacks. Native header probes
check both public signatures and `char**`/full signed `gboolean` callback ABI.
URI COPY-only pads/copied acceptance and image/binary offers are described below.
Trusted image requests are described below; MOVE and asynchronous acceptance remain separate
functionality batches. Raw TextLayout audits are deferred, not continued or certified
by these features.

## Copied binary clipboard offers

`newBinaryData(mime, openArray[byte])` creates an immutable-by-API copied value;
`.mime`, `.len` and `.bytes` return its target, byte count and independent copied byte
storage. Embedded NUL, invalid UTF-8 and all 256 byte values are ordinary data. No
string overload, decoding, normalization, framing or compression is implicit.

```nim
let value = newBinaryData("application/vnd.example.sample", [0'u8, 255, 128, 0])
let offer = getClipboard().offerBinary(value) # Explicit user action only.
# Also: clipboard.offerBinary(mime, bytes)
# offer.active / offer.clear(); dropping tokens alone does not revoke ownership.
```

MIME validation deliberately accepts a **conservative subset**, not arbitrary atom
names or every valid MIME spelling: exactly lowercase `application/`, followed by
1..127 ASCII subtype characters. The first must be a lowercase letter/digit; the
rest may additionally contain `!#$&-^_.+`. Whitespace, NUL, uppercase, parameters,
extra slashes and other top-level types are errors, never silently normalized.
`application/octet-stream`, `application/json`, vendor names and custom x- names are
allowed; x-gtk-/x-gdk- prefixes and exact x-color/x-rootwindow-drop subtypes are
reserved. This prevents use as GTK rich-text/color/root-drop or bare TARGETS,
TIMESTAMP, MULTIPLE, DELETE, SAVE_TARGETS/text/image protocol adapters. It is **not**
a universal registry of every application's special target or a claim that JSON,
PDF or other declared data is valid, trusted or authorized. Applications must know
their chosen format and independently validate every later use.

The private payload is copied before publication. Byte count must fit **gint minus
one** (at most 2147483646), because GTK2's public selection setter allocates length+1
using gint arithmetic. Actual memory/platform limits may be smaller; no allocation
success or denial-of-service boundary is promised. Default BinaryData has no valid
MIME and cannot be offered; a constructed zero-length value is a valid available
empty payload, not clear/unavailable. Validation/copy failure precedes native atom/
ownership changes and leaves the old offer alone. Pure value construction/access
uses no GTK; both offer overloads and clear reject synchronous model/URI predicate
calls before native lookup or publication. GTK initialization/display and UI-thread
operation/callback/final-release requirements apply.

`offerBinary` uses native `set_with_data` with one ordinary application-data target
(flags/info zero). GTK's own housekeeping protocol targets remain native. The get
callback roots the original storage and calls `gtk_selection_data_set` with the
selected MIME as type, format **8** and the exact byte length. GTK copies bytes;
its trailing terminator is not part of the payload. No UTF-8/string conversion,
text/URI/image fallback, format-16/32 reinterpretation or invented INCR transport is
installed. Large foreign transfers use GTK's actual selection protocol.

`BinaryClipboardOffer.active` follows native clear notifications, not an atomic
cross-process ownership check or delivery acknowledgment. Native pins retain payload/
clipboard references after token loss, until clear/replacement/ownership loss.
Inactive retained tokens no longer retain the payload; stale inactive clear and
repeated clear are no-ops. Reentrant old-owner clear may install a winner and cause
GTK itself to clear the failed candidate before returning false. Cleanup is
idempotent, raises for the failed claim and never retries over the winner. Already-
started requests may complete old data; clear is not a secure eraser or transaction.
No persistence/set_can_store, startup publication, parser, application acknowledgment or binary DnD is added by offers. The separate
bounded incoming byte API is described next. PRIMARY is explicit only.

[examples/desktop.nim](../examples/desktop.nim) has user-triggered opaque byte copy/
clear buttons. Hidden value/MIME/invalid-handle/purity tests never claim ownership,
request data or realize widgets. `nimble testMappedBinaryClipboard` requires isolated
DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1. It verifies exact type/format/length, all byte
values, empty/unavailable, copied input/getters, dropped tokens, replacement/stale
clear, actual reentrant claim failure, no fallback, independent explicit PRIMARY,
foreign ownership loss and a 600013-byte foreign transfer exceeding GTK2 X11's INCR
threshold. The test-only raw receiver copies bytes without parsing; the additional SDK incoming
byte API is described next. Native setter/length prototypes and signed format/
count/unsigned-byte ABI probes plus source ownership/size/scope guards cover this path.

### Bounded copied binary requests

`clipboard.requestBinary(mime, fn, maxBytes = 16*1024*1024): BinaryRequest` requests
exactly one explicit application target. The owner-bound overload is
`clipboard.requestBinary(owner: Widget, mime, fn, maxBytes = ...)`. It uses the same
conservative MIME subset as offers. Nil callbacks, invalid/destroyed owners and
maxBytes outside 0..2147483646 are rejected before starting a native request.

```nim
var request = getClipboard().requestBinary(window, "application/vnd.example.sample",
  proc (value: ClipboardBytes) =
    case value.kind
    of bytesAvailable: echo value.bytes.len # Opaque bytes; do not auto-parse.
    of bytesUnavailable: echo "No reply for this target"
    of bytesRejected: echo(value.error),
  maxBytes = 4096)
# request.pending includes both native waiting and queued idle observation.
# request.cancel() suppresses observation, not the native request.
```

`ClipboardBytes` contains copied `.mime` (the requested name), `.bytes`, `.error` and
`.kind`: bytesUnavailable for absent/negative-length native replies, bytesAvailable
for exact target/type/format-8 data (including valid empty), and bytesRejected for
wrong target/type/format, excessive length or missing nonempty data. Rejected results
have no partial bytes. No fallback, codec, JSON/XML parser, image decoder, UTF-8 check,
NUL stripping or format-16/32 conversion is performed. MIME is not authentication,
format validity or authorization; consumers must explicitly validate any later use.

The byte bound is checked **before application payload allocation/copy**. A zero
bound permits only empty data. It does **not** cap GTK/GDK/X11 receipt buffers, INCR
accumulation, native timeouts or the desktop owner's work: native GTK has already
received/allocated the selection by this callback. It is not a security or total
memory/CPU limit against a hostile owner. No native transport is rewritten, canceled,
repaired or pumped recursively to enforce an application deadline.

Every user observation runs on UI idle, even for synchronous local replies. Native
borrowed bytes are copied before returning from the native callback. Captures/data
are detached before application delivery; pending is false inside the observer,
which may reenter GTK, request again, replace ownership or destroy widgets. Exceptions
are contained/reported. Returned values are ordinary owned Nim data and survive
clipboard replacement/native buffer release. Dropped request tokens do not cancel.

Cancel/owner destruction promptly clears user captures, queued bytes and idle sources.
A separate native wire pin and clipboard reference survive until the actual reply/
GTK timeout; replies arriving after cancellation skip application copying and schedule
no observation.
The idle pin is independent of the wire pin. Owners are **not retained by the
binding**: a non-owning native pointer plus independently pinned destroy/closure
notification handles disposal without acquiring a finalizing-widget reference. The
public Connection type is deliberately not stored here because it owns its target.
A callback that itself captures GUI handles can still retain them; explicitly cancel
or destroy controller owners rather than assuming arbitrary closure cycles disappear.
Requests/owner teardown/callbacks/final releases stay on the UI thread. Checked
synchronous model/URI predicates reject requests and cancel, including empty tokens.

Desktop's explicit Inspect sample byte target button uses the window-bound overload
with a 4096-byte application bound; it reports counts, never decodes payloads.
`tests/tgtk2binaryrequests.nim` performs no wire/ownership/realization work. The existing
isolated `testMappedBinaryClipboard` task now also tests SDK result kinds/idle/copies,
exact/zero/over-limit bounds, wrong type/format/empty-type rejection, local queued and
delayed foreign cancellation/capture release, weak owner disposal, dropped tokens,
reentrant/throwing observers, PRIMARY and large real foreign INCR data. Six native
public prototypes and received/destroy/closure-notify callback ABI probes plus source
allocation/lifetime guards cover this path. Explicitly trusted incoming requests are described above.

## Copied image clipboard offers

`clipboard.offerImage(image: Pixbuf): ImageClipboardOffer` explicitly replaces
clipboard ownership with an **independent native pixel copy**. For example:

```nim
let pixels = newPixbuf(32, 24, 0x3377cc90'u32)
let offer = getClipboard().offerImage(pixels) # Only in an explicit user action.
# Later source pixel mutations/releases cannot change the offer.
# offer.active follows native ownership notifications, not an atomic desktop lock.
# offer.clear() releases this offer if still locally active; stale tokens are no-ops.
```

There is no startup publication, widget realization, automatic paste, incoming
image request API, image DnD or clipboard-manager persistence in this batch.
`getClipboard(clipboardPrimary)` is supported only as an explicit application choice;
normal tests never publish to either selection. GTK initialization/display and UI-
thread operation/callback/final-release rules apply. Offer and clear reject inside
synchronous model functions/URI predicates before native clipboard work or copying.

An empty/uninitialized Pixbuf is an error, **not** an empty image or clear request.
Pixel allocation/copy and target discovery finish before claiming ownership, so
invalid input leaves the previous contents alone. A failed native claim releases
its own snapshot/pin and raises; native ownership races are not rollback transactions.
If an old raw owner's clear callback installs a reentrant winner, GTK may clear the
failed candidate itself before returning false. Cleanup is idempotent and does not
revoke that winner; no forced second ownership claim is attempted.
The source Pixbuf is neither retained nor exposed as an offer getter. The private
snapshot's lifetime is owned by the attachment/native pin, not by the token. Dropping
all tokens does not revoke it; clear/replacement/native ownership loss promptly drops
the snapshot and clipboard reference even if an inactive token is retained. Repeated
clear is harmless. As with URI offers, process death, display shutdown and foreign
ownership changes follow native GTK semantics, not a synthesized desktop-state cache.

Targets come from public `gtk_target_list_add_image_targets(..., writable=TRUE)` and
`gtk_target_table_new_from_list`; the temporary table/list are freed with their native
functions after `set_with_data` copies them. No hardcoded PNG-only offer or guessed
codec/target registry is maintained. The native getter callback pins the original
private Pixbuf locally through encoding and calls `gtk_selection_data_set_pixbuf`,
which selects a native encoder for the requested MIME target. Clear releases the
independent native callback pin. Unlike `gtk_clipboard_set_image`, this API does **not**
call `set_can_store`: persistence is deliberately not enabled.

An active offer means claimed/not yet notified lost, **not** delivery or encoding
success. Installed writable encoders determine available targets and may fail, be
lossy or discard alpha/metadata. A pixel snapshot does not promise original encoded
file bytes, codec, file metadata or identical output in every format. No text/URI
fallback is advertised, and observations/async delivery acknowledgments are not
invented. Already-started requests may finish with old data during replacement;
clear is not a secure eraser or an atomic cross-process ownership check.

[examples/desktop.nim](../examples/desktop.nim) adds explicit copy-image/clear buttons
and an independent preview. `tests/tgtk2imageclipboard.nim` covers invalid handles,
idempotent empty tokens and early pure-function guards without claiming ownership,
requesting data or realizing widgets. `nimble testMappedImageClipboard` requires
isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1; its tiny **trusted fixture PNG**
fixtures require a writable PNG codec. Offer probes verify local/foreign
encoding, exact pixel/alpha/dimension snapshots, mutation/source release, dropped
tokens, repeated requests, replacement/stale clear/ownership loss, reentrant native
clear/failed-candidate cleanup, explicit independent
PRIMARY and absence of text/URI fallback. Six native prototype checks plus pointer/
signed-gboolean probes cover the public adapter ABI. No untrusted desktop image is
automatically decoded by the SDK; explicit trusted request/security policy follows below.

## Explicitly trusted COPY-only image drag/drop pads

Exact ordinary DrawingArea/EventBox pads support:

- `enableImageDrag(image: Pixbuf): ImageDragSource`; `setImage(image)` copies new
  payload pixels for later actual begins. No getter exposes mutable payload storage.
- `onImageDrop(trusted: bool, fn, maxPixels = 4*1024*1024, accept: ImageDropPredicate = nil)`
  returns ImageDropSite. False trust rejects before native registration/decoding.
- Source/site connected/disconnect; destination draining. Image sources also support
  copied setIcon/clearIcon, independently of their payload.
- `ImageDrop` owns `.image: Pixbuf` and copied `.info: ImageDropInfo`: width/height/
  hasAlpha, original pad-local x/y and uint32 time. ImageDropPredicate receives **only
  ImageDropInfo**, never a Pixbuf, borrowed pixels or context.

```nim
let source = sourcePad.enableImageDrag(newPixbuf(32, 24, 0x339966dd'u32))
let small: ImageDropPredicate = proc (info: ImageDropInfo): bool =
  info.width <= 64 and info.height <= 64 # Metadata policy, not trust/authorization.
# Only after explicitly trusting incoming native codec data:
let site = destinationPad.onImageDrop(true, proc (value: ImageDrop) =
  preview.pixbuf = value.image, maxPixels = 4096, accept = small)
source.setImage(newPixbuf(24, 32, 0x99663380'u32)) # Active drags retain old pixels.
```

Payload construction/update copies before replacing state; caller mutation/release
and invalid updates cannot change actual begin snapshots. Flights retain immutable
private pixel refs; callback/state/pixel pins span native encoding reentrancy. Dropped
tokens do not revoke sites. Native targets use installed writable source/readable
receiver formats, with PNG prioritized when available. Temporary public lists/tables
are freed; encoder alpha/loss/metadata behavior remains native, not encoded-file
preservation. Payload is not automatically the drag icon.

One site owns each direction: image/text/URI/binary/native target lists conflict rather
than overwrite; opposite directions are independent. Public GTK cannot enumerate every
empty/proxy raw registration: do not preconfigure/mutate SDK pads via raw handlers.
No private registry, guessed layout or implicit realization/mapping/reparenting is used.

Destination trust is fixed per attachment and must cover all responding data/owners;
MIME labels, copied metadata policies and checkbox state authenticate nothing. Selected
action must be COPY at drop and receipt. Reply target/type must match the negotiated
native target, format must be 8, length positive and bytes present **before** decode.
GTK get_pixbuf uses an autodetecting loader (transfer-full result freed): installed
loaders are not sandboxed or confined to a MIME security allowlist. A drop requests one
negotiated target; no alternate-format/text/URI/rich fallback is added. Native NULL
and invalid/absent/empty transfer envelopes fail without observation. A non-NULL native
Pixbuf is not independent bitstream/completeness validation: GTK may return partially
decoded pixels even when its loader reported errors, which the SDK cannot reconstruct.

maxPixels shares trusted requests' **0..536870911** post-decode copy bound: positive
int64 dimension product is checked before allocating the private pixel copy. Zero
rejects every image. This does not limit native receipt/INCR/decoded image allocations,
codec CPU/timeouts, owner work or total queued/retained memory. A predicate **cannot
authorize decoding**: it runs after trusted decode/bounded copy and before native
finish, over independent metadata only. Nil accepts valid transport; false/errors
reject without observation. Invalid/non-COPY/canceled/over-bound replies never call
policy. Shared pure guards reject checked GTK/clipboard/teardown access, contain
exceptions and restore scope. Do not pump events, block, use raw GTK or invoke arbitrary
controller teardown. This is a contract, not whole-program interposition or a sandbox.

Each tracked selection finishes exactly once, always **delete=false**, without
DEFAULT_DROP, MOVE, synthetic cancellation/acceptance or source-success repair. Idle
owning observations queue only after finish and may retain/mutate images, reenter GTK,
disconnect/destroy or throw. Delivered handles alias ordinary mutable application
storage; use copy() for another image. Canceling a queued observer releases images/
captures but cannot undo native completion. GTK2 X11 drag-end still looks success-like
on rejected Finished; tests inspect the actual public GDK outcome bit, not that signal
as acceptance or application acknowledgment.

Disconnect/destruction promptly clears observer/policy/payload/icon config. Pending
native wires pin original pad/context and an independent **unrealized same-screen
receiver Window**, preserving replies after original handlers disappear. Inactive sites
reserve against image/text/URI/binary replacement until actual receipt/timeout plus
separate idle cleanup. Late canceled replies skip SDK decoding/copy/policy, then finish
false; already-entered decoders/native encoding/receipt cannot be stopped. No early
finish or timeout repair is fabricated. Pads are weakly owned outside wire/cleanup
work; application closures can still create their own cycles. GTK owns IPC resources;
no user pad or receiver is implicitly realized.

Desktop makes the sample preview an image source and incoming preview a destination
only while a **separate initially-off drop trust checkbox** is enabled. Re-enable while
draining is refused until a later event; demo policy/copy bounds are small. Hidden tests
cover copies/weak pads/trust/conflicts/purity without selections/decoding.
`testMappedImageDrag` requires isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1 and X11/XTEST.
Real local/foreign tiny trusted PNG tests cover exact pixels/alpha/snapshots/updates,
bounds/zero, metadata copies/fixed identity/policy/errors/guards, wrong envelopes/text/
MOVE/source-cancel, no DELETE, retained/reentrant observers, queued cancel and delayed
disconnect/destroy/drain/replacement. Icon cursor/popup tests include this fourth source
family. Seven image-target/codec plus shared seven DnD native prototypes/four signed/
full-width signal ABI probes and source guards pin scope. Other platforms get semantic
checks, not simulated drags. Untrusted decoding, model/editor sources, MOVE, async
acceptance, persistence and private audits remain separate.

## Explicitly trusted copied image clipboard requests

`Clipboard.requestImage(trusted: bool, fn, maxPixels = 4*1024*1024)` and its leading
`Widget` owner overload return `ImageRequest` with pending/cancel. The **required**
trust argument must be true: false raises ValueError before any native image request.
This is an explicit caller decision to trust all data/owners involved in native
negotiation, not authenticated owner identity, codec sandboxing or a safe default
for arbitrary desktop data. A MIME name, URI, checkbox or size bound grants no trust.

```nim
# Only after an explicit application trust decision, never automatic desktop paste:
let request = getClipboard().requestImage(window, true, proc (value: ClipboardImage) =
  case value.kind
  of imageAvailable: preview.pixbuf = value.image
  of imageUnavailable: echo "No native image result"
  of imageRejected: echo value.error,
  maxPixels = 4096)
# request.cancel() cancels application delivery, NOT native decoding or receipt.
```

`ClipboardImage` owns `.kind` (imageUnavailable/imageAvailable/imageRejected),
`.image: Pixbuf` and `.error`. Available means a new private native pixel copy with
positive dimensions; no valid zero-size/available-empty image is invented. Rejected
results contain no partial image. Native NULL means unavailable: GTK does not
separate missing targets, unsupported formats and decoder failure, so neither does
this API. Rejected is an SDK dimension/copy-limit/allocation failure, not invented
codec diagnostics. Native errors are not reconstructed from unrelated global state.

GTK2.24 request_image tries PNG, then JPEG/GIF/BMP when previous conversion fails.
That native image negotiation remains intact, including codec lossy/alpha/metadata
semantics; the SDK does not parse formats, choose an extra codec, authenticate owners,
return encoded bytes or silently fall back to text/URI/rich data. Native get_pixbuf
uses an autodetecting loader: the four target names are **not a codec allowlist**,
and installed loaders may recognize other content regardless of MIME labels. A request may span
multiple selection transactions and owner changes: it is not an atomic ownership
snapshot. Use opaque requestBinary for supported application targets when no decoder
should run, not this API for untrusted encoded images.

maxPixels accepts **0..536870911** (gint div 4). Zero rejects any non-NULL image;
otherwise positive width*height is checked with int64 before the SDK pixel copy.
Default is 4,194,304 pixels. This constrains the application's post-decode copy only,
not encoded wire size, GTK/GDK receipt/INCR buffering, native decoded image allocation,
codec CPU/work/timeouts, aggregate requests or application-retained images. Native
codecs have already run before the bound can be checked. Do not treat it as decompression
bomb protection or a hostile-owner sandbox. The SDK adds no file loading/launch;
trust must cover the behavior of installed native codecs/loaders too.

The decoded callback Pixbuf is borrowed only through the native callback; the SDK
copies it before returning, independently of native decoder storage and clipboard
publication. User delivery always runs at idle, including local synchronous native
receipt. pending is false and state/owner/captures are detached before calling a
locally rooted observer. Results may be retained, widgets changed, new requests
started and exceptions thrown (contained/reported). Delivered Pixbufs are ordinary
mutable owning handles: aliases of one result share pixels; use `.copy()` for a
separate application image. No image or user callback is left on a completed token.

Owner binding uses a weak native widget pointer plus separately pinned destroy/closure
callbacks, not an owning Connection. Destroy or last unparented-owner disposal cancels
queued/pending delivery without referencing a finalizing widget. Dropped request tokens
do not cancel. Explicit cancel is idempotent and promptly releases observer/queued
image/owner roots. Independent native/idle pins keep callback state valid until the
real final native callback or timeout, including GTK's codec retries. Late replies
skip the SDK copy and user code. **Cancellation cannot stop native decoding, retry,
receipt, allocation or remote owner work**, even after trust is later withdrawn.
Application closures capturing owners can still introduce their own retention cycles.

All GTK operations/callbacks/final releases stay on the UI thread. Shared pure-function
guards reject request/cancel before native work. No widget is implicitly realized or
mapped, no selection is claimed by requests, no native timeout/history/cache is reset,
and no wait/nested event pump or clipboard-manager persistence is added.

Desktop adds an initially-off trust control, explicit decode button, small private
preview and 4096-pixel copy limit. Turning trust off cancels delivery, not decoding
already started. Hidden tests validate no-wire trust/bounds/callback/owner/purity rules.
`testMappedImageClipboard` uses **only explicitly trusted tiny PNG fixtures** for real
local/foreign idle/pixel/alpha/dimension/bound/retention/reentrant/error/PRIMARY/queued/
delayed cancel/destruction/last-owner disposal regressions; a second real reply drains
canceled native wires without exposing private bookkeeping. Four native request/copy/
dimension prototypes plus nullable-image/destroy/closure ABI and source guards cover
this path with ARC/ORC and cross-target checks. Trusted image pads are described above;
persistence and private layout audits remain separate.

## Copied drag-source Pixbuf icons

`TextDragSource`, `UriDragSource`, `BinaryDragSource` and `ImageDragSource` support the same explicit
`setIcon(image: Pixbuf)` and `clearIcon()` operations:

```nim
let source = pad.enableTextDrag("Copied text")
let image = newPixbuf(32, 24, 0x339966dd'u32)
source.setIcon(image) # Private native pixel copy now; caller may mutate/release image.
source.clearIcon()    # Future drags use GTK's actual default, including global defaults.
```

Configuration is UI-thread-only and never realizes/maps the pad or creates a drag
context/icon window. Empty images or disconnected/default tokens reject before
changing configuration; failed copy leaves the prior icon intact. Dropped tokens do
not revoke the site/icon. Sources still weakly own pads; the private Pixbuf copy does
not introduce widget retention. Destroy/disconnect releases source configuration;
old disconnected tokens cannot change icons on replacement sites. There is no icon
getter, alias to the caller's pixels, automatic decoding or clipboard publication.

During the SDK's **actual native drag-begin** handler, a nonempty copied icon is
applied through public `gtk_drag_set_icon_pixbuf` with GTK's source-site hotspot
`(-2,-2)`. A temporary native pixel pin spans reentrancy until GTK retains its own
reference. GTK owns actual context rendering/lifetime, choosing a composited RGBA
cursor or a native DND popup according to backend capabilities and size. No arbitrary
SDK icon size limit, private cursor/layout fields, cache reset or rendering simulation
is introduced. Native compositing, alpha, color rounding, masks, cursor decoration and
popup behavior remain GTK/backend semantics, not exact encoded-file preservation.

Updates/clear **after the SDK begin handler** affect future drags only. Native active
contexts keep their old pixel reference, even after clearing/disconnecting the source.
Clear simply leaves icon selection to GTK on later begins: it neither replaces the
current context icon nor calls a stock/default setter or rebuilds the source site.
In particular, a stock "gtk-dnd" substitute would ignore GTK's application-wide native
default override. Raw drag-begin/context/site handlers may override GTK behavior and
are outside SDK-owned icon configuration; do not mutate it via raw handlers.

Payload snapshots, MIME/targets, COPY validation, destination policies, exactly-once
native finish/delete=false, draining receivers and idle observations are unchanged.
Checked set/clear reject inside synchronous pure functions before pixel copying or
state changes. GTK calls, callbacks and final releases stay on the UI thread.
Custom widget icons, named/stock icons, custom hotspots, live context mutation and
model/editor drag sources remain separate; this is only copied source-pad icons.

`examples/controls.nim` uses a copied text source icon. `examples/desktop.nim` provides
copied sample/default controls for URI/binary pads. Hidden `tests/tgtk2dragicons.nim`
performs configuration/lifetime/purity only, with no realization or selections.
`nimble testMappedDragIcons` requires isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1,
**X11/XTEST/XFixes and GTK2 development headers**. Genuine drags for all source types
observe current cursor pixels via public XFixes and oversized native popup pixels via
public GTK toplevel/GDK drawable capture. Tests cover mutation/release, failed updates,
active/future update/reset and disconnect without simulated signals or private state.
The native cursor compositor rounds opaque channels down by one on this GTK backend;
the observation probe allows that one-unit visual tolerance, without changing pixels,
caches or outcomes. Two native copy/context-icon prototypes and pointer/signed-hotspot
ABI probes plus source guards accompany ARC/ORC and cross-target checks. Other platforms
receive semantic checks, not simulated native rendering claims. Trusted image requests
and pads are described above; private layout audits remain separate.

## Binary COPY-only drag/drop pads

Ordinary exact `DrawingArea`/`EventBox` pads support:

- `enableBinaryDrag(BinaryData)` or `enableBinaryDrag(mime, bytes)` returning
  `BinaryDragSource` with connected/disconnect and copied-value `.data` access/update.
- `onBinaryDrop(mime, fn, maxBytes = 16*1024*1024, accept: BinaryDropPredicate = nil)`
  returning `BinaryDropSite` with connected/disconnect/draining.
- `BinaryDrop` copied `.mime`, `.bytes`, original pad-local `.x/.y`, uint32 `.time`.

```nim
let payload = newBinaryData("application/vnd.example.sample", [0'u8, 255, 128, 0])
let source = sourcePad.enableBinaryDrag(payload)
let policy: BinaryDropPredicate = proc (value: BinaryDrop): bool =
  value.bytes.len > 0 # Copied-data-only application decision, no GTK or I/O.
let site = destinationPad.onBinaryDrop(payload.mime, proc (value: BinaryDrop) =
  echo(value.bytes.len), maxBytes = 4096, accept = policy)
source.data = newBinaryData(payload.mime, [1'u8]) # Later drags only.
```

MIME validation and source size bounds are the same conservative application subset
as binary clipboard data; default BinaryData is invalid. The source MIME is **fixed
per attachment**: data updates with another MIME reject atomically, without changing
native target lists or old data. Disconnect/reconfigure to use another target. Source
bytes are copied on construction and snapshotted per actual native drag-begin;
subsequent updates affect only future drags. Dropped tokens do not cancel sources or
destinations. No plain text/URI/image fallback, parser, encoding or automatic file use
is installed. Only COPY is advertised; selected action must be COPY at drop and at
receipt. No MOVE, source deletion or editor/model/private-site override is provided.

Only one native site per direction may own a pad. The other direction is independent;
text/URI/binary/image sites in the same direction conflict rather than overwrite each other.
Existing native target lists reject configuration. Public GTK cannot enumerate every
empty-target/proxy raw registration: do not preconfigure raw sites on SDK pads or
mutate their target lists/handlers while active or draining. No private registry,
realization, mapping, showing or reparenting is used by configuration.

A destination uses the same exact target/type/format-8 validator as binary requests.
maxBytes accepts 0..2147483646 and bounds application copying **before allocation**;
zero accepts only valid empty data. Valid empty succeeds by default; a predicate may
reject it. Wrong MIME/type/format, excess/missing data, unavailable replies, non-COPY
and canceled transfers never call acceptance or observation. Rejected data is not
partially delivered. The bound is not a total-memory budget covering native receipt/
INCR allocation, queued aggregate bytes, the additional predicate copy or retained
application values, nor a security sandbox against hostile owners. Opaque MIME/bytes are not format validation, file
permissions or authenticated application identity.

Optional acceptance is a fixed synchronous closure evaluated once before successful
native finish, over independently copied byte storage. Nil accepts otherwise valid
transport; false or an exception fails with no observation. The shared model-function
guard rejects checked handle access, clipboard work and mutable site operations;
exceptions restore the guard and are contained/reported. Ordinary final handle
releases defer outside pure computation. Do not block, pump events, open files, await
async work or call raw/unguarded GTK constructors inside the policy: this is a contract,
not whole-program interposition. Captured state is read at receipt time, not frozen.
Policy input can be retained/modified without altering the eventual observer's copy.

Each tracked selection finishes exactly once, **delete=false**, through the native
finish API. DEFAULT_DROP is not enabled. Accepted drops queue separate per-drop idle
observations only **after** finish; observers may reenter GTK, disconnect, destroy or
throw. Canceling queued observation releases captures/data but never rolls back a
completed transfer or repeats its policy. GTK2 X11 still treats XDND Finished as
success-like source drag-end regardless of its failure bit; that signal is not proof
of destination acceptance or application work. No synthetic source correction or
second finish is introduced; isolated tests inspect the actual public GDK outcome bit.

Disconnect/destruction clears observer/predicate captures immediately. Pending native
selection requests cannot be canceled: original context/pad and an independent
**unrealized same-screen receiver Window** remain pinned until actual reply/timeout,
then finish false without user code. This survives destroyed-pad signal removal;
GTK creates its own native IPC resource, not an implicitly realized user pad/receiver.
Inactive sites reserve the native target list until draining completes; binary/text/
URI replacement is blocked. Post-receipt cleanup uses its own idle widget/state pin.
Retry from a later event when draining is false, never a nested event pump. Active
sites hold no strong pad reference outside actual wire/cleanup work; controller
closures that capture handles still require explicit cancellation/destruction.

[examples/desktop.nim](../examples/desktop.nim) adds count-only binary source/drop
pads with a nonempty pure policy. Hidden `tests/tgtk2binarydrag.nim` tests unrealized
copies/fixed MIME/atomic invalid configuration/conflicts/lifetime/purity, with no
selections or input. `nimble testMappedBinaryDrag` requires isolated DISPLAY,
GTK2_TEST_VIRTUAL_DISPLAY=1 and X11/XTEST. Real local/foreign tests cover snapshots,
NUL/non-UTF-8/all-byte INCR payloads, exact/zero/exceeded bounds, wrong type/format,
text/MOVE/other-MIME/source-disconnected replies, fixed policy/copies/guards/errors,
reentrant observers, no DELETE, queued cancellation, delayed disconnect/destruction,
independent receivers and blocked replacement. Seven public native prototypes/four
callback signatures probe signed coordinates/gboolean and full unsigned info/time;
source guards pin finish, copy validation and scope. Other platforms receive semantic
checks, not simulated native drags. Trusted image requests are described above;
trusted image pads are also available; async acceptance stays separate.

## URI COPY-only drag/drop pads

`DrawingArea` and `EventBox` pads provide `enableUriDrag(UriList | openArray[string])`
and `onUriDrop(proc(value: UriDrop), accept: UriDropPredicate = nil)`. Only exact ordinary pad types are supported,
not editor/model/native private DnD sites or arbitrary subclasses. Source and
destination may share a pad; only one native site per direction is allowed. Text
and URI SDK sites cannot overwrite each other in that direction. Existing public
native target lists are rejected. GTK has no public registration query for every
empty-list/proxy raw site: do not preconfigure such sites on these pads or combine
raw site mutation with SDK ownership. No private registry inspection is guessed.
No widget is shown,
realized or reparented by configuration. Native UI operations/callbacks/final
releases stay on the UI thread and mutable site operations obey pure-function guards.

```nim
let source = sourcePad.enableUriDrag(["file:///tmp/a%20b", "urn:example:token"])
let site = destinationPad.onUriDrop(proc (value: UriDrop) =
  echo value.uris, " at ", value.x, ",", value.y) # Inspect only; never auto-open.
source.uris = newUriList(["urn:example:next-drag"])
# source.uris also accepts openArray[string]; its getter returns a copied sequence.
# site.disconnect() cancels observation; site.draining tells whether cleanup awaits a wire reply.
```

Source URI data is copied/validated before configuration or replacement, and
snapshotted at native **drag-begin**. Mid-drag changes affect only later drags.
Targets advertise only text/uri-list and only COPY; no plain-text fallback, DELETE,
MOVE semantics, custom drag icon or model/editor rebinding is installed. Disconnect
removes the source; outstanding native requests cannot extract a newer snapshot
through a disconnected source. Dropped source/drop tokens do not cancel sites.

The destination requires the actual selected action to be COPY at both drop and
receipt. It reuses public URI type/format/UTF-8/NUL/token checks and native comment/
line parsing. Valid empty URI lists succeed by default (a policy may reject them);
malformed/unavailable/wrong-type data
fails as a whole and emits no observation. Each tracked request is finished exactly
once with delete=false; DEFAULT_DROP is not set. Selected COPY alone does not imply
a valid URI reply. `UriDrop` contains copied uris, original pad-local x/y and uint32
native event time; no context, selection pointer or C vector escapes.

The first `onUriDrop` callback remains a **per-drop idle observation**. Optional
`accept` is a separate **synchronous pre-finish decision** over copied `UriDrop`
values. `UriDropPredicate` is a Nim closure returning bool, not a raw GTK signal or
GObject virtual method. Nil means accept any otherwise valid URI COPY transfer.
A non-nil predicate is invoked exactly once only after complete valid URI data and
COPY selection arrive; malformed/unavailable/canceled/text/MOVE drops never call
it. False or an exception completes failure and queues no observation. Exceptions
are contained/reported; the shared guard is restored before native completion.

```nim
let acceptNamespace: UriDropPredicate = proc (value: UriDrop): bool =
  if value.uris.len == 0: return false
  for uri in value.uris:
    if not uri.startsWith("urn:example:"): return false # import std/strutils
  true
let site = destinationPad.onUriDrop(proc (value: UriDrop) =
  echo(value.uris), accept = acceptNamespace)
```

This predicate uses the existing synchronous model-function guard: checked GTK
handle access, widget/clipboard operations, site mutation/disconnect and nested GUI
work are forbidden. Even getClipboard rejects **before** its atom/native lookup, and init/quit reject
before touching GTK runtime/main-loop state. This guard is not whole-program purity
or native-call interposition: unguarded constructors and raw calls are also forbidden
by contract, not safe ways to bypass the checked handle restrictions.
Ordinary last-handle releases are deferred to UI idle outside the pure computation.
Use only copied data and quick deterministic computation: no event pumping, blocking
I/O, async waits or raw GTK. This is an application contract, not a sandbox against
arbitrary Nim/FFI, and does not make untrusted application callbacks safe.

Input sequence storage is independent of the eventual observer's payload; copied
inputs may be retained, but never represent a live context/selection or permission
token. The callback identity is fixed per attachment; reassigning the caller's proc
variable does not replace it. Captured variables remain application state, read at
receipt time, not automatically frozen. Prefer immutable copied configuration.
Disconnect/drain/reattach to install another function; no mutable policy cache or
re-evaluation of already completed drops is introduced. Predicate captures are
released on disconnect/destruction even while wire pins continue to drain. An
executing callback retains its own local root through return. Dropped tokens alone
do not release attachment callbacks or cancel transfers; explicitly destroy GUI
owners whose closures capture their handles.

Native completion follows the decision and precedes observation; transport/policy
success is **not** full scheme/authority/file authorization or successful application
work. The observer runs only after acceptance and may then update UI, disconnect,
destroy or start other work. Canceling a queued observation does not undo the
completed transfer or repeat its predicate. Validate every later use independently.
Nothing is decoded, opened, launched or inserted.
GTK2's X11 source handler treats received XDND Finished as source success without
honoring its failure bit; `drag-end`/absence of `drag-failed` cannot prove destination
acceptance. The raw public gdk_drag_drop_succeeded getter can inspect a completed
GDK outcome when the backend/protocol supplies it; actual X11 tests use that bit
rather than GtkWidget's success-like source signal. It is not a portable application
acknowledgment or authorization. No synthetic correction, second finish or native
patch is introduced.

Disconnect or widget destruction promptly releases callback captures and queued
values. A completed transfer is not rolled back when its observation is canceled.
A pending native selection cannot be canceled: it drains to the actual reply/timeout,
then finishes false, without calling application code. Finishing prematurely can
retire the source before it answers, so the SDK does not do so. The independent wire
pin owns context, destination and a separate **unrealized receiver Window on the
same screen**. GTK's public drag_get_data creates its own native IPC resource, as
usual; the SDK never realizes/maps that receiver or the user's pad. Destroying the
pad clears its signals, but not the independent receiver. Raw drag-data-received
on the original pad is consequently not a second delivery interface for this API.

An inactive destination retains its native URI site/reservation while draining,
blocking both URI and text SDK replacement. Cleanup runs after native receipt (at
idle when necessary), with a separate widget/state pin; `site.connected` is false
immediately and `site.draining` stays true until cleanup. Retry configuration only
from a later event after draining becomes false, never with a nested event pump.
Do not replace target lists, unset native sites, disconnect handlers or destroy
SDK-owned receiver windows through raw APIs while a site is active/draining.
No private GTK bookkeeping, layout/cache repair or invented wire cancellation is used.

[examples/desktop.nim](../examples/desktop.nim) has URI COPY source/inspection pads
with an explicit nonempty urn:example:/https://example.invalid/ namespace policy.
It rejects file URIs for this inspection pad and never opens accepted URIs.
`tests/tgtk2uridrag.nim` covers unrealized configuration, copied/atomic values, type/
site conflicts, teardown/capture ownership and pure guards without requesting data,
claiming PRIMARY or synthesizing input. `nimble testMappedUriDrag` requires isolated
DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1 and X11/XTEST for real input. It tests actual
local/foreign XDND, begin snapshots/empty lists, malformed/text/MOVE/source-canceled
rejection, no DELETE, reentrant/throwing observations, queued cancellation and delayed
foreign replies surviving disconnect/destruction without reaching replacement sites.
Acceptance tests additionally cover true/false/empty/error/uncaught-guard outcomes,
fixed callback identity, independent retained/modified copies, pre-finish ordering,
GDK acceptance bits, deferred final releases, prompt policy-capture cleanup, and
no policy invocation after cancellation or for invalid data. Other platforms receive semantic checks, not simulated native drags. Native header
probes verify six public function prototypes, three widget callback signatures,
signed coordinates/booleans and full unsigned info/time payloads.

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

## Text completion and editable combo entries

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

The default policy remains **popup-only**: GTK performs normalized, case-insensitive
prefix matching and native popup rendering/navigation. minimumKeyLength accepts a
nonnegative gint count; popupCompletion, popupSingleMatch and popupSetWidth control
native popup policy. refilter() requires an attached entry and updates matching;
it is not a public force-popup method. Normal user editing triggers GTK's popup
timeout. gtk_entry_set_text (and entryText=) intentionally suppresses automatic
popup scheduling in GTK2; do not confuse programmatic replacement with typing.
Inline completion/selection are opt-in policies described below. Custom match
predicates and literal action rows are covered below. Arbitrary model columns,
markup providers and deeper IME integration remain separate work.

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
Changing the fixed model/column, inline policy or attachment through raw GTK is rejected on checked
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

### Custom completion matching

The expanded inputs example offers an explicitly labelled ASCII substring mode.
setMatch installs a short synchronous predicate on the **same fixed owned string
model**; it does not expose mutable GTK models, filtered popup positions, native
iterators or renderers.

```nim
import std/strutils
let connection = completion.setMatch(proc (input: CompletionMatchInput): bool =
  input.text.toLowerAscii.contains(input.key))
completion.refilter() # Explicit cache refresh; native typing also refreshes.
# Later:
completion.clearMatch() # Actual GTK default, not an SDK approximation.
completion.refilter()
```

CompletionMatchInput contains copied key/text strings and index in the source
suggestion list. GTK supplies key after compatibility decomposition and casefolding
(G_NORMALIZE_ALL then g_utf8_casefold), not the literal entry spelling. text is the
original literal suggestion, not pre-normalized. index is not a filtered popup row,
combo choice index or stable row reference. Copies remain usable after model or
controller teardown. If implementing Unicode matching, deliberately normalize the
suggestion consistently; toLowerAscii is only the example's declared ASCII policy,
not GTK's full Unicode default. No second undocumented SDK normalizer runs.

The predicate returns a row visibility decision **synchronously**. It may use copies
and ordinary application configuration, not live GTK handles, raw GTK calls, event
iteration, model mutation, controller close/disconnect or arbitrary owner teardown.
The shared synchronous model-function guard rejects checked handle access and
completion construction/close, as well as selection/inline/match disconnection.
Exceptions are caught and the affected row is rejected. Disconnected predicates
also reject rows; there is no implicit fallback to a guessed prefix algorithm.
As with model functions, last ordinary SDK native releases during the predicate
wait for UI idle so native traversal is not interrupted. This is not a sandbox:
captured custom owners/destructors and raw calls must obey the contract too.

The native callback copies its function and input before entering that guard. Native
callback-data pins are independent of public tokens/handles. GTK destroys the old
callback data **before** installing its replacement; separate slots, a native owner
pin and a replacement guard ensure old cleanup cannot invalidate the new slot or
recursively close/reconfigure the controller. Native finalization releases captures.
Replacing the fixed item list updates the slot's retained model before GTK may
match the new rows; stale iterators never escape into application code.

CompletionMatchConnection has connected and idempotent disconnect. It does not own
the controller; dropping a token does not disconnect. matchConnection() returns the
current token or an empty inactive one. customMatching reports whether an SDK custom
bridge is installed, **even after its token disconnects**. Disconnect releases user
captures immediately but leaves a no-match native bridge until clearMatch restores
GTK's exact default (NULL native function). Replacement, clearMatch, close and native
finalization invalidate old tokens and release their captures. An old token cannot
disconnect a replacement. A matcher capturing its own completion/entry can still
create an ownership cycle; explicitly clear/close before abandoning it.

The matcher belongs to the controller, not an attachment observation session: it
survives detach/password hiding and may be reused on reattachment. Native entry
ownership retains it even after public aliases disappear. Matching can also occur
when replacing a model with a cached native key, so do not assume callbacks only
occur during typing or while the popup is mapped. Checked access detects a raw
replacement of the installed function via its destroy notification; close remains
a cleanup path. Mixing raw configuration with the fixed SDK wrapper is unsupported.

setMatch and clearMatch cancel queued SDK commits/provisional/selection observations
but **do not automatically refilter GTK's cached rows**. Call refilter after changing
a predicate or captured configuration, resetting or disconnecting it; normal native
editing/explicit insertPrefix also refreshes. A disconnected token cannot refresh
its non-owned controller. Old cached popup rows can remain selectable until refresh:
matching is presentation, not authorization or a privacy filter. Do not populate the
suggestion model with data the application is not entitled to expose.

A custom predicate changes only which suggestions are visible. Popup selection still
uses deferred onSelected commits and original source indices. Inline common-prefix
computation remains GTK's literal starts-with algorithm over accepted rows; substring
or fuzzy matches do not automatically produce a new kind of inline suffix, highlight
or replacement span. Native previews/accept/reject behavior and the documented
Unicode preview/history limitations remain unchanged. Already-inserted text and
native historical prefix state are not rolled back by predicate changes.

Hidden tests/tgtk2completionmatch.nim covers normalized/copied inputs, source indices,
model replacement, explicit refresh, token/capture/native lifetime, pure-function
access rejection, exception fallback, delayed native release and replacement cleanup
reentrancy. C probes check native match/setter/destroy-notify pointer/cdecl/gboolean
ABI. testMappedCompletionMatch requires an explicitly isolated display and
GTK2_TEST_VIRTUAL_DISPLAY=1; Unix X11 XTEST verifies non-prefix popup choices, source
indices after model changes, exact native default reset and safe observer teardown.
Normal tests never map popups or manipulate desktop selection state.

### Completion action rows

Configure owned literal UTF-8 action labels independently of suggestions:

```nim
let completion = newEntryCompletion(["alpha", "alpine"],
  actions = ["Search current text", "Create new item"])
entry.completion = completion
let connection = completion.onActionActivated(proc (value: CompletionAction) =
  echo value.index, ": ", value.text, " — entry: ", value.key)
```

CompletionAction contains copied index in the **action list**, text (literal label)
and key (entry text at native emission). It never contains a filtered popup or
suggestion index. key is not the matcher’s normalized key or a promised original
query: GTK keyboard navigation restores its historical prefix on entering actions,
whereas clicking an action may leave a previously previewed entry value. The SDK
reports native text and does not invent a restoration. Labels, including markup-like
strings, are text, not Pango markup. Empty/duplicate labels are permitted; indices
disambiguate them. actions() returns an owned list. The inputs example configures
free-text/reset actions and performs any entry changes explicitly in application code.

setActions replaces the list, clearActions empties it. Both validate/copy before
native mutation and are **detached-only**, even if an attached popup appears closed.
GTK caches a combined suggestion/action navigation index, with no public reset or
popup-state query. GTK delete_action also uses an unchecked nth-child result: the
SDK only deletes its own known in-range rows, in descending order. Native mutation
is pinned/guarded, and the SDK never inspects private structures, fakes navigation,
rebinds the suggestion model or silently detaches to reset native state.

Prefer configuring once before attachment. If application policy requires a new
list, explicitly detach(), setActions(...), then attach and reconnect observation
listeners as a new session. Native detachment cancels completion sources and pops
down its popup through the public GTK API. The next native popup initializes its
navigation index normally; historical prefix state is not artificially reset.
Raw insertion/deletion of actions on an SDK completion is unsupported and cannot
be reliably detected through public GTK getters. Use the SDK exclusively for rows.

onActionActivated returns a non-owning CompletionActionConnection with connected
and idempotent disconnect. The signal handler only checks/copies payloads and queues
work. Application callbacks run at UI idle **after** the native key handler frees
its prefix or the mouse handler pops down its popup. No action label is inserted
into the entry and onSelected is not emitted. App code decides whether to edit the
entry, open a dialog, detach, replace actions, close the completion or destroy its
window. Exceptions are contained independently for each callback.

Delivery preserves each valid native emission in order; it is not coalesced. Only
listeners active at emission are included. A later subscription does not receive
old queued activations. Before each listener, the dispatcher rechecks generation,
attachment, visibility, editability and exact emission-time entry text. Edits,
read-only/password changes, suggestion replacement/selection, refiltering, match,
inline or popup/minimum-length policy setters, detach/close/destruction cancel stale
queued actions. If the
first callback changes text or closes/detaches, later listeners/emissions are
suppressed. Disconnect releases that listener's captures promptly, including while
work remains queued; self-disconnection is safe. Matching predicates cannot access
actions/configuration or disconnect action observers inside the synchronous guard.

Dropping a token does not disconnect. Native entry ownership can retain the
completion/listeners after public aliases disappear. Actions themselves belong to
the controller and survive detach; action **listeners** belong to the attachment
observation session and disconnect on detach, password hiding, owner destruction
or close. Native finalization releases captures. Self-capturing listeners can form
cycles; explicitly disconnect/close before abandoning them. Temporary native pins
also protect detach cleanup if a capture destructor drops the last public alias.

Action rows are not matched by setMatch: custom predicates filter suggestions only.
Actions may open an action-only popup even with no suggestion matches; popup policy
and native minimum-key-length still apply. Native arrow/page/Enter/mouse navigation
and inline previews are preserved. Actions are presentation, not authorization:
validate permissions/current state in application policy, not by assuming a row was
hidden. Arbitrary renderers, markup actions and deeper IME/provider work are separate.

Hidden tests/tgtk2completionactions.nim cover atomic labels, detached replacement,
copied emissions, cancellation, per-listener staleness, disconnect/capture lifetime,
exception/reentrancy and synchronous matcher guards without mapping windows. C probes
check signed gint/cdecl/data and insertion/deletion prototypes. The isolated opt-in
testMappedCompletionActions uses XTEST keyboard/mouse input for action-only popups,
inline suggestion-to-action navigation, rejected live mutation, explicit new sessions
and safe teardown beyond both native emitters. It requires GTK2_TEST_VIRTUAL_DISPLAY=1.

### Inline common prefix and popup selection

inlineCompletion and inlineSelection default false and can be configured before
attachment. inlineCompletion enables native common-prefix insertion with a selected
new suffix; inlineSelection enables native tentative row preview while navigating
the popup. They are independent: prefix completion works with popupCompletion=false,
while popup previews require an actual native popup. Neither changes the fixed
owned string model. The expanded inputs example provides separate checkboxes.

```nim
let completion = newEntryCompletion(["alphabet", "alphanumeric"])
completion.inlineCompletion = true
completion.inlineSelection = true
entry.completion = completion
completion.onInlineChanged(proc (value: CompletionInlineState) =
  echo value.kind, ": ", value.text, " suffix ", value.first, "..", value.last)
```

Native insert-prefix remains in charge of inserting/selecting the common suffix
and setting GTK's internal acceptance flag. cursor-on-match retains native popup
preview behavior. Down/Up/Page keys navigate; Escape restores GTK's original key;
Right/Left/Tab retain/position the native tentative text according to GTK, and
Return uses the existing deferred match-selected commit. A preview/common prefix
is not an onSelected event. onSelected still reports explicit popup selection,
not every way to accept text. This is native GTK behavior, not an SDK suggestion
engine, custom matcher or keyboard/IME reimplementation.

GTK's popup matching normalizes/casefolds, but its common-prefix computation
requires actual case-sensitive string prefixes; the SDK does not invent a different
case-preserving algorithm. minimumKeyLength retains GTK's popup semantics and is
not an extra SDK inline threshold. Programmatic text assignment suppresses native
popup scheduling, but with inlineCompletion it may still schedule a native prefix
check. insertPrefix() explicitly refilters and requests native prefix insertion;
it requires an attached editable entry with inlineCompletion enabled. It pins the
native completion throughout the call. Normal typed insertion schedules GTK's own
high-priority prefix check; no nested event iteration is introduced.

#### Safe callback timing

Inline GTK defaults mutate entry text synchronously, then continue unblocking entry
handlers, updating completion fields or restoring popup state. Letting application
changed callbacks tear down this state inside the emitter is unsafe. Consequently,
while **either inline policy is configured on an attached entry**, SDK Entry.onChanged
and Entry.onActivate observations are delivered at UI idle instead of synchronously.
For an editable ComboBoxText, its inherited ComboBox.onChanged observations defer
as well. This dynamic policy also covers connections installed before attaching or
enabling completion. Ordinary entries and popup-only completion retain their prior
synchronous timing.

Changed observations coalesce to one no-argument callback reading current state;
activation observations retain per-emission delivery. Disconnection or widget
teardown cancels queued callbacks and releases captures/source pins. Once queued,
an observation stays deferred even if inline policy is disabled/detached before
its delivery; later synchronous callbacks cannot overtake it. These Entry/Combo
observations belong to their widget, not to the completion, and are not automatically
removed by detach. ComboBoxText.onTextChanged already provides copied idle state.

Native matching/default insertion/navigation continue normally, but **no SDK entry/
combo changed/activate application closure runs inside those native emitters**.
Raw signal handlers and synchronous input/drawing/decision callbacks retain their
native restrictions: do not destroy/reconfigure entries or pump events from a raw
inline signal, raw changed callback or a synchronous key handler whose native
completion chain will continue. This checked callback policy is not a sandbox.

onInlineChanged returns a CompletionInlineConnection with connected/idempotent
disconnect; dropping it does not disconnect. Its CompletionInlineState contains
kind (inlinePrefix/inlinePreview), copied key/text, source suggestion index (-1 for
common prefix), and current native selection first/last/cursor character offsets.
At UI idle the bridge collects entry state after the native emitter, then queues
a copied coalesced application observation. It is a provisional snapshot, not a
veto/acceptance hook, stable row handle or guaranteed current selection at later
delivery. No model pointer/iterator/widget is exposed. A later text edit, model
replacement/refilter, readonly transition, policy change, selection commit, detach,
hiding/destruction or close cancels stale inline observations. Callbacks may close,
detach, edit, replace models or destroy windows safely; exceptions are contained.

#### Readonly, lifecycle and native limitations

Read-only entries suspend both effective native inline flags while retaining the
requested policies returned by the SDK getters. Making the entry editable restores
them; pending commits/inline observations are cancelled at each transition.
insertPrefix rejects readonly targets. Password entries still cannot attach, and
hiding text detaches, cancels work and releases both selection/inline observers.
The same rules cover the ordinary public entry of an editable ComboBoxText;
SpinButton/private entry subclasses remain rejected. Reattach/reconnect for a new
observation session. Explicit close/destroy still breaks self-capturing observer
cycles. Calls, native final releases and observers remain UI-thread ARC/ORC work.

completionPrefix() copies CompletionPrefix(available,text) from GTK's borrowed
get_completion_prefix result; nil is distinct from an available empty key. This
is GTK's **original popup-preview key**, not the computed common prefix. GTK may
retain it after model/policy/attachment changes; GTK2 has no public reset. Cancelling
SDK work does not undo already-inserted native text or erase native history. No
private-field access, model rebinding or fake-input reset is used. Use normal native
accept/reject navigation or a genuinely new controller when a new history is needed.

GTK 2.24.33 also computes popup-preview suffix start with strlen(original_key) but
passes it to a character-offset API. A multibyte key can therefore select too little
of the preview (e.g. λ starts the selection at character 2 rather than 1). Common
prefix insertion uses Unicode lengths correctly. SDK snapshots report the actual
native character offsets, not a fabricated correction. The optional, **not applied**
[gtk2-completion-unicode-preview.patch](../patches/gtk2-completion-unicode-preview.patch)
changes the native preview start to g_utf8_strlen. Installed libraries are unchanged;
normal code does not suppress warnings or patch/rewrite native state at runtime.
The isolated mapped suite diagnoses this case and supports patched/unpatched GTK.

Hidden tests/tgtk2inlinecompletion.nim checks Unicode prefix selection, readonly/
password/ordinary-entry policy, pre-existing entry/combo connections, safe teardown
from changed/inline callbacks, cancellation and disconnection without mapping
windows. Native C probes verify insert-prefix/cursor-on-match and borrowed prefix
ABI. testMappedInlineCompletion uses an explicitly isolated display and
GTK2_TEST_VIRTUAL_DISPLAY=1; Unix X11 XTEST checks typed suffix replacement, native
preview/Escape/Right/Tab/Return, activation/combo destruction and Unicode offsets.

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
ComboBox.onChanged remains synchronous except while its entry has configured SDK
inline completion/selection or during checked maxLength mutation (below);
use onTextChanged for consistently copied,
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

### Entry Unicode cursor and selection

Entry exposes characterCount, cursorOffset, hasSelection, selectionBounds and
selectedText. Coordinates count Unicode **code points**, not UTF-8 bytes, grapheme
clusters or pixels. For example λ🙂 has length two; a decomposed accented letter
can occupy two positions. Native keyboard movement still follows GTK/Pango cursor
rules and may move across a grapheme rather than exactly one code point.

```nim
let entry = newEntry("Aλ🙂e\u0301Z")
entry.selectRange(5, 1) # anchor 5, active cursor 1: reverse selection.
let state = entry.selectionBounds
assert state.first == 1 and state.last == 5 # Ordered half-open bounds.
assert state.anchor == 5 and state.cursor == 1
entry.cursorOffset = 2 # Collapse at code-point offset 2.
entry.clearSelection() # Collapse at the current active cursor.
entry.selectAll()
```

EntrySelection is a copied value containing hasSelection, ordered first/last and
oriented anchor/cursor. Without a selection all four offsets equal the cursor.
Snapshots and selectedText copies do not retain the widget and survive its teardown;
they are historical values, not live marks. selectedText copies GTK's allocated
GtkEditable.get_chars result and frees that allocation. A visible entry without a
selection returns an empty string. Selection-only moves do not emit text onChanged;
use the copied idle observations below. The inputs example observes keyboard-driven
selection and also offers a read-only Inspect button.

selectRange(anchor,cursor) and cursorOffset= accept only 0..characterCount, including
the end position. Both endpoints are checked before any mutation, callback-work
cancellation or ownership change; invalid/negative/past-end positions raise ValueError.
Byte coordinates are never converted or inferred. There is no public -1 sentinel
or silent bounds clamping. Reversed
ranges are intentional; clearSelection keeps the active endpoint. selectAll uses
the checked whole range. Ordinary entries, protected editable ComboBoxText children
and inherited SpinButton GtkEditable text support these operations. Combo children
remain protected against independent destroy/reparent; selection does not commit a
combo choice or change activeIndex. Destroyed handles reject access.

Read-only entries may move/select/copy visible selected text without editing it.
Password entries allow coordinate snapshots and movement, but selectedText raises
ValueError even for an empty selection: this API never silently copies selected
password plaintext. It is not a security sandbox (explicit entry.text still exists).
Native password PRIMARY replies use GTK's display text, not this getter; see the
concealed-text section for blank-mask and password-hint privacy limitations.

**Realized selections can own PRIMARY, even when the widget/window is unmapped.**
GTK returns before clipboard work only when the entry is unrealized. Selecting an
unrealized entry and later realizing it can also claim PRIMARY. Public select_region
performs native ownership updates; all these explicit range/collapse helpers use it.
A collapsed cursor/clearSelection releases PRIMARY only when GTK says this entry
owns it, and leaves other owners untouched. This differs from raw set_position,
which does not update PRIMARY in GTK2.24. No SDK clipboard emulation, unconditional
clear, ownership suppression or window realization is performed. Native ownership
loss/refusal may itself collapse a selection; inspect the actual snapshot afterward.
Do not use these APIs on realized desktop widgets if selection ownership is unwanted.

Entry.focus preserves **direction** as well as bounds across GTK's select-all-on-focus
behavior, restoring anchor/cursor through select_region. It pins the native widget
and its state during focus/cleanup and skips restoration after destruction or when
an endpoint no longer fits native focus-updated text. Focus may itself temporarily
claim/change PRIMARY under GTK policy; it is not an ownership-neutral operation.
The generic Widget.focus still has ordinary native focus behavior.

Valid selection mutations/focus cancel queued SDK completion commits, action and
provisional/selection observations before proceeding; invalid ranges cancel nothing.
Getters have no such side effects. These operations do **not** hide/rebind the popup,
accept an inline preview, undo inserted text, cancel native completion timers or
reset GTK's historical prefix. Native selection/focus still performs GTK's normal
IM-context reset behavior; this is not a separate preedit/IME control API.
Future native edits/selection can still complete,
and Escape after a programmatic cursor move can restore the native preview prefix.
All checked getters/mutators are forbidden in synchronous model/match functions;
computations on an already copied EntrySelection are fine.

Hidden tests/tgtk2entryselection.nim assert entries remain unrealized before/after
selection/focus and event draining: no windows, clipboard ownership or selection
requests. They cover Unicode/direction/copies/atomicity, read-only/password, combo
and SpinButton behavior, destruction, completion cancellation and purity guards.
C probes check signed gint outputs, gboolean and cursor/range/get_chars prototypes.
The opt-in testMappedEntrySelection requires GTK2_TEST_VIRTUAL_DISPLAY=1 on an
isolated display. Unix X11 tests use real Shift-Left/focus/preview keys and explicitly
exercise PRIMARY ownership, preserving another owner, masked password replies and
combo cleanup. Never run those tests on an ordinary desktop.

### Entry cursor/selection observations

```nim
let connection = entry.onSelectionChanged(
  (proc (value: EntrySelection) =
    echo value.anchor, " -> ", value.cursor), initial = true)
# Later, if the entry itself is not being destroyed:
connection.disconnect()
```

onSelectionChanged observes the same copied EntrySelection value described above,
including direction and collapsed cursor moves. It works on ordinary Entry,
protected editable combo children and inherited SpinButton text. No selected text,
password text, character count, native event or widget reference is in the payload.
A snapshot remains usable after its widget is destroyed. Password/read-only entries
may be observed; coordinate changes are not authorization or permission to extract
password text. Existing selectedText safeguards are unchanged.

Delivery is **asynchronous final-state**, not one callback per key/notification.
GTK freezes/thaws paired cursor-position/selection-bound notifications inside its
position setter, then continues adjustment/recompute and PRIMARY updates. Each
native handler only schedules one idle source. That source samples the final public
bounds/cursor, deduplicates against the last delivered (or registration) snapshot,
and then calls the application after normal native traversal. A burst becomes one
value; a roundtrip back to the previous coordinates before idle delivers nothing.
Equal coordinates with different text do not trigger delivery: observe text changes
separately with onChanged/onTextChanged. Native keyboard grapheme rules and the
actual native Unicode-preview offsets remain unchanged.

There is no initial callback by default. initial=true requests an **idle** first
sample, even if unchanged; intervening changes coalesce into that sample. Nothing
runs synchronously on registration or inside the notify/PRIMARY/completion emitter.
Each connection samples independently. If an earlier observer changes the entry,
a later observer can see its newer final state; this is not a frozen global event
batch. User edits from a callback schedule another non-nested idle delivery if the
coordinates change. Avoid feedback loops and do not pump nested GTK loops during
native operations; deferral is not a sandbox for raw reentrant event iteration.

EntrySelectionConnection has a cheap connected query and idempotent disconnect.
Dropping a token does not disconnect. The token/source retain callback data, **not
the widget**. Each native signal closure and queued source has an independent data
pin. A native parent can keep the entry/listener alive after public entry aliases
disappear; conversely retaining a token or pending initial source cannot keep an
unparented entry alive. Owner destruction/finalization cancels pending work and
releases captures; combo destruction invalidates its child observers too.

Explicit disconnect cancels queued work, removes all three hooks, prunes live
shared-state bookkeeping and releases captures promptly. Temporary data/native pins
protect teardown if a capture destructor drops the last public entry alias. Native
closure-finalization cleanup never dereferences or refs its weak widget; losing a
native hook invalidates the whole observation, leaving any remaining hooks inert
until native cleanup. No weak-pointer resurrection, private GTK field access or
ownership-suppression workaround is used. A function already executing keeps its
local closure copy through return, so self-disconnect/owner destruction is safe.
Exceptions are caught without disabling subsequent valid observations. Capturing
custom owners/destructors must still obey UI-thread and teardown rules.

Unlike completion-session observers, this observation belongs to the **entry**:
completion detach/close/replacement does not end it. It can observe common-prefix
selection, popup preview, native PRIMARY loss and selection-helper/focus changes;
it neither cancels completion work itself nor accepts/resets native history.
Application callbacks may safely close completion or destroy the owner at idle.
Registration/disconnect are forbidden inside synchronous model/match functions;
already copied EntrySelection values and connected's plain state flag are ordinary
non-GTK data. Self-capturing GUI closures can still form cycles; explicitly disconnect
or destroy their widget tree before abandoning it.

Observing alone never realizes a widget, claims PRIMARY or issues selection requests.
Hidden tests/tgtk2entryobservations.nim assert unrealized state and cover pairing,
initial/dedup/reentrant edits, password/readonly, text-only changes, native parent
ownership, token/source non-ownership, prompt disconnect/destruction/capture cleanup,
combo/SpinButton, completion and purity guards. Native probes check notify's
GObject/GParamSpec/userdata and GClosureNotify cdecl ABI. The opt-in isolated
testMappedEntryObservations requires GTK2_TEST_VIRTUAL_DISPLAY=1; Unix X11 XTEST
covers Shift-Left, reverse focus roundtrips, PRIMARY loss with owner teardown and
completion-preview teardown beyond the native emitters. Never run it on a desktop.

### Entry limits and presentation policy

Entry and inherited SpinButton/protected editable combo entries expose:

- maxLength: checked 0..65535 code points; 0 removes the application maximum, not
  GTK's underlying buffer capacity limit. Lowering it immediately truncates text.
- widthChars: -1 restores the native default request; 0..high(gint) requests an
  approximate character width. This is a size request, not capacity or pixel width;
  font metrics and container packing still determine allocation.
- alignment: finite 0..1, passed as native gfloat and returned as float64. Zero/one
  mean left/right in LTR and reverse under native RTL rules. It affects short-text
  positioning, not text direction or character order; getters may reflect float32
  rounding. NaN/infinity/out-of-range values raise rather than native clamping.
- activatesDefault: a native gboolean policy controlling the entry's default
  activate handler. False does not disable onActivate; true does not choose/create
  a default button, override its sensitivity or authorize an operation.

```nim
entry.maxLength = 20
entry.widthChars = 24
entry.alignment = 0.5
entry.activatesDefault = true # Only if the host's actual default policy is wanted.
```

The inputs example offers max/width/alignment/default controls. Its ordinary window
has **no implicit default**, deliberately labelled as such. The dialogs example
instead configures defaultResponse and enables activatesDefault, replacing its old
manual onActivate/response simulation with GTK's actual default response behavior.
No global accelerators, fake Return event, shortcut remapping or synthesized click
is installed. A sensitive configured default is still required. Applications decide
whether Return should submit and must perform their own permission/validation checks.

maxLength counts Unicode code points, not UTF-8 bytes or grapheme clusters; truncation
can split a decomposed accent sequence, but not a UTF-8 code point. The stock GTK2.24
EntryBuffer also caps allocation at GTK_ENTRY_BUFFER_MAX_SIZE (65535 bytes including
NUL), leaving at most 65534 UTF-8 text bytes. Multibyte text can hit this ceiling
before the configured character count. Zero and 65535 therefore do **not** promise
an arbitrarily long/unlimited string, even though the latter is a valid policy value.
The SDK delegates storage/truncation to GTK rather than simulating a larger buffer.
Invalid limits/width/alignment validate before any mutation or queued-work cancellation.

These are programmatic GTK policies. Read-only/password text may still be truncated
by an explicit maxLength assignment, just as text= can replace it; selectedText still
rejects password extraction. SpinButton truncation changes displayed text, not a
validated numeric transaction or an immediate adjustment update. Later native spin
activation/focus/formatting can parse/reformat it. Shared/custom raw buffers, undo,
input validators and IME/preedit transactions are not added by these properties.

**GTK's buffer setter deletes/emits changed before assigning its new max-length.**
During a checked maxLength assignment the SDK pins the entry and any direct combo
parent and temporarily defers SDK Entry changed/activate and parent ComboBox changed
observations, including pre-existing connections. Changed emissions coalesce; queued
observations remain deferred until their idle delivery, so they see the committed
new limit and cannot close/reconfigure the buffer mid-setter. SDK entry selection
and combo onTextChanged observations already run at idle. Disconnect/destruction
cancels pending captures; exceptions remain contained. Ordinary entry/combo callback
timing outside this scope or existing inline policy is unchanged. This is not a
sandbox for raw synchronous notify/buffer handlers or arbitrary custom destructors.

All four property setters pin their native entry through native notifications and
cleanup. Truncation may update cursor/selection and native PRIMARY ownership on
realized entries, just like other native text edits; observation does not suppress
those effects. Valid maxLength assignments also invalidate queued SDK completion commits,
actions and provisional/selection observations, even without truncation; invalid
assignments do not. Presentation/default setters do not cancel completion. None
silently rebinds/detaches its model, resets native prefix state, rewrites suggestions
or implements an atomic text validation/rollback. Coordinate observations report
actual final GTK positions after truncation.

Future text assignment, insertion, paste and completion still use GTK's native limit.
A suggestion longer than the limit is **not automatically filtered**: GTK can truncate
its inserted text; the existing deferred completion commit's exact-text check then
suppresses onSelected rather than falsely reporting a full successful choice. The
partial native text can remain and normal text/coordinate observations can report it.
Filter suggestions or choose a suitable limit in application policy if partial text
is unacceptable. No hidden SDK all-or-nothing edit or guessed numeric validator runs.

Raw gtk_entry_set_alignment now takes PEntry (not PWidget) and get_alignment returns
gfloat. Obsolete activates_default/set_activates_default uint bitfield helpers are
removed, without a shim; raw callers use get_activates_default and the native
set_activates_default(PEntry,gboolean). ABI-required GtkEntry storage remains, but
no ergonomic property uses guessed private flag offsets.

Hidden tests/tgtk2entrypolicy.nim keep widgets unrealized: Unicode and byte-ceiling
behavior, atomic failures, callbacks seeing committed limits, reentrant/destroy/
disconnect cleanup, read-only/password/combo/SpinButton, completion cancellation,
pure-function rejection and native pins even when a raw notify drops the final alias.
C probes check all eight prototypes plus gfloat/gboolean argument/return ABI.
The isolated opt-in testMappedEntryPolicy requires GTK2_TEST_VIRTUAL_DISPLAY=1;
Unix X11 XTEST covers actual Return/default sensitivity, typed Unicode length limits,
long completion truncation and mapped combo observer teardown past the buffer setter.
Normal tests never realize entries, own PRIMARY, request selections or fake input.

### Entry icons and deferred icon events

```nim
entry.setIconName(iconPrimary, "edit-find")
entry.setIcon(iconSecondary, newPixbuf(16, 16, 0x3388ffff'u32))
entry.setIconTooltip(iconSecondary, "Plain text: <b>not markup</b>")
entry.setIconSensitive(iconSecondary, true)
entry.setIconActivatable(iconSecondary, true)
let connection = entry.onIconEvent(proc (value: EntryIconEvent) =
  if value.position == iconSecondary and value.event.kind == buttonPress and
      value.event.button == 1:
    entry.text = "") # Explicit application policy, not a native/synthesized click.
```

EntryIconPosition is iconPrimary/iconSecondary, logical native positions (not
hard-coded left/right under RTL). All position arguments are checked before native
calls. setIcon refs a Pixbuf through GTK; it is not a deep pixel copy. Passing an
empty Pixbuf, or clearIcon, removes the image. setIconName copies a validated nonempty
UTF-8 icon name; use clearIcon rather than an empty name. Named-icon theme lookup,
missing-image fallback and menu-icon sizing remain GTK's behavior. The expanded
inputs example uses native named search/clear icons and explicit press policy.

iconStorage reports native ImageStorage. iconName returns an owned copied name,
empty for no image and raises for a non-name storage kind. iconPixbuf returns an
owning reference to the rendered native pixbuf for **any** storage, including named
icons, or an empty Pixbuf. It remains alive after replacement/entry destruction,
but is not an immutable rendering snapshot: copy() it for independent pixels.
No private icon-info records, child widgets or native event windows escape through
the ergonomic API. Raw entry_get_icon_window is the public GTK2.20 API used by
isolated geometry tests, not private-structure access or a GTK3 area workaround.

iconSensitive/iconActivatable inspect native per-position flags; their set methods
retain GTK's defaults and policy. GTK-created icon info defaults to sensitive and
activatable, while queries on never-configured empty positions may differ. Clearing
an image does **not** reset its native tooltip or policy; configure them explicitly.
setIconTooltip takes plain validated UTF-8 and GTK escapes it. Empty text removes it.
iconTooltip copies/frees GTK's transfer-full allocated text; iconName is borrowed
natively and copied, while pixbuf is borrowed and ref'd. Generic widget tooltip/
has-tooltip configuration can suppress icon tooltips under normal GTK rules.

onIconEvent returns a non-owning EntryIconConnection (connected/idempotent disconnect).
The payload is EntryIconEvent(position,event), where event is the existing copied
ButtonEvent with press/double/triple/release kind, uint32 button/time, modifiers and
local/root coordinates. Local coordinates are relative to the **icon GdkWindow**,
not the entry allocation. There is no borrowed GdkEvent/window/pixbuf or entry text
in the payload, including on password entries. Read-only/password entries may have
active icons; these events do not authorize editing or password extraction.

These are native **press/release observations, not a clicked/activated command**.
GTK may report non-left buttons, multi-press kinds, or a release outside the original
icon bounds. A release need not have a preceding SDK-observed press (for example,
after disconnection/reconfiguration). Do not infer an inside-release gesture or
privilege from receiving it; application policy chooses a gesture. The demo uses a
left press explicitly. No button click, Return, text mutation, preview acceptance,
drag source or default response is synthesized, and no native signal is consumed.

Native handlers only validate/copy and queue, never call application code during
GTK's icon-state/window traversal. UI-idle delivery preserves each emission in order,
without coalescing, to listeners active at emission; later subscribers do not receive
old events. Before each listener it checks owner lifetime, per-position generation,
nonempty icon storage, effective widget sensitivity, per-icon sensitivity/
activatability and public native icon-window viewability when realized. An SDK image/name/tooltip/policy mutation invalidates queued events
for that position, even a same-value assignment. The other position is unaffected.
An earlier callback replacing/disabling/clearing an icon suppresses later listeners
and stale queued events for it. Hiding/unmapping/destroying the entry cancels queued events for
both positions. Text edits, readonly/password changes and completion attachment
changes alone do not cancel icon observations; no text is copied or authenticated.
Ancestor sensitivity/viewability are final-state checks, not a record of every
transient ancestor change. GTK2 can leave child widget mapped flags set under a
hidden ancestor; the SDK queries public gdk_window_is_viewable, not private flags.

Each metadata/native-hook/source pin is independent of widget ownership. Retaining
a token or queued source does not itself retain an unparented entry; a native parent
can retain its callbacks after public aliases disappear. Disconnect promptly releases
that listener's captures, even with pending records; dropping a token does not
disconnect. Destroy/finalization clears all callbacks and pending work without
ref'ing a finalizing widget. Configuration pins its native entry across notifications
and cleanup and rejects recursive SDK icon configuration on an existing bridge.
Self-disconnect, widget/combo destruction and icon replacement from a callback are
safe; exceptions are contained. Self-capturing GUI functions can still cycle: destroy
their tree or disconnect explicitly. Checked configuration/getters/disconnect are
forbidden in synchronous model/match functions. Raw hook/storage mutations are
unsupported: public final-state checks cannot reliably identify same-kind raw image
replacement, and raw/custom destructors must obey UI-thread/reentrancy rules.

Hidden tests/tgtk2entryicons.nim keep widgets unrealized and cover reference/copy
ownership, name/storage replacement, literal tooltips, atomic validation, ordered
button copies, generation cancellation, policy, password/readonly, combo destruction,
non-owning token/source, capture cleanup and pure-function guards. C probes check
native icon enum width/values, twelve icon prototypes and GdkEvent/button fields.
The opt-in isolated testMappedEntryIcons requires GTK2_TEST_VIRTUAL_DISPLAY=1;
Unix X11 XTEST verifies both real icon windows, inert flags, no implicit text change,
press-time replacement and release-time combo teardown. Hidden tests do not map,
claim PRIMARY, issue selection requests or manipulate desktop input. Stock/GIcon
providers, icon DnD, markup tooltips and custom renderers remain separate work.

### Entry editing and concealed-text presentation

Entry exposes native overwriteMode and hasFrame boolean policies, plus a checked
Unicode invisibleChar, invisibleCharSet and unsetInvisibleChar(). They also work
on protected editable ComboBoxText entries and inherited SpinButton text.

```nim
entry.overwriteMode = true
entry.hasFrame = false
entry.textVisible = false
entry.invisibleChar = 0x2022'u32 # Explicit bullet scalar; not a string/byte.
assert entry.invisibleCharSet
entry.unsetInvisibleChar()      # Restore GTK's font-selected default, not '*'.
```

Bool setters call public native APIs with gboolean; they do not write GtkEntry
flags. All setters/unset pin the native entry through notification/recompute, and
the existing textVisible setter now does too. Raw unsigned overwrite_mode/
set_overwrite_mode and has_frame/set_has_frame bitfield helpers are removed without
shims. Native get_overwrite_mode/set_overwrite_mode(PEntry,gboolean), get_has_frame/
set_has_frame(PEntry,gboolean), and unset_invisible_char are the supported path;
ABI storage remains unchanged. Corresponding native scalar/prototype probes cover
signed C boolean and 32-bit gunichar conventions.

Overwrite changes GTK's **typed/IME commit path**, including its native Insert-key
toggle. Native selection replacement takes precedence over deleting a following
character; grapheme/IME/password cursor behavior remains GTK/Pango policy, not a
byte overwrite invented by the SDK. Programmatic text= and insertText still use
their existing native buffer/GtkEditable semantics: insertText does not synthesize
typing and does not become an overwrite operation merely because this flag is true.
Read-only entries remain non-editable to user typing. No key event, fake delete,
undo transaction, numeric validation or text sanitization is introduced.

hasFrame changes the GtkEntry frame, not a combo's outer border, parent layout,
focus authorization or theme resource. Native style may render borders/focus rings
differently. These presentation/editing setters do not mutate stored text, cursor
coordinates or combo activeIndex and do not implicitly cancel queued completion/icon
observations or reset native preview/history. Ordinary selection observers remain
coordinate-only. Explicit textVisible=false still detaches SDK completion through
its existing visibility hook; mask glyph choice alone does not hide text or detach
completion. Raw/nested callbacks must still obey native traversal rules.

invisibleChar is the effective native uint32 glyph value; the setter accepts Unicode
scalars 0..0x10FFFF excluding surrogates. Zero is intentionally valid: GTK's explicit
**no visual feedback** setting. Negative values are not this API's unsigned type,
and invalid/out-of-range/surrogate values raise before mutation. Noncharacters are
scalars; GTK/font fallback still governs actual rendering. invisibleCharSet reads
GTK's public boolean property, not private storage. Setting even the current glyph
makes the policy explicit; unsetInvisibleChar restores font-selected policy and
clears that flag. The default glyph can change with font/theme; zero in a getter
alone does not tell you whether explicit blank mode or native default is selected.

Mask configuration applies only while textVisible=false. It does not erase, encrypt,
rewrite or shorten the underlying text, prevent explicit entry.text access, or
change programmatic editing rights. selectedText and SDK copy/cut safeguards still
refuse password extraction even with a blank/default glyph. The inputs example
uses a **separate non-secret sample entry** with show/native/asterisk/bullet/blank
controls; it never copies a real password into a status label.

**Native PRIMARY is not a security boundary.** Realized selection can still own it.
GTK's PRIMARY callback uses display text dynamically: programmatically selected
password text can return repeated mask glyphs, and explicit zero returns repeated
spaces, not necessarily an empty reply. GTK's optional password-hint policy can also
leave a recently typed character visible in display-text replies. The SDK does not
authenticate selection owners, suppress ownership, replace native masking or alter
global hint settings. Do not assume any mask choice guarantees clipboard privacy.
The isolated regression uses programmatic text without a typing hint and checks
bullet/asterisk/space/native-default replies, without patching GTK or its settings.

Hidden tests/tgtk2entryediting.nim keep entries unrealized: boolean roundtrips,
scalar/default/blank policies, atomic invalid values, no text/coordinate mutation,
programmatic insertion, read-only/password, combo/SpinButton, completion visibility,
purity guards and setter/unset/visibility pins when raw notify drops the last alias.
The native ABI probe checks nine prototypes and gunichar argument/return width.
The opt-in isolated testMappedEntryEditing requires GTK2_TEST_VIRTUAL_DISPLAY=1;
Unix X11 XTEST verifies actual insert/overwrite/selection/Insert-key behavior and
native PRIMARY display under each programmatic mask policy. Normal tests never
realize widgets, claim ownership, request selections or fake input.

### Raw TextTagTable lifecycle and traversal

Private table_add_buffer/table_remove_buffer bindings are removed without shims.
GTK registers buffers through public text_buffer_new(table) and unregisters on final
release; callers must not manipulate native registry fields/hooks. A shared table
shares tag definitions, not document text. Explicit table removal clears that tag's
ranges in every registered buffer; table finalization instead detaches/releases
without emitting tag-removed. Raw constructor/add/lookup ownership differs from
SDK tag table retention: neither native tables nor SDK tags own document buffers.

Public foreach is synchronous, unordered, borrowed and non-mutating in membership.
Keep owners alive, contain exceptions, do not pump events or add/remove members.
Owned refs can be collected first, then used after traversal. Pinning is not a
blanket guarantee for every peer buffer during destructive raw callbacks. No SDK
registry mirror, table wrapper, generic callback, rebinding or cache repair is added.
See [table migration](raw-widgets.md#gtktexttagtable-raw-migration-public-construction-and-traversal).

Tests cover native ownership, retained lookups, named/anonymous iteration,
post-traversal removal, silent finalization and shared-buffer cleanup, with seven
new signature/class callback checks plus full native field offsets/foreach ABI.
Isolated testMappedTextTags exercises separate-buffer repaint/removal/peer teardown.
The text example's highlight toggle performs genuine table-wide deletion, distinct
from unsetting an override. No normal test maps/realizes widgets or requests input.

### TextTag override and priority policy

Raw GtkTextTag flag/padding helpers and masks are removed without shims; native
storage/layout remains checked. Use real public GObject properties, not flag words;
see [tag migration](raw-widgets.md#gtktexttag-raw-migration-real-override-properties).
New clearBold/clearItalic/clearUnderline/clearInvisible/clearEditable remove the
corresponding tag contribution, like existing color clears. Assigning false instead
establishes an explicit override. Clearing leaves stored values/tag ranges intact,
so property getters alone do not report whether a value contributes to effective
style. The text example separates its value checkbox from an unset-override button.

TextTag.priority checks current membership in its SDK table and validates 0..<table
size before native mutation. Higher native priority wins and other ranks shift;
removed/foreign-table tags reject checked priority/range operations. A live detached
tag still supports native property changes. Its SDK table handle does not retain a
document buffer. Native tag-added removal returns a valid detached tag.

GTK2 priority changes do not emit tag-changed: fresh style queries use new ranks,
but cached views need not repaint until genuine native invalidation. No synthetic
signal, detach/reapply, buffer rebinding or cache-reset helper is added. Native
priority/visible pixels are not authorization; tag editability may override view
defaults. Property/color/clear/range/table operations pin native owners through
callbacks, without legalizing destructive reentrancy during GTK traversal.

Unrealized ARC/ORC property/removal/priority/pin/guard tests and native tag/table
layout/signature/cdecl event probes cover the change. Opt-in testMappedTextTags
checks actual inherited/false/unset/removal pixels and fresh priority queries on an
isolated display. No normal test realizes widgets, requests selections or fakes input.

### Raw text attributes and effective style

TextAttributes/Appearance flag helpers and masks are removed without aliases.
Public native layout remains, and reference(PTextAttributes) now returns the actual
native pointer. These are boxed, explicitly refcounted values, never ObjectHandles
or GObjects. Native new/copy/get_default_attributes results are owned and need
unref; reference and GLib boxed copy alias the same value, while explicit copy
creates an independent snapshot. See [attribute migration/ownership](raw-widgets.md#gtktextattributesappearance-raw-migration-and-ownership).

Effective style inspection starts with a view-default copy and overlays iterator
tag attributes. The native boolean reports tag contribution, not visibility,
editability, authorization or snapshot validity. Snapshots do not update live tags
or track later changes; the example's underline checkbox changes the actual emphasis
tag property. False is an explicit property value, not necessarily removal of its
override. No ergonomic generic style/snapshot wrapper was added in this raw audit.

Native copy_values preserves destination refs but GTK2.24.33 source leaks old tabs/
paragraph color on populated destinations. Prefer independent copies; the optional
source-only patch is not applied or validated as rebuilt GTK. No private resource
repair, realized-bit override or warning suppression is used. Unrealized ARC/ORC,
compile/layout/prototype tests cover ownership/default overlays; isolated
`testMappedTextAttributes` covers native pixels and snapshots after tag/view changes.
Normal tests never realize, request selections or manipulate desktop input.

### TextMark public lifetime and raw migration

TextMark uses native visibility/name/gravity/deletion/buffer APIs, never a guessed
segment/body layout. Raw private body types, four helpers and four constants are
removed without shims; native public instance/class ABI storage remains unchanged.
See [raw mark migration](raw-widgets.md#gtktextmark-raw-migration-no-guessed-private-body).

createMark owns its native non-floating mark before adding it to the buffer.
Synchronous raw mark-set listeners can delete a mark during insertion; the returned
handle then safely reports deleted instead of adopting a dangling borrowed return.
Creation/move/delete/visibility pin relevant native lifetimes, not arbitrary GTK
BTree reentrancy. Raw callbacks must still obey traversal rules and avoid nested
pumping. No new asynchronous mark-listener, reinsertion or mutable-gravity API is
added. Deletion and visibility do not rewrite document text or simulate undo.

TextMark.buffer returns an owning buffer handle, raising when deleted. A mark alone
does not retain its buffer; explicit owner retrieval can. Deleted marks retain
native name/gravity/visibility, but offset/membership operations reject deletion or
a different buffer. Checked deletion protects the native insertion/selection marks
using public identities, not the removed not_deleteable bit. The text example has
an explicit bookmark-cursor checkbox, including after explicit document replacement.

Unrealized ARC/ORC tests cover compile rejection, native visible clearing, Unicode
gravity, dropped-alias/immediate-deletion safety, buffer ownership and guards.
Native record/prototype/cdecl probes cover ABI; opt-in testMappedTextMarks checks
actual cursor pixels, movement/deletion and shared-view gravity only on an isolated
display with GTK2_TEST_VIRTUAL_DISPLAY=1. No normal test realizes or requests selections.

### TextView public policy and raw migration

TextView editable, cursorVisible and acceptsTab use public gboolean APIs; new
TextView.overwriteMode uses native get_overwrite/set_overwrite. All four mutations
pin the native view across notifications. These are per-view policies, not edits to
a shared buffer or overrides of tag-level permissions. Readonly still permits
explicit buffer edits; hiding the caret does not conceal text or prohibit typing.
Native typed overwrite, Insert, IME and selection replacement remain GTK policy;
programmatic buffer insertion is not simulated typing. The text example now has
manual editor readonly/caret/overwrite/Tab controls without rebinding its document.

Stock GTK2 can warn when changing overwrite before realization because native
cursor invalidation uses missing layout/windows. The checked setter therefore
rejects a changed value on an unrealized view with ValueError (same-value no-op is
allowed). Configure it after normal realization, never force realization in a normal
hidden test. No private inspection, automatic realization, warning suppression or
runtime repair is added. A native diagnostic and optional source-only patch are
provided, not applied; see [raw TextView migration](raw-widgets.md#gtktextview-raw-migration-public-policy-not-private-flags).

The audit removed 16 unsafe raw helpers/16 masks, including stale masks whose names
no longer match GTK2.24 bits. Real public methods are the only replacements; private
IME/cache/focus flags have no equivalent getter/setter. GtkTextViewClass backspace/
clipboard/toggle/move_focus slots now match GTK2, keeping instance storage/class
size and seven real reserved slots. Native layout/prototype/cdecl probes and
unrealized ARC/ORC tests cover migration/pins/guards. Opt-in
`testMappedTextViewPolicy` covers native overwrite, selection, readonly, caret and
Tab/focus with XTEST on an isolated display; normal tests never realize or fake input.

### Raw Entry private-flag migration

Raw GtkEntry bitfield helpers and mask/shift constants are removed without shims.
Use the public GtkEditable boolean methods for editability and GtkEntry visibility
methods for text concealment, not widget show/hide. Ergonomic editable/textVisible
already use those methods; editable mutations now pin native lifetime through raw
notify callbacks too. Inputs demonstrates public read-only control without changing
stored text. GtkCellEditable's public editing-canceled property is scoped to native
cell-editor sessions, not a general undo/cancel API. Other removed private drag,
IME/cache/click/caret/renderer flags have no direct public replacement. No guessed
state, synthetic reset, model rebinding or deeper IME API was added.

The raw GtkEntryClass backspace/clipboard/toggle/text-area slots were corrected
without changing class size; instance ABI storage is unchanged. Native layout and
signature probes cover those declarations, while unrealized
`tests/tgtk2entryrawaudit.nim` rejects old helper pairs/constants and tests boolean
clearing, public property typing and setter pins. See the complete inventory and
migration table in [raw widgets](raw-widgets.md#gtkentry-raw-migration-no-private-bitfield-helpers).

### Entry progress feedback

Entry has progressFraction and progressPulseStep float64 properties, plus
progressPulse(). Native gdouble crosses the FFI unchanged. Both setters require
finite values in 0..1 inclusive and reject invalid values before any native change;
zero and one are deliberate valid endpoints. Native entry references are pinned
through setters/pulse and notifications. Ordinary, protected editable-combo and
inherited SpinButton entries share the API.

```nim
entry.progressFraction = 0.625 # Determinate overlay, not stored text.
entry.progressPulseStep = 0.15
entry.progressPulse()         # Enter activity; subsequent calls move the block.
entry.progressFraction = 0    # Explicitly end activity and clear the overlay.
```

The first pulse enters GTK activity at the initial position and resets the native
fraction to zero; it **does not emit notify::progress-fraction**. Later pulses move
GTK's block according to native direction/step policy. There is no public activity
getter, so progressFraction==0 cannot distinguish activity from an empty determinate
indicator. The SDK deliberately keeps no guessed private flag or shadow mode. Every
fraction assignment ends activity, including assigning zero when the getter is
already zero. GTK emits its native fraction notification for that transition;
assigning an unchanged determinate fraction does not force a notification. Invalid
assignments leave native activity unchanged.

Changing the step does not enter activity or reset its position; it sets the native
width/movement fraction for subsequent drawing/pulses. Step zero can produce an
invisible zero-width block; step one can span the available progress area. Geometry,
bounce, clipping, theme styling and native determinate RTL direction remain GTK's
policy. No independent promise of visual percentage, accessible job completion or
animation duration is made. The progress overlay does not resize/reorder icons,
rewrite text, change selection coordinates, select combo rows, validate spin values,
authorize input, reset completion history or relax readonly/password-copy policy.

progressPulse is **one explicit UI-thread operation**, not a timer, event pump,
worker, source connection or job runner. Applications choose when to call it and
when to assign a determinate/zero fraction. Hide/show retains native policy; no
background animation is installed. GTK may redraw independently for normal reasons.
Raw property observers still obey native callback rules; no new asynchronous
progress-observation abstraction is implied by native notifications.

The inputs example has requested-fraction, pulse-once and explicit clear controls;
the requested fraction control is not an activity-mode getter. Hidden
`tests/tgtk2entryprogress.nim` keeps entries unrealized and checks defaults,
notifications/transitions, atomic NaN/infinity/range rejection, guards, notification
pins and unchanged text/selection/completion/icons/readonly/password/combo/SpinButton
behavior. Five native prototype checks and a double-precision callback/pulse probe
cover ABI. Opt-in `testMappedEntryProgress` requires an isolated display with
GTK2_TEST_VIRTUAL_DISPLAY=1: native offscreen pixels cover determinate/activity/clear,
zero/full-width steps, RTL, hide/show, unchanged public icon-window geometry and
password/read-only combo/SpinButton drawing. Normal tests never realize widgets,
claim clipboard ownership, request selections or synthesize desktop input.

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

## Text child anchors and inline widgets

The expanded [text example](../examples/text.nim) inserts one buffer anchor with a
button in the editable view and a different label in the shared read-only view.
These are actual GtkTextView embedded widgets, not DrawingArea overlays or markup.

### Creation, identity and offsets

createChildAnchor(buffer,offset) inserts a TextChildAnchor at a checked Unicode
character offset, including the end of the buffer. It owns a non-floating native
anchor reference **before** insertion. GTK's convenience create_child_anchor returns
a borrowed pointer which a changed observer could delete before it is returned;
the SDK deliberately uses public new()+insert() instead. A retained result remains
safe and reports deleted even if an existing changed observer immediately removes
it. No native iterators escape the operation.

childAnchorAt(buffer,offset) returns an owning cached alias, or an empty/deleted
handle if that character is not an anchor (including buffer end). It accepts only
SDK-created anchors with known buffer identity; arbitrary raw/Builder anchors are
not silently wrapped. There is no uninserted constructor or reinsertion API.
Deleted anchors cannot be reused: create a new one.

```nim
let buffer = newTextBuffer("Aλ🙂B")
let anchor = buffer.createChildAnchor(2)
let view = newTextView(buffer)
view.addChildAtAnchor(newButton("Inline"), anchor)
```

Anchor offset is its current character offset and follows edits before it. buffer()
returns an owning live buffer handle. Both reject deleted anchors. deleteAnchor(b,a)
checks live buffer identity before deleting exactly the anchor's one-character
range; foreign/deleted anchors fail before GTK's get_iter_at_child_anchor could
receive them. Buffer/anchor operations use public getters, not private segment/tree
fields. The constructor and explicit delete helper pin their native buffer through
the native operation.

A child anchor counts as **one character**. Ordinary text/textRange/selectedText
omit it, while slice includes U+FFFC, the object replacement character. That slice
is not a serialization of the anchor or widget; a literal U+FFFC in text does not
create an anchor. Existing findText(textOnly=true) can match text across the object,
with returned offsets still counting the anchor; textOnly=false includes the object
in matching, so searching U+FFFC can locate it. These semantics match existing
pixbuf insertion. Tags, cursor/selection and range offsets remain native Unicode
character coordinates, not byte offsets or plain-text string lengths. Plain-text
clipboard helpers omit embedded widgets and do not reconstruct them on paste.

### Widget slots, shared views and cleanup

addChildAtAnchor(view,child,anchor) validates that the anchor is live in the view's
current buffer and that the child is unparented, non-toplevel and introduces no
containment cycle. The SDK supports **one widget per anchor per view**; a shared
buffer may have different widget instances at the same anchor in different views.
A widget cannot be parented in multiple views. Read-only TextView editing policy
does not automatically disable the independently interactive embedded widget.

widgets(anchor) returns copied owning Widget aliases across all views; GTK's list
container is freed without unreffing its borrowed elements. A deleted anchor returns
an empty list, not GTK's temporary list while segment cleanup is in progress.
Show newly inserted children explicitly when adding them after showAll().

Normal Container.remove(view,child) detaches the retained child, unregistering its
native anchor/layout association without destroying it or deleting the anchor.
It can subsequently be embedded again. Destroying a child leaves the anchor's
one-character slot in the buffer. Destroying a view or replacing its buffer destroys
that view's anchored children, not children in other views and not anchors in a
still-live shared old buffer. Deleting the anchor, replacing the buffer's contents,
or finalizing its buffer destroys all widgets at that anchor in all views. Retained
widget aliases become destroyed and reject further native access.

Anchors do **not** retain their buffer or view. A shared SDK identity uses native
weak notification, independent signal-data pins and weak anchor metadata entries;
it never creates an anchor-to-buffer owning edge or reads GTK private storage.
A retained anchor safely reports deleted when its buffer finalizes. Calling its
buffer getter explicitly obtains a strong buffer handle, as expected. Buffer's
internal changed inspector scans live SDK anchor metadata and queues notifications;
it invokes no application code and does not pump events. Public raw mutation of
SDK anchor metadata/insertion signals is outside this contract.

### Deferred deletion observations

onDeleted(anchor,proc()) returns an AnchorConnection with connected and idempotent
disconnect. It is a **one-shot UI-idle observation**, not a synchronous pre-deletion
hook. It runs after native buffer/view/segment cleanup has returned, so application
code can edit buffers, delete another anchor or destroy windows safely. Exceptions
are contained. The connection becomes inactive before delivery and releases its
capture automatically. Registering on an already deleted retained anchor schedules
one idle delivery as well. No initial event occurs for a live anchor.

Disconnect or disconnectSignals(anchor) cancels queued delivery and releases
captures. Dropping a token does not disconnect. Keep the SDK anchor handle while
observations are needed: native anchor finalization cancels undelivered observers;
the token itself does not keep its owner alive. A self-capturing observer is released
by one-shot delivery, but a callback capturing a buffer/view can still create an
ownership cycle that prevents deletion in the first place. Explicitly disconnect
before abandoning such owners. The text example cancels these observers on close.

Existing synchronous TextBuffer.onChanged and Widget.onDestroy retain their native
contracts. **Do not recursively edit buffers, replace view buffers, destroy other
views/children, or otherwise reenter GTK from embedded-widget destroy callbacks**:
GTK may still be walking a text segment or shallow child list. Merely recording
ordinary application state there is appropriate; use onDeleted for post-anchor-
deletion GUI work. It does not report child-only destruction or view-buffer changes
when the anchor remains live. Raw signal handlers cannot bypass native reentrancy
restrictions. All calls, observer delivery and final unrefs stay on the UI thread
under ARC/ORC.

Hidden tests/tgtk2textanchors.nim covers Unicode/search/slice behavior, buffer identity,
shared views, unparenting, replacement, immediate constructor-time deletion, weak
buffer lifetime, one-shot self-capture release and cancellation without mapping
windows. C probes verify native anchor insertion/deleted callback shapes and
pointer/gboolean/cdecl ABI. testMappedTextAnchors maps real inline buttons/entries
in two views, checks allocation, then exercises deletion and buffer replacement;
it requires an explicitly isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1.

Native rich-text serialization is covered below; anchors/widgets deliberately have
no implicit save/load representation. Undo/redo, fixed-position
TextView window children and arbitrary raw/Builder anchor wrapping remain separate
work. See TODO.md for the next batch.

## Native rich-text serialization

This surface reads/writes **GTK2's own binary tagset format for trusted application
data**, not RTF, HTML, a portable document standard or a safe parser for untrusted
files. The expanded [text example](../examples/text.nim) has an explicit path entry,
Save and Load trusted file buttons. Loading first decodes a detached document, then
replaces both views; parse/read errors leave the live editor untouched. Saving a
selection is available through the API, but the example saves the whole buffer.
Those file buttons do not negotiate clipboard formats or record undo/history;
separate rich clipboard document controls are described below.

```nim
let codec = newTextFormat("my-editor-v1", canCreateTags = true)
let saved = buffer.serialize(codec) # Or serialize(codec, first, last).
writeFile("document.gtk2rt", saved.data) # Binary string; embedded NUL is normal.
let loaded = codec.deserialize(newSerializedText(codec, readFile("document.gtk2rt")))
view.buffer = loaded # Explicit application commit, after successful decoding.
loaded.modified = false # Explicit application save/load policy.
```

### Native formats and copied binary data

TextFormat is a copyable owned descriptor. newTextFormat(tagset="",canCreateTags=false)
registers GTK's native serialize/deserialise tagset functions on a **private owned
registration buffer**, never on a live application/content buffer. There are no
user codec callbacks, mutable registration tables or public raw controller pointers.
Dropping the last descriptor copy releases this ordinary non-floating native owner;
no explicit close/unregister ordering or native callback-data capture is required.

mimeType is copied from native gdk_atom_name. An empty tagset selects
application/x-gtk-text-buffer-rich-text; a nonempty name selects the native
;format=NAME suffix. Names are checked portable ASCII letters/digits/hyphen/underscore,
maximum 64 characters. Native GdkAtom identity is preserved internally with its
pointer width; the SDK does not invent a codec or infer a format from a filename.
Descriptors with the same name are compatible, but their tag-creation policies are
independent because their registration owners are distinct. The default native
serialization registration on a GtkTextBuffer does not get overwritten by a public
SDK descriptor: its buffer is private.

SerializedText owns copied binary bytes and native format identity. data returns a
fresh binary string, byteCount counts bytes (not characters), and mimeType is the
copied native name. It retains neither source buffer, tags, pixbufs nor descriptor.
newSerializedText(format,binaryString) copies imported bytes and explicitly associates
the caller-selected format. deserialize rejects incompatible format identities.
The bytes themselves do **not** encode the MIME/tagset name: persist that separately
if an application supports multiple formats. A caller claiming a format on imported
bytes is not authentication, schema enforcement or content-type detection.

Native serialize allocations are copied by returned gsize and g_free'd, never
strlen'd; GError messages are copied and every returned error is freed. Native
format-array getters in headers/gtk2 return transfer-full arrays of borrowed atoms;
raw callers free the array, not atoms. Raw custom codec registration and signatures
are available there, not exposed as ergonomic application callbacks.

### Exact ranges, tags, images and unsupported objects

serialize(buffer,format,first=0,last=-1) uses checked Unicode offsets and ordered
ranges; -1 means buffer end only for last. It checks the selected range, then uses
public gtk_text_buffer_insert_range to copy text/tags/pixbufs into an unobserved
buffer sharing the source tag table. GTK serializes that snapshot's full range.
This is necessary because GTK2's serializer scans beyond a requested end before
clamping and can include out-of-range images or produce invalid markup. The snapshot
preserves exact boundaries and source tag identity; no source text/modified/cursor
changes or SDK changed observations occur. Native temporary marks used during
insert_range are not saved. Raw mark/signal hooks must not reenter this operation.

Named/anonymous tag properties, relative priority, invisible characters and embedded
pixbuf pixels are handled by the native codec. New native pixbufs are owned by the
decoded document. Marks, cursor/selection state, modified flag/history, view settings,
widgets and application callback connections are not document data; establish them
explicitly after loading. An empty document or empty selected range is supported.

Anchors and **literal U+FFFC** in the selected range are rejected before native
serialization. GTK2's serializer does not advance over a non-pixbuf U+FFFC and can
hang. No widgets are silently omitted, converted to text or reconstructed. Genuine
pixbuf replacement characters are supported. Unsupported characters outside the
selected range do not prevent saving a valid range, since the private snapshot
contains only that range. A literal U+FFFC imported through native XML remains a
literal character, not an anchor; saving it later is subject to this same check.

### Detached import and tag policy

deserialize(format,SerializedText,tagsFrom=default(TextBuffer)) returns a new
**detached** TextBuffer. It never inserts into a live observed buffer: GTK emits
synchronous changes while continuing to use iterators/tags. Application callbacks
cannot see or mutate the destination until import completes. On failure the private
buffer and its native tags are released; an existing document is not rolled back
because it was never modified. On success ordinary TextBuffer operations/callbacks
work normally. Setting view.buffer is a separate explicit commit, not a transaction
across windows. Replacing an old view buffer follows the anchor cleanup rules above.

canCreateTags is immutable and defaults false. With false, named tags must already
exist, anonymous/unknown tags fail, and existing tag **properties win** over serialized
properties. To provide a fixed schema, pass tagsFrom=anExistingBuffer: the returned
buffer shares its native tag table, but not its text, marks or changed callbacks.
Returned tag handles have the same native identity as schema tags; subsequent tag
property edits affect all buffers sharing that table. This is sharing, not cloning.
Without tagsFrom, false can import untagged data into an empty table.

With canCreateTags=true, import uses a fresh tag table and permits the native codec
to create named/anonymous tags. Combining it with tagsFrom is rejected, preventing
partial parser-created tag pollution of an application table. The native parser
can create tags before reporting a later XML error; private destination ownership
contains these side effects. A native tagset/MIME name alone is not a tag allowlist.

### Limits, native diagnostics and validation

newSerializedText validates the audited GTK2 native outer section framing: known
first content/subsequent pixdata section identifiers, positive in-bounds big-endian
lengths and total length below native signed-gint limits. It rejects empty,
truncated, unknown-header, negative/overflowing-length and trailing-section data
before GTK can take known bad paths. It does not parse/rewrite the XML or pixdata
bodies, guess another codec or make GTK's old native parser safe for untrusted
input. Malformed properties/images can still trigger native resource consumption
or defects. Use trusted data from a controlled application, not arbitrary uploads.

Audited GTK 2.24.33 also leaks its anonymous-tag parser hash table on imports and
can leak decoded pixbuf spans on later parse failure. The optional, **not applied**
[gtk2-text-serialization.patch](../patches/gtk2-text-serialization.patch) fixes these
native cleanup defects and the U+FFFC progress bug. It does not fix range scanning
or turn the parser into a security boundary. The SDK keeps its snapshot/rejection
contract even with patched GTK. Native GTK rich-clipboard serialization outside
this API can still encounter the progress/range defects; the SDK does not globally
rewrite clipboard registrations or native key bindings. No native warnings are
hidden, private GTK fields inspected at runtime or installed libraries modified.

The opt-in C diagnostic tests/headers/text_serialization.c maps no windows. Compile
with GTK2 development flags (`gcc -m64` and `/usr/lib/64/pkgconfig` on illumos).
--anchor/--literal use a two-second alarm to report the native hang; --past-end
reports native out-of-range image corruption; --bad-header with G_DEBUG=fatal-warnings
exposes GTK's invalid domain-zero GError fallback. These expected-failure probes
are not part of normal SDK tests. Disable core dumps when running fatal diagnostics.

Hidden tests/tgtk2textserialization.nim covers raw registration/array ownership,
owned binary copies, format matching, weak source lifetime, tag policy/shared
schema, Unicode/invisible text, exact ranges/images, rejected objects and errors.
C probes cover native callbacks, pointer-sized atoms/gsize, gboolean and GError**.
testMappedTextSerialization checks restored tag/image layout and explicit two-view
buffer replacement; like other mapped suites it requires an opted-in isolated
display and GTK2_TEST_VIRTUAL_DISPLAY=1. Calls and final releases remain UI-thread
ARC/ORC operations. Rich clipboard negotiation is covered below. Live insertion, custom codecs,
widget serialization and undo/redo remain separate work.

## Rich clipboard negotiation

Rich clipboard support is **explicit document transfer**, not a replacement for
plain-text copy/cut/paste or native TextView key bindings. The expanded text example
has Copy document (includes hidden text), Import clipboard as document and a
Trust native rich owner checkbox, initially off. An import returns a detached
buffer and the example explicitly replaces both views only after success. No rich
cut, implicit insertion, automatic fallback after parse errors or undo is provided.

### Snapshot offers

```nim
let codec = newTextFormat("my-editor-v1", canCreateTags = true)
let snapshot = buffer.serialize(codec)
let offer = getClipboard().offerRichText(snapshot, buffer.text)
# Later, only if this particular offer is still active:
offer.clear()
```

offerRichText(clipboard,SerializedText,plainText) claims CLIPBOARD (or the Clipboard's
explicit PRIMARY selection) with an immutable copied binary snapshot and explicit
validated UTF-8 plain fallback. It offers the payload's exact native MIME/tagset
atom plus UTF8_STRING, COMPOUND_TEXT, TEXT, STRING and common text/plain targets;
GTK converts text for the requested target. Byte lengths are explicit, including
native binary NULs. Target-entry strings are consumed/interned during registration;
get callbacks copy into GTK selection data, never lend a source buffer's memory.
There are no application callbacks inside native offer/get/clear handlers.

RichClipboardOffer.active tracks native clear notification. Dropping a token does
not clear the offer; a native pin retains snapshot bytes until ownership is lost,
replaced or cleared. clear(offer) only acts while that offer remains active, so an
old token cannot clear a subsequent local offer. Native loss notifications can be
delayed until display events are processed. This is not proof of current foreign
ownership or an atomic X-server ownership check. No clipboard-manager persistence
or automatic store is requested. Clear notification releases data and the pin once,
including GTK's unusual failed/reentrant replacement path.

An offer retains **no source buffer, view, marks or application callback**. It can
outlive the originating document/window while the process/display remains alive.
Serialization's anchor/literal U+FFFC rejection and exact-range rules apply before
offering. Plain fallback is deliberately supplied by the application, not inferred
from serialized XML or silently sanitized. Native serialization includes invisible
tagged text. Only offer such data intentionally; buffer.text includes hidden text,
whereas existing plain copySelection excludes it. There is no rich Entry/password
copy helper. Existing plain-text Clipboard/Entry/TextView APIs are unchanged.

### Requests and explicit trust

```nim
let request = getClipboard().requestRichText(view, codec, trusted = false,
  fn = proc (value: RichClipboardResult) =
    case value.kind
    of richDocument: view.buffer = value.document # Explicit application commit.
    of richPlainText: discard # Application chooses how/if to use plain fallback.
    of richRejected: echo value.error
    of richUnavailable: discard)
# Explicit user/application cancellation:
request.cancel()
```

requestRichText has overloads with/without a TextView owner, requires a TextFormat
and an explicit trusted boolean, and accepts fallbackToText=true and optional
tagsFrom. With trusted=false it **never requests or parses rich bytes**, even when
advertised. It uses the existing UTF8_STRING → COMPOUND_TEXT → STRING text path, or
returns unavailable at idle if fallback is disabled. Acquiring a Clipboard handle
alone does not claim ownership; the no-trust/no-fallback path makes no selection
request at all.

With trusted=true it requests exactly the descriptor's native format atom, without
blocking wait_for_* calls, nested loops or implicit guesses at another tagset. GTK's
borrowed selection data is checked for requested target, native data type, format 8
and explicit nonnegative length, then copied before the callback returns. Native
rich-text parsing happens **only at UI idle**, outside the selection callback, via
the detached deserialize API and its native framing checks. The request never
modifies a live buffer or invokes application code while GTK is transferring data.
Tag creation/shared-schema policy is exactly TextFormat's policy: creation requires
a fresh table; false may reuse tagsFrom's table/properties without changing its
text. Invalid policy combinations fail before issuing a selection request.

RichClipboardResult.kind is:

- richDocument: document owns a newly decoded detached TextBuffer.
- richPlainText: text is copied validated UTF-8. Empty-but-available text is valid.
- richUnavailable: no compatible rich/text data, or fallback deliberately disabled.
- richRejected: an offered rich reply has invalid type/format/data, framing, tags or
  native parse failure; error is copied. **No automatic plain fallback after a rich
  reply is rejected.** This avoids disguising damaged/denied rich data as success.

Only an absent/refused rich target proceeds to plain fallback. A format-name
mismatch can therefore yield text, but never an automatically selected alternate
native codec. A successful empty rich reply is rejected, not treated as empty text.
Clipboard ownership may change between requests/fallback targets; results are not
an atomic multi-target snapshot and no portable authenticated owner identity is
claimed. Native atom identity is format matching, not trust or authentication.

trusted=true is the application's assertion that native GTK2 parsing is appropriate
for the replying owner in this environment. It is not a sandbox, a verified owner,
a prompt supplied by the library or protection against malicious XML/pixdata.
The known native parser defects/resource limits described above still apply,
including unpatched native cleanup leaks. Do not automatically enable it for
arbitrary desktop owners; use plain text by default. The example cancels a pending
request when its trust checkbox changes. The SDK does not rewrite native Ctrl+C/
Ctrl+V bindings or globally change GTK clipboard registrations.

### Lifetime, cancellation and explicit commit

RichTextRequest.pending becomes false before delivery. cancel is idempotent, drops
application captures/copied data promptly and suppresses queued observations.
Dropping the token does not cancel. Native GTK has no request_contents cancellation:
a separate small pinned bridge/clipboard reference remains until an outstanding
native callback actually returns. That bridge does not retain the cancelled user
closure, format/schema/view or copied body. Native/source/request lifetime pins are
independent, including synchronous same-process replies and foreign-owner replies.

The TextView-owner overload cancels on destruction and edits to its captured buffer;
it validates the view's buffer identity again at idle before decoding/delivery and
silently cancels if the buffer was replaced. Replacement need not immediately clear
pending while the wire request remains outstanding. This avoids decoding a stale
reply into a different document. It does not detect every tag/property change or
provide transactional document replacement. The owner buffer/schema are retained
until completion/cancellation; no buffer iterator survives the request.

Before calling the application, owner hooks, pending state and request captures are
released. Result buffers/text are copied into the delivery payload, so callbacks
can reenter, replace views, start another request, close windows or throw safely;
exceptions are contained. An unowned request has no automatic window cancellation:
cancel it explicitly on close if its closure captures GUI state. All operations,
callback delivery and native final releases remain UI-thread ARC/ORC work.

Hidden tests/tgtk2richclipboard.nim validates cancellation/capture release, owner
staleness and arguments with **no clipboard ownership or selection requests**.
testMappedRichClipboard owns only an explicitly isolated display's selections and
requires GTK2_TEST_VIRTUAL_DISPLAY=1. It covers copied snapshot lifetime, text-only
trust policy, malformed/wrong-type replies, fixed schemas, fallback/empty/refused
results, PRIMARY, reentrant callbacks and foreign-process transfer/cancellation.
C probes verify get/clear callback ABI and pointer-width selection target atoms.

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
`tests/tgtk2builder.nim`, `tests/tgtk2uimanager.nim`, `tests/tgtk2completion.nim`, `tests/tgtk2inlinecompletion.nim`, `tests/tgtk2completionmatch.nim`, `tests/tgtk2completionactions.nim`, `tests/tgtk2entryselection.nim`, `tests/tgtk2entryobservations.nim`, `tests/tgtk2entrypolicy.nim`, `tests/tgtk2entryicons.nim`, `tests/tgtk2entryediting.nim`, `tests/tgtk2entryprogress.nim`, `tests/tgtk2entryrawaudit.nim`, `tests/tgtk2textviewrawaudit.nim`, `tests/tgtk2textmarkrawaudit.nim`, `tests/tgtk2textattributesaudit.nim`, `tests/tgtk2texttagaudit.nim`, `tests/tgtk2tagtables.nim`, `tests/tgtk2textbufferaudit.nim`, `tests/tgtk2textbtreeaudit.nim`, `tests/tgtk2textlineaudit.nim`, `tests/tgtk2modelfunctions.nim`, `tests/tgtk2iconselection.nim`, `tests/tgtk2textanchors.nim`, `tests/tgtk2textserialization.nim`, and `tests/tgtk2richclipboard.nim`.
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
testMappedDesktop/testMappedExtensions/testMappedTransfers/testMappedActions/testMappedBuilder/testMappedUIManager/testMappedCompletion/testMappedModelFunctions/testMappedIconSelection/testMappedTextAnchors/testMappedTextSerialization/testMappedRichClipboard/testMappedInlineCompletion/testMappedCompletionMatch/testMappedCompletionActions/testMappedEntrySelection/testMappedEntryObservations/testMappedEntryPolicy/testMappedEntryIcons/testMappedEntryEditing/testMappedEntryProgress/testMappedTextViewPolicy/testMappedTextMarks/testMappedTextAttributes/testMappedTextTags/testMappedTextBufferState/testMappedTextGeometry/testMappedUriClipboard/testMappedUriDrag/testMappedImageClipboard/testMappedBinaryClipboard/testMappedBinaryDrag/testMappedDragIcons/testMappedImageDrag tasks map windows only on an isolated virtual display, as
described above.

All non-deprecated concrete core GTK2 widgets in the audited inventory now have
an ergonomic entry point. StatusIcon (a GObject, not a widget) and the abstract
Misc API are also covered; optional HtmlView remains outside the core layer.
Other gaps include standalone popup positioning and arbitrary/custom cell renderers beyond the audited
text/pixbuf/toggle column APIs, broader event argument/return-value APIs,
additional rich clipboard protocols, untrusted image decoding, asynchronous acceptance
acceptance and MOVE/model drag-and-drop,
undo and live rich-text insertion, actual print jobs,
arbitrary GObject properties,
widget subclass virtual methods, or gtkmm's broader GDK/Pango abstractions.
Use the raw API for those while this layer grows. No gtkmm C++ runtime is needed.
