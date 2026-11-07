# Public mark lifetime tests, no realized widgets or selection wire operations.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
static:
  doAssert not declared(n.TTextMarkBody)
  doAssert not declared(n.PTextMarkBody)
  doAssert not declared(n.bm_TGtkTextMarkBody_visible)
  doAssert not declared(n.bp_TGtkTextMarkBody_visible)
  doAssert not declared(n.bm_TGtkTextMarkBody_not_deleteable)
  doAssert not declared(n.bp_TGtkTextMarkBody_not_deleteable)
  doAssert not compiles(n.visible(n.PTextMark(nil)))
  doAssert not compiles(n.not_deleteable(n.PTextMark(nil)))
  doAssert not compiles(n.set_not_deleteable(n.PTextMark(nil), g.guint(0)))
  doAssert not compiles(n.set_visible(n.PTextMark(nil), g.guint(0)))
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc deleteAtBirth(buffer: n.PTextBuffer, where: n.PTextIter, mark: n.PTextMark, data: pointer) {.cdecl.} =
  if n.get_name(mark) != nil and $n.get_name(mark) == "delete-at-birth": n.delete_mark(buffer, mark)
proc dropBufferOnSet(buffer: n.PTextBuffer, where: n.PTextIter, mark: n.PTextMark, data: pointer) {.cdecl.} =
  cast[ptr ui.TextBuffer](data)[] = default(ui.TextBuffer)
proc dropBufferOnDelete(buffer: n.PTextBuffer, mark: n.PTextMark, data: pointer) {.cdecl.} =
  cast[ptr ui.TextBuffer](data)[] = default(ui.TextBuffer)
proc dropOnDeleted(buffer: n.PTextBuffer, mark: n.PTextMark, data: pointer) {.cdecl.} =
  cast[ptr ui.TextMark](data)[] = default(ui.TextMark)
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
ui.init()
suite "raw TextMark public API and ownership":
  test "name, visibility clearing, immutable gravity and codepoint movement":
    let b = newTextBuffer("λ🙂abc")
    let left = b.createMark(1, "left λ", leftGravity = true)
    let right = b.createMark(1, leftGravity = false)
    check left.name == "left λ" and right.name == ""
    check left.leftGravity and not right.leftGravity and not left.deleted
    check left.buffer.raw == b.raw
    for flag in [true, false, true, false]:
      left.visible = flag
      check left.visible == flag and g.toBool(n.get_visible(left.raw)) == flag
    b.insertText(1, "界🙂")
    check left.offset == 1 and right.offset == 3
    b.moveMark(left, 5)
    check left.offset == 5 and left.leftGravity
    expect ValueError: discard b.createMark(0, "left λ")
    expect ValueError: discard b.createMark(0, "bad\0name")
    expect ValueError: discard b.createMark(100)
    let other = newTextBuffer("other")
    expect ValueError: other.moveMark(left, 0)
    expect ValueError: other.deleteMark(left)
    let cursor = b.mark("insert")
    expect ValueError: b.deleteMark(cursor)
    expect ValueError: b.deleteMark(b.mark("selection_bound"))
    check not cursor.leftGravity and not cursor.deleted
    b.deleteMark(left)
    check left.deleted and left.name == "left λ" and left.leftGravity
    check n.get_buffer(left.raw) == nil
    left.visible = true # Native detached visibility remains a policy, not reinsertion.
    check left.visible
    expect ValueError: discard left.buffer
    expect ValueError: discard left.offset
    expect ValueError: b.moveMark(left, 0)
    expect ValueError: b.deleteMark(left)
  test "owned mark survives deletion in native mark-set during creation":
    let b = newTextBuffer("abc")
    discard g.g_signal_connect_data(b.raw, "mark-set", cast[g.TGCallback](deleteAtBirth), nil, nil, g.TGConnectFlags(0))
    let mark = b.createMark(1, "delete-at-birth")
    check mark.deleted and mark.name == "delete-at-birth" and mark.leftGravity
    check n.get_mark(b.raw, "delete-at-birth") == nil
    expect ValueError: discard mark.offset
  test "create/move native notifications may drop the last public buffer alias":
    for moving in [false, true]:
      var b = newTextBuffer("abc")
      var finalized = 0
      g.weak_ref(cast[g.PGObject](b.raw), gone, addr finalized)
      var mark: ui.TextMark
      if moving: mark = b.createMark(0, "move")
      discard g.g_signal_connect_data(b.raw, "mark-set", cast[g.TGCallback](dropBufferOnSet), addr b, nil, g.TGConnectFlags(0))
      if moving: b.moveMark(mark, 1)
      else: mark = b.createMark(1, "birth")
      check finalized == 1 and mark.deleted
      check mark.name == (if moving: "move" else: "birth")
  test "delete pins the buffer while native mark-deleted drops its last public alias":
    var b = newTextBuffer("abc")
    let mark = b.createMark(1)
    var finalized = 0
    g.weak_ref(cast[g.PGObject](b.raw), gone, addr finalized)
    discard g.g_signal_connect_data(b.raw, "mark-deleted", cast[g.TGCallback](dropBufferOnDelete), addr b, nil, g.TGConnectFlags(0))
    b.deleteMark(mark)
    check finalized == 1 and mark.deleted
  test "delete pins a mark while a native observer drops its last public alias":
    let b = newTextBuffer("abc")
    var mark = b.createMark(1)
    var finalized = 0
    g.weak_ref(cast[g.PGObject](mark.raw), gone, addr finalized)
    discard g.g_signal_connect_data(b.raw, "mark-deleted", cast[g.TGCallback](dropOnDeleted), addr mark, nil, g.TGConnectFlags(0))
    b.deleteMark(mark)
    check mark.isDestroyed and finalized == 1
  test "marks do not retain buffers, but the explicit buffer getter owns its result":
    var mark: ui.TextMark
    var finalized = 0
    block:
      let b = newTextBuffer("abc")
      g.weak_ref(cast[g.PGObject](b.raw), gone, addr finalized)
      mark = b.createMark(0, "survivor")
    check finalized == 1 and mark.deleted and mark.name == "survivor"
    block:
      var b = newTextBuffer("abc")
      let attached = b.createMark(0)
      let owner = attached.buffer
      b = default(ui.TextBuffer)
      check not attached.deleted and owner.characterCount == 3
      owner.deleteMark(attached)
      check attached.deleted
  test "unrealized views/mark visibility do not change document or selection":
    let b = newTextBuffer("λ🙂abc")
    let view = newTextView(b)
    defer: view.destroy()
    let mark = b.createMark(2)
    b.selectRange(4, 1)
    let before = b.selectionBounds
    let cursor = b.cursorOffset
    mark.visible = true
    mark.visible = false
    drain()
    check b.text == "λ🙂abc" and not b.modified and b.selectionBounds == before and b.cursorOffset == cursor
    check not g.toBool(n.get_realized(cast[n.PWidget](view.raw)))
  test "synchronous matcher rejects checked mark access and mutation":
    let b = newTextBuffer("abc")
    let mark = b.createMark(1)
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: mark.visible = true
      except ValueError: inc denied
      try: discard mark.buffer
      except ValueError: inc denied
      try: discard b.createMark(0)
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 3 and denied mod 3 == 0
