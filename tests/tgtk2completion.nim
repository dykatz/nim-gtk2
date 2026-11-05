# Hidden configuration/lifetime tests. No completion popup is mapped.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
# All-pointer native signal arguments; a mapped keyboard test also covers the
# actual popup dispatch rather than relying solely on this lifecycle probe.
proc choose(c: EntryCompletion, row: int) =
  let model = n.entry_completion_get_model(c.raw)
  var iter: n.TTreeIter
  doAssert g.toBool(n.iter_nth_child(model, addr iter, nil, g.gint(row)))
  var handled: g.gboolean
  g.g_signal_emit_by_name(c.raw, "match-selected", model, addr iter, addr handled)
  doAssert g.toBool(handled)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]

gtk2.init()
suite "text completion and editable combo (never mapped)":
  test "fixed text model validation, properties, exclusive entry attachment and copied items":
    expect ValueError: discard newEntryCompletion(["\xff"])
    expect ValueError: discard newEntry("\xff")
    let c = newEntryCompletion(["Nim", "Nimble", "λ🙂"])
    defer: c.close()
    let copy = c.items
    c.setItems(["new"])
    check copy == @["Nim", "Nimble", "λ🙂"] and c.items == @["new"]
    expect ValueError: c.setItems(["bad\0value"])
    check c.items == @["new"]
    c.minimumKeyLength = 0
    c.popupSingleMatch = false
    c.popupSetWidth = false
    c.popupCompletion = false
    check c.minimumKeyLength == 0 and not c.popupSingleMatch and not c.popupSetWidth and not c.popupCompletion
    expect ValueError: c.minimumKeyLength = -1
    expect ValueError: c.refilter()
    let a = newEntry()
    expect ValueError: a.text = "\xff"
    expect ValueError: a.insertText("\xff")
    let b = newEntry()
    defer:
      a.destroy()
      b.destroy()
    a.completion = c
    check c.attached and a.completion.raw == c.raw
    a.completion = c
    expect ValueError: b.completion = c
    c.refilter()
    a.clearCompletion()
    check not c.attached and a.completion.closed
    b.completion = c
    b.destroy()
    check not c.attached
    let spin = newSpinButton()
    defer: spin.destroy()
    expect ValueError: gtk2.Entry(spin).completion = c
  test "selection commits at idle; stale key/model, readonly and detach cancel insertion":
    let entry = newEntry("Ni")
    defer: entry.destroy()
    let c = newEntryCompletion(["Nim λ🙂", "Nimble"])
    defer: c.close()
    entry.completion = c
    var values: seq[CompletionSelection]
    c.onSelected(proc (value: CompletionSelection) = values.add(value))
    choose(c, 0)
    check entry.text == "Ni" and values.len == 0
    drain()
    check entry.text == "Nim λ🙂" and values.len == 1 and values[0].index == 0
    entry.text = "Ni"
    choose(c, 1)
    entry.text = "typed after selection"
    drain()
    check entry.text == "typed after selection" and values.len == 1
    entry.text = "Ni"
    choose(c, 0)
    c.setItems(["Replacement"])
    drain()
    check entry.text == "Ni" and values.len == 1
    entry.editable = false
    choose(c, 0)
    drain()
    check entry.text == "Ni"
    c.detach()
    check not c.attached
  test "password hiding detaches, callback reentrancy and owner destruction are safe":
    let entry = newEntry("prefix")
    let c = newEntryCompletion(["committed"])
    defer: c.close()
    entry.textVisible = false
    expect ValueError: entry.completion = c
    entry.textVisible = true
    entry.completion = c
    var calls = 0
    let canceled = c.onSelected(proc (value: CompletionSelection) = inc calls)
    choose(c, 0)
    entry.textVisible = false
    drain()
    check entry.text == "prefix" and not c.attached and not canceled.connected and calls == 0
    entry.textVisible = true
    entry.completion = c
    c.onSelected(proc (value: CompletionSelection) =
      inc calls
      entry.destroy()
      c.close()
      raise newException(ValueError, "expected completion observer error"))
    choose(c, 0)
    drain()
    check calls == 1 and entry.isDestroyed and c.closed
    c.close()
  test "destroying the entry during the deferred text change avoids native emitter reentrancy":
    let entry = newEntry()
    let c = newEntryCompletion(["text"])
    defer: c.close()
    entry.completion = c
    entry.onChanged(proc () = entry.destroy())
    choose(c, 0)
    drain()
    check entry.isDestroyed and not c.attached
  test "reattachment during the native text setter is rejected until its emitter returns":
    let entry = newEntry()
    let other = newEntry()
    let c = newEntryCompletion(["text"])
    defer:
      c.close()
      entry.destroy()
      other.destroy()
    entry.completion = c
    var rejected = false
    entry.onChanged(proc () =
      c.detach()
      try: other.completion = c
      except ValueError: rejected = true)
    choose(c, 0)
    drain()
    check rejected and not c.attached
    other.completion = c
    check c.attached
  test "native completion survives a text callback dropping its final public handle":
    let entry = newEntry()
    var c = newEntryCompletion(["text"])
    var finalized = 0
    g.weak_ref(cast[g.PGObject](c.raw), gone, addr finalized)
    entry.completion = c
    entry.onChanged(proc () =
      c.close()
      c = EntryCompletion()
      entry.destroy())
    choose(c, 0)
    drain()
    check finalized == 1 and entry.isDestroyed
  test "native entry retains completion even when SDK handles drop; owner destroy releases bridges":
    let entry = newEntry()
    var finalized = 0
    block:
      let c = newEntryCompletion(["text"])
      g.weak_ref(cast[g.PGObject](c.raw), gone, addr finalized)
      entry.completion = c
    check finalized == 0
    check entry.completion.items == @["text"]
    entry.destroy()
    check finalized == 1
  test "editable combo entry is protected, UTF-8 checked and text observations coalesce":
    let combo = newComboBoxText(["Nim", "λ🙂"], editable = true)
    defer: combo.destroy()
    let child = combo.entry
    var values: seq[ComboTextState]
    combo.onTextChanged(proc (value: ComboTextState) = values.add(value))
    combo.activeIndex = 1
    combo.entryText = "custom"
    check values.len == 0
    drain()
    check values.len == 1 and values[0].index == -1 and values[0].text == "custom"
    expect ValueError: combo.appendText("\xff")
    expect ValueError: combo.entryText = "\xff"
    expect ValueError: child.destroy()
    expect ValueError: gtk2.Container(combo).remove(child)
    check combo.itemCount == 2 and combo.entryText == "custom"
    let c = newEntryCompletion(["customary"])
    defer: c.close()
    child.completion = c
    choose(c, 0)
    drain()
    check combo.entryText == "customary"
    combo.destroy()
    check child.isDestroyed and not c.attached
    let fixed = newComboBoxText(["fixed"])
    defer: fixed.destroy()
    expect ValueError: discard fixed.entry
