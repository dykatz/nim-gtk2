# Included by gtk2.nim. Synchronous rendering and copied input event payloads.
type
  WidgetAllocation* = tuple[x, y, width, height: int]
  ModifierMask* = distinct uint32
  ButtonEventKind* = enum buttonPress, buttonDoublePress, buttonTriplePress, buttonRelease
  ButtonEvent* = object
    kind*: ButtonEventKind
    x*, y*, rootX*, rootY*: float64
    button*, time*: uint32
    modifiers*: ModifierMask
  MotionEvent* = object
    x*, y*, rootX*, rootY*: float64
    time*: uint32
    modifiers*: ModifierMask
    isHint*: bool
  ScrollDirection* = enum scrollUp, scrollDown, scrollLeft, scrollRight
  ScrollEvent* = object
    x*, y*, rootX*, rootY*: float64
    time*: uint32
    modifiers*: ModifierMask
    direction*: ScrollDirection
  KeyEvent* = object
    keyval*, time*: uint32
    modifiers*: ModifierMask
    hardwareKeycode*: uint16
    group*: uint8
  DrawInfo* = object
    width*, height*: int
    damaged*: WidgetAllocation
  DrawScope = ref object
    p: ptr rawCairo.Context
    owner: ObjectState
  DrawContext* = object
    scope: DrawScope
  DrawBinding = ref object
    fn: proc (context: DrawContext, info: DrawInfo) {.closure.}
  InputBinding[T] = ref object
    fn: proc (event: T): bool {.closure.}

const
  keyLeft* = 0xff51'u32
  keyUp* = 0xff52'u32
  keyRight* = 0xff53'u32
  keyDown* = 0xff54'u32
  keyEscape* = 0xff1b'u32
  keyReturn* = 0xff0d'u32
  keySpace* = 0x20'u32
  modifierShift* = ModifierMask(1'u32 shl 0)
  modifierControl* = ModifierMask(1'u32 shl 2)
  modifierAlt* = ModifierMask(1'u32 shl 3)
  modifierButton1* = ModifierMask(1'u32 shl 8)
  modifierButton2* = ModifierMask(1'u32 shl 9)
  modifierButton3* = ModifierMask(1'u32 shl 10)
  modifierSuper* = ModifierMask(1'u32 shl 26)
proc `==`*(a, b: ModifierMask): bool {.borrow.}
proc `or`*(a, b: ModifierMask): ModifierMask = ModifierMask(uint32(a) or uint32(b))
proc has*(value, flags: ModifierMask): bool = (uint32(value) and uint32(flags)) == uint32(flags)
proc unicode*(event: KeyEvent): uint32 = rawGdk.keyval_to_unicode(g.guint(event.keyval)).uint32
proc allocation*(w: Widget): WidgetAllocation =
  var a: rawGtk.TAllocation
  rawGtk.get_allocation(w.raw, addr a)
  (a.x.int, a.y.int, a.width.int, a.height.int)
proc queueDrawArea*(w: Widget, x, y, width, height: int) =
  let p = w.raw
  let a = signedCoordinate(x)
  let b = signedCoordinate(y)
  let dx = checkedInt(width)
  let dy = checkedInt(height)
  if x.int64 + width.int64 > high(g.gint).int64 or y.int64 + height.int64 > high(g.gint).int64:
    raise newException(ValueError, "redraw area endpoints exceed gint")
  if dx > 0 and dy > 0: rawGtk.queue_draw_area(p, a, b, dx, dy)
proc canFocus*(w: Widget): bool = g.toBool(rawGtk.get_can_focus(w.raw))
proc `canFocus=`*(w: Widget, value: bool) = rawGtk.set_can_focus(w.raw, g.gbool(value))

proc raw*(c: DrawContext): ptr rawCairo.Context =
  ## Borrowed for this draw callback ONLY. Neither destroy nor retain this pointer.
  if c.scope == nil or c.scope.p == nil or c.scope.owner.destroyed:
    raise newException(ValueError, "drawing context is outside its live callback scope")
  c.scope.p
proc setSource*(c: DrawContext, color: Color) =
  rawCairo.setSourceRgba(c.raw, color.red.float64 / 65535, color.green.float64 / 65535,
    color.blue.float64 / 65535, color.alpha.float64 / 65535)
proc setLineWidth*(c: DrawContext, width: float64) =
  let value = finite(width)
  if value <= 0: raise newException(ValueError, "line width must be positive")
  rawCairo.setLineWidth(c.raw, value)
proc moveTo*(c: DrawContext, x, y: float64) = rawCairo.moveTo(c.raw, finite(x), finite(y))
proc lineTo*(c: DrawContext, x, y: float64) = rawCairo.lineTo(c.raw, finite(x), finite(y))
proc rectangle*(c: DrawContext, x, y, width, height: float64) =
  let a = finite(x)
  let b = finite(y)
  let w = finite(width)
  let h = finite(height)
  if w < 0 or h < 0: raise newException(ValueError, "rectangle dimensions must be nonnegative")
  rawCairo.rectangle(c.raw, a, b, w, h)
proc circle*(c: DrawContext, x, y, radius: float64) =
  let a = finite(x)
  let b = finite(y)
  let r = finite(radius)
  if r < 0: raise newException(ValueError, "circle radius must be nonnegative")
  rawCairo.arc(c.raw, a, b, r, 0, 6.283185307179586)
proc paint*(c: DrawContext) = rawCairo.paint(c.raw)
proc fill*(c: DrawContext) = rawCairo.fill(c.raw)
proc stroke*(c: DrawContext) = rawCairo.stroke(c.raw)
proc save*(c: DrawContext) = rawCairo.save(c.raw)
proc restore*(c: DrawContext) = rawCairo.restore(c.raw)

proc releaseDraw(data: pointer, closure: g.PGClosure) {.cdecl.} = GC_unref(cast[DrawBinding](data))
proc drawThunk(instance: rawGtk.PWidget, event: rawGdk.PEventExpose, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[DrawBinding](data).fn
    var owner: ObjectState
    try: owner = adoptObject(instance, borrowed = true, cache = true)
    except Exception as error:
      reportSignalError(error)
      return g.gbool(false)
    if event == nil or owner.destroyed: return g.gbool(false)
    let window = rawGtk.get_window(instance)
    if window == nil or event.window != window: return g.gbool(false)
    discard g.g_object_ref(instance)
    defer: g.g_object_unref(instance)
    let scope = DrawScope(owner: owner)
    try:
      scope.p = rawGdk.cairo_create(cast[rawGdk.PDrawable](window))
      if scope.p == nil: raise newException(IOError, "could not create a native Cairo context")
      rawCairo.checkStatus(rawCairo.status(scope.p))
      if event.region != nil: rawGdk.cairo_region(scope.p, event.region)
      else:
        rawCairo.rectangle(scope.p, event.area.x.float64, event.area.y.float64,
          event.area.width.float64, event.area.height.float64)
      rawCairo.clip(scope.p)
      var a: rawGtk.TAllocation
      rawGtk.get_allocation(instance, addr a)
      fn(DrawContext(scope: scope), DrawInfo(width: a.width.int, height: a.height.int,
        damaged: (event.area.x.int, event.area.y.int, event.area.width.int, event.area.height.int)))
      rawCairo.checkStatus(rawCairo.status(scope.p))
    except Exception as error: reportSignalError(error)
    finally:
      let p = scope.p
      scope.p = nil
      scope.owner = nil
      if p != nil: rawCairo.destroy(p)
    g.gbool(owner.destroyed)
proc onDraw*(w: DrawingArea, fn: proc (context: DrawContext, info: DrawInfo) {.closure.}): Connection {.discardable.} =
  let p = Widget(w).raw
  if fn == nil: raise newException(ValueError, "draw callback cannot be nil")
  rawGtk.add_events(p, rawGdk.EXPOSURE_MASK)
  let binding = DrawBinding(fn: fn)
  GC_ref(binding)
  let id = g.g_signal_connect_data(p, "expose-event", cast[g.TGCallback](drawThunk),
    cast[pointer](binding), releaseDraw, g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)

proc copyInput(event: rawGdk.PEvent, _: typedesc[ButtonEvent]): ButtonEvent =
  let e = cast[rawGdk.PEventButton](event)
  result = ButtonEvent(x: e.x, y: e.y, rootX: e.x_root, rootY: e.y_root,
    button: e.button.uint32, time: e.time.uint32, modifiers: ModifierMask(e.state))
  case e.type
  of rawGdk.TWO_BUTTON_PRESS: result.kind = buttonDoublePress
  of rawGdk.THREE_BUTTON_PRESS: result.kind = buttonTriplePress
  of rawGdk.BUTTON_RELEASE: result.kind = buttonRelease
  else: result.kind = buttonPress
proc copyInput(event: rawGdk.PEvent, _: typedesc[MotionEvent]): MotionEvent =
  let e = cast[rawGdk.PEventMotion](event)
  MotionEvent(x: e.x, y: e.y, rootX: e.x_root, rootY: e.y_root, time: e.time.uint32,
    modifiers: ModifierMask(e.state), isHint: e.is_hint != 0)
proc copyInput(event: rawGdk.PEvent, _: typedesc[ScrollEvent]): ScrollEvent =
  let e = cast[rawGdk.PEventScroll](event)
  ScrollEvent(x: e.x, y: e.y, rootX: e.x_root, rootY: e.y_root, time: e.time.uint32,
    modifiers: ModifierMask(e.state), direction: ScrollDirection(ord(e.direction)))
proc copyInput(event: rawGdk.PEvent, _: typedesc[KeyEvent]): KeyEvent =
  let e = cast[rawGdk.PEventKey](event)
  KeyEvent(keyval: e.keyval.uint32, time: e.time.uint32, modifiers: ModifierMask(e.state),
    hardwareKeycode: e.hardware_keycode.uint16, group: e.group.uint8)
proc releaseInput[T](data: pointer, closure: g.PGClosure) {.cdecl.} = GC_unref(cast[InputBinding[T]](data))
proc inputThunk[T](instance: pointer, event: rawGdk.PEvent, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[InputBinding[T]](data).fn
    var owner: ObjectState
    try: owner = adoptObject(instance, borrowed = true, cache = true)
    except Exception as error:
      reportSignalError(error)
      return g.gbool(false)
    if event == nil or owner.destroyed: return g.gbool(false)
    discard g.g_object_ref(instance)
    defer: g.g_object_unref(instance)
    var handled = false
    try: handled = fn(copyInput(event, T))
    except Exception as error: reportSignalError(error)
    # Never invoke GTK's default handler on an object destroyed by this callback.
    g.gbool(handled or owner.destroyed)
proc connectInput[T](w: Widget, name: cstring, mask: g.gint,
                     fn: proc (event: T): bool {.closure.}): Connection =
  let p = w.raw
  if fn == nil: raise newException(ValueError, "input callback cannot be nil")
  rawGtk.add_events(p, mask)
  let binding = InputBinding[T](fn: fn)
  GC_ref(binding)
  let id = g.g_signal_connect_data(p, name, cast[g.TGCallback](inputThunk[T]),
    cast[pointer](binding), releaseInput[T], g.TGConnectFlags(0))
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
proc onButtonPress*(w: Widget, fn: proc (event: ButtonEvent): bool {.closure.}): Connection {.discardable.} =
  connectInput(w, "button-press-event", rawGdk.BUTTON_PRESS_MASK, fn)
proc onButtonRelease*(w: Widget, fn: proc (event: ButtonEvent): bool {.closure.}): Connection {.discardable.} =
  connectInput(w, "button-release-event", rawGdk.BUTTON_RELEASE_MASK, fn)
proc onMotion*(w: Widget, fn: proc (event: MotionEvent): bool {.closure.}): Connection {.discardable.} =
  connectInput(w, "motion-notify-event", rawGdk.POINTER_MOTION_MASK, fn)
proc onScroll*(w: Widget, fn: proc (event: ScrollEvent): bool {.closure.}): Connection {.discardable.} =
  connectInput(w, "scroll-event", rawGdk.SCROLL_MASK, fn)
proc onKeyPress*(w: Widget, fn: proc (event: KeyEvent): bool {.closure.}): Connection {.discardable.} =
  connectInput(w, "key-press-event", rawGdk.KEY_PRESS_MASK, fn)
proc onKeyRelease*(w: Widget, fn: proc (event: KeyEvent): bool {.closure.}): Connection {.discardable.} =
  connectInput(w, "key-release-event", rawGdk.KEY_RELEASE_MASK, fn)
