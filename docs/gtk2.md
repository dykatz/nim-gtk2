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
| `newDrawingArea(width, height)` | Size request and redraw scheduling; rendering callbacks are not wrapped yet |

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
text getter. Rich text, tags, marks, search, clipboard, images, and anchors remain
outside this initial surface.

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
`onSelectionChanged(proc () = ...)` returns a normal connection. Selection
signals originate on a separate GtkTreeSelection GObject: the wrapper tracks IDs
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
references are covered below. Multiple selection, editable/custom cell renderers,
and model replacement remain future work. Pixbuf-backed IconView is covered below.

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

- `selectedIndex` uses `-1` for no selection; assigning `-1` clears it.
- `selectedPath` uses the virtual root for no selection. Other paths/indices
  must identify existing rows. Native modes other than SINGLE are rejected.
- `onSelectionChanged(proc () = ...)` observes native selection changes.
- `onItemActivated(proc (index: int) = ...)` and
  `onPathActivated(proc (path: TreePath) = ...)` deliver copied positional values.
  `activateRow(index)` emits activation without selecting the row automatically.
- `scrollToRow(index)` asks GTK to bring a row into view, including deferred
  scrolling before realization.
- `columns` and `itemWidth` accept positive values or `-1` for automatic sizing.
  `spacing`, `rowSpacing`, `columnSpacing`, and `margin` accept nonnegative pixels.

Native selected-item lists and every allocated path are freed after copying.
Callbacks contain exceptions, support self-disconnection, and are disconnected
on widget destruction. Model coordinates remain positional: convert proxy paths
before source edits or use a stable source row reference. Multiple selection,
custom/editable renderers, drag-and-drop, and model replacement remain deferred.

[`examples/icons.nim`](../examples/icons.nim) demonstrates generated color tiles,
a scaled Image preview, filtering, sorting, selection, and activation. Validation
compiles this sampler without launching visible windows.

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
Custom accelerator groups/key registration are not wrapped in this batch; raw
GTK can install shortcuts on monitored widgets, while ordinary menu mnemonics
work without extra registration.

Widget constructors now use the same weak native-state cache as borrowed
getters, so aliases share destruction tracking and connections without stealing
references or introducing a cache ownership cycle. GTK2 menu trees and accelerator
labels can themselves contain **native** reference cycles. Explicitly destroy
standalone/unattached menu roots and unused unparented menu items; do not rely on
merely dropping their Nim handles. For an attached menu bar, explicitly destroying
its window destroys the menu tree and releases captures. Also destroy standalone
AccelLabels or clear their monitored widgets when done. All operations and final
releases remain on the UI thread.

This batch is for menu-bar trees. Standalone popup positioning, custom accelerator
routing, menu grid attachment, and action/UIManager abstractions remain raw APIs.
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
`tests/tgtk2choosers.nim`. Chooser tests cover copied selections, alpha semantics,
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
enters the GTK main loop. The separate, opt-in `testMappedMenus` task maps windows
only on an isolated virtual display, as described above.

This layer intentionally does not yet wrap specialized file/recent/color/font
chooser dialogs, assistants, standalone popup positioning, custom model comparison/predicate callbacks,
multiple icon selection, drawing/expose callbacks, most event argument/return-value APIs, arbitrary GObject properties,
widget subclass virtual methods, or gtkmm's broader GDK/Pango abstractions.
Use the raw API for those while this layer grows. No gtkmm C++ runtime is needed.
