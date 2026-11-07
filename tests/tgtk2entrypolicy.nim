# Unrealized widgets only. No PRIMARY requests/ownership, input or windows.
import std/[strutils, unittest]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc unrealized(entry: ui.Entry) = doAssert not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
proc choose(c: EntryCompletion) =
  let model = n.entry_completion_get_model(c.raw)
  var iter: n.TTreeIter
  doAssert g.toBool(n.iter_nth_child(model, addr iter, nil, 0))
  var handled: g.gboolean
  g.g_signal_emit_by_name(c.raw, "match-selected", model, addr iter, addr handled)
proc dropEntry(instance: g.PGObject, spec: g.PGParamSpec, data: pointer) {.cdecl.} =
  cast[ptr ui.Entry](data)[] = default(ui.Entry)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
static:
  doAssert not compiles(n.activates_default(n.PEntry(nil)))
ui.init()
suite "Entry limits and presentation (unrealized)":
  test "native character limits preserve UTF-8, zero resets policy, no fake unlimited capacity":
    let entry = newEntry("Aλ🙂e\u0301Z")
    defer: entry.destroy()
    unrealized(entry)
    check entry.maxLength == 0
    entry.maxLength = 4
    check entry.maxLength == 4 and entry.text == "Aλ🙂e" and entry.characterCount == 4
    entry.text = "λ🙂abcd"
    check entry.text == "λ🙂ab" and entry.characterCount == 4
    entry.maxLength = 0
    entry.text = "λ🙂abcd"
    check entry.characterCount == 6
    entry.maxLength = 65535
    check entry.maxLength == 65535
    entry.maxLength = 0
    entry.text = "🙂".repeat(20000)
    check entry.text.len <= 65534 and entry.characterCount < 20000
    check g.toBool(g.g_utf8_validate(entry.text.cstring, g.gssize(entry.text.len), nil))
    unrealized(entry)
  test "validation is atomic and presentation/default flags round-trip through GTK":
    let entry = newEntry("λ🙂abc")
    defer: entry.destroy()
    unrealized(entry)
    entry.maxLength = 5
    entry.selectRange(4, 1)
    let before = entry.selectionBounds
    for value in [-1, 65536, high(int)]:
      expect ValueError: entry.maxLength = value
      check entry.maxLength == 5 and entry.text == "λ🙂abc" and entry.selectionBounds == before
    check entry.widthChars == -1 and entry.alignment == 0.0 and not entry.activatesDefault
    for value in [-1, 0, 12]:
      entry.widthChars = value
      check entry.widthChars == value
    expect ValueError: entry.widthChars = -2
    when sizeof(int) > 4:
      expect ValueError: entry.widthChars = high(int)
    check entry.widthChars == 12
    for value in [0.0, 0.3, 0.5, 1.0]:
      entry.alignment = value
      check abs(entry.alignment - value) < 0.000001
    for value in [-0.1, 1.1, Inf, NegInf, NaN]:
      expect ValueError: entry.alignment = value
      check entry.alignment == 1.0
    entry.activatesDefault = true
    check entry.activatesDefault and g.toBool(n.get_activates_default(entry.raw))
    entry.activatesDefault = false
    check not entry.activatesDefault and not g.toBool(n.get_activates_default(entry.raw))
    check entry.selectionBounds == before and entry.text == "λ🙂abc"
    unrealized(entry)
  test "truncation callbacks are deferred and see the committed native limit":
    let entry = newEntry("λ🙂abc")
    defer: entry.destroy()
    var limits: seq[int]
    entry.onChanged(proc () = limits.add(entry.maxLength)) # Registered before policy frame.
    var snapshots: seq[EntrySelection]
    entry.selectAll()
    entry.onSelectionChanged(proc (value: EntrySelection) = snapshots.add(value))
    entry.maxLength = 3
    entry.maxLength = 2
    check limits.len == 0 and entry.text == "λ🙂"
    drain()
    check limits == @[2] and snapshots.len == 1
    check snapshots[0] == entry.selectionBounds
    entry.text = "ab" # Ordinary popup-only/non-inline timing is unchanged.
    check limits.len == 2
    unrealized(entry)
  test "deferred changed callback can reconfigure or destroy beyond the native buffer setter":
    let entry = newEntry("λ🙂abcd")
    var seen: seq[int]
    entry.onChanged(proc () =
      seen.add(entry.maxLength)
      if seen.len == 1: entry.maxLength = 1
      else: entry.destroy())
    entry.maxLength = 3
    check seen.len == 0
    drain()
    check seen == @[3, 1] and entry.isDestroyed
  test "combo parent observations defer too, and child remains protected":
    let combo = newComboBoxText(["λ🙂abcd"], editable = true)
    defer: combo.destroy()
    combo.activeIndex = 0
    let child = combo.entry
    var entryValues, comboValues: seq[int]
    child.onChanged(proc () = entryValues.add(child.maxLength))
    combo.onChanged(proc () = comboValues.add(child.maxLength))
    child.maxLength = 2
    check entryValues.len == 0 and comboValues.len == 0 and child.text == "λ🙂"
    drain()
    check entryValues == @[2] and comboValues == @[2] and combo.activeIndex == -1
    child.widthChars = 9
    child.alignment = 0.75
    child.activatesDefault = true
    check child.widthChars == 9 and child.activatesDefault
    expect ValueError: child.destroy()
    unrealized(child)
  test "readonly/password and inherited SpinButton retain native text/value policy":
    let entry = newEntry("λ🙂secret")
    defer: entry.destroy()
    entry.editable = false
    entry.textVisible = false
    entry.maxLength = 2
    check entry.text == "λ🙂" and entry.characterCount == 2
    expect ValueError: discard entry.selectedText
    unrealized(entry)
    let spin = newSpinButton(newAdjustment(12.5, 0, 100, 0.1), digits = 1)
    defer: spin.destroy()
    let value = spin.value
    spin.maxLength = 2
    check spin.characterCount <= 2 and spin.value == value
    spin.widthChars = 8
    spin.alignment = 1
    spin.activatesDefault = true
    check spin.widthChars == 8 and spin.alignment == 1 and spin.activatesDefault
    unrealized(spin)
  test "max policy cancels queued completion even without truncation; invalid policy does not":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"], actions = ["Act"])
    defer: c.close()
    entry.completion = c
    var selected, actions = 0
    c.onSelected(proc (value: CompletionSelection) = inc selected)
    c.onActionActivated(proc (value: CompletionAction) = inc actions)
    choose(c)
    expect ValueError: entry.maxLength = -1
    drain()
    check selected == 1 and entry.text == "alpha"
    choose(c)
    entry.maxLength = 20
    drain()
    check selected == 1
    g.g_signal_emit_by_name(c.raw, "action-activated", g.gint(0))
    entry.maxLength = 19
    drain()
    check actions == 0
    unrealized(entry)
  test "native property emitters stay pinned when a raw notify drops the final public alias":
    for property in ["xalign", "width-chars", "activates-default", "max-length"]:
      var entry = newEntry("abcdef")
      var finalized = 0
      g.weak_ref(cast[g.PGObject](entry.raw), gone, addr finalized)
      let signal = "notify::" & property
      discard g.g_signal_connect_data(entry.raw, signal.cstring,
        cast[g.TGCallback](dropEntry), addr entry, nil, g.TGConnectFlags(0))
      case property
      of "xalign": entry.alignment = 0.5
      of "width-chars": entry.widthChars = 10
      of "activates-default": entry.activatesDefault = true
      else: entry.maxLength = 2
      check entry.isDestroyed and finalized == 1
  test "destroy/disconnect cancel deferred captures; pure matching cannot use policy":
    let entry = newEntry("abcdef")
    var changed = 0
    let changedToken = entry.onChanged(proc () = inc changed)
    entry.maxLength = 3
    changedToken.disconnect()
    drain()
    check changed == 0
    entry.onChanged(proc () = inc changed)
    entry.maxLength = 2
    entry.destroy()
    drain()
    check changed == 0
    let other = newEntry("a")
    defer: other.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    other.completion = c
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: discard other.maxLength
      except ValueError: inc denied
      try: other.maxLength = 1
      except ValueError: inc denied
      try: other.alignment = 0.5
      except ValueError: inc denied
      try: other.activatesDefault = true
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 4 and denied mod 4 == 0
    unrealized(other)
