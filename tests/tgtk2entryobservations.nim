# No realized widgets, selection requests, ownership changes or desktop input.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc unrealized(entry: ui.Entry) = doAssert not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
type CaptureObj = object
  freed: ptr int
proc `=destroy`(value: var CaptureObj) = inc value.freed[]
type Capture = ref CaptureObj
proc tracked(entry: ui.Entry, freed: ptr int, initial = false): EntrySelectionConnection =
  let capture = Capture(freed: freed)
  entry.onSelectionChanged((proc (value: EntrySelection) = discard capture.freed), initial = initial)
type DropCaptureObj = object
  alias: ptr ui.Entry
proc `=destroy`(value: var DropCaptureObj) = value.alias[] = default(ui.Entry)
type DropCapture = ref DropCaptureObj
proc dropping(entry: ui.Entry, alias: ptr ui.Entry): EntrySelectionConnection =
  let capture = DropCapture(alias: alias)
  entry.onSelectionChanged(proc (value: EntrySelection) = discard capture.alias)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc withoutOwnerAlias(freed, finalized: ptr int): EntrySelectionConnection =
  let entry = newEntry("λ🙂abc")
  g.weak_ref(cast[g.PGObject](entry.raw), gone, finalized)
  result = tracked(entry, freed, initial = true)
proc parentOnly(host: Window, seen: ptr int): tuple[p: n.PEntry, connection: EntrySelectionConnection] =
  let entry = newEntry("λ🙂abc")
  host.add(entry)
  result.p = entry.raw
  result.connection = entry.onSelectionChanged(proc (value: EntrySelection) = inc seen[])
ui.init()
suite "Entry selection observations (unrealized)":
  test "paired notifications coalesce, direction is copied, no synchronous delivery":
    let entry = newEntry("Aλ🙂e\u0301Z")
    defer: entry.destroy()
    unrealized(entry)
    var values: seq[EntrySelection]
    let token = entry.onSelectionChanged(proc (value: EntrySelection) = values.add(value))
    check token.connected
    drain()
    check values.len == 0 # No initial event by default.
    entry.selectRange(0, 2)
    entry.selectRange(1, 5)
    entry.selectRange(5, 1)
    check values.len == 0
    drain()
    check values.len == 1 and values[0] == entry.selectionBounds
    check values[0].anchor == 5 and values[0].cursor == 1 and values[0].last == 5
    let copied = values[0]
    entry.selectRange(5, 1)
    drain()
    check values.len == 1
    unrealized(entry)
    entry.destroy()
    check not token.connected and copied.anchor == 5
  test "optional initial is deferred/final-state; returning to last coordinates is deduplicated":
    let entry = newEntry("λ🙂abc")
    defer: entry.destroy()
    unrealized(entry)
    entry.cursorOffset = 1
    var values: seq[EntrySelection]
    let token = entry.onSelectionChanged((proc (value: EntrySelection) = values.add(value)), initial = true)
    check values.len == 0
    entry.selectRange(4, 2)
    drain()
    check values.len == 1 and values[0].anchor == 4 and values[0].cursor == 2
    entry.cursorOffset = 0
    entry.selectRange(4, 2)
    drain()
    check values.len == 1
    token.disconnect()
    expect ValueError: discard entry.onSelectionChanged(nil)
    unrealized(entry)
  test "text edits use final coordinates, not text or changed notifications":
    let entry = newEntry("abc")
    defer: entry.destroy()
    unrealized(entry)
    entry.cursorOffset = 3
    var values: seq[EntrySelection]
    entry.onSelectionChanged(proc (value: EntrySelection) = values.add(value))
    entry.text = "XYZ"
    entry.cursorOffset = 3 # Same final coordinates after GTK's set_text movement.
    drain()
    check values.len == 0
    entry.text = "λ"
    drain()
    check values.len == 1 and values[0].cursor == entry.cursorOffset
    entry.textVisible = false
    entry.editable = false
    entry.selectRange(0, 1)
    drain()
    check values[^1].hasSelection and values[^1].anchor == 0 and values[^1].cursor == 1
    expect ValueError: discard entry.selectedText
    unrealized(entry)
  test "callback edits schedule a later non-nested final-state delivery":
    let entry = newEntry("λ🙂abc")
    defer: entry.destroy()
    var values: seq[EntrySelection]
    var depth, maximum = 0
    entry.onSelectionChanged(proc (value: EntrySelection) =
      inc depth
      maximum = max(maximum, depth)
      values.add(value)
      if values.len == 1: entry.selectRange(4, 1)
      dec depth)
    entry.cursorOffset = 2
    check values.len == 0
    drain()
    check values.len == 2 and maximum == 1
    check values[0].cursor == 2 and values[1].anchor == 4 and values[1].cursor == 1
    unrealized(entry)
  test "disconnect cancels queued initial/normal work and releases captures immediately":
    let entry = newEntry("abc")
    defer: entry.destroy()
    var freed = 0
    let first = tracked(entry, addr freed, initial = true)
    first.disconnect()
    first.disconnect()
    check not first.connected and freed == 1
    let second = tracked(entry, addr freed)
    entry.selectAll()
    second.disconnect()
    check not second.connected and freed == 2
    drain()
    unrealized(entry)
    var empty: EntrySelectionConnection
    empty.disconnect()
    check not empty.connected
  test "token and source do not retain the native entry; native destruction drops captures":
    var freed, finalized = 0
    let token = withoutOwnerAlias(addr freed, addr finalized)
    check finalized == 1 and freed == 1 and not token.connected
    drain()
    check finalized == 1
  test "disconnect is pinned against capture teardown dropping the final public alias":
    var entry = newEntry("abc")
    var finalized = 0
    g.weak_ref(cast[g.PGObject](entry.raw), gone, addr finalized)
    let token = dropping(entry, addr entry)
    entry.selectAll()
    token.disconnect()
    check not token.connected and entry.isDestroyed and finalized == 1
    drain()
  test "an earlier listener destroying the owner cancels later queued listeners":
    let entry = newEntry("abc")
    var first, second = 0
    entry.onSelectionChanged(proc (value: EntrySelection) =
      inc first
      entry.destroy())
    let other = entry.onSelectionChanged(proc (value: EntrySelection) = inc second)
    entry.selectAll()
    drain()
    check first == 1 and second == 0 and not other.connected
  test "native parent retains listener after public entry aliases disappear":
    let host = newWindow("No realization")
    defer: host.destroy()
    var seen = 0
    let retained = parentOnly(host, addr seen)
    n.select_region(cast[n.PEditable](retained.p), 4, 1)
    drain()
    check seen == 1 and retained.connection.connected
    check not g.toBool(n.get_realized(cast[n.PWidget](retained.p)))
    host.destroy()
    check not retained.connection.connected
    drain()
  test "exceptions, self-disconnection and destroy from idle are contained":
    let entry = newEntry("abc")
    var calls = 0
    var token: EntrySelectionConnection
    token = entry.onSelectionChanged(proc (value: EntrySelection) =
      inc calls
      token.disconnect()
      entry.destroy()
      raise newException(ValueError, "expected entry selection observer error"))
    entry.selectAll()
    drain()
    check calls == 1 and not token.connected and entry.isDestroyed
    token.disconnect()
  test "owner destruction cancels a queued snapshot and protected combo aliases":
    let combo = newComboBoxText(["λ🙂abc"], editable = true)
    combo.activeIndex = 0
    let child = combo.entry
    var freed = 0
    let token = tracked(child, addr freed, initial = true)
    child.selectRange(4, 1)
    combo.destroy()
    check not token.connected and freed == 1 and child.isDestroyed
    drain()
  test "SpinButton inherits coordinate notifications without exposing formatted text":
    let spin = newSpinButton(newAdjustment(12.5, 0, 100, 0.1), digits = 1)
    defer: spin.destroy()
    var values: seq[EntrySelection]
    spin.onSelectionChanged(proc (value: EntrySelection) = values.add(value))
    spin.selectAll()
    drain()
    check values.len == 1 and values[0] == spin.selectionBounds
    unrealized(spin)
  test "completion attachment changes do not end the entry-owned observation":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha", "alpine"])
    defer: c.close()
    c.popupCompletion = false
    c.inlineCompletion = true
    entry.completion = c
    var values: seq[EntrySelection]
    let token = entry.onSelectionChanged(proc (value: EntrySelection) = values.add(value))
    c.insertPrefix()
    drain()
    check values.len == 1 and values[0].hasSelection and values[0].first == 1 and values[0].last == 3
    c.detach()
    check token.connected
    entry.cursorOffset = 1
    drain()
    check values[^1].cursor == 1 and not values[^1].hasSelection
    unrealized(entry)
  test "registration and disconnection are rejected inside synchronous matching":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    let token = entry.onSelectionChanged(proc (value: EntrySelection) = discard)
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: token.disconnect()
      except ValueError: inc denied
      try: discard entry.onSelectionChanged(proc (value: EntrySelection) = discard)
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 2 and denied mod 2 == 0 and token.connected
    unrealized(entry)
