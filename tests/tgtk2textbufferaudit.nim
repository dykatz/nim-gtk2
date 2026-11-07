# Public buffer state only: no views, PRIMARY, selection requests or fake input.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
static:
  doAssert not declared(n.bm_TGtkTextBuffer_modified)
  doAssert not declared(n.bp_TGtkTextBuffer_modified)
  doAssert not compiles(n.modified(n.PTextBuffer(nil)))
  doAssert not compiles(n.set_modified(n.PTextBuffer(nil), g.guint(0)))
  doAssert compiles(n.set_modified(n.PTextBuffer(nil), g.gbool(false)))
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type Drop = object
  buffer: ptr ui.TextBuffer
  calls: int
proc dropChanged(buffer: n.PTextBuffer, data: pointer) {.cdecl.} =
  let d = cast[ptr Drop](data)
  inc d.calls
  d.buffer[] = default(ui.TextBuffer)
proc dropMark(buffer: n.PTextBuffer, it: n.PTextIter, mark: n.PTextMark, data: pointer) {.cdecl.} = dropChanged(buffer, data)
proc dropTag(buffer: n.PTextBuffer, tag: n.PTextTag, first, last: n.PTextIter, data: pointer) {.cdecl.} = dropChanged(buffer, data)
type Actions = object
  begins, ends: int
  drop: ptr ui.TextBuffer
proc began(buffer: n.PTextBuffer, data: pointer) {.cdecl.} =
  let a = cast[ptr Actions](data)
  inc a.begins
  if a.drop != nil: a.drop[] = default(ui.TextBuffer)
proc ended(buffer: n.PTextBuffer, data: pointer) {.cdecl.} = inc cast[ptr Actions](data).ends
proc observeActions(b: ui.TextBuffer, a: ptr Actions) =
  discard g.g_signal_connect_data(b.raw, "begin-user-action", cast[g.TGCallback](began), a, nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(b.raw, "end-user-action", cast[g.TGCallback](ended), a, nil, g.TGConnectFlags(0))
ui.init()
suite "TextBuffer public state, ABI migration and pins":
  test "native dirty transitions are synchronous, normalized, and not a property":
    let b = newTextBuffer("Aλ🙂界Z")
    var events: seq[string]
    b.onChanged(proc () = events.add("changed:" & $b.modified))
    b.onModifiedChanged(proc () = events.add("modified:" & $b.modified))
    defer: b.disconnectSignals()
    check not b.modified
    check g.class_find_property(g.G_OBJECT_GET_CLASS(b.raw), "modified") == nil
    b.modified = false
    check events.len == 0
    b.modified = true
    b.modified = true
    n.set_modified(b.raw, g.gboolean(-37)) # C gboolean is normalized, not guint flag access.
    check events == @["modified:true"]
    b.modified = false
    check events == @["modified:true", "modified:false"]
    events.setLen(0)
    b.insertText(1, "x")
    check events == @["modified:true", "changed:true"]
    b.insertAtCursor("y")
    check events == @["modified:true", "changed:true", "changed:true"]
    events.setLen(0)
    b.modified = false
    let savedText = b.text
    let tag = b.createTag()
    tag.bold = true
    b.applyTag(tag, 0, 1)
    b.removeTag(tag, 0, 1)
    let mark = b.createMark(1)
    b.moveMark(mark, 2)
    b.selectRange(1, 3)
    b.cursorOffset = 2
    check b.text == savedText and not b.modified
    check events == @["modified:false"]
  test "Unicode coordinates/direction, readonly native metadata and invalid atomicity":
    let b = newTextBuffer("Aλ🙂界Z")
    var moves = 0
    b.onCursorMoved(proc () = inc moves)
    defer: b.disconnectSignals()
    for name in ["cursor-position", "has-selection"]:
      let spec = g.class_find_property(g.G_OBJECT_GET_CLASS(b.raw), name.cstring)
      require spec != nil
      check (spec.flags and g.G_PARAM_WRITABLE) == 0
      check spec.value_type == (if name == "has-selection": g.G_TYPE_BOOLEAN else: g.G_TYPE_INT)
    b.selectRange(4, 1)
    check b.cursorOffset == 1 and b.selectionBounds == (true, 1, 4)
    var bound: n.TTextIter
    n.get_iter_at_mark(b.raw, addr bound, n.get_selection_bound(b.raw))
    check n.get_offset(addr bound) == 4
    b.selectRange(1, 4)
    check b.cursorOffset == 4 and b.selectionBounds == (true, 1, 4)
    b.cursorOffset = 2
    check not b.hasSelection and b.selectionBounds == (false, 2, 2)
    check moves > 0 and not b.modified
    let before = moves
    for bad in [-1, 6, int.high]:
      expect ValueError: b.cursorOffset = bad
      expect ValueError: b.selectRange(0, bad)
      expect ValueError: b.insertText(bad, "x")
    expect ValueError: b.deleteRange(3, 1)
    expect ValueError: b.text = "bad\0text"
    check moves == before and b.cursorOffset == 2 and b.text == "Aλ🙂界Z" and not b.modified
    check not b.deleteSelection()
  test "native interactive permissions differ from explicit programmatic deletion":
    let b = newTextBuffer("abc")
    let tag = b.createTag()
    tag.editable = false
    b.applyTag(tag, 0, 3)
    b.selectRange(0, 3)
    check b.deleteSelection(interactive = true) # Reports selection presence, not edit success.
    check b.text == "abc" and not b.modified
    check b.deleteSelection() # Native non-interactive operation ignores editability.
    check b.text == "" and b.modified
  test "every basic mutation pins native buffer through callbacks dropping final aliases":
    for kind in ["modified", "text", "insert", "append", "atCursor", "delete", "deleteSelection", "cursor", "selection", "removeAllTags"]:
      var b = newTextBuffer("abc")
      let tag = b.createTag()
      if kind == "removeAllTags": b.applyTag(tag, 0, 3)
      if kind == "deleteSelection": b.selectRange(0, 2)
      var final = 0
      g.weak_ref(cast[g.PGObject](b.raw), gone, addr final)
      var d = Drop(buffer: addr b)
      case kind
      of "modified":
        discard g.g_signal_connect_data(b.raw, "modified-changed", cast[g.TGCallback](dropChanged), addr d, nil, g.TGConnectFlags(0))
        b.modified = true
      of "cursor", "selection":
        discard g.g_signal_connect_data(b.raw, "mark-set", cast[g.TGCallback](dropMark), addr d, nil, g.TGConnectFlags(0))
        if kind == "cursor": b.cursorOffset = 1
        else: b.selectRange(0, 2)
      of "removeAllTags":
        discard g.g_signal_connect_data(b.raw, "remove-tag", cast[g.TGCallback](dropTag), addr d, nil, g.TGConnectFlags(0))
        b.removeAllTags(0, 3)
      else:
        discard g.g_signal_connect_data(b.raw, "changed", cast[g.TGCallback](dropChanged), addr d, nil, g.TGConnectFlags(0))
        case kind
        of "text": b.text = "λ🙂"
        of "insert": b.insertText(1, "λ")
        of "append": b.appendText("λ")
        of "atCursor": b.insertAtCursor("λ")
        of "delete": b.deleteRange(0, 1)
        else: discard b.deleteSelection()
      check d.calls > 0 and final == 1 and b.isDestroyed
  test "SDK synchronous observers may drop their last public buffer alias":
    for signal in ["changed", "modified-changed", "cursor"]:
      var b = newTextBuffer("abc")
      var final, calls = 0
      g.weak_ref(cast[g.PGObject](b.raw), gone, addr final)
      let drop = proc () =
        inc calls
        b = default(ui.TextBuffer)
      case signal
      of "changed":
        b.onChanged(drop)
        b.text = "replacement"
      of "modified-changed":
        b.onModifiedChanged(drop)
        b.modified = true
      else:
        b.onCursorMoved(drop)
        b.cursorOffset = 1
      check final == 1 and calls > 0 and b.isDestroyed
  test "nested/exceptional user actions balance on original target without undo or rollback":
    var b = newTextBuffer("abc")
    var actions: Actions
    observeActions(b, addr actions)
    expect ValueError:
      b.withUserAction:
        b.appendText("λ")
        b.withUserAction: b.appendText("🙂")
        raise newException(ValueError, "application failure")
    check actions.begins == 1 and actions.ends == 1 and b.text == "abcλ🙂" and b.modified
    var final = 0
    g.weak_ref(cast[g.PGObject](b.raw), gone, addr final)
    b.withUserAction: b = newTextBuffer("replacement")
    check final == 1 and actions.begins == 2 and actions.ends == 2 and b.text == "replacement"
  test "begin handler can drop public alias; finally still ends even on exception":
    var b = newTextBuffer("abc")
    var final = 0
    g.weak_ref(cast[g.PGObject](b.raw), gone, addr final)
    var a = Actions(drop: addr b)
    observeActions(b, addr a)
    expect ValueError:
      b.withUserAction:
        check b.isDestroyed and final == 0
        raise newException(ValueError, "application failure")
    check a.begins == 1 and a.ends == 1 and final == 1
  test "pure completion rejects mutations and user actions before native side effects":
    let b = newTextBuffer("abc")
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: b.modified = true
      except ValueError: inc denied
      try: b.cursorOffset = 1
      except ValueError: inc denied
      try:
        b.withUserAction: discard
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 3 and denied mod 3 == 0 and not b.modified and b.text == "abc"
