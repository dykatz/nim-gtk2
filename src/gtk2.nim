## Small, gtkmm-inspired GTK2 API for Nim ARC/ORC programs.
## See docs/gtk2.md for ownership, signal and threading rules.
import headers/gtk2 as rawGtk
import headers/glib2 as g
import headers/gdk2pixbuf as rawPixbuf
from headers/gdk2 import TColor
import headers/gdk2 as rawGdk except string
import headers/cairo as rawCairo
import std/algorithm as uiAlgorithm
import std/xmlparser as uiXmlParser
import std/xmltree as uiXmlTree

when not (defined(gcArc) or defined(gcOrc)):
  {.error: "gtk2 requires --mm:arc or --mm:orc".}

type
  ObjectStateObj = object
    p: pointer
    destroyed: bool
    destroyHandler: g.gulong
    handlers: seq[g.gulong]
    cached: bool
    hasDestroySignal: bool
  ObjectState = ref ObjectStateObj
  ObjectHandle* = object of RootObj
    state: ObjectState
  Widget* = object of ObjectHandle
  Container* = object of Widget
  Bin* = object of Container
  Window* = object of Bin
  Button* = object of Bin
  Box* = object of Container
  VBox* = object of Box
  HBox* = object of Box
  Misc* = object of Widget
  Label* = object of Misc
  Entry* = object of Widget
  PackOptions* = enum
    packShrink, packExpandPadding, packExpandWidget
  Connection* = object
    state: ObjectState
    id: g.gulong
  Callback = ref object
    fn: proc () {.closure.}
    deferForEntryPolicy, coalesce, cancelled: bool
    pending: int
    idle: g.guint

const completionDeferredKey = "nim-gtk2-deferred-inline-observers"
const entryPolicyDeferredKey = "nim-gtk2-deferred-entry-policy-observers"
const objectStateKey = "nim-gtk2-owned-object-state"

# Synchronous model functions consume copied data, not live GUI handles. Native
# traversals continue after they return, so last-handle releases wait for UI idle.
var modelFunctionDepth {.threadvar.}: int
type DeferredModelRelease = object
  p: pointer
  handlers: seq[g.gulong]
var deferredModelReleases {.threadvar.}: seq[DeferredModelRelease]
var deferredModelReleaseIdle {.threadvar.}: g.guint
proc requireOutsideModelFunction() =
  if modelFunctionDepth != 0:
    raise newException(ValueError, "GTK handle access is forbidden inside a synchronous model function; use copied row values")
proc flushModelReleases(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    if modelFunctionDepth != 0: return g.gbool(true)
    deferredModelReleaseIdle = 0
    let pending = move(deferredModelReleases)
    for item in pending:
      for id in item.handlers:
        if g.g_signal_handler_is_connected(item.p, id): g.g_signal_handler_disconnect(item.p, id)
      g.g_object_unref(item.p)
    g.gbool(false)

proc `=destroy`(s: var ObjectStateObj) =
  if s.p != nil:
    if s.cached and g.get_data(cast[g.PGObject](s.p), objectStateKey) == addr s:
      g.set_data(cast[g.PGObject](s.p), objectStateKey, nil)
    # Detach the borrowed state hook before this state storage goes away.
    if s.destroyHandler != 0 and g.g_signal_handler_is_connected(s.p, s.destroyHandler):
      g.g_signal_handler_disconnect(s.p, s.destroyHandler)
    if modelFunctionDepth != 0:
      deferredModelReleases.add(DeferredModelRelease(p: s.p,
        handlers: (if s.hasDestroySignal: @[] else: move(s.handlers))))
      if deferredModelReleaseIdle == 0:
        deferredModelReleaseIdle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE,
          cast[pointer](flushModelReleases), nil, nil)
      `=destroy`(s.handlers)
      return
    # Plain GObject signals belong to the shared Nim state, not a destroy signal.
    if not s.hasDestroySignal:
      for id in s.handlers:
        if g.g_signal_handler_is_connected(s.p, id):
          g.g_signal_handler_disconnect(s.p, id)
    g.g_object_unref(s.p)
  `=destroy`(s.handlers)

proc markDestroyed(instance, data: pointer) {.cdecl.} =
  let s = cast[ObjectState](data)
  s.destroyed = true
  if s.cached:
    # Keep a non-owning tombstone until native finalization. A disposed object
    # may still be retained by a widget after all its Nim handles leave scope.
    g.set_data(cast[g.PGObject](instance), objectStateKey, cast[pointer](1))
  # Break native -> Nim closure -> widget cycles, including self-captures.
  # Run after ordinary destroy handlers so onDestroy callbacks still execute.
  let handlers = s.handlers
  s.handlers = @[]
  for id in handlers:
    if g.g_signal_handler_is_connected(instance, id):
      g.g_signal_handler_disconnect(instance, id)

proc adoptObject(p: pointer, borrowed = false, cache = false,
                 hasDestroySignal = true, sink = true): ObjectState =
  if p == nil: raise newException(ValueError, "GTK returned a nil object")
  if cache:
    let data = g.get_data(cast[g.PGObject](p), objectStateKey)
    if data == cast[pointer](1): raise newException(ValueError, "GTK object is destroyed")
    let existing {.cursor.} = cast[ObjectState](data)
    if existing != nil:
      if existing.destroyed: raise newException(ValueError, "GTK object is destroyed")
      return existing
  new(result)
  result.p = if borrowed: g.g_object_ref(p)
    elif sink: g.g_object_ref_sink(p)
    else: p # Transfer-full, non-floating GObject reference.
  result.cached = cache
  result.hasDestroySignal = hasDestroySignal
  if cache:
    # Weak native data: it must not keep the Nim state (and native object) alive.
    g.set_data(cast[g.PGObject](p), objectStateKey, cast[pointer](result))
  if hasDestroySignal:
    result.destroyHandler = g.g_signal_connect_data(p, "destroy",
      cast[g.TGCallback](markDestroyed), cast[pointer](result), nil,
      g.G_CONNECT_AFTER)

proc adoptWidget(p: pointer): ObjectState = adoptObject(p, cache = true)

proc nativePointer(w: ObjectHandle): pointer =
  requireOutsideModelFunction()
  if w.state == nil or w.state.destroyed:
    raise newException(ValueError, "object is uninitialized or destroyed")
  w.state.p

proc raw*(w: Widget): rawGtk.PWidget =
  ## Borrowed pointer; do not unref it or retain it beyond the wrapper lifetime.
  cast[rawGtk.PWidget](nativePointer(w))

proc raw*(w: Window): rawGtk.PWindow = cast[rawGtk.PWindow](raw(Widget(w)))
proc raw*(w: Button): rawGtk.PButton = cast[rawGtk.PButton](raw(Widget(w)))
proc raw*(w: Label): rawGtk.PLabel = cast[rawGtk.PLabel](raw(Widget(w)))
proc raw*(w: Entry): rawGtk.PEntry = cast[rawGtk.PEntry](raw(Widget(w)))
proc raw*(w: Box): rawGtk.PBox = cast[rawGtk.PBox](raw(Widget(w)))

proc isDestroyed*(w: ObjectHandle): bool = w.state == nil or w.state.destroyed

proc checkedString(s: string): cstring =
  if '\0' in s: raise newException(ValueError, "GTK strings cannot contain NUL")
  s.cstring

proc checkedInt(n: int): g.gint =
  if n < 0 or n > high(g.gint).int:
    raise newException(ValueError, "GTK size must fit a nonnegative gint")
  g.gint(n)

proc checkedUtf8Text(text: string): cstring =
  result = checkedString(text)
  discard checkedInt(text.len)
  if not g.toBool(g.g_utf8_validate(result, g.gssize(text.len), nil)):
    raise newException(ValueError, "GTK text must be valid UTF-8")

proc checkedBoxSpacing(value: int): g.gint =
  if value < 0 or value > high(int16).int:
    raise newException(ValueError, "box spacing must be 0..32767")
  g.gint(value)

proc checkedBoxPadding(value: int): g.guint =
  if value < 0 or value > 65535:
    raise newException(ValueError, "box padding must be 0..65535")
  g.guint(value)

proc init*() =
  ## Initialize GTK without exiting the process if no display is available.
  requireOutsideModelFunction()
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
  result.state = adoptWidget(rawGtk.label_new(checkedUtf8Text(text)))

proc newEntry*(text = ""): Entry =
  let t = checkedUtf8Text(text)
  result.state = adoptWidget(rawGtk.entry_new())
  rawGtk.set_text(result.raw, t)

proc newVBox*(spacing = 0, homogeneous = false): VBox =
  result.state = adoptWidget(rawGtk.vbox_new(g.gboolean(homogeneous), checkedBoxSpacing(spacing)))

proc newHBox*(spacing = 0, homogeneous = false): HBox =
  result.state = adoptWidget(rawGtk.hbox_new(g.gboolean(homogeneous), checkedBoxSpacing(spacing)))

proc show*(w: Widget) = rawGtk.show(w.raw)
proc showAll*(w: Widget) =
  let p = w.raw
  when defined(posix) and not defined(macosx):
    if g.G_TYPE_CHECK_INSTANCE_TYPE(p, rawGtk.print_unix_dialog_get_type()) or
        g.G_TYPE_CHECK_INSTANCE_TYPE(p, rawGtk.page_setup_unix_dialog_get_type()):
      # Native constructors/backends own visibility (conflicts, preview, tabs).
      # Recursive show_all would expose deliberately hidden private controls.
      rawGtk.show(p)
      return
  rawGtk.show_all(p)
proc hide*(w: Widget) = rawGtk.hide(w.raw)
proc focus*(w: Widget) = rawGtk.grab_focus(w.raw)
proc destroy*(w: Widget) =
  ## Idempotent. Destroy containers/windows explicitly to release signal captures.
  if not w.isDestroyed:
    let p = w.raw
    let parent = rawGtk.get_parent(p)
    if parent != nil and g.G_TYPE_CHECK_INSTANCE_TYPE(parent, rawGtk.combo_box_get_type()) and
        g.toBool(rawGtk.get_has_entry(cast[rawGtk.PComboBox](parent))) and
        rawGtk.get_child(cast[rawGtk.PBin](parent)) == p:
      raise newException(ValueError, "editable combo owns its entry; destroy the combo instead")
    rawGtk.destroy(p)

proc `title=`*(w: Window, text: string) = rawGtk.set_title(w.raw, checkedString(text))
proc title*(w: Window): string = $rawGtk.get_title(w.raw)
proc `text=`*(w: Label, text: string) = rawGtk.set_text(w.raw, checkedUtf8Text(text))
proc text*(w: Label): string = $rawGtk.get_text(w.raw)
proc `text=`*(w: Entry, text: string) = rawGtk.set_text(w.raw, checkedUtf8Text(text))
proc text*(w: Entry): string = $rawGtk.get_text(w.raw)
proc focus*(w: Entry)
proc selectAll*(w: Entry)

proc insertText*(w: Entry, text: string) =
  ## Replace the selection, or insert at the cursor; positions are Unicode chars.
  let value = checkedUtf8Text(text)
  let size = checkedInt(text.len)
  let editable = cast[rawGtk.PEditable](w.raw)
  rawGtk.delete_selection(editable)
  if w.isDestroyed: return
  var position = rawGtk.get_position(editable)
  rawGtk.insert_text(editable, value, size, addr position)
  if not w.isDestroyed: rawGtk.set_position(editable, position)

proc backspace*(w: Entry) =
  let editable = cast[rawGtk.PEditable](w.raw)
  var first, last: g.gint
  if rawGtk.get_selection_bounds(editable, addr first, addr last):
    rawGtk.delete_selection(editable)
  else:
    let position = rawGtk.get_position(editable)
    if position > 0:
      rawGtk.delete_text(editable, position - 1, position)
      rawGtk.set_position(editable, position - 1)

proc `text=`*(w: Button, text: string) =
  let label = checkedString(text)
  let p = w.raw
  if g.G_TYPE_CHECK_INSTANCE_TYPE(p, rawGtk.color_button_get_type()) or
      g.G_TYPE_CHECK_INSTANCE_TYPE(p, rawGtk.font_button_get_type()) or
      g.G_TYPE_CHECK_INSTANCE_TYPE(p, rawGtk.scale_button_get_type()):
    raise newException(ValueError, "this button manages its own content")
  rawGtk.set_label(p, label)
proc text*(w: Button): string = $rawGtk.get_label(w.raw)
proc `borderWidth=`*(w: Container, width: int) =
  rawGtk.set_border_width(cast[rawGtk.PContainer](w.raw), g.guint(checkedInt(width)))

proc checkChild(parent: Container, child: Widget) =
  if g.G_TYPE_CHECK_INSTANCE_TYPE(parent.raw, rawGtk.file_chooser_button_get_type()) or
      g.G_TYPE_CHECK_INSTANCE_TYPE(parent.raw, rawGtk.file_chooser_widget_get_type()) or
      g.G_TYPE_CHECK_INSTANCE_TYPE(parent.raw, rawGtk.recent_chooser_widget_get_type()) or
      g.G_TYPE_CHECK_INSTANCE_TYPE(parent.raw, rawGtk.recent_chooser_menu_get_type()):
    raise newException(ValueError, "chooser controls manage their own content")
  if rawGtk.IS_WINDOW(child.raw) or g.toBool(rawGtk.WIDGET_TOPLEVEL(child.raw)):
    raise newException(ValueError, "a top-level widget cannot be a child")
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
  if rawGtk.IS_SEPARATOR_MENU_ITEM(parent.raw) or rawGtk.IS_TEAROFF_MENU_ITEM(parent.raw) or
      g.G_TYPE_CHECK_INSTANCE_TYPE(parent.raw, rawGtk.separator_tool_item_get_type()) or
      g.G_TYPE_CHECK_INSTANCE_TYPE(parent.raw, rawGtk.tool_button_get_type()) or
      g.G_TYPE_CHECK_INSTANCE_TYPE(parent.raw, rawGtk.assistant_get_type()):
    raise newException(ValueError, "this widget manages its own content or cannot have children")
  if rawGtk.get_child(cast[rawGtk.PBin](parent.raw)) != nil:
    raise newException(ValueError, "container already has a child")
  # GtkScrolledWindow requires the GTK2 scroll-adjustments protocol. Adapt
  # ordinary widgets even when this parent has been upcast to Bin.
  if rawGtk.IS_SCROLLED_WINDOW(parent.raw) and
      g.g_signal_lookup("set-scroll-adjustments", g.G_TYPE_FROM_INSTANCE(child.raw)) == 0:
    rawGtk.add_with_viewport(cast[rawGtk.PScrolledWindow](parent.raw), child.raw)
  else:
    rawGtk.add(cast[rawGtk.PContainer](parent.raw), child.raw)

proc packStart*(box: Box, child: Widget, options = packExpandWidget, padding = 0) =
  checkChild(box, child)
  let pad = checkedBoxPadding(padding)
  rawGtk.pack_start(box.raw, child.raw, g.gboolean(options != packShrink),
    g.gboolean(options == packExpandWidget), pad)

proc packEnd*(box: Box, child: Widget, options = packExpandWidget, padding = 0) =
  checkChild(box, child)
  let pad = checkedBoxPadding(padding)
  rawGtk.pack_end(box.raw, child.raw, g.gboolean(options != packShrink),
    g.gboolean(options == packExpandWidget), pad)

proc releaseCallback(data: pointer, closure: g.PGClosure) {.cdecl.} =
  let callback = cast[Callback](data)
  callback.cancelled = true
  callback.fn = nil
  let idle = callback.idle
  callback.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  GC_unref(callback)

proc reportSignalError(error: ref Exception) =
  # Even a closed stderr must not unwind through C.
  try:
    stderr.writeLine("gtk2 signal callback: " & error.msg)
  except Exception:
    discard

proc releaseCallbackIdle(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[Callback](data))
proc dispatchCallbackIdle(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let callback = cast[Callback](data)
    callback.idle = 0
    let count = callback.pending
    callback.pending = 0
    for i in 0..<count:
      if callback.cancelled: break
      let fn = callback.fn
      try: fn()
      except Exception as error: reportSignalError(error)
    g.gbool(false)
proc signalThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  # GTK callbacks execute only on the UI thread. The legacy raw binding marks
  # callbacks gcsafe, though user closures may access UI-thread-local state.
  {.cast(gcsafe).}:
    # Copy the closure before calling: the callback may disconnect itself.
    let callback = cast[Callback](data)
    if callback.deferForEntryPolicy and (callback.idle != 0 or
        g.get_data(cast[g.PGObject](instance), completionDeferredKey) != nil or
        g.get_data(cast[g.PGObject](instance), entryPolicyDeferredKey) != nil):
      if callback.coalesce: callback.pending = 1
      else: inc callback.pending
      if callback.idle == 0:
        GC_ref(callback)
        callback.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchCallbackIdle),
          cast[pointer](callback), cast[pointer](releaseCallbackIdle))
      return
    let fn = callback.fn
    try:
      fn()
    except Exception as error:
      # Never unwind a Nim exception through the GTK C stack.
      reportSignalError(error)

proc connect(w: ObjectHandle, name: cstring, fn: proc () {.closure.}, after = false): Connection =
  let p = nativePointer(w)
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let isEntry = g.G_TYPE_CHECK_INSTANCE_TYPE(p, rawGtk.entry_get_type())
  let isCombo = g.G_TYPE_CHECK_INSTANCE_TYPE(p, rawGtk.combo_box_get_type())
  let callback = Callback(fn: fn, coalesce: $name == "changed",
    deferForEntryPolicy: (isEntry and $name in ["changed", "activate"]) or
      (isCombo and $name == "changed"))
  GC_ref(callback)
  let id = g.g_signal_connect_data(p, name, cast[g.TGCallback](signalThunk),
    cast[pointer](callback), releaseCallback,
    (if after: g.G_CONNECT_AFTER else: g.TGConnectFlags(0)))
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)

proc onClicked*(w: Button, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "clicked", fn)
proc onChanged*(w: Entry, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "changed", fn)
proc onActivate*(w: Entry, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "activate", fn)
proc onDestroy*(w: ObjectHandle, fn: proc () {.closure.}): Connection {.discardable.} =
  discard nativePointer(w)
  if not w.state.hasDestroySignal:
    raise newException(ValueError, "this GObject has no destroy signal; disconnect its connections explicitly")
  connect(w, "destroy", fn)

proc connected*(c: Connection): bool =
  requireOutsideModelFunction()
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

proc disconnectObjectSignals(w: ObjectHandle) =
  # Disconnect every gtk2 callback tracked by this shared object state.
  let p = nativePointer(w)
  let handlers = w.state.handlers
  w.state.handlers = @[]
  for id in handlers:
    if g.g_signal_handler_is_connected(p, id): g.g_signal_handler_disconnect(p, id)

proc click*(w: Button) = rawGtk.clicked(w.raw)
proc quit*() =
  requireOutsideModelFunction()
  if rawGtk.main_level() > 0: rawGtk.main_quit()

proc run*(w: Window) =
  ## Show the window and run until it is destroyed. Call init() first.
  if g.G_TYPE_CHECK_INSTANCE_TYPE(w.raw, rawGtk.offscreen_window_get_type()):
    raise newException(ValueError, "run an onscreen application window instead")
  let connection = w.onDestroy(proc () = quit())
  try:
    w.showAll()
    rawGtk.main()
  finally:
    connection.disconnect()

include gtk2/controls
include gtk2/layout
include gtk2/inputs
include gtk2/feedback
include gtk2/dialogs
include gtk2/text
include gtk2/pixbufs
include gtk2/models
include gtk2/trees
include gtk2/proxies
include gtk2/icons
include gtk2/selectors
include gtk2/ranges
include gtk2/containers
include gtk2/menus
include gtk2/toolbars
include gtk2/positioned
include gtk2/choosers
include gtk2/assistant
include gtk2/filechoosers
include gtk2/recents
include gtk2/displays
include gtk2/printing
include gtk2/desktop
include gtk2/drawing
include gtk2/richtext
include gtk2/editableviews
include gtk2/clipboard
include gtk2/uriclipboard
include gtk2/imageclipboard
include gtk2/imagerequests
include gtk2/binaryclipboard
include gtk2/binaryrequests
include gtk2/textdrag
include gtk2/uridrag
include gtk2/binarydrag
include gtk2/imagedrag
include gtk2/dragicons
include gtk2/actions
include gtk2/radioactions
include gtk2/builder
include gtk2/uimanager
include gtk2/completion
include gtk2/completionmatch
include gtk2/completionactions
include gtk2/entryselection
include gtk2/entryobservations
include gtk2/entrypolicy
include gtk2/entryicons
include gtk2/entryediting
include gtk2/entryprogress
include gtk2/modelfunctions
include gtk2/iconselection
include gtk2/textanchors
include gtk2/textserialization
include gtk2/richclipboard
