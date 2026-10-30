# Included by gtk2.nim. Calendar, color/font selectors and popup scale buttons.
type
  Calendar* = object of Widget
  ColorButton* = object of Button
  FontButton* = object of Button
  ScaleButton* = object of Button
  VolumeButton* = object of ScaleButton
  CalendarDate* = tuple[year, month, day: int]
  CalendarOption* = enum
    calendarHeading, calendarDayNames, calendarFixedMonth, calendarWeekNumbers,
    calendarDetails
  CalendarOptions* = set[CalendarOption]
  Color* = object
    ## Copied 16-bit RGBA channels; no GdkColor pixel/colormap identity.
    red*, green*, blue*, alpha*: uint16
  SelectorCallback[T] = ref object
    fn: proc (value: T) {.closure.}

proc raw*(w: Calendar): rawGtk.PCalendar = cast[rawGtk.PCalendar](raw(Widget(w)))
proc raw*(w: ColorButton): ptr rawGtk.ColorButton = cast[ptr rawGtk.ColorButton](raw(Widget(w)))
proc raw*(w: FontButton): ptr rawGtk.FontButton = cast[ptr rawGtk.FontButton](raw(Widget(w)))
proc raw*(w: ScaleButton): ptr rawGtk.ScaleButton = cast[ptr rawGtk.ScaleButton](raw(Widget(w)))
proc raw*(w: VolumeButton): ptr rawGtk.VolumeButton = cast[ptr rawGtk.VolumeButton](raw(Widget(w)))

proc checkedCalendarDay(day: int, allowNone = false): g.guint =
  if day < (if allowNone: 0 else: 1) or day > 31:
    raise newException(ValueError, "calendar day must be 1..31 (or 0 for no selection)")
  g.guint(day)

proc checkCalendarDate(year, month, day: int) =
  if year < 1 or year > 9999 or month < 1 or month > 12:
    raise newException(ValueError, "calendar year must be 1..9999 and month 1..12")
  discard checkedCalendarDay(day, allowNone = true)
  const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  let leap = year mod 4 == 0 and (year mod 100 != 0 or year mod 400 == 0)
  let limit = days[month - 1] + (if month == 2 and leap: 1 else: 0)
  if day > limit: raise newException(ValueError, "day does not exist in this month")

proc calendarDate(p: rawGtk.PCalendar): CalendarDate =
  var year, month, day: g.guint
  rawGtk.get_date(p, addr year, addr month, addr day)
  (year.int, month.int + 1, day.int)

proc newCalendar*(): Calendar = result.state = adoptWidget(rawGtk.calendar_new())
proc selectDate*(w: Calendar, year, month, day: int) =
  ## Months are 1..12; day 0 clears selection. Native notifications are sequential,
  ## not an atomic date-change transaction. Marks persist across month changes.
  checkCalendarDate(year, month, day)
  let p = w.raw
  let current = calendarDate(p)
  if current.day != 0 and (current.year != year or current.month != month):
    # GTK2 otherwise keeps e.g. January 31 selected in February and may warn
    # when subsequently trying to invalidate that nonexistent day.
    rawGtk.select_day(p, 0)
    if w.isDestroyed: return
  discard rawGtk.select_month(w.raw, g.guint(month - 1), g.guint(year))
  # A month-changed handler may close/destroy this control.
  if not w.isDestroyed: rawGtk.select_day(w.raw, g.guint(day))
proc newCalendar*(year, month, day: int): Calendar =
  checkCalendarDate(year, month, day)
  result = newCalendar()
  result.selectDate(year, month, day)
proc date*(w: Calendar): CalendarDate = calendarDate(w.raw)
proc `date=`*(w: Calendar, value: CalendarDate) = w.selectDate(value.year, value.month, value.day)
proc checkedMarkDay(w: Calendar, day: int): g.guint =
  let date = w.date
  result = checkedCalendarDay(day)
  checkCalendarDate(date.year, date.month, day)
proc markDay*(w: Calendar, day: int) = discard rawGtk.mark_day(w.raw, checkedMarkDay(w, day))
proc unmarkDay*(w: Calendar, day: int) = discard rawGtk.unmark_day(w.raw, checkedMarkDay(w, day))
proc clearMarks*(w: Calendar) = rawGtk.clear_marks(w.raw)

const calendarOptionBits = [rawGtk.CALENDAR_SHOW_HEADING.int32,
  rawGtk.CALENDAR_SHOW_DAY_NAMES.int32, rawGtk.CALENDAR_NO_MONTH_CHANGE.int32,
  rawGtk.CALENDAR_SHOW_WEEK_NUMBERS.int32, rawGtk.CALENDAR_SHOW_DETAILS.int32]
proc options*(w: Calendar): CalendarOptions =
  let flags = rawGtk.get_display_options(w.raw)
  for option in CalendarOption:
    if (flags and calendarOptionBits[ord(option)]) != 0: result.incl(option)
proc `options=`*(w: Calendar, options: CalendarOptions) =
  var flags: rawGtk.TCalendarDisplayOptions
  for option in options: flags = flags or calendarOptionBits[ord(option)]
  rawGtk.set_display_options(w.raw, flags)

proc rgba16*(red, green, blue: int, alpha = 65535): Color =
  ## Channels are 0..65535, not 0..255 or floating-point fractions.
  for channel in [red, green, blue, alpha]:
    if channel < 0 or channel > 65535:
      raise newException(ValueError, "RGBA channels must be 0..65535")
  Color(red: red.uint16, green: green.uint16, blue: blue.uint16, alpha: alpha.uint16)

proc buttonColor(p: ptr rawGtk.ColorButton): Color =
  var color: TColor
  rawGtk.color_button_get_color(p, addr color)
  Color(red: color.red, green: color.green, blue: color.blue,
    alpha: rawGtk.color_button_get_alpha(p))
proc color*(w: ColorButton): Color = buttonColor(w.raw)
proc `color=`*(w: ColorButton, value: Color) =
  let p = w.raw
  var color = TColor(red: value.red, green: value.green, blue: value.blue)
  rawGtk.color_button_set_color(p, addr color)
  rawGtk.color_button_set_alpha(p, value.alpha)
proc useAlpha*(w: ColorButton): bool = g.toBool(rawGtk.color_button_get_use_alpha(w.raw))
proc `useAlpha=`*(w: ColorButton, value: bool) = rawGtk.color_button_set_use_alpha(w.raw, g.gbool(value))
proc title*(w: ColorButton): string = $rawGtk.color_button_get_title(w.raw)
proc `title=`*(w: ColorButton, value: string) = rawGtk.color_button_set_title(w.raw, checkedUtf8Text(value))
proc newColorButton*(color = rgba16(0, 0, 0), useAlpha = false,
                     title = "Pick a Color"): ColorButton =
  let label = checkedUtf8Text(title)
  result.state = adoptWidget(rawGtk.color_button_new())
  result.color = color
  result.useAlpha = useAlpha
  rawGtk.color_button_set_title(result.raw, label)

proc checkedFontName(value: string): cstring =
  result = checkedUtf8Text(value)
  if value.len == 0: raise newException(ValueError, "font description must not be empty")
proc fontName*(w: FontButton): string = $rawGtk.font_button_get_font_name(w.raw)
proc `fontName=`*(w: FontButton, value: string) =
  let name = checkedFontName(value)
  # GTK2 updates the cached name but returns FALSE until its chooser exists.
  # This result is not validation of whether a font is installed.
  discard rawGtk.font_button_set_font_name(w.raw, name)
proc title*(w: FontButton): string = $rawGtk.font_button_get_title(w.raw)
proc `title=`*(w: FontButton, value: string) = rawGtk.font_button_set_title(w.raw, checkedUtf8Text(value))
proc useFont*(w: FontButton): bool = g.toBool(rawGtk.font_button_get_use_font(w.raw))
proc `useFont=`*(w: FontButton, value: bool) = rawGtk.font_button_set_use_font(w.raw, g.gbool(value))
proc useSize*(w: FontButton): bool = g.toBool(rawGtk.font_button_get_use_size(w.raw))
proc `useSize=`*(w: FontButton, value: bool) = rawGtk.font_button_set_use_size(w.raw, g.gbool(value))
proc showStyle*(w: FontButton): bool = g.toBool(rawGtk.font_button_get_show_style(w.raw))
proc `showStyle=`*(w: FontButton, value: bool) = rawGtk.font_button_set_show_style(w.raw, g.gbool(value))
proc showSize*(w: FontButton): bool = g.toBool(rawGtk.font_button_get_show_size(w.raw))
proc `showSize=`*(w: FontButton, value: bool) = rawGtk.font_button_set_show_size(w.raw, g.gbool(value))
proc newFontButton*(fontName = "Sans 10", title = "Pick a Font"): FontButton =
  discard checkedFontName(fontName)
  let label = checkedUtf8Text(title)
  result.state = adoptWidget(rawGtk.font_button_new())
  try:
    result.fontName = fontName
    rawGtk.font_button_set_title(result.raw, label)
  except:
    result.destroy()
    raise

proc checkedScaleIcons(icons: openArray[string]): seq[cstring] =
  for icon in icons:
    discard checkedUtf8Text(icon)
    if icon.len == 0: raise newException(ValueError, "icon names must not be empty")
  result = newSeq[cstring](icons.len + 1)
  for i, icon in icons: result[i] = icon.cstring
proc setIcons*(w: ScaleButton, icons: openArray[string]) =
  var names = checkedScaleIcons(icons)
  rawGtk.scale_button_set_icons(w.raw, addr names[0]) # GTK copies the vector.
proc newScaleButton*(lower = 0.0, upper = 100.0, step = 1.0,
                     icons: openArray[string] = [], size = iconSmallToolbar): ScaleButton =
  checkBounds(lower, upper)
  if lower == upper or not (finite(step) > 0):
    raise newException(ValueError, "scale buttons require lower < upper and a positive step")
  discard finite(step * 10.0)
  var names = checkedScaleIcons(icons)
  result.state = adoptWidget(rawGtk.scale_button_new(rawGtk.TIconSize(ord(size)),
    lower, upper, step, addr names[0]))
proc newVolumeButton*(): VolumeButton = result.state = adoptWidget(rawGtk.volume_button_new())
proc value*(w: ScaleButton): float64 = rawGtk.scale_button_get_value(w.raw)
proc `value=`*(w: ScaleButton, value: float64) = rawGtk.scale_button_set_value(w.raw, finite(value))
proc adjustment*(w: ScaleButton): Adjustment = ownedAdjustment(rawGtk.scale_button_get_adjustment(w.raw))
proc `adjustment=`*(w: ScaleButton, value: Adjustment) = rawGtk.scale_button_set_adjustment(w.raw, value.raw)

proc releaseSelectorCallback[T](data: pointer, closure: g.PGClosure) {.cdecl.} =
  GC_unref(cast[SelectorCallback[T]](data))
proc selectorThunk[T](instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[SelectorCallback[T]](data).fn
    try:
      when T is CalendarDate: fn(calendarDate(cast[rawGtk.PCalendar](instance)))
      elif T is Color: fn(buttonColor(cast[ptr rawGtk.ColorButton](instance)))
      elif T is string: fn($rawGtk.font_button_get_font_name(cast[ptr rawGtk.FontButton](instance)))
    except Exception as error: reportSignalError(error)
proc scaleValueThunk(instance: pointer, value: g.gdouble, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[SelectorCallback[float64]](data).fn
    try: fn(value)
    except Exception as error: reportSignalError(error)
proc connectSelector[T](w: Widget, signal: cstring, fn: proc (value: T) {.closure.},
                        thunk: g.TGCallback): Connection =
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let callback = SelectorCallback[T](fn: fn)
  GC_ref(callback)
  let id = g.g_signal_connect_data(p, signal, thunk, cast[pointer](callback),
    releaseSelectorCallback[T], g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
proc onDaySelected*(w: Calendar, fn: proc (date: CalendarDate) {.closure.}): Connection {.discardable.} =
  connectSelector(w, "day-selected", fn, cast[g.TGCallback](selectorThunk[CalendarDate]))
proc onMonthChanged*(w: Calendar, fn: proc (date: CalendarDate) {.closure.}): Connection {.discardable.} =
  connectSelector(w, "month-changed", fn, cast[g.TGCallback](selectorThunk[CalendarDate]))
proc onDayActivated*(w: Calendar, fn: proc (date: CalendarDate) {.closure.}): Connection {.discardable.} =
  connectSelector(w, "day-selected-double-click", fn, cast[g.TGCallback](selectorThunk[CalendarDate]))
proc onColorSet*(w: ColorButton, fn: proc (color: Color) {.closure.}): Connection {.discardable.} =
  connectSelector(w, "color-set", fn, cast[g.TGCallback](selectorThunk[Color]))
proc onFontSet*(w: FontButton, fn: proc (fontName: string) {.closure.}): Connection {.discardable.} =
  connectSelector(w, "font-set", fn, cast[g.TGCallback](selectorThunk[string]))
proc onValueChanged*(w: ScaleButton, fn: proc (value: float64) {.closure.}): Connection {.discardable.} =
  connectSelector(w, "value-changed", fn, cast[g.TGCallback](scaleValueThunk))
