# Hidden widgets only: never click a chooser or open a scale popup.
import std/unittest
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newCalendar().raw) is rawGtk.PCalendar
  doAssert typeof(newColorButton().raw) is ptr rawGtk.ColorButton
  doAssert typeof(newFontButton().raw) is ptr rawGtk.FontButton
  doAssert typeof(newScaleButton().raw) is ptr rawGtk.ScaleButton
  doAssert typeof(newVolumeButton().raw) is ptr rawGtk.VolumeButton
  doAssert compiles(newVolumeButton().onValueChanged(proc (value: float64) = discard))
  doAssert not compiles(newCalendar().onClicked(proc () = discard))

proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = cast[ptr bool](data)[] = true

type CaptureObj = object
  released: ptr int
type Capture = ref CaptureObj
proc `=destroy`(value: var CaptureObj) = inc value.released[]
proc trackColor(w: gtk2.ColorButton, released: ptr int): Connection =
  let capture = Capture(released: released)
  w.onColorSet(proc (value: Color) = discard capture.released)
proc trackFont(w: gtk2.FontButton, released: ptr int): Connection =
  let capture = Capture(released: released)
  w.onFontSet(proc (value: string) = discard capture.released)
proc trackScale(w: gtk2.ScaleButton, released: ptr int): Connection =
  let capture = Capture(released: released)
  w.onValueChanged(proc (value: float64) = discard capture.released)
proc trackCalendar(w: gtk2.Calendar, released: ptr int): Connection =
  let capture = Capture(released: released)
  w.onDaySelected(proc (value: CalendarDate) = discard capture.released)

proc runTests() =
  gtk2.init()
  suite "gtk2 calendar and selector controls":
    test "calendar dates use one-based months, leap years, explicit deselection and marks":
      let calendar = newCalendar(2024, 2, 29)
      defer: calendar.destroy()
      check calendar.date == (2024, 2, 29)
      var selected: seq[CalendarDate]
      var months: seq[CalendarDate]
      calendar.onDaySelected(proc (date: CalendarDate) = selected.add(date))
      calendar.onMonthChanged(proc (date: CalendarDate) = months.add(date))
      calendar.selectDate(2025, 12, 31)
      check calendar.date == (2025, 12, 31)
      check selected[^1] == calendar.date
      check months[^1].month == 12
      calendar.date = (2000, 2, 0)
      check calendar.date == (2000, 2, 0)
      for date in [(1900, 2, 29), (2025, 2, 29), (2024, 4, 31), (2024, 1, 32),
                   (0, 1, 1), (10000, 1, 1), (2024, 0, 1), (2024, 13, 1), (2024, 1, -1)]:
        expect ValueError: calendar.date = date
      check calendar.date == (2000, 2, 0)
      for day in [1, 15, 29]: calendar.markDay(day)
      calendar.unmarkDay(15)
      calendar.clearMarks()
      expect ValueError: calendar.markDay(0)
      expect ValueError: calendar.markDay(31)
      expect ValueError: calendar.unmarkDay(32)
      let options = {calendarHeading, calendarWeekNumbers, calendarDetails, calendarFixedMonth}
      calendar.options = options
      check calendar.options == options
      check rawGtk.get_display_options(calendar.raw) == (1 or 4 or 8 or 32)
      calendar.options = {}
      check calendar.options == {}
      var activated: CalendarDate
      var once: Connection
      once = calendar.onDayActivated(proc (date: CalendarDate) =
        activated = date
        once.disconnect())
      g.g_signal_emit_by_name(calendar.raw, "day-selected-double-click")
      check activated == calendar.date
      check not once.connected
      expect ValueError: discard newCalendar(2023, 2, 29)

    test "color values copy 16-bit RGBA channels and user signals differ from setters":
      let button = newColorButton(rgba16(65535, 1234, 40000, 32768), useAlpha = true)
      defer: button.destroy()
      check button.color == rgba16(65535, 1234, 40000, 32768)
      check button.useAlpha
      button.useAlpha = false
      check not button.useAlpha
      check button.color.alpha == 32768'u16
      button.title = "Choose café color"
      check button.title == "Choose café color"
      var values: seq[Color]
      button.onColorSet(proc (value: Color) = values.add(value))
      button.color = rgba16(100, 200, 300)
      check values.len == 0
      g.g_signal_emit_by_name(button.raw, "color-set")
      check values == @[rgba16(100, 200, 300)]
      button.color = rgba16(5, 6, 7, 8)
      check values[0] == rgba16(100, 200, 300)
      expect ValueError: discard rgba16(-1, 0, 0)
      expect ValueError: discard rgba16(0, 65536, 0)
      expect ValueError: discard rgba16(0, 0, 0, -1)
      expect ValueError: button.title = "bad\0title"
      expect ValueError: button.title = "\xff"
      expect ValueError: discard newColorButton(title = "\xff")

    test "font properties and copied selections never require opening a dialog":
      let button = newFontButton("Sans Bold 12", "Select typography")
      defer: button.destroy()
      check button.fontName == "Sans Bold 12"
      check button.title == "Select typography"
      button.title = "Choose font"
      check button.title == "Choose font"
      button.useFont = true
      button.useSize = true
      button.showStyle = false
      button.showSize = false
      check button.useFont and button.useSize
      check not button.showStyle and not button.showSize
      var names: seq[string]
      button.onFontSet(proc (name: string) = names.add(name))
      button.fontName = "Monospace 11"
      check names.len == 0
      g.g_signal_emit_by_name(button.raw, "font-set")
      button.fontName = "Serif 14"
      check names == @["Monospace 11"]
      expect ValueError: button.fontName = ""
      expect ValueError: button.fontName = "bad\0font"
      expect ValueError: button.fontName = "\xff"
      expect ValueError: discard newFontButton("")
      check button.fontName == "Serif 14"

    test "scale values, copied icon vectors and owning adjustments compose with spin buttons":
      let scale = newScaleButton(-10, 10, 0.25, ["audio-volume-muted", "audio-volume-high"])
      let volume = newVolumeButton()
      defer: scale.destroy()
      defer: volume.destroy()
      let adjustment = scale.adjustment
      check adjustment.lower == -10
      check adjustment.upper == 10
      check adjustment.stepIncrement == 0.25
      var values: seq[float64]
      let connection = scale.onValueChanged(proc (value: float64) = values.add(value))
      scale.value = 4.5
      check values == @[4.5]
      scale.value = 999
      check scale.value == 10
      check values[^1] == 10
      connection.disconnect()
      scale.value = -999
      check scale.value == -10
      check values.len == 2
      var icons = @["audio-volume-low", "audio-volume-high"]
      scale.setIcons(icons)
      icons[0] = "edited after native copy"
      scale.setIcons([])
      expect ValueError: scale.setIcons([""])
      expect ValueError: scale.setIcons(["bad\0icon"])
      expect ValueError: scale.setIcons(["\xff"])
      expect ValueError: scale.value = Inf
      expect ValueError: discard newScaleButton(0, 0)
      expect ValueError: discard newScaleButton(10, 0)
      expect ValueError: discard newScaleButton(step = 0)
      expect ValueError: discard newScaleButton(step = NaN)
      expect ValueError: discard newScaleButton(step = 1e308)
      let shared = newAdjustment(0.3, 0, 1, 0.05, 0.1)
      volume.adjustment = shared
      let spin = newSpinButton(shared, digits = 2)
      defer: spin.destroy()
      check volume.adjustment.raw == shared.raw
      volume.value = 0.7
      check spin.value == 0.7
      check shared.value == 0.7
      volume.destroy()
      check shared.value == 0.7
      check not shared.isDestroyed
      scale.destroy()
      check adjustment.upper == 10

    test "managed button contents reject inherited label replacement including upcasts":
      let color = newColorButton()
      let font = newFontButton()
      let scale = newScaleButton()
      let volume = newVolumeButton()
      for button in [gtk2.Button(color), gtk2.Button(font), gtk2.Button(scale), gtk2.Button(volume)]:
        expect ValueError: button.text = "would replace private GTK widgets"
        button.destroy()

    test "callbacks contain exceptions, self-disconnect, and permit emitter destruction":
      let scale = newScaleButton()
      defer: scale.destroy()
      var once: Connection
      var calls = 0
      once = scale.onValueChanged(proc (value: float64) =
        inc calls
        once.disconnect()
        raise newException(ValueError, "expected scale selection error"))
      scale.value = 10
      scale.value = 20
      check calls == 1
      let color = newColorButton()
      var colorConnection: Connection
      colorConnection = color.onColorSet(proc (value: Color) =
        color.destroy()
        raise newException(ValueError, "expected color selection error"))
      g.g_signal_emit_by_name(color.raw, "color-set")
      check color.isDestroyed
      check not colorConnection.connected
      let font = newFontButton()
      let fontConnection = font.onFontSet(proc (value: string) =
        font.destroy()
        check value.len > 0)
      g.g_signal_emit_by_name(font.raw, "font-set")
      check not fontConnection.connected
      let calendar = newCalendar(2024, 1, 1)
      calendar.onMonthChanged(proc (value: CalendarDate) = calendar.destroy())
      calendar.selectDate(2024, 2, 1)
      check calendar.isDestroyed
      let day = newCalendar(2024, 1, 1)
      day.onDaySelected(proc (value: CalendarDate) = day.destroy())
      day.selectDate(2024, 1, 2)
      check day.isDestroyed

    test "widget destruction releases real captures and invalidates aliases":
      let calendar = newCalendar()
      let color = newColorButton()
      let font = newFontButton()
      let scale = newScaleButton()
      var released = 0
      let connections = [trackCalendar(calendar, addr released), trackColor(color, addr released),
        trackFont(font, addr released), trackScale(scale, addr released)]
      check released == 0
      let alias = color
      for widget in [gtk2.Widget(calendar), gtk2.Widget(color), gtk2.Widget(font), gtk2.Widget(scale)]: widget.destroy()
      check released == 4
      check alias.isDestroyed
      for connection in connections: check not connection.connected
      expect ValueError: discard alias.color
      expect ValueError: discard calendar.date
      expect ValueError: discard font.fontName
      expect ValueError: discard scale.value
      expect ValueError: discard scale.onValueChanged(nil)
      let live = newScaleButton()
      defer: live.destroy()
      expect ValueError: discard live.onValueChanged(nil)

    test "handles and retained adjustment references finalize exactly once":
      var scaleGone, adjustmentGone: bool
      proc keepAdjustment(): Adjustment =
        let scale = newScaleButton()
        g.weak_ref(cast[g.PGObject](scale.raw), finalized, addr scaleGone)
        result = scale.adjustment
        g.weak_ref(cast[g.PGObject](result.raw), finalized, addr adjustmentGone)
        scale.destroy()
      block:
        let retained = keepAdjustment()
        check scaleGone
        check not adjustmentGone
        check retained.upper == 100
      check adjustmentGone

runTests()
