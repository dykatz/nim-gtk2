## Calendar, color/font selection and popup scale/volume controls.
## Build: nim c --path:src examples/selectors.nim
import std/strutils
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 calendar and selectors", 580, 420)
  defer: window.destroy()
  window.borderWidth = 12
  let layout = newVBox(spacing = 10)
  window.add(layout)
  let calendar = newCalendar()
  calendar.options = calendar.options + {calendarWeekNumbers}
  let selected = newLabel()
  proc displayDate(date: CalendarDate) =
    selected.text = $date.year & "-" & $date.month & "-" & $date.day &
      (if date.day == 0: " (no selected day)" else: "")
  calendar.onDaySelected(proc (date: CalendarDate) = displayDate(date))
  calendar.onMonthChanged(proc (date: CalendarDate) = displayDate(date))
  displayDate(calendar.date)
  layout.packStart(calendar, packShrink)
  layout.packStart(selected, packShrink)

  let row = newHBox(spacing = 8)
  let colors = newColorButton(rgba16(12000, 36000, 56000), useAlpha = true)
  let fonts = newFontButton("Sans 12")
  fonts.useFont = true
  fonts.useSize = true
  row.packStart(colors)
  row.packStart(fonts)
  layout.packStart(row, packShrink)
  let description = newLabel("Choose a color or a font above")
  layout.packStart(description, packShrink)
  colors.onColorSet(proc (color: Color) =
    description.text = "RGBA16: " & $color.red & ", " & $color.green & ", " &
      $color.blue & ", " & $color.alpha)
  fonts.onFontSet(proc (name: string) = description.text = "Font: " & name)

  let levels = newHBox(spacing = 8)
  let volume = newVolumeButton()
  let numeric = newSpinButton(volume.adjustment, digits = 2)
  let output = newLabel("Volume: 0.00")
  volume.onValueChanged(proc (value: float64) =
    output.text = "Volume: " & formatFloat(value, ffDecimal, 2))
  volume.value = 0.5
  levels.packStart(volume, packShrink)
  levels.packStart(numeric, packShrink)
  levels.packStart(output)
  layout.packStart(levels, packShrink)
  layout.packStart(newLabel("Click the speaker for its popup, or edit the shared numeric value."))
  window.run()

when isMainModule:
  main()
