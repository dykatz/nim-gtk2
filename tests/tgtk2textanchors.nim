# Native buffer/anchor/widget lifetime tests. Never maps a window.
import std/unittest
import gtk2 as ui
import headers/glib2 as g
import headers/gtk2 as n
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc orphan(done: ptr int, notices: ptr int): TextChildAnchor =
  let buffer = newTextBuffer("text")
  g.weak_ref(cast[g.PGObject](buffer.raw), gone, done)
  result = buffer.createChildAnchor(2)
  result.onDeleted(proc () = inc notices[])
proc selfObserved(buffer: TextBuffer, calls, finalized: ptr int): TextChildAnchor =
  let anchor = buffer.createChildAnchor(0)
  g.weak_ref(cast[g.PGObject](anchor.raw), gone, finalized)
  anchor.onDeleted(proc () =
    doAssert anchor.deleted
    inc calls[])
  anchor
ui.init()
suite "TextView child anchors (unmapped)":
  test "Unicode offsets, identity, copied owning lookup, slices and search":
    let buffer = newTextBuffer("Aλ🙂B")
    expect ValueError: discard buffer.createChildAnchor(-1)
    expect ValueError: discard buffer.createChildAnchor(5)
    let anchor = buffer.createChildAnchor(2)
    check not anchor.deleted and anchor.offset == 2
    check anchor.buffer.raw == buffer.raw
    check buffer.characterCount == 5 and buffer.text == "Aλ🙂B"
    check buffer.slice(0, 5) == "Aλ\uFFFC🙂B"
    check buffer.childAnchorAt(2).raw == anchor.raw
    check buffer.childAnchorAt(0).deleted and buffer.childAnchorAt(5).deleted
    check buffer.findText("λ🙂").found
    check buffer.findText("λ🙂").first == 1 and buffer.findText("λ🙂").last == 4
    check not buffer.findText("λ🙂", textOnly = false).found
    check buffer.findText("\uFFFC", textOnly = false).first == 2
    buffer.insertText(0, "x")
    check anchor.offset == 3
    let other = newTextBuffer("other")
    expect ValueError: other.deleteAnchor(anchor)
    buffer.deleteAnchor(anchor)
    check anchor.deleted and anchor.widgets.len == 0
    expect ValueError: discard anchor.offset
    expect ValueError: discard anchor.buffer
    expect ValueError: buffer.deleteAnchor(anchor)
    check buffer.text == "xAλ🙂B" and buffer.characterCount == 5
  test "one widget per view, shared buffer views, normal remove/reparent and deletion":
    let buffer = newTextBuffer("AB")
    let anchor = buffer.createChildAnchor(1)
    let first = newTextView(buffer)
    let second = newTextView(buffer)
    defer:
      first.destroy()
      second.destroy()
    let a = newButton("one")
    let b = newButton("two")
    let duplicate = newLabel("duplicate")
    defer: duplicate.destroy()
    first.addChildAtAnchor(a, anchor)
    second.addChildAtAnchor(b, anchor)
    check anchor.widgets.len == 2
    expect ValueError: first.addChildAtAnchor(duplicate, anchor)
    expect ValueError: second.addChildAtAnchor(a, anchor)
    expect ValueError: first.addChildAtAnchor(first, anchor)
    let top = newWindow()
    defer: top.destroy()
    expect ValueError: first.addChildAtAnchor(top, anchor)
    let foreign = newTextBuffer().createChildAnchor(0)
    expect ValueError: first.addChildAtAnchor(duplicate, foreign)
    first.remove(a)
    check not a.isDestroyed and anchor.widgets.len == 1
    first.addChildAtAnchor(a, anchor)
    first.buffer = newTextBuffer("replacement")
    check a.isDestroyed and not b.isDestroyed and not anchor.deleted
    check anchor.widgets.len == 1
    buffer.deleteAnchor(anchor)
    check b.isDestroyed and anchor.deleted and anchor.widgets.len == 0
  test "destroying a widget or a view does not delete its buffer anchor":
    let buffer = newTextBuffer()
    let anchor = buffer.createChildAnchor(0)
    let view = newTextView(buffer)
    let child = newEntry("inline")
    view.addChildAtAnchor(child, anchor)
    child.destroy()
    check anchor.widgets.len == 0 and not anchor.deleted
    let other = newLabel("again")
    view.addChildAtAnchor(other, anchor)
    view.destroy()
    check other.isDestroyed and not anchor.deleted and buffer.characterCount == 1
  test "owned constructor survives immediate deletion by an existing changed observer":
    let buffer = newTextBuffer("AB")
    var once = false
    var lookup: TextChildAnchor
    let observer = buffer.onChanged(proc () =
      if not once:
        once = true
        lookup = buffer.childAnchorAt(1)
        buffer.deleteRange(1, 2))
    let anchor = buffer.createChildAnchor(1)
    observer.disconnect()
    check anchor.deleted and lookup.raw == anchor.raw and lookup.deleted
    check buffer.text == "AB"
  test "anchors do not retain buffers; buffer finalization queues a single safe observation":
    var finalized, notices = 0
    let anchor = orphan(addr finalized, addr notices)
    check finalized == 1 and anchor.deleted and notices == 0
    drain()
    check notices == 1
    drain()
    check notices == 1
  test "idle one-shot observations may edit buffers, destroy views and throw safely":
    let buffer = newTextBuffer("ABC")
    let anchor = buffer.createChildAnchor(1)
    let later = buffer.createChildAnchor(3)
    let view = newTextView(buffer)
    let child = newButton("embedded")
    view.addChildAtAnchor(child, anchor)
    var calls = 0
    let token = anchor.onDeleted(proc () =
      inc calls
      doAssert child.isDestroyed and anchor.deleted
      buffer.deleteAnchor(later)
      buffer.appendText("done")
      view.destroy()
      raise newException(ValueError, "expected anchor deletion observer error"))
    buffer.deleteAnchor(anchor)
    check child.isDestroyed and calls == 0 and token.connected
    drain()
    check calls == 1 and not token.connected and later.deleted and view.isDestroyed
    var late = 0
    let already = anchor.onDeleted(proc () = inc late)
    check late == 0 and already.connected
    drain()
    check late == 1 and not already.connected
  test "one-shot delivery releases self-captured anchors after the external handle drops":
    let buffer = newTextBuffer()
    var calls, finalized = 0
    block:
      let anchor = selfObserved(buffer, addr calls, addr finalized)
      check not anchor.deleted
    buffer.text = "reset"
    check calls == 0 and finalized == 0
    drain()
    check calls == 1 and finalized == 1
  test "disconnection cancels queued notifications and native finalization releases captures":
    let buffer = newTextBuffer()
    let anchor = buffer.createChildAnchor(0)
    var calls = 0
    let token = anchor.onDeleted(proc () = inc calls)
    buffer.text = "reset"
    token.disconnect()
    token.disconnect()
    drain()
    check calls == 0 and anchor.deleted and not token.connected
    let canceled = anchor.onDeleted(proc () = inc calls)
    anchor.disconnectSignals()
    drain()
    check calls == 0 and not canceled.connected
    var finalized = 0
    block:
      let another = buffer.createChildAnchor(0)
      g.weak_ref(cast[g.PGObject](another.raw), gone, addr finalized)
      buffer.deleteAnchor(another)
    check finalized == 1
