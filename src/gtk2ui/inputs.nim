# Included by gtk2ui.nim. Adjustment is a GtkObject, NOT a widget.
type
  Adjustment* = object of ObjectHandle
  SpinButton* = object of Entry
  ComboBox* = object of Bin # Shared selection API; generic models live in models.nim.
  ComboBoxText* = object of ComboBox

proc raw*(a: Adjustment): rawGtk.PAdjustment = cast[rawGtk.PAdjustment](nativePointer(a))
proc raw*(w: SpinButton): rawGtk.PSpinButton = cast[rawGtk.PSpinButton](raw(Widget(w)))
proc raw*(w: ComboBox): rawGtk.PComboBox = cast[rawGtk.PComboBox](raw(Widget(w)))
proc raw*(w: ComboBoxText): rawGtk.PComboBoxText = cast[rawGtk.PComboBoxText](raw(Widget(w)))

proc finite(value: float64): float64 =
  if value != value or value == Inf or value == NegInf:
    raise newException(ValueError, "numeric values must be finite")
  value

proc checkBounds(lower, upper: float64) =
  discard finite(lower)
  discard finite(upper)
  if lower > upper: raise newException(ValueError, "lower bound must not exceed upper bound")
  discard finite(upper - lower)

proc nonnegative(value: float64): float64 =
  result = finite(value)
  if result < 0: raise newException(ValueError, "increment or size must be nonnegative")

proc checkAdjustment(value, lower, upper, stepIncrement, pageIncrement, pageSize: float64) =
  discard finite(value)
  checkBounds(lower, upper)
  discard nonnegative(stepIncrement)
  discard nonnegative(pageIncrement)
  discard nonnegative(pageSize)
  if pageSize > upper - lower:
    raise newException(ValueError, "page size must not exceed the adjustment span")

proc newAdjustment*(value = 0.0, lower = 0.0, upper = 100.0,
                    stepIncrement = 1.0, pageIncrement = 10.0, pageSize = 0.0): Adjustment =
  checkAdjustment(value, lower, upper, stepIncrement, pageIncrement, pageSize)
  result.state = adoptObject(rawGtk.adjustment_new(value, lower, upper,
    stepIncrement, pageIncrement, pageSize), cache = true)

proc ownedAdjustment(p: rawGtk.PAdjustment): Adjustment =
  ## Native getters transfer no reference. Retain, do not steal or sink theirs.
  result.state = adoptObject(p, borrowed = true, cache = true)

proc destroy*(a: Adjustment) =
  ## Disconnects captures and invalidates aliases. Normally just release handles;
  ## explicitly destroy or disconnect signals to break self-capture cycles.
  if not a.isDestroyed: rawGtk.destroy(cast[rawGtk.PObject](a.raw))
proc value*(a: Adjustment): float64 = rawGtk.get_value(a.raw)
proc `value=`*(a: Adjustment, value: float64) = rawGtk.set_value(a.raw, finite(value))
proc lower*(a: Adjustment): float64 = rawGtk.get_lower(a.raw)
proc upper*(a: Adjustment): float64 = rawGtk.get_upper(a.raw)
proc stepIncrement*(a: Adjustment): float64 = rawGtk.get_step_increment(a.raw)
proc pageIncrement*(a: Adjustment): float64 = rawGtk.get_page_increment(a.raw)
proc pageSize*(a: Adjustment): float64 = rawGtk.get_page_size(a.raw)
proc configure*(a: Adjustment, value, lower, upper, stepIncrement, pageIncrement: float64,
                pageSize = 0.0) =
  checkAdjustment(value, lower, upper, stepIncrement, pageIncrement, pageSize)
  rawGtk.configure(a.raw, value, lower, upper, stepIncrement, pageIncrement, pageSize)
proc onChanged*(a: Adjustment, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(a, "changed", fn)
proc onValueChanged*(a: Adjustment, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(a, "value-changed", fn)

proc horizontalAdjustment*(w: ScrolledWindow): Adjustment = ownedAdjustment(rawGtk.get_hadjustment(w.raw))
proc verticalAdjustment*(w: ScrolledWindow): Adjustment = ownedAdjustment(rawGtk.get_vadjustment(w.raw))
proc horizontalAdjustment*(w: Viewport): Adjustment = ownedAdjustment(rawGtk.get_hadjustment(w.raw))
proc verticalAdjustment*(w: Viewport): Adjustment = ownedAdjustment(rawGtk.get_vadjustment(w.raw))
proc `horizontalAdjustment=`*(w: ScrolledWindow, a: Adjustment) = rawGtk.set_hadjustment(w.raw, a.raw)
proc `verticalAdjustment=`*(w: ScrolledWindow, a: Adjustment) = rawGtk.set_vadjustment(w.raw, a.raw)
proc `horizontalAdjustment=`*(w: Viewport, a: Adjustment) = rawGtk.set_hadjustment(w.raw, a.raw)
proc `verticalAdjustment=`*(w: Viewport, a: Adjustment) = rawGtk.set_vadjustment(w.raw, a.raw)

proc spinDigits(value: int): g.guint =
  if value < 0 or value > 20: raise newException(ValueError, "spin digits must be between 0 and 20")
  g.guint(value)

proc newSpinButton*(lower = 0.0, upper = 100.0, step = 1.0): SpinButton =
  checkBounds(lower, upper)
  if nonnegative(step) == 0:
    raise newException(ValueError, "spin step must be positive")
  discard finite(step * 10.0) # Native range constructor also creates a page increment.
  result.state = adoptWidget(rawGtk.spin_button_new(lower, upper, step))

proc newSpinButton*(adjustment: Adjustment, climbRate = 0.0, digits = 0): SpinButton =
  let p = adjustment.raw
  let rate = nonnegative(climbRate)
  let d = spinDigits(digits)
  result.state = adoptWidget(rawGtk.spin_button_new(p, rate, d))

proc adjustment*(w: SpinButton): Adjustment = ownedAdjustment(rawGtk.get_adjustment(w.raw))
proc `adjustment=`*(w: SpinButton, a: Adjustment) = rawGtk.set_adjustment(w.raw, a.raw)
proc value*(w: SpinButton): float64 = rawGtk.get_value(w.raw)
proc `value=`*(w: SpinButton, value: float64) = rawGtk.set_value(w.raw, finite(value))
proc digits*(w: SpinButton): int = rawGtk.get_digits(w.raw).int
proc `digits=`*(w: SpinButton, value: int) = rawGtk.set_digits(w.raw, spinDigits(value))
proc bounds*(w: SpinButton): tuple[lower, upper: float64] =
  rawGtk.get_range(w.raw, addr result.lower, addr result.upper)
proc setRange*(w: SpinButton, lower, upper: float64) =
  checkBounds(lower, upper)
  rawGtk.set_range(w.raw, lower, upper)
proc increments*(w: SpinButton): tuple[step, page: float64] =
  rawGtk.get_increments(w.raw, addr result.step, addr result.page)
proc setIncrements*(w: SpinButton, step, page: float64) =
  let s = nonnegative(step)
  let p = nonnegative(page)
  rawGtk.set_increments(w.raw, s, p)
proc numeric*(w: SpinButton): bool = g.toBool(rawGtk.get_numeric(w.raw))
proc `numeric=`*(w: SpinButton, value: bool) = rawGtk.set_numeric(w.raw, g.gbool(value))
proc wrap*(w: SpinButton): bool = g.toBool(rawGtk.get_wrap(w.raw))
proc `wrap=`*(w: SpinButton, value: bool) = rawGtk.set_wrap(w.raw, g.gbool(value))
proc snapToTicks*(w: SpinButton): bool = g.toBool(rawGtk.get_snap_to_ticks(w.raw))
proc `snapToTicks=`*(w: SpinButton, value: bool) = rawGtk.set_snap_to_ticks(w.raw, g.gbool(value))
proc update*(w: SpinButton) = rawGtk.update(w.raw)
proc onValueChanged*(w: SpinButton, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "value-changed", fn)

proc itemCount*(w: ComboBox): int =
  let model = rawGtk.get_model(w.raw)
  if model != nil: result = rawGtk.iter_n_children(model, nil).int
proc activeIndex*(w: ComboBox): int = rawGtk.get_active(w.raw).int
proc `activeIndex=`*(w: ComboBox, index: int) =
  if index < -1 or index >= w.itemCount:
    raise newException(ValueError, "combo index must be -1 or an existing row")
  discard w.raw
  rawGtk.set_active(w.raw, g.gint(index))
proc onChanged*(w: ComboBox, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "changed", fn)

proc newComboBoxText*(items: openArray[string] = [], editable = false): ComboBoxText =
  for text in items: discard checkedString(text)
  result.state = adoptWidget(if editable: rawGtk.combo_box_text_new_with_entry()
                            else: rawGtk.combo_box_text_new())
  for text in items: rawGtk.append_text(result.raw, text.cstring)

proc appendText*(w: ComboBoxText, text: string) = rawGtk.append_text(w.raw, checkedString(text))
proc insertText*(w: ComboBoxText, index: int, text: string) =
  if index < 0 or index > w.itemCount:
    raise newException(ValueError, "combo insertion index is out of range")
  rawGtk.insert_text(w.raw, checkedInt(index), checkedString(text))
proc prependText*(w: ComboBoxText, text: string) = rawGtk.prepend_text(w.raw, checkedString(text))
proc removeText*(w: ComboBoxText, index: int) =
  if index < 0 or index >= w.itemCount:
    raise newException(ValueError, "combo removal index is out of range")
  rawGtk.remove(w.raw, checkedInt(index))
proc activeText*(w: ComboBoxText): string =
  let p = rawGtk.get_active_text(w.raw)
  defer: g.g_free(p)
  $p

proc comboEntry(w: ComboBoxText): rawGtk.PEntry =
  if not g.toBool(rawGtk.get_has_entry(cast[rawGtk.PComboBox](w.raw))):
    raise newException(ValueError, "combo has no editable entry")
  cast[rawGtk.PEntry](rawGtk.get_child(cast[rawGtk.PBin](w.raw)))
proc entryText*(w: ComboBoxText): string = $rawGtk.get_text(comboEntry(w))
proc `entryText=`*(w: ComboBoxText, text: string) = rawGtk.set_text(comboEntry(w), checkedString(text))
