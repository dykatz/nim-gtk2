# Fixed-string custom completion matching. No mapped windows or clipboard state.
import std/[strutils, unittest]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
type CaptureObj = object
  freed, calls: ptr int
proc `=destroy`(value: var CaptureObj) = inc value.freed[]
type Capture = ref CaptureObj
proc tracked(c: EntryCompletion, freed, calls: ptr int): CompletionMatchConnection =
  let capture = Capture(freed: freed, calls: calls)
  c.setMatch(proc (input: CompletionMatchInput): bool =
    inc capture.calls[]
    true)
type CloseCaptureObj = object
  completion: EntryCompletion
  denied: ptr int
proc `=destroy`(value: var CloseCaptureObj) =
  try: value.completion.close()
  except ValueError: inc value.denied[]
  except Exception: value.denied[] = -100 # Fail the outer assertion without throwing from a destructor.
  value.completion = default(EntryCompletion)
type CloseCapture = ref CloseCaptureObj
proc teardownMatcher(c: EntryCompletion, denied: ptr int) =
  let capture = CloseCapture(completion: c, denied: denied)
  c.setMatch(proc (input: CompletionMatchInput): bool =
    discard capture.denied
    true)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc installVictim(c: EntryCompletion, freed: ptr int) =
  var victim = newTextBuffer("victim")
  g.weak_ref(cast[g.PGObject](victim.raw), gone, freed)
  c.setMatch(proc (input: CompletionMatchInput): bool =
    victim = default(TextBuffer)
    doAssert freed[] == 0 # Native final release cannot interrupt filter traversal.
    true)
proc refresh(entry: ui.Entry) =
  let c = entry.completion
  c.refilter()
proc attachedWithoutAlias(entry: ui.Entry, freed, calls: ptr int) =
  let c = newEntryCompletion(["one", "two"])
  discard tracked(c, freed, calls)
  entry.completion = c
ui.init()
suite "custom entry completion matching (unmapped)":
  test "copied normalized key/literal suggestion/source index and explicit lifecycle":
    let entry = newEntry("CAFÉ")
    defer: entry.destroy()
    let c = newEntryCompletion(["Café noir", "Other λ🙂"])
    defer: c.close()
    entry.completion = c
    check not c.customMatching and not c.matchConnection.connected
    var seen: seq[CompletionMatchInput]
    let token = c.setMatch(proc (input: CompletionMatchInput): bool =
      seen.add(input)
      input.index == 1)
    check token.connected and c.customMatching and seen.len == 0
    c.refilter()
    check seen.len >= 2
    check seen[0].key == "cafe\u0301" and seen[0].text == "Café noir" and seen[0].index == 0
    check seen[1].text == "Other λ🙂" and seen[1].index == 1
    c.detach()
    check token.connected and c.customMatching # Matcher belongs to controller, not attachment.
    entry.completion = c
    c.setItems(["Replacement 🙂"])
    seen.setLen(0)
    c.refilter()
    check seen.len >= 1 and seen[^1].text == "Replacement 🙂" and seen[^1].index == 0
    c.clearMatch()
    check not token.connected and not c.customMatching
    check seen[0].key == "cafe\u0301" # Independent copies survive teardown/model replacement.
    expect ValueError: discard c.setMatch(nil)
  test "replace/disconnect/default reset release captures without owning controller":
    let entry = newEntry("x")
    defer: entry.destroy()
    let c = newEntryCompletion(["one", "two"])
    defer: c.close()
    entry.completion = c
    var freed, calls = 0
    let first = tracked(c, addr freed, addr calls)
    let second = tracked(c, addr freed, addr calls)
    check freed == 1 and not first.connected and second.connected
    second.disconnect()
    second.disconnect()
    check freed == 2 and not second.connected and c.customMatching
    c.refilter()
    check calls == 0 # An inactive native bridge rejects rows until default reset.
    c.clearMatch()
    check not c.customMatching
    let third = tracked(c, addr freed, addr calls)
    c.refilter()
    check calls > 0
    c.close()
    check freed == 3 and not third.connected
  test "native entry owns matcher after public aliases/tokens drop; finalization releases captures":
    let entry = newEntry("x")
    var freed, calls = 0
    attachedWithoutAlias(entry, addr freed, addr calls)
    refresh(entry)
    check calls > 0 and freed == 0
    entry.destroy()
    check freed == 1
  test "predicate exceptions and checked GUI/replacement/teardown access are contained":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["one"])
    defer: c.close()
    entry.completion = c
    var denied = 0
    var token: CompletionMatchConnection
    token = c.setMatch(proc (input: CompletionMatchInput): bool =
      try: discard entry.text
      except ValueError: inc denied
      try: c.close()
      except ValueError: inc denied
      try: discard c.closed
      except ValueError: inc denied
      try: token.disconnect()
      except ValueError: inc denied
      try: c.setItems(["illegal"])
      except ValueError: inc denied
      try: c.clearMatch()
      except ValueError: inc denied
      try: discard newEntryCompletion()
      except ValueError: inc denied
      raise newException(ValueError, "expected pure completion predicate error"))
    c.refilter()
    check denied == 7 and token.connected and not c.closed and c.items == @["one"]
    c.clearMatch()
    c.refilter() # Exact native default restored without reimplementing Unicode matching.
  test "ordinary last native releases inside predicate wait for UI idle":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["one"])
    defer: c.close()
    entry.completion = c
    var freed = 0
    installVictim(c, addr freed)
    c.refilter()
    check freed == 0
    drain()
    check freed == 1
    c.clearMatch()
  test "custom visibility does not invent a different inline prefix algorithm":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["beta a", "alpha", "alpine"])
    defer: c.close()
    c.popupCompletion = false
    c.inlineCompletion = true
    entry.completion = c
    c.setMatch(proc (input: CompletionMatchInput): bool = input.text == "beta a")
    c.insertPrefix()
    check entry.text == "a" # Native prefix computation ignores non-prefix matches.
    c.setMatch(proc (input: CompletionMatchInput): bool = input.text.startsWith(input.key))
    c.insertPrefix()
    check entry.text == "alp"
    c.clearMatch()
    drain()
  test "capture teardown cannot recursively close a completion mid native replacement":
    let c = newEntryCompletion(["one"])
    defer: c.close()
    var denied = 0
    teardownMatcher(c, addr denied)
    let token = c.setMatch(proc (input: CompletionMatchInput): bool = true)
    check denied == 1 and token.connected and not c.closed
    c.clearMatch()
    check not token.connected
  test "raw matcher replacement is detected, while close remains safe":
    let c = newEntryCompletion(["one"])
    let token = c.setMatch(proc (input: CompletionMatchInput): bool = true)
    n.entry_completion_set_match_func(c.raw, nil, nil, nil)
    check not token.connected
    expect ValueError: discard c.customMatching
    c.close()
    check c.closed
