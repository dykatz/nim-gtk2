# Native inline prefix tests without mapped widgets or desktop selection changes.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
type CaptureObj = object
  freed: ptr int
proc `=destroy`(value: var CaptureObj) = inc value.freed[]
type Capture = ref CaptureObj
proc watch(entry: ui.Entry, freed: ptr int): Connection =
  let capture = Capture(freed: freed)
  entry.onChanged(proc () = discard capture.freed)
proc choose(c: EntryCompletion, row: int) =
  let model = n.entry_completion_get_model(c.raw)
  var iter: n.TTreeIter
  doAssert g.toBool(n.iter_nth_child(model, addr iter, nil, g.gint(row)))
  var handled: g.gboolean
  g.g_signal_emit_by_name(c.raw, "match-selected", model, addr iter, addr handled)
  doAssert g.toBool(handled)
ui.init()
suite "inline entry completion (unmapped)":
  test "Unicode prefix and selected suffix, policy, copied idle observation":
    let entry = newEntry("λ")
    defer: entry.destroy()
    let completion = newEntryCompletion(["λ🙂abc", "λ🙂abd"])
    defer: completion.close()
    completion.popupCompletion = false
    completion.inlineCompletion = true
    check completion.inlineCompletion and not completion.inlineSelection
    expect ValueError: completion.insertPrefix()
    entry.completion = completion
    var values: seq[CompletionInlineState]
    let token = completion.onInlineChanged(proc (value: CompletionInlineState) = values.add(value))
    completion.insertPrefix()
    check entry.text == "λ🙂ab" and values.len == 0
    drain()
    check values.len == 1 and values[0].kind == inlinePrefix
    check values[0].key == "λ" and values[0].text == "λ🙂ab" and values[0].index == -1
    check values[0].first == 1 and values[0].last == 4
    check not completion.completionPrefix.available # Native popup history, not common prefix.
    token.disconnect()
    check not token.connected
  test "combined inline policy preserves final popup commits and cancels provisional delivery":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha", "alpine"])
    defer: completion.close()
    completion.inlineCompletion = true
    completion.inlineSelection = true
    completion.popupCompletion = false
    entry.completion = completion
    var selected: seq[CompletionSelection]
    var provisional = 0
    completion.onSelected(proc (value: CompletionSelection) = selected.add(value))
    completion.onInlineChanged(proc (value: CompletionInlineState) = inc provisional)
    completion.insertPrefix()
    check entry.text == "alp"
    choose(completion, 1)
    check selected.len == 0
    drain()
    check selected.len == 1 and selected[0].text == "alpine" and entry.text == "alpine"
    check provisional == 0
  test "existing entry and combo observers defer even when registered before attachment":
    let combo = newComboBoxText(editable = true)
    defer: combo.destroy()
    let entry = combo.entry
    var entryChanges, comboChanges, activations = 0
    entry.onChanged(proc () = inc entryChanges)
    combo.onChanged(proc () = inc comboChanges)
    entry.onActivate(proc () = inc activations)
    let completion = newEntryCompletion(["alpha", "alpine"])
    defer: completion.close()
    entry.completion = completion
    completion.inlineCompletion = true
    completion.popupCompletion = false
    entry.text = "al"
    completion.insertPrefix()
    check entryChanges == 0 and comboChanges == 0 and entry.text == "alp"
    discard n.activate(entry.raw)
    discard n.activate(entry.raw)
    check activations == 0
    drain()
    check entryChanges == 1 and comboChanges == 1 and activations == 2
    completion.inlineCompletion = false
    entry.text = "synchronous again"
    check entryChanges == 2 and comboChanges == 2
  test "readonly suspends native inline policy, password detaches and default mode stays synchronous":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    completion.inlineCompletion = true
    completion.inlineSelection = true
    entry.editable = false
    check completion.inlineCompletion and completion.inlineSelection
    check not g.toBool(n.entry_completion_get_inline_completion(completion.raw))
    check not g.toBool(n.entry_completion_get_inline_selection(completion.raw))
    expect ValueError: completion.insertPrefix()
    entry.editable = true
    check g.toBool(n.entry_completion_get_inline_completion(completion.raw))
    entry.textVisible = false
    check not completion.attached and entry.completion.closed
    expect ValueError: entry.completion = completion
    let ordinary = newEntry()
    defer: ordinary.destroy()
    var changes = 0
    ordinary.onChanged(proc () = inc changes)
    ordinary.completion = newEntryCompletion(["hello"])
    ordinary.text = "h"
    check changes == 1 # Existing popup-only contract unchanged.
  test "native default emitters survive changed callbacks that close/destroy/drop owners":
    let entry = newEntry("a")
    let completion = newEntryCompletion(["alphabet"])
    completion.inlineCompletion = true
    completion.popupCompletion = false
    entry.completion = completion
    entry.onChanged(proc () =
      completion.close()
      entry.destroy())
    completion.insertPrefix()
    check entry.text == "alphabet" and not entry.isDestroyed
    drain()
    check entry.isDestroyed and completion.closed
  test "model replacement, refilter, edits, readonly, policy and detach cancel stale inline observations":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alphabet"])
    defer: completion.close()
    completion.inlineCompletion = true
    completion.popupCompletion = false
    entry.completion = completion
    var calls = 0
    completion.onInlineChanged(proc (value: CompletionInlineState) = inc calls)
    completion.insertPrefix()
    completion.setItems(["alpha"])
    drain()
    check calls == 0
    entry.text = "a"
    completion.insertPrefix()
    entry.text = "other"
    drain()
    check calls == 0
    entry.text = "a"
    completion.insertPrefix()
    completion.refilter()
    drain()
    check calls == 0
    entry.text = "a"
    completion.insertPrefix()
    entry.editable = false
    drain()
    check calls == 0
    entry.editable = true
    entry.text = "a"
    completion.insertPrefix()
    completion.inlineCompletion = false
    drain()
    check calls == 0
    completion.inlineCompletion = true
    entry.text = "a"
    completion.insertPrefix()
    completion.detach()
    drain()
    check calls == 0
  test "disconnect cancels pending entry and inline observations; inline observer can safely throw/close":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    entry.completion = completion
    completion.inlineCompletion = true
    completion.popupCompletion = false
    var calls, freed = 0
    let changed = entry.onChanged(proc () = inc calls)
    let captured = watch(entry, addr freed)
    let inlineToken = completion.onInlineChanged(proc (value: CompletionInlineState) = inc calls)
    completion.insertPrefix()
    changed.disconnect()
    captured.disconnect()
    check freed == 1
    inlineToken.disconnect()
    drain()
    check calls == 0
    completion.onInlineChanged(proc (value: CompletionInlineState) =
      inc calls
      completion.close()
      raise newException(ValueError, "expected inline observer error"))
    entry.text = "a"
    completion.insertPrefix()
    drain()
    check calls == 1 and completion.closed
