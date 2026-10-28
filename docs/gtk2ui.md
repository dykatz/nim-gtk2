# gtk2ui: a Nim-style layer inspired by gtkmm 2

`import gtk2ui` instead of the raw modules for a small, typed, ergonomic API.
The original `gtk2` API remains available and compatible. This is an initial
subset, not a complete replacement or a source-compatible port of gtkmm.
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
| `Gtk::Main` | `gtk2ui.init()`, `window.run()`, `gtk2ui.quit()` |
| stack widgets / `Gtk::manage()` | shared Nim handles plus GTK parent ownership |

There is deliberately no `manage(new ...)` ceremony, manual signal function
cast, `cstring` conversion, or `gboolean` conversion in normal application code.

## Example

```nim
import gtk2ui

proc main() =
  gtk2ui.init()
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

See also [`examples/ergonomic.nim`](../examples/ergonomic.nim).
Compile with `nim c --path:src examples/ergonomic.nim` from this checkout.

## Initial API

- Hierarchy: `Widget`, `Container`, `Bin`, `Window`, `Button`, `Box`, `VBox`,
  `HBox`, `Label`, `Entry`. The hierarchy restricts operations at compile time:
  `onClicked` needs a `Button`, `onChanged` needs an `Entry`, and `add` needs a
  single-child `Bin`. A box uses `packStart` / `packEnd` instead.
- Constructors: `newWindow(title, width, height)`, `newButton(text, mnemonic)`,
  `newLabel(text)`, `newEntry(text)`, `newVBox(spacing, homogeneous)`,
  `newHBox(spacing, homogeneous)`; all arguments have defaults.
- Properties: window `title`, label/entry/button `text`; container `borderWidth`
  is write-only. Strings are copied on reads and must not contain NUL on writes.
- Common operations: `show`, `showAll`, `hide`, `destroy`, `isDestroyed`.
- Packing: `packShrink` (natural size), `packExpandPadding` (extra padding),
  `packExpandWidget` (grow widget, the default), with optional `padding`.
- Signals: `onClicked`, `onChanged`, `onDestroy`, all accepting `proc ()`
  closures. Call `button.click()` to emit clicked programmatically.

## Ownership and safety contract

Call `gtk2ui.init()` before creating widgets. It raises `IOError` if no display
is available rather than terminating the process. It does not parse application
command-line arguments. All operations, callbacks, and final handle releases
must happen on the GTK/UI thread; do not send handles to worker threads.

Each constructor returns a value handle sharing one owned native reference.
Copying a handle shares its state rather than creating another widget. Releasing
the last handle drops that reference; adding a child also gives its container
a native reference, so a child may safely leave Nim scope after being packed.
This differs from gtkmm's stack-object destruction semantics.

**Explicitly destroy top-level windows**, normally with `defer: window.destroy()`.
GTK itself retains top-level windows, so losing the last Nim handle is not a
substitute for closing a window. Destroying a container also destroys its
children. All surviving copies detect destruction (including destruction through
the raw API) and raise `ValueError` rather than using a destroyed widget.
`destroy()` is idempotent; a default/uninitialized handle is considered destroyed.

Closures remain alive until disconnected or the widget is destroyed. Discarding
a returned `Connection` does not disconnect it. Retaining one keeps the shared
widget state alive. It is safe to disconnect from inside a callback; disconnect
is idempotent. Capturing widgets is supported, but captures can create native/Nim
reference cycles: explicitly destroy the widget or disconnect the signal to
break them. Destruction releases this layer's callbacks after running ordinary
`onDestroy` handlers. Exceptions in callbacks are reported to stderr and are
not allowed to unwind through GTK's C stack.

`.raw` is an escape hatch for APIs not wrapped yet. It returns a borrowed pointer:
do not unref it, wrap it independently, or keep it after releasing its handle.
Raw operations bypass this layer's argument/containment checks. Import raw GTK
with a module alias and qualify raw names to avoid Nim's case-insensitive name
collisions (e.g. `gtk2.WIDGET` versus `gtk2ui.Widget`).

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

This first layer intentionally does not yet wrap dialogs, menus, tree/model
APIs, drawing, event arguments/return values, arbitrary GObject properties,
widget subclass virtual methods, or gtkmm's broader GDK/Pango abstractions.
Use the raw API for those while this layer grows. No gtkmm C++ runtime is needed.
