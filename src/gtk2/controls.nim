# Included by gtk2.nim: shares the ownership and signal machinery.
type
  ToggleButton* = object of Button
  CheckButton* = object of ToggleButton
  RadioButton* = object of CheckButton
  LinkButton* = object of Button
  ProgressBar* = object of Widget
  Spinner* = object of Widget
  Frame* = object of Bin
  AspectFrame* = object of Frame
  Expander* = object of Bin
  Separator* = object of Widget
  HSeparator* = object of Separator
  VSeparator* = object of Separator
  DrawingArea* = object of Widget

proc raw*(w: ToggleButton): rawGtk.PToggleButton = cast[rawGtk.PToggleButton](raw(Widget(w)))
proc raw*(w: CheckButton): rawGtk.PCheckButton = cast[rawGtk.PCheckButton](raw(Widget(w)))
proc raw*(w: RadioButton): rawGtk.PRadioButton = cast[rawGtk.PRadioButton](raw(Widget(w)))
proc raw*(w: LinkButton): rawGtk.PLinkButton = cast[rawGtk.PLinkButton](raw(Widget(w)))
proc raw*(w: ProgressBar): rawGtk.PProgressBar = cast[rawGtk.PProgressBar](raw(Widget(w)))
proc raw*(w: Spinner): ptr rawGtk.Spinner = cast[ptr rawGtk.Spinner](raw(Widget(w)))
proc raw*(w: Frame): rawGtk.PFrame = cast[rawGtk.PFrame](raw(Widget(w)))
proc raw*(w: AspectFrame): rawGtk.PAspectFrame = cast[rawGtk.PAspectFrame](raw(Widget(w)))
proc raw*(w: Expander): ptr rawGtk.Expander = cast[ptr rawGtk.Expander](raw(Widget(w)))
proc raw*(w: HSeparator): rawGtk.PHSeparator = cast[rawGtk.PHSeparator](raw(Widget(w)))
proc raw*(w: VSeparator): rawGtk.PVSeparator = cast[rawGtk.PVSeparator](raw(Widget(w)))
proc raw*(w: DrawingArea): rawGtk.PDrawingArea = cast[rawGtk.PDrawingArea](raw(Widget(w)))

proc unitInterval(value: float64): float64 =
  if not (value >= 0.0 and value <= 1.0):
    raise newException(ValueError, "value must be finite and between 0 and 1")
  value

proc sizeRequestValue(value: int): g.gint =
  if value < -1 or value > high(g.gint).int:
    raise newException(ValueError, "size request must be -1 or a nonnegative gint")
  g.gint(value)

proc setSizeRequest*(w: Widget, width, height: int) =
  ## -1 restores GTK's natural size for that dimension.
  let x = sizeRequestValue(width)
  let y = sizeRequestValue(height)
  rawGtk.set_size_request(w.raw, x, y)

proc sizeRequest*(w: Widget): tuple[width, height: int] =
  var x, y: g.gint
  rawGtk.get_size_request(w.raw, addr x, addr y)
  (x.int, y.int)

proc queueDraw*(w: Widget) = rawGtk.queue_draw(w.raw)

proc newToggleButton*(text = "", mnemonic = false): ToggleButton =
  let t = checkedString(text)
  result.state = adoptWidget(if mnemonic: rawGtk.toggle_button_new_with_mnemonic(t)
                            else: rawGtk.toggle_button_new(t))

proc newCheckButton*(text = "", mnemonic = false): CheckButton =
  let t = checkedString(text)
  result.state = adoptWidget(if mnemonic: rawGtk.check_button_new_with_mnemonic(t)
                            else: rawGtk.check_button_new(t))

proc makeRadioButton(group: rawGtk.PRadioButton, text: string, mnemonic: bool): RadioButton =
  let t = checkedString(text)
  result.state = adoptWidget(if mnemonic:
    rawGtk.radio_button_new_with_mnemonic_from_widget(group, t)
    else: rawGtk.radio_button_new_with_label_from_widget(group, t))

proc newRadioButton*(text = "", mnemonic = false): RadioButton =
  ## Starts a new group; GTK initially activates its first member.
  makeRadioButton(nil, text, mnemonic)

proc newRadioButton*(group: RadioButton, text = "", mnemonic = false): RadioButton =
  ## Joins the live group containing group; no borrowed GSList escapes to Nim.
  makeRadioButton(group.raw, text, mnemonic)

proc joinGroup*(w: RadioButton, group: RadioButton) =
  let p = w.raw
  let target = rawGtk.get_group(group.raw)
  # GTK rejects a group that already contains this button.
  if rawGtk.get_group(p) != target: rawGtk.set_group(p, target)

proc active*(w: ToggleButton): bool = g.toBool(rawGtk.get_active(w.raw))
proc `active=`*(w: ToggleButton, value: bool) = rawGtk.set_active(w.raw, g.gbool(value))
proc inconsistent*(w: ToggleButton): bool = g.toBool(rawGtk.get_inconsistent(w.raw))
proc `inconsistent=`*(w: ToggleButton, value: bool) =
  rawGtk.set_inconsistent(w.raw, g.gbool(value))
proc onToggled*(w: ToggleButton, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "toggled", fn)

proc newLinkButton*(uri: string): LinkButton =
  result.state = adoptWidget(rawGtk.link_button_new(checkedString(uri)))

proc newLinkButton*(uri, text: string): LinkButton =
  let address = checkedString(uri)
  let label = checkedString(text)
  result.state = adoptWidget(rawGtk.link_button_new_with_label(address, label))

proc uri*(w: LinkButton): string = $rawGtk.link_button_get_uri(w.raw)
proc `uri=`*(w: LinkButton, value: string) = rawGtk.link_button_set_uri(w.raw, checkedString(value))
proc visited*(w: LinkButton): bool = g.toBool(rawGtk.link_button_get_visited(w.raw))
proc `visited=`*(w: LinkButton, value: bool) = rawGtk.link_button_set_visited(w.raw, g.gbool(value))

proc newProgressBar*(fraction = 0.0, text = ""): ProgressBar =
  let value = unitInterval(fraction)
  let label = checkedString(text)
  result.state = adoptWidget(rawGtk.progress_bar_new())
  rawGtk.set_fraction(result.raw, value)
  if text.len > 0: rawGtk.set_text(result.raw, label)

proc fraction*(w: ProgressBar): float64 = rawGtk.get_fraction(w.raw)
proc `fraction=`*(w: ProgressBar, value: float64) = rawGtk.set_fraction(w.raw, unitInterval(value))
proc text*(w: ProgressBar): string = $rawGtk.get_text(w.raw)
proc `text=`*(w: ProgressBar, value: string) =
  let label = checkedString(value)
  rawGtk.set_text(w.raw, if value.len == 0: nil else: label)
proc pulseStep*(w: ProgressBar): float64 = rawGtk.get_pulse_step(w.raw)
proc `pulseStep=`*(w: ProgressBar, value: float64) = rawGtk.set_pulse_step(w.raw, unitInterval(value))
proc pulse*(w: ProgressBar) = rawGtk.pulse(w.raw)

proc newSpinner*(): Spinner =
  result.state = adoptWidget(rawGtk.spinner_new())
proc start*(w: Spinner) = rawGtk.spinner_start(w.raw)
proc stop*(w: Spinner) = rawGtk.spinner_stop(w.raw)

proc newFrame*(text = ""): Frame =
  let label = checkedString(text)
  result.state = adoptWidget(rawGtk.frame_new(if text.len == 0: nil else: label))
proc text*(w: Frame): string = $rawGtk.get_label(w.raw)
proc `text=`*(w: Frame, value: string) =
  let label = checkedString(value)
  rawGtk.set_label(w.raw, if value.len == 0: nil else: label)
proc labelAlignment*(w: Frame): tuple[x, y: float64] =
  var x, y: g.gfloat
  rawGtk.get_label_align(w.raw, addr x, addr y)
  (x.float64, y.float64)
proc setLabelAlignment*(w: Frame, x, y: float64) =
  let a = unitInterval(x)
  let b = unitInterval(y)
  rawGtk.set_label_align(w.raw, a.gfloat, b.gfloat)

proc aspectRatio(value: float64): g.gfloat =
  # GTK's documented ratio range; reject rather than silently clamp.
  if not (value >= 0.0001 and value <= 10000.0):
    raise newException(ValueError, "aspect ratio must be between 0.0001 and 10000")
  g.gfloat(value)

proc newAspectFrame*(text = "", ratio = 1.0, xalign = 0.5, yalign = 0.5,
                     obeyChild = false): AspectFrame =
  let label = checkedString(text)
  let r = aspectRatio(ratio)
  let x = unitInterval(xalign)
  let y = unitInterval(yalign)
  result.state = adoptWidget(rawGtk.aspect_frame_new(
    (if text.len == 0: nil else: label), x.gfloat, y.gfloat, r, g.gbool(obeyChild)))

proc setAspect*(w: AspectFrame, ratio: float64, xalign = 0.5, yalign = 0.5,
                obeyChild = false) =
  let r = aspectRatio(ratio)
  let x = unitInterval(xalign)
  let y = unitInterval(yalign)
  rawGtk.set(w.raw, x.gfloat, y.gfloat, r, g.gbool(obeyChild))

proc newExpander*(text = "", mnemonic = false): Expander =
  let label = checkedString(text)
  result.state = adoptWidget(if mnemonic: rawGtk.expander_new_with_mnemonic(label)
                            else: rawGtk.expander_new(label))
proc text*(w: Expander): string = $rawGtk.expander_get_label(w.raw)
proc `text=`*(w: Expander, value: string) = rawGtk.expander_set_label(w.raw, checkedString(value))
proc expanded*(w: Expander): bool = g.toBool(rawGtk.expander_get_expanded(w.raw))
proc `expanded=`*(w: Expander, value: bool) = rawGtk.expander_set_expanded(w.raw, g.gbool(value))
proc spacing*(w: Expander): int = rawGtk.expander_get_spacing(w.raw).int
proc `spacing=`*(w: Expander, value: int) = rawGtk.expander_set_spacing(w.raw, checkedInt(value))
proc onActivate*(w: Expander, fn: proc () {.closure.}): Connection {.discardable.} =
  ## Runs before GTK's default expand/collapse action, not on property writes.
  connect(w, "activate", fn)

proc newHSeparator*(): HSeparator =
  result.state = adoptWidget(rawGtk.hseparator_new())
proc newVSeparator*(): VSeparator =
  result.state = adoptWidget(rawGtk.vseparator_new())
proc newDrawingArea*(width = -1, height = -1): DrawingArea =
  let x = sizeRequestValue(width)
  let y = sizeRequestValue(height)
  result.state = adoptWidget(rawGtk.drawing_area_new())
  rawGtk.set_size_request(cast[rawGtk.PWidget](result.raw), x, y)
