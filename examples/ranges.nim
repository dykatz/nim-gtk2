## Shared scale/spin values, a page-sized scrollbar, and decorative arrows.
## Build: nim c --path:src examples/ranges.nim
import std/strutils
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 scales and scrollbars", 580, 380)
  defer: window.destroy()
  window.borderWidth = 12
  let layout = newVBox(spacing = 10)
  window.add(layout)
  let shared = newAdjustment(25, 0, 100, 1, 10)
  let horizontal = newHScale(shared)
  horizontal.digits = 1
  horizontal.valuePosition = valueRight
  horizontal.addMark(0, "Start <0>")
  horizontal.addMark(50, "Middle & center")
  horizontal.addMark(100, "End")
  layout.packStart(horizontal, packShrink)
  let row = newHBox(spacing = 12)
  let vertical = newVScale(shared)
  vertical.setSizeRequest(90, 170)
  vertical.inverted = true
  let numeric = newSpinButton(shared, digits = 1)
  let output = newLabel("Shared value: 25.0")
  row.packStart(vertical, packShrink)
  row.packStart(numeric, packShrink)
  row.packStart(output)
  layout.packStart(row)
  horizontal.onValueChanged(proc (value: float64) =
    output.text = "Shared value: " & formatFloat(value, ffDecimal, 1))

  let pages = newHScrollbar(pageSize = 20)
  let pageText = newLabel("Page start: 0.0 (upper bound 100, visible page 20)")
  pages.onValueChanged(proc (value: float64) =
    pageText.text = "Page start: " & formatFloat(value, ffDecimal, 1) &
      " (maximum 80 = upper bound minus visible page)")
  layout.packStart(pages, packShrink)
  layout.packStart(pageText, packShrink)
  let decorations = newHBox(spacing = 8)
  decorations.packStart(newArrow(arrowLeft), packShrink)
  decorations.packStart(newLabel("Arrows are decorations, not clickable buttons."))
  decorations.packStart(newArrow(arrowRight, shadowIn), packShrink)
  layout.packStart(decorations, packShrink)
  window.run()

when isMainModule:
  main()
