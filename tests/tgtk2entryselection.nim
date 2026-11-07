# Unrealized GtkEditable tests: select_region returns before PRIMARY operations.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc unrealized(entry: ui.Entry) = doAssert not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
proc choose(c: EntryCompletion, row: int) =
  let model = n.entry_completion_get_model(c.raw)
  var iter: n.TTreeIter
  doAssert g.toBool(n.iter_nth_child(model, addr iter, nil, g.gint(row)))
  var handled: g.gboolean
  g.g_signal_emit_by_name(c.raw, "match-selected", model, addr iter, addr handled)
ui.init()
suite "Entry Unicode cursor and selection (unrealized)":
  test "forward/reverse code-point ranges, copied snapshots and selected text":
    let entry = newEntry("Aλ🙂e\u0301Z")
    defer: entry.destroy()
    unrealized(entry)
    check entry.characterCount == 6
    var changed = 0
    entry.onChanged(proc () = inc changed)
    entry.selectRange(5, 1)
    let reverse = entry.selectionBounds
    check reverse.hasSelection and reverse.first == 1 and reverse.last == 5
    check reverse.anchor == 5 and reverse.cursor == 1 and entry.cursorOffset == 1
    let copied = entry.selectedText
    check copied == "λ🙂e\u0301"
    entry.selectRange(1, 5)
    check entry.selectionBounds.anchor == 1 and entry.cursorOffset == 5
    entry.clearSelection()
    check not entry.hasSelection and entry.cursorOffset == 5
    check entry.selectionBounds.first == 5 and entry.selectionBounds.last == 5
    check entry.selectedText == ""
    entry.cursorOffset = 2
    check entry.cursorOffset == 2 and not entry.hasSelection
    entry.selectAll()
    check entry.selectedText == entry.text and entry.cursorOffset == 6
    check changed == 0 and copied == "λ🙂e\u0301" and reverse.cursor == 1
    unrealized(entry)
    drain()
    unrealized(entry)
    entry.destroy()
    check copied == "λ🙂e\u0301" and reverse.anchor == 5
    expect ValueError: discard entry.characterCount
  test "both endpoints are checked atomically, no sentinel or byte offsets":
    let entry = newEntry("λ🙂")
    defer: entry.destroy()
    unrealized(entry)
    entry.selectRange(2, 1)
    let before = entry.selectionBounds
    for bounds in [(-1, 0), (0, -1), (0, 3), (3, 0), (high(int), 0)]:
      expect ValueError: entry.selectRange(bounds[0], bounds[1])
      check entry.selectionBounds == before
    expect ValueError: entry.cursorOffset = -1
    expect ValueError: entry.cursorOffset = 3
    check entry.selectionBounds == before
    entry.text = ""
    entry.selectAll()
    entry.selectRange(0, 0)
    check entry.characterCount == 0 and not entry.hasSelection and entry.cursorOffset == 0
    unrealized(entry)
  test "readonly navigation allowed; password snapshots but no selected plaintext":
    let entry = newEntry("λ🙂secret")
    defer: entry.destroy()
    unrealized(entry)
    entry.editable = false
    entry.selectRange(0, 2)
    check entry.selectedText == "λ🙂"
    entry.textVisible = false
    check entry.selectionBounds.hasSelection and entry.characterCount == 8
    expect ValueError: discard entry.selectedText
    entry.cursorOffset = 1
    entry.clearSelection()
    expect ValueError: discard entry.selectedText
    entry.selectAll()
    check entry.cursorOffset == 8 and entry.text == "λ🙂secret"
    unrealized(entry)
  test "focus keeps reverse direction without realization or changed emissions":
    let host = newWindow("Unrealized focus")
    defer: host.destroy()
    let entry = newEntry("λ🙂abc")
    host.add(entry)
    unrealized(entry)
    entry.selectRange(4, 1)
    let before = entry.selectionBounds
    entry.focus()
    check entry.selectionBounds == before
    unrealized(entry)
    entry.cursorOffset = 2
    entry.focus()
    check entry.cursorOffset == 2 and not entry.hasSelection
    unrealized(entry)
  test "protected combo entry and inherited SpinButton GtkEditable behavior":
    let combo = newComboBoxText(["λ🙂x"], editable = true)
    let child = combo.entry
    combo.activeIndex = 0
    unrealized(child)
    child.selectRange(2, 0)
    check child.selectedText == "λ🙂" and child.cursorOffset == 0
    check combo.activeIndex == 0 and child.selectionBounds.anchor == 2
    combo.destroy()
    expect ValueError: discard child.selectionBounds
    let spin = newSpinButton(newAdjustment(12.5, 0, 100, 0.1), digits = 1)
    defer: spin.destroy()
    unrealized(spin)
    spin.selectAll()
    check spin.selectedText == spin.text and spin.cursorOffset == spin.characterCount
    unrealized(spin)
  test "selection helpers cancel queued completion actions/commits but invalid ranges do not":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"], actions = ["Act"])
    defer: c.close()
    entry.completion = c
    var selected, actions = 0
    c.onSelected(proc (value: CompletionSelection) = inc selected)
    c.onActionActivated(proc (value: CompletionAction) = inc actions)
    choose(c, 0)
    expect ValueError: entry.selectRange(0, 99)
    drain()
    check entry.text == "alpha" and selected == 1
    choose(c, 0)
    entry.selectRange(2, 0)
    drain()
    check entry.cursorOffset == 0 and selected == 1
    g.g_signal_emit_by_name(c.raw, "action-activated", g.gint(0))
    entry.clearSelection()
    drain()
    check actions == 0
    unrealized(entry)
  test "checked snapshots and mutation are forbidden in synchronous model functions":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: discard entry.selectionBounds
      except ValueError: inc denied
      try: entry.cursorOffset = 0
      except ValueError: inc denied
      try: entry.focus()
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 3 and denied mod 3 == 0
    unrealized(entry)
