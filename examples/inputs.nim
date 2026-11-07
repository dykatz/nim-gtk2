## Numeric input, a shared adjustment, and fixed/editable text choices.
## Build: nim c --path:src examples/inputs.nim
import std/strutils
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 measurement inputs and completion", 880, 660)
  defer: window.destroy()
  window.borderWidth = 12
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let name = newComboBoxText(["Length", "Width", "Height"], editable = true)
  name.activeIndex = 0
  layout.packStart(name, packShrink)
  name.entry.widthChars = 24
  let policyRow = newHBox(spacing = 6)
  let limit = newSpinButton(0, 64, 1)
  limit.numeric = true
  limit.widthChars = 4
  let width = newSpinButton(-1, 40, 1)
  width.value = 24
  width.widthChars = 4
  let align = newComboBoxText(["Left", "Center", "Right"])
  align.activeIndex = 0
  policyRow.packStart(newLabel("Max code points (0=native cap):"), packShrink)
  policyRow.packStart(limit, packShrink)
  policyRow.packStart(newLabel("Requested width (-1=default):"), packShrink)
  policyRow.packStart(width, packShrink)
  policyRow.packStart(align, packShrink)
  layout.packStart(policyRow, packShrink)
  limit.onValueChanged(proc () = name.entry.maxLength = limit.value.int)
  width.onValueChanged(proc () = name.entry.widthChars = width.value.int)
  align.onChanged(proc () =
    if align.activeIndex >= 0: name.entry.alignment = float64(align.activeIndex) / 2.0)
  let activateDefault = newCheckButton("Activate host default on Return (this window has no implicit default)")
  activateDefault.onToggled(proc () = name.entry.activatesDefault = activateDefault.active)
  layout.packStart(activateDefault, packShrink)
  let suggestions = newEntryCompletion(
    ["Length", "Length unit", "Width", "Width offset", "Height", "Height λ🙂"],
    actions = ["Use current label (free text)", "Reset measurement to Length"])
  defer: suggestions.close()
  name.entry.completion = suggestions
  layout.packStart(newLabel("Type a prefix; Down previews, Escape restores, Return selects. Free text is allowed."), packShrink)
  layout.packStart(newLabel("Down past suggestions (or Up) selects actions; actions never auto-insert their labels."), packShrink)
  let policies = newHBox(spacing = 6)
  let inline = newCheckButton("Inline common prefix")
  let preview = newCheckButton("Inline popup preview")
  let popup = newCheckButton("Popup")
  popup.active = true
  for option in [inline, preview, popup]: policies.packStart(option, packShrink)
  layout.packStart(policies, packShrink)
  inline.onToggled(proc () = suggestions.inlineCompletion = inline.active)
  preview.onToggled(proc () = suggestions.inlineSelection = preview.active)
  popup.onToggled(proc () = suggestions.popupCompletion = popup.active)
  layout.packStart(newLabel("Inline changes are provisional; SDK entry/combo observers run at idle."), packShrink)
  let matching = newCheckButton("Custom ASCII substring matching (not Unicode normalization)")
  layout.packStart(matching, packShrink)
  matching.onToggled(proc () =
    if matching.active:
      suggestions.setMatch(proc (input: CompletionMatchInput): bool =
        # Synchronous pure computation on copies only: never access widgets here.
        input.text.toLowerAscii.contains(input.key))
    else:
      suggestions.clearMatch() # Actual GTK default matcher, not an approximation.
    suggestions.refilter())

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
  suggestions.onActionActivated(proc (value: CompletionAction) =
    # Deferred past native keyboard/mouse traversal. Explicit application policy:
    selected.text = "Action " & $value.index & ": " & value.text & " (key: " & value.key & ")"
    if value.index == 1:
      name.entryText = "Length"
      amount.value = 25.4)

  let provisional = newLabel("No inline change")
  layout.packStart(provisional, packShrink)
  suggestions.onInlineChanged(proc (value: CompletionInlineState) =
    provisional.text = $value.kind & ": " & value.text & " — suffix " &
      $value.first & ".." & $value.last & " (key: " & value.key & ")")
  let selectionStatus = newLabel("Selection changes arrive at UI idle")
  layout.packStart(selectionStatus, packShrink)
  proc showSelection(state: EntrySelection) =
    selectionStatus.text = "Code points: " & $name.entry.characterCount &
      "; anchor/cursor " & $state.anchor & "/" & $state.cursor &
      "; range " & $state.first & ".." & $state.last
  proc inspectSelection() = showSelection(name.entry.selectionBounds)
  let selectionChanges = name.entry.onSelectionChanged(
    (proc (state: EntrySelection) = showSelection(state)), initial = true)
  defer: selectionChanges.disconnect()
  let selectionRow = newHBox(spacing = 6)
  let all = newButton("Select all")
  let reverse = newButton("Reverse last 2 code points")
  let clear = newButton("Clear selection")
  let inspect = newButton("Inspect selection")
  for button in [all, reverse, clear, inspect]: selectionRow.packStart(button, packShrink)
  layout.packStart(selectionRow, packShrink)
  layout.packStart(newLabel("Realized selections use native PRIMARY ownership; Inspect is read-only."), packShrink)
  all.onClicked(proc () =
    name.entry.selectAll()
    name.entry.focus() # Keeps the active endpoint, including reverse selections.
    inspectSelection())
  reverse.onClicked(proc () =
    let count = name.entry.characterCount
    name.entry.selectRange(count, max(0, count - 2))
    name.entry.focus()
    inspectSelection())
  clear.onClicked(proc () =
    name.entry.clearSelection()
    inspectSelection())
  inspect.onClicked(proc () = inspectSelection())
  window.onDestroy(proc () = suggestions.close())

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
