# No realization, clipboard ownership/requests, or desktop input.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc unrealized(entry: Entry) = doAssert not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
proc progressNotify(obj: g.PGObject, spec: g.PGParamSpec, data: pointer) {.cdecl.} = inc cast[ptr int](data)[]
proc dropEntry(obj: g.PGObject, spec: g.PGParamSpec, data: pointer) {.cdecl.} = cast[ptr Entry](data)[] = default(Entry)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
gtk2.init()
suite "Entry progress (unrealized)":
  test "native defaults, transitions and notification semantics; no private activity query":
    let entry = newEntry("λ🙂abc")
    defer: entry.destroy()
    unrealized(entry)
    check entry.progressFraction == 0 and entry.progressPulseStep == 0.1
    var notifications = 0
    discard g.g_signal_connect_data(entry.raw, "notify::progress-fraction", cast[g.TGCallback](progressNotify), addr notifications, nil, g.TGConnectFlags(0))
    entry.progressFraction = 0.625
    check notifications == 1 and entry.progressFraction == 0.625
    entry.progressPulse()
    check notifications == 1 and entry.progressFraction == 0 # Native pulse does not notify.
    entry.progressPulseStep = 0.25 # Step changes do not exit native activity.
    check notifications == 1 and entry.progressFraction == 0
    entry.progressFraction = 0 # Even zero ends activity and notifies natively.
    check notifications == 2
    entry.progressFraction = 0
    check notifications == 2
    for value in [0.0, 0.125, 1.0]:
      entry.progressPulseStep = value
      entry.progressPulse()
      entry.progressPulse()
      check entry.progressPulseStep == value and entry.progressFraction == 0
    entry.progressFraction = 1
    check entry.progressFraction == 1
    unrealized(entry)
  test "invalid nonfinite/out-of-range setters are atomic and do not end activity":
    let entry = newEntry("abc")
    defer: entry.destroy()
    entry.progressPulseStep = 0.25
    entry.progressFraction = 0.5
    for value in [-0.01, 1.01, Inf, NegInf, NaN]:
      expect ValueError: entry.progressFraction = value
      expect ValueError: entry.progressPulseStep = value
      check entry.progressFraction == 0.5 and entry.progressPulseStep == 0.25
    entry.progressPulse()
    expect ValueError: entry.progressFraction = NaN
    var notifications = 0
    discard g.g_signal_connect_data(entry.raw, "notify::progress-fraction", cast[g.TGCallback](progressNotify), addr notifications, nil, g.TGConnectFlags(0))
    entry.progressFraction = 0
    check notifications == 1 # Still in native activity before the valid assignment.
    unrealized(entry)
  test "no text, selection, completion, icon or user edit policy changes":
    let entry = newEntry("aλ🙂")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    entry.setIconName(iconPrimary, "edit-find")
    entry.selectRange(3, 1)
    let before = entry.selectionBounds
    var changed, selections = 0
    entry.onChanged(proc () = inc changed)
    entry.onSelectionChanged(proc (value: EntrySelection) = inc selections)
    entry.editable = false
    entry.overwriteMode = true
    entry.progressFraction = 0.75
    entry.progressPulseStep = 0.375
    entry.progressPulse()
    entry.progressFraction = 0
    drain()
    check entry.text == "aλ🙂" and entry.selectionBounds == before
    check changed == 0 and selections == 0 and c.attached
    check entry.iconName(iconPrimary) == "edit-find" and not entry.editable and entry.overwriteMode
    entry.textVisible = false
    entry.progressPulse()
    check not entry.textVisible and not c.attached
    expect ValueError: discard entry.selectedText
    unrealized(entry)
  test "protected combo/SpinButton preserve model/value and native parent ownership":
    let combo = newComboBoxText(["λ🙂abc"], editable = true)
    defer: combo.destroy()
    combo.activeIndex = 0
    let entry = combo.entry
    entry.progressFraction = 0.5
    entry.progressPulseStep = 0.125
    entry.progressPulse()
    check entry.progressFraction == 0 and combo.activeIndex == 0 and entry.text == "λ🙂abc"
    expect ValueError: entry.destroy()
    unrealized(entry)
    let spin = newSpinButton(newAdjustment(12.5, 0, 100, 0.1), digits = 1)
    defer: spin.destroy()
    spin.progressFraction = 0.75
    spin.progressPulse()
    spin.progressFraction = 0
    check spin.value == 12.5 and spin.progressFraction == 0
    unrealized(spin)
  test "setters pin native emitter through raw notify dropping last alias":
    for property in ["progress-fraction", "progress-pulse-step"]:
      var entry = newEntry("abc")
      var finalized = 0
      g.weak_ref(cast[g.PGObject](entry.raw), gone, addr finalized)
      let signal = "notify::" & property
      discard g.g_signal_connect_data(entry.raw, signal.cstring, cast[g.TGCallback](dropEntry), addr entry, nil, g.TGConnectFlags(0))
      if property == "progress-fraction": entry.progressFraction = 0.5
      else: entry.progressPulseStep = 0.25
      check entry.isDestroyed and finalized == 1
  test "synchronous matcher guard and destroyed handle rejection":
    let entry = newEntry("a")
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: entry.progressPulse()
      except ValueError: inc denied
      try: entry.progressFraction = 0.25
      except ValueError: inc denied
      try: discard entry.progressPulseStep
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 3 and denied mod 3 == 0
    unrealized(entry)
    entry.destroy()
    expect ValueError: entry.progressPulse()
    expect ValueError: discard entry.progressFraction
    expect ValueError: entry.progressPulseStep = 0.1
