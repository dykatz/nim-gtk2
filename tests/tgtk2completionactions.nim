# No mapped windows or desktop transfers. Native emissions exercise copied payloads.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc activate(c: EntryCompletion, index: int) =
  g.g_signal_emit_by_name(c.raw, "action-activated", g.gint(index))
type CaptureObj = object
  freed: ptr int
proc `=destroy`(value: var CaptureObj) = inc value.freed[]
type Capture = ref CaptureObj
proc watch(c: EntryCompletion, freed: ptr int): CompletionActionConnection =
  let capture = Capture(freed: freed)
  c.onActionActivated(proc (value: CompletionAction) = discard capture.freed)
type DropCaptureObj = object
  alias: ptr EntryCompletion
proc `=destroy`(value: var DropCaptureObj) = value.alias[] = default(EntryCompletion)
type DropCapture = ref DropCaptureObj
proc dropOnDisconnect(c: EntryCompletion, alias: ptr EntryCompletion) =
  let capture = DropCapture(alias: alias)
  c.onActionActivated(proc (value: CompletionAction) = discard capture.alias)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc attachWithoutAlias(entry: ui.Entry, freed: ptr int) =
  let c = newEntryCompletion(actions = ["Search λ🙂"])
  discard watch(c, freed)
  entry.completion = c
proc emitWithoutAlias(entry: ui.Entry) = activate(entry.completion, 0)
ui.init()
suite "completion action rows (unmapped)":
  test "owned literal labels, atomic validation and detached-only structural changes":
    let c = newEntryCompletion(["suggestion"], actions = ["<b>literal</b>", "λ🙂", ""])
    defer: c.close()
    var labels = c.actions
    labels[0] = "copy"
    check c.actions == @["<b>literal</b>", "λ🙂", ""]
    for bad in ["bad\0label", "\xff"]:
      expect ValueError: c.setActions([bad])
      check c.actions.len == 3
      expect ValueError: discard newEntryCompletion(actions = [bad])
    c.setActions(["duplicate", "duplicate"])
    check c.actions == @["duplicate", "duplicate"]
    c.clearActions()
    c.clearActions()
    check c.actions.len == 0
    c.setActions(["first", "last"])
    let entry = newEntry("key")
    defer: entry.destroy()
    entry.completion = c
    expect ValueError: c.setActions(["not safe while attached"])
    expect ValueError: c.clearActions()
    check c.actions == @["first", "last"]
    c.detach()
    c.setActions(["replacement"])
    entry.completion = c
    check c.actions == @["replacement"]
  test "per-emission action index/label/key copies are separate from suggestion commits":
    let entry = newEntry("λ query")
    defer: entry.destroy()
    let c = newEntryCompletion(["suggestion"], actions = ["Search", "Create λ🙂"])
    defer: c.close()
    entry.completion = c
    var values: seq[CompletionAction]
    expect ValueError: discard c.onActionActivated(nil)
    var suggestions = 0
    c.onSelected(proc (value: CompletionSelection) = inc suggestions)
    let token = c.onActionActivated(proc (value: CompletionAction) = values.add(value))
    activate(c, -1)
    activate(c, high(int32))
    activate(c, 1)
    activate(c, 0)
    check values.len == 0 and entry.text == "λ query"
    var late = 0
    c.onActionActivated(proc (value: CompletionAction) = inc late)
    drain()
    check values.len == 2 and suggestions == 0 and late == 0
    check values[0].index == 1 and values[0].text == "Create λ🙂" and values[0].key == "λ query"
    check values[1].index == 0 and entry.text == "λ query"
    activate(c, 0)
    token.disconnect()
    drain()
    check not token.connected and values.len == 2 and late == 1
  test "edits/refilter/model/predicate/readonly/detach cancel queued activations":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"], actions = ["Action"])
    defer: c.close()
    entry.completion = c
    var calls = 0
    c.onActionActivated(proc (value: CompletionAction) = inc calls)
    activate(c, 0)
    entry.text = "b"
    drain()
    check calls == 0
    activate(c, 0)
    c.refilter()
    drain()
    check calls == 0
    activate(c, 0)
    c.popupCompletion = false
    drain()
    check calls == 0
    c.popupCompletion = true
    activate(c, 0)
    c.minimumKeyLength = 2
    drain()
    check calls == 0
    activate(c, 0)
    c.setItems(["beta"])
    drain()
    check calls == 0
    activate(c, 0)
    c.setMatch(proc (input: CompletionMatchInput): bool = true)
    drain()
    check calls == 0
    activate(c, 0)
    entry.editable = false
    drain()
    activate(c, 0)
    drain()
    check calls == 0
    entry.editable = true
    activate(c, 0)
    c.detach()
    drain()
    check calls == 0 and c.actions == @["Action"]
    c.setActions(["New"])
    entry.completion = c
    c.onActionActivated(proc (value: CompletionAction) = inc calls)
    activate(c, 0)
    entry.textVisible = false
    drain()
    check calls == 0 and not c.attached
  test "reentrant first listener edits cancel other listeners and subsequent emissions":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(actions = ["Act"])
    defer: c.close()
    entry.completion = c
    var first, second = 0
    c.onActionActivated(proc (value: CompletionAction) =
      inc first
      entry.text = "changed")
    c.onActionActivated(proc (value: CompletionAction) = inc second)
    activate(c, 0)
    activate(c, 0)
    drain()
    check first == 1 and second == 0
  test "exceptions are contained and self-disconnection/close is safe":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(actions = ["Act"])
    defer: c.close()
    entry.completion = c
    c.onActionActivated(proc (value: CompletionAction) =
      raise newException(ValueError, "expected completion action observer error"))
    var calls = 0
    var token: CompletionActionConnection
    token = c.onActionActivated(proc (value: CompletionAction) =
      inc calls
      token.disconnect()
      c.close()
      entry.destroy())
    activate(c, 0)
    activate(c, 0)
    drain()
    check calls == 1 and c.closed and entry.isDestroyed and not token.connected
  test "native owner and cancellation release callback captures promptly":
    let entry = newEntry("a")
    var freed = 0
    attachWithoutAlias(entry, addr freed)
    emitWithoutAlias(entry)
    check freed == 0
    entry.destroy()
    check freed == 1
    drain()
    let c = newEntryCompletion(actions = ["Act"])
    let token = watch(c, addr freed)
    token.disconnect()
    check freed == 2
    discard watch(c, addr freed)
    c.close()
    check freed == 3
  test "detaching survives capture cleanup dropping the final public completion alias":
    let entry = newEntry("a")
    defer: entry.destroy()
    var c = newEntryCompletion(actions = ["Act"])
    var finalized = 0
    g.weak_ref(cast[g.PGObject](c.raw), gone, addr finalized)
    entry.completion = c
    dropOnDisconnect(c, addr c)
    activate(c, 0)
    c.detach()
    check c.isDestroyed and finalized == 1
    drain()
  test "action configuration and disconnection are forbidden inside pure matching":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"], actions = ["Act"])
    defer: c.close()
    entry.completion = c
    let token = c.onActionActivated(proc (value: CompletionAction) = discard)
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: discard c.actions
      except ValueError: inc denied
      try: c.setActions(["bad"])
      except ValueError: inc denied
      try: token.disconnect()
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 3 and denied mod 3 == 0 and token.connected
