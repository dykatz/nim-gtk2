## Numeric input, a shared adjustment, and fixed/editable text choices.
## Build: nim c --path:src examples/inputs.nim
import std/strutils
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 measurement inputs and completion", 520, 340)
  defer: window.destroy()
  window.borderWidth = 12
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let name = newComboBoxText(["Length", "Width", "Height"], editable = true)
  name.activeIndex = 0
  layout.packStart(name, packShrink)
  let suggestions = newEntryCompletion(["Length", "Length unit", "Width", "Width offset", "Height", "Height λ🙂"])
  defer: suggestions.close()
  name.entry.completion = suggestions
  layout.packStart(newLabel("Type a prefix above; use Down/Return to choose a suggestion. Free text is allowed."), packShrink)

  let amount = newAdjustment(25.4, 0, 1000, 0.1, 10)
  let input = newSpinButton(amount, digits = 2)
  let mirror = newSpinButton(amount, digits = 3)
  input.numeric = true
  mirror.numeric = true
  let units = newComboBoxText(["Centimeters", "Inches"])
  units.activeIndex = 0
  let row = newHBox(spacing = 6)
  row.packStart(input)
  row.packStart(units)
  layout.packStart(row, packShrink)
  layout.packStart(newLabel("Same adjustment, different decimal display:"), packShrink)
  layout.packStart(mirror, packShrink)
  let output = newLabel()
  layout.packStart(output)
  let selected = newLabel("No completion selected")
  layout.packStart(selected, packShrink)
  suggestions.onSelected(proc (value: CompletionSelection) =
    selected.text = "Suggestion " & $value.index & ": " & value.text)

  proc refresh() =
    let centimeters = units.activeIndex == 0
    let converted = if centimeters: amount.value / 2.54 else: amount.value * 2.54
    let suffix = if centimeters: " inches" else: " cm"
    output.text = name.activeText & ": " & formatFloat(converted, ffDecimal, 3) & suffix

  let values = amount.onValueChanged(proc () = refresh())
  # Shared adjustments are not destroyed with widgets. Disconnect their closure
  # before destroying the window so it cannot keep the widget tree alive.
  defer: values.disconnect()
  units.onChanged(proc () = refresh())
  name.onTextChanged(proc (state: ComboTextState) = refresh())
  refresh()
  window.run()

when isMainModule:
  main()
