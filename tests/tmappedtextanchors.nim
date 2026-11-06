# Native TextView inline layout/cleanup, isolated virtual display only.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped anchor tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)
gtk2.init()
suite "native inline TextView widgets":
  test "shared anchor allocates different widgets in two views and deletes safely":
    let host = newWindow("Text anchors", 700, 280)
    defer: host.destroy()
    let buffer = newTextBuffer("Before λ🙂  after\nAnother line\n")
    let anchor = buffer.createChildAnchor(11)
    let first = newTextView(buffer)
    let second = newTextView(buffer)
    first.wrapMode = wrapWordChar
    second.wrapMode = wrapWordChar
    second.editable = false
    let button = newButton("Inline λ🙂")
    let entry = newEntry("inline editor")
    first.addChildAtAnchor(button, anchor)
    second.addChildAtAnchor(entry, anchor)
    let layout = newHBox(spacing = 8)
    let left = newScrolledWindow()
    let right = newScrolledWindow()
    left.add(first)
    right.add(second)
    layout.packStart(left)
    layout.packStart(right)
    host.add(layout)
    var notices = 0
    anchor.onDeleted(proc () =
      inc notices
      doAssert button.isDestroyed and entry.isDestroyed
      buffer.appendText("Anchor cleanup finished\n")
      host.destroy())
    host.showAll()
    require awaitUi(proc (): bool =
      g.toBool(n.get_mapped(cast[n.PWidget](button.raw))) and
      g.toBool(n.get_mapped(cast[n.PWidget](entry.raw))) and
      button.allocation.width > 20 and entry.allocation.height > 10)
    check anchor.widgets.len == 2 and anchor.offset == 11
    buffer.insertText(0, "prefix ")
    check anchor.offset == 18
    button.onClicked(proc () = buffer.deleteAnchor(anchor))
    button.click()
    check button.isDestroyed and entry.isDestroyed and notices == 0
    require awaitUi(proc (): bool = notices == 1)
    check host.isDestroyed and anchor.deleted
  test "removal/reparenting and replacing one mapped view's buffer preserve other view":
    let host = newWindow("Anchor detach", 700, 280)
    defer: host.destroy()
    let buffer = newTextBuffer("AB")
    let anchor = buffer.createChildAnchor(1)
    let first = newTextView(buffer)
    let second = newTextView(buffer)
    let one = newLabel("first")
    let two = newLabel("second")
    first.addChildAtAnchor(one, anchor)
    second.addChildAtAnchor(two, anchor)
    let box = newHBox()
    box.packStart(first)
    box.packStart(second)
    host.add(box)
    host.showAll()
    require awaitUi(proc (): bool = g.toBool(n.get_mapped(cast[n.PWidget](two.raw))))
    first.remove(one)
    check not one.isDestroyed and anchor.widgets.len == 1
    first.addChildAtAnchor(one, anchor)
    one.showAll()
    first.buffer = newTextBuffer("new buffer")
    check one.isDestroyed and not two.isDestroyed and not anchor.deleted
    check anchor.widgets.len == 1
    buffer.text = "reset"
    check two.isDestroyed and anchor.deleted
    discard awaitUi(proc (): bool = true)
