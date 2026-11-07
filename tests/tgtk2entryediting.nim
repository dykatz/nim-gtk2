# Unrealized display/edit policy tests: no PRIMARY ownership/requests or input.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc unrealized(entry: ui.Entry) = doAssert not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
proc dropEntry(instance: g.PGObject, spec: g.PGParamSpec, data: pointer) {.cdecl.} =
  cast[ptr ui.Entry](data)[] = default(ui.Entry)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
static:
  doAssert not compiles(n.overwrite_mode(n.PEntry(nil)))
  doAssert not compiles(n.has_frame(n.PEntry(nil)))
ui.init()
suite "Entry native editing and mask presentation (unrealized)":
  test "frame/overwrite bools round-trip and do not mutate text/selection":
    let entry = newEntry("λ🙂abc")
    defer: entry.destroy()
    unrealized(entry)
    entry.selectRange(4, 1)
    let before = entry.selectionBounds
    var changed, selections = 0
    entry.onChanged(proc () = inc changed)
    entry.onSelectionChanged(proc (value: EntrySelection) = inc selections)
    check entry.hasFrame and not entry.overwriteMode
    for value in [false, true, true, false]:
      entry.hasFrame = value
      entry.overwriteMode = value
      check entry.hasFrame == value and entry.overwriteMode == value
      check g.toBool(n.get_has_frame(entry.raw)) == value
      check g.toBool(n.get_overwrite_mode(entry.raw)) == value
    drain()
    check entry.text == "λ🙂abc" and entry.selectionBounds == before and changed == 0 and selections == 0
    unrealized(entry)
  test "explicit mask vs native default, zero, non-BMP scalar and atomic invalid values":
    let entry = newEntry("λ🙂secret")
    defer: entry.destroy()
    unrealized(entry)
    check not entry.invisibleCharSet
    let nativeDefault = entry.invisibleChar
    entry.invisibleChar = nativeDefault # Same glyph still makes policy explicit.
    check entry.invisibleCharSet and entry.invisibleChar == nativeDefault
    entry.textVisible = false
    entry.selectRange(2, 0)
    let before = entry.selectionBounds
    for value in [0'u32, 0x2a'u32, 0x2022'u32, 0x1f512'u32]:
      entry.invisibleChar = value
      check entry.invisibleChar == value and entry.invisibleCharSet
      check entry.selectionBounds == before and entry.text == "λ🙂secret"
      expect ValueError: discard entry.selectedText
    for bad in [0xd800'u32, 0xdfff'u32, 0x110000'u32, high(uint32)]:
      expect ValueError: entry.invisibleChar = bad
      check entry.invisibleChar == 0x1f512'u32 and entry.invisibleCharSet
      check entry.selectionBounds == before
    entry.unsetInvisibleChar()
    check not entry.invisibleCharSet
    entry.unsetInvisibleChar()
    check not entry.invisibleCharSet and entry.invisibleChar == nativeDefault
    entry.textVisible = true
    check entry.selectedText == "λ🙂" # Visibility, not mask choice, gates extraction.
    unrealized(entry)
  test "programmatic insertion is not simulated keyboard overwrite":
    let entry = newEntry("λ🙂AB")
    defer: entry.destroy()
    entry.overwriteMode = true
    entry.cursorOffset = 2
    entry.insertText("X")
    check entry.text == "λ🙂XAB" # Native GtkEditable insertion, not gtk_entry_enter_text.
    entry.text = "replaced"
    check entry.text == "replaced" and entry.overwriteMode
    unrealized(entry)
  test "readonly, protected combo and inherited SpinButton policies remain native":
    let combo = newComboBoxText(["λ🙂abc"], editable = true)
    defer: combo.destroy()
    combo.activeIndex = 0
    let entry = combo.entry
    entry.editable = false
    entry.hasFrame = false
    entry.overwriteMode = true
    entry.invisibleChar = 0x2a
    entry.textVisible = false
    check combo.activeIndex == 0 and entry.text == "λ🙂abc"
    check entry.overwriteMode and not entry.hasFrame and entry.invisibleCharSet
    expect ValueError: discard entry.selectedText
    expect ValueError: entry.destroy()
    unrealized(entry)
    let spin = newSpinButton(newAdjustment(12.5, 0, 100, 0.1), digits = 1)
    defer: spin.destroy()
    let value = spin.value
    spin.hasFrame = false
    spin.overwriteMode = true
    spin.invisibleChar = 0x2a
    check spin.value == value and not spin.hasFrame and spin.overwriteMode
    spin.unsetInvisibleChar()
    check not spin.invisibleCharSet
    unrealized(spin)
  test "password visibility detaches completion; mask policy itself does not":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    entry.invisibleChar = 0
    entry.hasFrame = false
    entry.overwriteMode = true
    check c.attached and entry.textVisible
    entry.textVisible = false
    check not c.attached
    entry.unsetInvisibleChar()
    check not c.attached and not entry.invisibleCharSet and not entry.textVisible
    unrealized(entry)
  test "native emitters pinned when notify drops final alias, including visibility":
    for property in ["has-frame", "overwrite-mode", "invisible-char-set", "invisible-char", "visibility"]:
      var entry = newEntry("abcdef")
      var finalized = 0
      g.weak_ref(cast[g.PGObject](entry.raw), gone, addr finalized)
      let signal = "notify::" & property
      discard g.g_signal_connect_data(entry.raw, signal.cstring,
        cast[g.TGCallback](dropEntry), addr entry, nil, g.TGConnectFlags(0))
      case property
      of "has-frame": entry.hasFrame = false
      of "overwrite-mode": entry.overwriteMode = true
      of "visibility": entry.textVisible = false
      else: entry.invisibleChar = 0x2a
      check entry.isDestroyed and finalized == 1
  test "unsetting native default mask is pinned through char-set notification":
    var entry = newEntry("abcdef")
    entry.invisibleChar = 0x2a
    var finalized = 0
    g.weak_ref(cast[g.PGObject](entry.raw), gone, addr finalized)
    discard g.g_signal_connect_data(entry.raw, "notify::invisible-char-set",
      cast[g.TGCallback](dropEntry), addr entry, nil, g.TGConnectFlags(0))
    entry.unsetInvisibleChar()
    check entry.isDestroyed and finalized == 1
  test "pure matching rejects policy access and mutation; destroyed getters reject":
    let entry = newEntry("a")
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: entry.overwriteMode = true
      except ValueError: inc denied
      try: discard entry.invisibleCharSet
      except ValueError: inc denied
      try: entry.invisibleChar = 0
      except ValueError: inc denied
      try: entry.unsetInvisibleChar()
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 4 and denied mod 4 == 0
    unrealized(entry)
    entry.destroy()
    expect ValueError: discard entry.hasFrame
    expect ValueError: discard entry.invisibleChar
