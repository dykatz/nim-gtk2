## Numeric input, a shared adjustment, and fixed/editable text choices.
## Build: nim c --path:src examples/inputs.nim
import std/strutils
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 measurement inputs and completion", 960, 740)
  defer: window.destroy()
  window.borderWidth = 12
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let name = newComboBoxText(["Length", "Width", "Height"], editable = true)
  name.activeIndex = 0
  name.entry.setIconName(iconPrimary, "edit-find")
  name.entry.setIconTooltip(iconPrimary, "Press for input information")
  name.entry.setIconName(iconSecondary, "edit-clear")
  name.entry.setIconTooltip(iconSecondary, "Press to clear free text")
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
  let progressRow = newHBox(spacing = 6)
  let fraction = newSpinButton(0, 1, 0.05)
  fraction.digits = 2
  let pulse = newButton("Pulse once (no automatic timer)")
  let clearProgress = newButton("Clear / end activity")
  progressRow.packStart(newLabel("Requested determinate progress:"), packShrink)
  progressRow.packStart(fraction, packShrink)
  progressRow.packStart(pulse, packShrink)
  progressRow.packStart(clearProgress, packShrink)
  layout.packStart(progressRow, packShrink)
  name.entry.progressPulseStep = 0.15
  fraction.onValueChanged(proc () = name.entry.progressFraction = fraction.value)
  pulse.onClicked(proc () = name.entry.progressPulse())
  clearProgress.onClicked(proc () =
    name.entry.progressFraction = 0 # Explicit assignment ends activity even at zero.
    fraction.value = 0)
  let editingRow = newHBox(spacing = 6)
  let overwrite = newCheckButton("Overwrite typed input (Insert also toggles natively)")
  let frame = newCheckButton("Entry frame (not combo outer frame)")
  frame.active = name.entry.hasFrame
  editingRow.packStart(overwrite, packShrink)
  editingRow.packStart(frame, packShrink)
  let readOnly = newCheckButton("Read-only input")
  editingRow.packStart(readOnly, packShrink)
  # Public GtkEditable policy; never write Entry flags or private IME state.
  readOnly.onToggled(proc () = name.entry.editable = not readOnly.active)
  layout.packStart(editingRow, packShrink)
  overwrite.onToggled(proc () = name.entry.overwriteMode = overwrite.active)
  frame.onToggled(proc () = name.entry.hasFrame = frame.active)
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
  let iconActions = newCheckButton("Icon actions")
  iconActions.active = true
  for option in [inline, preview, popup, iconActions]: policies.packStart(option, packShrink)
  layout.packStart(policies, packShrink)
  inline.onToggled(proc () = suggestions.inlineCompletion = inline.active)
  preview.onToggled(proc () = suggestions.inlineSelection = preview.active)
  popup.onToggled(proc () = suggestions.popupCompletion = popup.active)
  iconActions.onToggled(proc () =
    for pos in [iconPrimary, iconSecondary]: name.entry.setIconActivatable(pos, iconActions.active))
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
  name.entry.onIconEvent(proc (value: EntryIconEvent) =
    # Observe native presses, not a synthesized click. The payload has no entry text.
    if value.event.kind == buttonPress and value.event.button == 1:
      if value.position == iconSecondary: name.entryText = ""
      selected.text = "Icon " & $value.position & " pressed (application policy)")
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
  let concealedRow = newHBox(spacing = 6)
  let concealed = newEntry("Sample λ🙂 — not a real secret")
  concealed.textVisible = false
  let mask = newComboBoxText(["Native mask", "Asterisk", "Bullet", "No visual feedback"])
  mask.activeIndex = 0
  let reveal = newCheckButton("Show sample")
  concealedRow.packStart(concealed)
  concealedRow.packStart(mask, packShrink)
  concealedRow.packStart(reveal, packShrink)
  layout.packStart(concealedRow, packShrink)
  mask.onChanged(proc () =
    case mask.activeIndex
    of 0: concealed.unsetInvisibleChar()
    of 1: concealed.invisibleChar = 0x2a
    of 2: concealed.invisibleChar = 0x2022
    of 3: concealed.invisibleChar = 0
    else: discard)
  reveal.onToggled(proc () = concealed.textVisible = reveal.active)
  # Masking is presentation, not encrypted storage or a clipboard security boundary.
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
