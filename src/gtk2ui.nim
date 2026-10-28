## Small, gtkmm-inspired GTK2 API for Nim ARC/ORC programs.
## See docs/gtk2ui.md for ownership, signal and threading rules.
import gtk2 as rawGtk
import glib2 as g

when not (defined(gcArc) or defined(gcOrc)):
  {.error: "gtk2ui requires --mm:arc or --mm:orc".}

type
  WidgetStateObj = object
    p: rawGtk.PWidget
    destroyed: bool
    destroyHandler: g.gulong
    handlers: seq[g.gulong]
  WidgetState = ref WidgetStateObj
  Widget* = object of RootObj
    state: WidgetState
  Container* = object of Widget
  Bin* = object of Container
  Window* = object of Bin
  Button* = object of Bin
  Box* = object of Container
  VBox* = object of Box
  HBox* = object of Box
  Label* = object of Widget
  Entry* = object of Widget
  PackOptions* = enum
    packShrink, packExpandPadding, packExpandWidget
  Connection* = object
    state: WidgetState
    id: g.gulong
  Callback = ref object
    fn: proc () {.closure.}

proc `=destroy`(s: var WidgetStateObj) =
  if s.p != nil:
    # This callback borrows s; detach it before releasing our native reference.
    if g.g_signal_handler_is_connected(s.p, s.destroyHandler):
      g.g_signal_handler_disconnect(s.p, s.destroyHandler)
    g.g_object_unref(s.p)
  `=destroy`(s.handlers)

proc markDestroyed(instance, data: pointer) {.cdecl.} =
  let s = cast[WidgetState](data)
  s.destroyed = true
  # Break native -> Nim closure -> widget cycles, including self-captures.
  # Run after ordinary destroy handlers so onDestroy callbacks still execute.
  let handlers = s.handlers
  s.handlers = @[]
  for id in handlers:
    if g.g_signal_handler_is_connected(instance, id):
      g.g_signal_handler_disconnect(instance, id)

proc adoptWidget(p: pointer): WidgetState =
  if p == nil:
    raise newException(ValueError, "GTK returned a nil widget")
  new(result)
  result.p = cast[rawGtk.PWidget](g.g_object_ref_sink(p))
  result.destroyHandler = g.g_signal_connect_data(p, "destroy",
    cast[g.TGCallback](markDestroyed), cast[pointer](result), nil,
    g.G_CONNECT_AFTER)

proc raw*(w: Widget): rawGtk.PWidget =
  ## Borrowed pointer; do not unref it or retain it beyond the wrapper lifetime.
  if w.state == nil or w.state.destroyed:
    raise newException(ValueError, "widget is uninitialized or destroyed")
  w.state.p

proc raw*(w: Window): rawGtk.PWindow = cast[rawGtk.PWindow](raw(Widget(w)))
proc raw*(w: Button): rawGtk.PButton = cast[rawGtk.PButton](raw(Widget(w)))
proc raw*(w: Label): rawGtk.PLabel = cast[rawGtk.PLabel](raw(Widget(w)))
proc raw*(w: Entry): rawGtk.PEntry = cast[rawGtk.PEntry](raw(Widget(w)))
proc raw*(w: Box): rawGtk.PBox = cast[rawGtk.PBox](raw(Widget(w)))

proc isDestroyed*(w: Widget): bool = w.state == nil or w.state.destroyed

proc checkedString(s: string): cstring =
  if '\0' in s: raise newException(ValueError, "GTK strings cannot contain NUL")
  s.cstring

proc checkedInt(n: int): g.gint =
  if n < 0 or n > high(g.gint).int:
    raise newException(ValueError, "GTK size must fit a nonnegative gint")
  g.gint(n)

proc init*() =
  ## Initialize GTK without exiting the process if no display is available.
  if not rawGtk.init_check(nil, nil):
    raise newException(IOError, "GTK could not open a display")

proc newWindow*(title = "", width = 640, height = 480): Window =
  let t = checkedString(title)
  let x = checkedInt(width)
  let y = checkedInt(height)
  result.state = adoptWidget(rawGtk.window_new(rawGtk.WINDOW_TOPLEVEL))
  rawGtk.set_title(result.raw, t)
  rawGtk.set_default_size(result.raw, x, y)

proc newButton*(text = "", mnemonic = false): Button =
  let t = checkedString(text)
  result.state = adoptWidget(if mnemonic: rawGtk.button_new_with_mnemonic(t)
                      else: rawGtk.button_new(t))

proc newLabel*(text = ""): Label =
  result.state = adoptWidget(rawGtk.label_new(checkedString(text)))

proc newEntry*(text = ""): Entry =
  let t = checkedString(text)
  result.state = adoptWidget(rawGtk.entry_new())
  rawGtk.set_text(result.raw, t)

proc newVBox*(spacing = 0, homogeneous = false): VBox =
  result.state = adoptWidget(rawGtk.vbox_new(g.gboolean(homogeneous), checkedInt(spacing)))

proc newHBox*(spacing = 0, homogeneous = false): HBox =
  result.state = adoptWidget(rawGtk.hbox_new(g.gboolean(homogeneous), checkedInt(spacing)))

proc show*(w: Widget) = rawGtk.show(w.raw)
proc showAll*(w: Widget) = rawGtk.show_all(w.raw)
proc hide*(w: Widget) = rawGtk.hide(w.raw)
proc destroy*(w: Widget) =
  ## Idempotent. Destroy containers/windows explicitly to release signal captures.
  if not w.isDestroyed: rawGtk.destroy(w.raw)

proc `title=`*(w: Window, text: string) = rawGtk.set_title(w.raw, checkedString(text))
proc title*(w: Window): string = $rawGtk.get_title(w.raw)
proc `text=`*(w: Label, text: string) = rawGtk.set_text(w.raw, checkedString(text))
proc text*(w: Label): string = $rawGtk.get_text(w.raw)
proc `text=`*(w: Entry, text: string) = rawGtk.set_text(w.raw, checkedString(text))
proc text*(w: Entry): string = $rawGtk.get_text(w.raw)
proc `text=`*(w: Button, text: string) = rawGtk.set_label(w.raw, checkedString(text))
proc text*(w: Button): string = $rawGtk.get_label(w.raw)
proc `borderWidth=`*(w: Container, width: int) =
  rawGtk.set_border_width(cast[rawGtk.PContainer](w.raw), g.guint(checkedInt(width)))

proc checkChild(parent: Container, child: Widget) =
  discard parent.raw
  if rawGtk.IS_WINDOW(child.raw):
    raise newException(ValueError, "a top-level window cannot be a child")
  if child.raw == parent.raw or rawGtk.get_parent(child.raw) != nil:
    raise newException(ValueError, "child must be unparented and distinct from parent")
  # Reject adding an ancestor under one of its descendants.
  var ancestor = rawGtk.get_parent(parent.raw)
  while ancestor != nil:
    if ancestor == child.raw:
      raise newException(ValueError, "widget containment cycle")
    ancestor = rawGtk.get_parent(ancestor)

proc add*(parent: Bin, child: Widget) =
  ## Single-child containers only. Use packStart/packEnd for boxes.
  checkChild(parent, child)
  if rawGtk.get_child(cast[rawGtk.PBin](parent.raw)) != nil:
    raise newException(ValueError, "container already has a child")
  rawGtk.add(cast[rawGtk.PContainer](parent.raw), child.raw)

proc packStart*(box: Box, child: Widget, options = packExpandWidget, padding = 0) =
  checkChild(box, child)
  let pad = g.guint(checkedInt(padding))
  rawGtk.pack_start(box.raw, child.raw, g.gboolean(options != packShrink),
    g.gboolean(options == packExpandWidget), pad)

proc packEnd*(box: Box, child: Widget, options = packExpandWidget, padding = 0) =
  checkChild(box, child)
  let pad = g.guint(checkedInt(padding))
  rawGtk.pack_end(box.raw, child.raw, g.gboolean(options != packShrink),
    g.gboolean(options == packExpandWidget), pad)

proc releaseCallback(data: pointer, closure: g.PGClosure) {.cdecl.} =
  GC_unref(cast[Callback](data))

proc signalThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  # GTK callbacks execute only on the UI thread. The legacy raw binding marks
  # callbacks gcsafe, though user closures may access UI-thread-local state.
  {.cast(gcsafe).}:
    # Copy the closure before calling: the callback may disconnect itself.
    let fn = cast[Callback](data).fn
    try:
      fn()
    except Exception as error:
      # Never unwind a Nim exception through the GTK C stack.
      try:
        stderr.writeLine("gtk2ui signal callback: " & error.msg)
      except Exception:
        discard # Even a closed stderr must not unwind through C.

proc connect(w: Widget, name: cstring, fn: proc () {.closure.}): Connection =
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let callback = Callback(fn: fn)
  GC_ref(callback)
  let id = g.g_signal_connect_data(p, name, cast[g.TGCallback](signalThunk),
    cast[pointer](callback), releaseCallback, g.TGConnectFlags(0))
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)

proc onClicked*(w: Button, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "clicked", fn)
proc onChanged*(w: Entry, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "changed", fn)
proc onDestroy*(w: Widget, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "destroy", fn)

proc connected*(c: Connection): bool =
  c.state != nil and not c.state.destroyed and
    g.g_signal_handler_is_connected(c.state.p, c.id)

proc disconnect*(c: Connection) =
  ## Idempotent; dropping a Connection does NOT disconnect its callback.
  if c.connected:
    g.g_signal_handler_disconnect(c.state.p, c.id)
    for i, id in c.state.handlers:
      if id == c.id:
        c.state.handlers.delete(i)
        break

proc click*(w: Button) = rawGtk.clicked(w.raw)
proc quit*() =
  if rawGtk.main_level() > 0: rawGtk.main_quit()

proc run*(w: Window) =
  ## Show the window and run until it is destroyed. Call init() first.
  let connection = w.onDestroy(proc () = quit())
  try:
    w.showAll()
    rawGtk.main()
  finally:
    connection.disconnect()
