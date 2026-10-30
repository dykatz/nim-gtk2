# Included by gtk2.nim. Native ranges share owning Adjustment handles.
type
  Range* = object of Widget
  Scale* = object of Range
  HScale* = object of Scale
  VScale* = object of Scale
  Scrollbar* = object of Range
  HScrollbar* = object of Scrollbar
  VScrollbar* = object of Scrollbar
  Arrow* = object of Widget
  ValuePosition* = enum
    valueLeft, valueRight, valueTop, valueBottom
  ArrowDirection* = enum
    arrowUp, arrowDown, arrowLeft, arrowRight, arrowNone

proc raw*(w: Range): rawGtk.PRange = cast[rawGtk.PRange](raw(Widget(w)))
proc raw*(w: Scale): rawGtk.PScale = cast[rawGtk.PScale](raw(Widget(w)))
proc raw*(w: HScale): rawGtk.PHScale = cast[rawGtk.PHScale](raw(Widget(w)))
proc raw*(w: VScale): rawGtk.PVScale = cast[rawGtk.PVScale](raw(Widget(w)))
proc raw*(w: Scrollbar): rawGtk.PScrollbar = cast[rawGtk.PScrollbar](raw(Widget(w)))
proc raw*(w: HScrollbar): rawGtk.PHScrollbar = cast[rawGtk.PHScrollbar](raw(Widget(w)))
proc raw*(w: VScrollbar): rawGtk.PVScrollbar = cast[rawGtk.PVScrollbar](raw(Widget(w)))
proc raw*(w: Arrow): rawGtk.PArrow = cast[rawGtk.PArrow](raw(Widget(w)))

proc checkedScaleRange(lower, upper, step: float64) =
  checkBounds(lower, upper)
  if lower == upper or not (finite(step) > 0):
    raise newException(ValueError, "scale constructors require lower < upper and a positive step")
  discard finite(step * 10.0)

proc newHScale*(adjustment: Adjustment): HScale =
  result.state = adoptWidget(rawGtk.hscale_new(adjustment.raw))
proc newVScale*(adjustment: Adjustment): VScale =
  result.state = adoptWidget(rawGtk.vscale_new(adjustment.raw))
proc newHScale*(lower = 0.0, upper = 100.0, step = 1.0): HScale =
  checkedScaleRange(lower, upper, step)
  result.state = adoptWidget(rawGtk.hscale_new(lower, upper, step))
proc newVScale*(lower = 0.0, upper = 100.0, step = 1.0): VScale =
  checkedScaleRange(lower, upper, step)
  result.state = adoptWidget(rawGtk.vscale_new(lower, upper, step))
proc newHScrollbar*(adjustment: Adjustment): HScrollbar =
  result.state = adoptWidget(rawGtk.hscrollbar_new(adjustment.raw))
proc newVScrollbar*(adjustment: Adjustment): VScrollbar =
  result.state = adoptWidget(rawGtk.vscrollbar_new(adjustment.raw))
proc newHScrollbar*(value = 0.0, lower = 0.0, upper = 100.0,
                   stepIncrement = 1.0, pageIncrement = 10.0, pageSize = 10.0): HScrollbar =
  newHScrollbar(newAdjustment(value, lower, upper, stepIncrement, pageIncrement, pageSize))
proc newVScrollbar*(value = 0.0, lower = 0.0, upper = 100.0,
                   stepIncrement = 1.0, pageIncrement = 10.0, pageSize = 10.0): VScrollbar =
  newVScrollbar(newAdjustment(value, lower, upper, stepIncrement, pageIncrement, pageSize))

proc adjustment*(w: Range): Adjustment = ownedAdjustment(rawGtk.get_adjustment(w.raw))
proc `adjustment=`*(w: Range, value: Adjustment) = rawGtk.set_adjustment(w.raw, value.raw)
proc value*(w: Range): float64 = rawGtk.get_value(w.raw)
proc `value=`*(w: Range, value: float64) = rawGtk.set_value(w.raw, finite(value))
proc inverted*(w: Range): bool = g.toBool(rawGtk.get_inverted(w.raw))
proc `inverted=`*(w: Range, value: bool) = rawGtk.set_inverted(w.raw, g.gbool(value))
proc flippable*(w: Range): bool = g.toBool(rawGtk.get_flippable(w.raw))
proc `flippable=`*(w: Range, value: bool) = rawGtk.set_flippable(w.raw, g.gbool(value))
proc setBounds*(w: Range, lower, upper: float64) =
  ## Bounds edits preserve page size; refuse a span smaller than the current page.
  checkBounds(lower, upper)
  if lower == upper: raise newException(ValueError, "range bounds must have a positive span")
  let a = w.adjustment
  if a.pageSize > upper - lower:
    raise newException(ValueError, "range span must not be smaller than its page size")
  a.configure(a.value, lower, upper, a.stepIncrement, a.pageIncrement, a.pageSize)
proc setIncrements*(w: Range, step, page: float64) =
  let s = nonnegative(step)
  let p = nonnegative(page)
  rawGtk.set_increments(w.raw, s, p)

proc scaleDigits(value: int): g.gint =
  if value < -1 or value > 64:
    raise newException(ValueError, "scale digits must be -1 (unrounded) or 0..64")
  g.gint(value)
proc digits*(w: Scale): int = rawGtk.get_digits(w.raw).int
proc `digits=`*(w: Scale, value: int) = rawGtk.set_digits(w.raw, scaleDigits(value))
proc drawValue*(w: Scale): bool = g.toBool(rawGtk.get_draw_value(w.raw))
proc `drawValue=`*(w: Scale, value: bool) = rawGtk.set_draw_value(w.raw, g.gbool(value))
proc valuePosition*(w: Scale): ValuePosition = ValuePosition(rawGtk.get_value_pos(w.raw))
proc `valuePosition=`*(w: Scale, value: ValuePosition) =
  rawGtk.set_value_pos(w.raw, rawGtk.TPositionType(ord(value)))
proc addMark*(w: Scale, value: float64, text = "", position = valueBottom) =
  ## Plain UTF-8 text, escaped before GTK's markup-taking API; empty means tick only.
  let v = finite(value)
  let label = checkedUtf8Text(text)
  let p = w.raw
  if text.len == 0:
    rawGtk.add_mark(p, v, rawGtk.TPositionType(ord(position)), nil)
  else:
    let escaped = g.g_markup_escape_text(label, g.gssize(text.len))
    if escaped == nil: raise newException(OutOfMemDefect, "could not escape mark label")
    defer: g.g_free(escaped)
    rawGtk.add_mark(p, v, rawGtk.TPositionType(ord(position)), escaped)
proc clearMarks*(w: Scale) = rawGtk.clear_marks(w.raw)

type RangeValueBinding = ref object
  fn: proc (value: float64) {.closure.}
  range: rawGtk.PRange # Borrowed: the primary connection belongs to this widget.
  adjustment: rawGtk.PAdjustment # One retained reference while subscribed.
  handler: culong
  lastValue, pendingValue: float64
  pending, active: bool
  idle: g.guint

proc detachRangeValue(binding: RangeValueBinding) =
  let p = binding.adjustment
  let id = binding.handler
  binding.adjustment = nil
  binding.handler = 0
  if p != nil:
    if g.g_signal_handler_is_connected(p, id): g.g_signal_handler_disconnect(p, id)
    g.g_object_unref(p)
proc releaseRangeValue(data: pointer, closure: g.PGClosure) {.cdecl.} =
  let binding = cast[RangeValueBinding](data)
  binding.active = false
  detachRangeValue(binding)
  if binding.idle != 0:
    discard g.g_source_remove(binding.idle)
    binding.idle = 0
  GC_unref(binding)
proc releaseRangeIdle(data: pointer) {.cdecl.} = GC_unref(cast[RangeValueBinding](data))
proc dispatchRangeValue(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[RangeValueBinding](data)
    if binding.active and binding.pending:
      let value = binding.pendingValue
      binding.pending = false
      let fn = binding.fn # May disconnect/destroy its own emitter.
      try: fn(value)
      except Exception as error: reportSignalError(error)
    if not binding.active or not binding.pending:
      binding.idle = 0
      return g.gbool(false)
    g.gbool(true)
proc reportRangeValue(binding: RangeValueBinding) =
  let value = rawGtk.get_value(binding.range)
  if value != binding.lastValue:
    binding.lastValue = value
    binding.pendingValue = value
    binding.pending = true
    if binding.idle == 0:
      GC_ref(binding)
      binding.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE,
        cast[pointer](dispatchRangeValue), cast[pointer](binding), cast[pointer](releaseRangeIdle))
proc rangeAdjustmentValueThunk(instance, pspec, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[RangeValueBinding](data)
    try: reportRangeValue(binding)
    except Exception as error: reportSignalError(error)
proc bindRangeValue(binding: RangeValueBinding) =
  let p = rawGtk.get_adjustment(binding.range)
  if p == binding.adjustment: return
  detachRangeValue(binding)
  discard g.g_object_ref(p)
  binding.adjustment = p
  binding.handler = g.g_signal_connect_data(p, "notify::value",
    cast[g.TGCallback](rangeAdjustmentValueThunk), cast[pointer](binding), nil, g.G_CONNECT_AFTER)
proc rangeAdjustmentNotify(instance, pspec, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[RangeValueBinding](data)
    try:
      bindRangeValue(binding)
      reportRangeValue(binding)
    except Exception as error: reportSignalError(error)
proc onValueChanged*(w: Range, fn: proc (value: float64) {.closure.}): Connection {.discardable.} =
  ## Deferred, coalesced numeric changes on the UI context. GTK2 input handlers
  ## access the range/adjustment after native signals; idle delivery makes it
  ## safe to close/destroy widgets here. Replacements are followed automatically.
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let binding = RangeValueBinding(fn: fn, range: p, lastValue: rawGtk.get_value(p), active: true)
  bindRangeValue(binding)
  GC_ref(binding)
  let id = g.g_signal_connect_data(p, "notify::adjustment",
    cast[g.TGCallback](rangeAdjustmentNotify), cast[pointer](binding), releaseRangeValue,
    g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)

proc arrowEnum(w: Arrow, name: cstring, kind: g.GType): cint =
  let p = w.raw
  var value: g.TGValue
  discard g.init(addr value, kind)
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](p), name, addr value)
  g.get_enum(addr value)
proc newArrow*(direction = arrowDown, shadow = shadowOut): Arrow =
  result.state = adoptWidget(rawGtk.arrow_new(rawGtk.TArrowType(ord(direction)),
    rawGtk.TShadowType(ord(shadow))))
proc direction*(w: Arrow): ArrowDirection =
  ArrowDirection(arrowEnum(w, "arrow-type", rawGtk.arrow_type_get_type()))
proc shadow*(w: Arrow): ShadowStyle =
  ShadowStyle(arrowEnum(w, "shadow-type", rawGtk.shadow_type_get_type()))
proc setArrow*(w: Arrow, direction: ArrowDirection, shadow: ShadowStyle) =
  rawGtk.set(w.raw, rawGtk.TArrowType(ord(direction)), rawGtk.TShadowType(ord(shadow)))
proc `direction=`*(w: Arrow, value: ArrowDirection) = w.setArrow(value, w.shadow)
proc `shadow=`*(w: Arrow, value: ShadowStyle) = w.setArrow(w.direction, value)
