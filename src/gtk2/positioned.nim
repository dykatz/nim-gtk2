# Included by gtk2.nim. Positioned scrolling and detachable single-child content.
type
  Layout* = object of Container
  HandleBox* = object of Bin
  HandlePosition* = enum handleLeft, handleRight, handleTop, handleBottom
  SnapEdge* = enum snapAutomatic = -1, snapLeft, snapRight, snapTop, snapBottom

proc raw*(w: Layout): rawGtk.PLayout = cast[rawGtk.PLayout](raw(Widget(w)))
proc raw*(w: HandleBox): rawGtk.PHandleBox = cast[rawGtk.PHandleBox](raw(Widget(w)))
proc canvasDimension(value: int): g.guint = g.guint(checkedInt(value))
proc setSize*(w: Layout, width, height: int) =
  let a = canvasDimension(width)
  let b = canvasDimension(height)
  rawGtk.set_size(w.raw, a, b)
proc dimensions*(w: Layout): tuple[width, height: int] =
  var width, height: g.guint
  rawGtk.get_size(w.raw, addr width, addr height)
  (width.int, height.int)
proc newLayout*(width = 100, height = 100): Layout =
  let a = canvasDimension(width)
  let b = canvasDimension(height)
  result.state = adoptWidget(rawGtk.layout_new(nil, nil))
  rawGtk.set_size(result.raw, a, b)
proc newLayout*(horizontalAdjustment, verticalAdjustment: Adjustment, width = 100, height = 100): Layout =
  let a = canvasDimension(width)
  let b = canvasDimension(height)
  let h = horizontalAdjustment.raw
  let v = verticalAdjustment.raw
  result.state = adoptWidget(rawGtk.layout_new(h, v))
  rawGtk.set_size(result.raw, a, b)
proc horizontalAdjustment*(w: Layout): Adjustment = ownedAdjustment(rawGtk.get_hadjustment(w.raw))
proc verticalAdjustment*(w: Layout): Adjustment = ownedAdjustment(rawGtk.get_vadjustment(w.raw))
proc `horizontalAdjustment=`*(w: Layout, value: Adjustment) = rawGtk.set_hadjustment(w.raw, value.raw)
proc `verticalAdjustment=`*(w: Layout, value: Adjustment) = rawGtk.set_vadjustment(w.raw, value.raw)
proc put*(w: Layout, child: Widget, x, y: int) =
  checkChild(w, child)
  if menuAncestorContains(cast[rawGtk.PWidget](w.raw), child.raw):
    raise newException(ValueError, "layout insertion would contain an ownership cycle")
  let a = signedCoordinate(x)
  let b = signedCoordinate(y)
  rawGtk.put(w.raw, child.raw, a, b)
proc move*(w: Layout, child: Widget, x, y: int) =
  checkMember(w, child)
  let a = signedCoordinate(x)
  let b = signedCoordinate(y)
  rawGtk.move(w.raw, child.raw, a, b)
proc position*(w: Layout, child: Widget): tuple[x, y: int] =
  checkMember(w, child)
  (childInt(w, child, "x"), childInt(w, child, "y"))
proc childCount*(w: Layout): int =
  let children = rawGtk.get_children(cast[rawGtk.PContainer](w.raw))
  defer: g.free(children)
  var node = children
  while node != nil:
    inc result
    node = node.next
proc childAt*(w: Layout, index: int): Widget =
  if index < 0: raise newException(ValueError, "layout child index out of bounds")
  let children = rawGtk.get_children(cast[rawGtk.PContainer](w.raw))
  defer: g.free(children)
  var node = children
  var i = 0
  while node != nil and i < index:
    node = node.next
    inc i
  if node == nil: raise newException(ValueError, "layout child index out of bounds")
  result.state = adoptObject(node.data, borrowed = true, cache = true)

proc shadow*(w: HandleBox): ShadowStyle = ShadowStyle(rawGtk.get_shadow_type(w.raw))
proc `shadow=`*(w: HandleBox, value: ShadowStyle) = rawGtk.set_shadow_type(w.raw, rawGtk.TShadowType(ord(value)))
proc handlePosition*(w: HandleBox): HandlePosition = HandlePosition(rawGtk.get_handle_position(w.raw))
proc `handlePosition=`*(w: HandleBox, value: HandlePosition) = rawGtk.set_handle_position(w.raw, rawGtk.TPositionType(ord(value)))
proc snapEdge*(w: HandleBox): SnapEdge = SnapEdge(cast[cint](rawGtk.get_snap_edge(w.raw)))
proc `snapEdge=`*(w: HandleBox, value: SnapEdge) =
  # GTK2 documents -1 as automatic, outside GtkPositionType's named members.
  rawGtk.set_snap_edge(w.raw, cast[rawGtk.TPositionType](cint(ord(value))))
proc childDetached*(w: HandleBox): bool = g.toBool(rawGtk.get_child_detached(w.raw))
proc hasChild*(w: HandleBox): bool = rawGtk.get_child(cast[rawGtk.PBin](w.raw)) != nil
proc child*(w: HandleBox): Widget =
  let p = rawGtk.get_child(cast[rawGtk.PBin](w.raw))
  if p != nil: result.state = adoptObject(p, borrowed = true, cache = true)
proc newHandleBox*(handlePosition = handleLeft, shadow = shadowOut, snapEdge = snapAutomatic): HandleBox =
  result.state = adoptWidget(rawGtk.handle_box_new())
  result.handlePosition = handlePosition
  result.shadow = shadow
  result.snapEdge = snapEdge

# GTK's drag handlers continue using native windows after emitting attachment
# signals. Deliver coalesced owning child snapshots at idle, not inside a drag.
type HandleChildBinding = ref object
  fn: proc (child: Widget) {.closure.}
  child: Widget
  active, pending: bool
  idle: g.guint
proc releaseHandleIdle(data: pointer) {.cdecl.} = GC_unref(cast[HandleChildBinding](data))
proc releaseHandleChild(data: pointer, closure: g.PGClosure) {.cdecl.} =
  let binding = cast[HandleChildBinding](data)
  binding.active = false
  binding.pending = false
  binding.fn = nil
  binding.child = Widget()
  if binding.idle != 0:
    discard g.g_source_remove(binding.idle)
    binding.idle = 0
  GC_unref(binding)
proc dispatchHandleChild(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[HandleChildBinding](data)
    if binding.active and binding.pending:
      let child = binding.child
      let fn = binding.fn
      binding.child = Widget()
      binding.pending = false
      if not child.isDestroyed:
        try: fn(child)
        except Exception as error: reportSignalError(error)
    if not binding.active or not binding.pending:
      binding.idle = 0
      return g.gbool(false)
    g.gbool(true)
proc handleChildThunk(instance, child, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[HandleChildBinding](data)
    try:
      if not binding.active or child == nil: return
      var snapshot: Widget
      snapshot.state = adoptObject(child, borrowed = true, cache = true)
      binding.child = snapshot
      binding.pending = true
      if binding.idle == 0:
        GC_ref(binding)
        binding.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE,
          cast[pointer](dispatchHandleChild), cast[pointer](binding), cast[pointer](releaseHandleIdle))
    except Exception as error: reportSignalError(error)
proc connectHandleChild(w: HandleBox, signal: cstring, fn: proc (child: Widget) {.closure.}): Connection =
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let binding = HandleChildBinding(fn: fn, active: true)
  GC_ref(binding)
  let id = g.g_signal_connect_data(p, signal, cast[g.TGCallback](handleChildThunk),
    cast[pointer](binding), releaseHandleChild, g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
proc onChildAttached*(w: HandleBox, fn: proc (child: Widget) {.closure.}): Connection {.discardable.} =
  ## Deferred/coalesced at UI idle. A destroyed child or disconnected observer
  ## is not delivered. The owning payload describes an event, not current state.
  connectHandleChild(w, "child-attached", fn)
proc onChildDetached*(w: HandleBox, fn: proc (child: Widget) {.closure.}): Connection {.discardable.} =
  connectHandleChild(w, "child-detached", fn)
