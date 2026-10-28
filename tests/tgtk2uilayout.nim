# Hidden widgets only: no toplevel show(), dialog run, or GTK main loop.
import std/unittest
import gtk2ui
import gtk2 as rawGtk
import glib2 as g

static:
  doAssert typeof(newScrolledWindow().raw) is rawGtk.PScrolledWindow
  doAssert typeof(newViewport().raw) is rawGtk.PViewport
  doAssert typeof(newNotebook().raw) is rawGtk.PNotebook
  doAssert typeof(newHPaned().raw) is rawGtk.PHPaned
  doAssert typeof(newVPaned().raw) is rawGtk.PVPaned
  doAssert not compiles(newNotebook().add(newLabel()))
  doAssert not compiles(newHPaned().add(newLabel()))
  doAssert not compiles(newLabel().onSwitchPage(proc (index: int) = discard))

gtk2ui.init()

suite "gtk2ui scrolling and layout":
  test "scroll policies, shadows and automatic viewport adaptation":
    let scroll = newScrolledWindow()
    let content = newVBox()
    let label = newLabel("Scrollable content")
    defer: scroll.destroy()
    check scroll.policies == (scrollAutomatic, scrollAutomatic)
    scroll.setPolicies(scrollNever, scrollAlways)
    check scroll.policies == (scrollNever, scrollAlways)
    scroll.shadow = shadowEtchedIn
    check scroll.shadow == shadowEtchedIn
    content.packStart(label)
    # Upcasting must not bypass the scrolling adapter or containment checks.
    let bin = gtk2ui.Bin(scroll)
    bin.add(content)
    let adapter = rawGtk.get_child(cast[rawGtk.PBin](scroll.raw))
    check rawGtk.IS_VIEWPORT(adapter)
    check rawGtk.get_parent(content.raw) == adapter
    expect ValueError: scroll.add(newLabel("Second child"))
    expect ValueError: content.packStart(scroll)
    scroll.destroy()
    check content.isDestroyed
    check label.isDestroyed

  test "explicit viewports are not wrapped twice and share adjustments":
    let scroll = newScrolledWindow(scrollAlways, scrollNever)
    let viewport = newViewport()
    let content = newLabel("Inside viewport")
    defer: scroll.destroy()
    viewport.shadow = shadowNone
    check viewport.shadow == shadowNone
    viewport.add(content)
    scroll.add(viewport)
    check rawGtk.get_child(cast[rawGtk.PBin](scroll.raw)) == cast[rawGtk.PWidget](viewport.raw)
    check rawGtk.get_hadjustment(scroll.raw) == rawGtk.get_hadjustment(viewport.raw)
    check rawGtk.get_vadjustment(scroll.raw) == rawGtk.get_vadjustment(viewport.raw)
    expect ValueError: viewport.add(newLabel())
    scroll.destroy()
    check viewport.isDestroyed
    check content.isDestroyed
    expect ValueError: discard scroll.policies
    expect ValueError: discard viewport.shadow

  test "paned slots, divider position and retained-child reparenting":
    let horizontal = newHPaned()
    let vertical = newVPaned()
    let left = newLabel("Left")
    let right = newLabel("Right")
    defer: horizontal.destroy()
    defer: vertical.destroy()
    check not horizontal.hasFirstChild
    check not horizontal.hasSecondChild
    horizontal.packFirst(left, resize = true, shrink = false)
    horizontal.packSecond(right, resize = false, shrink = true)
    check horizontal.hasFirstChild
    check horizontal.hasSecondChild
    check rawGtk.get_child1(cast[rawGtk.PPaned](horizontal.raw)) == cast[rawGtk.PWidget](left.raw)
    check rawGtk.get_child2(cast[rawGtk.PPaned](horizontal.raw)) == cast[rawGtk.PWidget](right.raw)
    horizontal.position = 123
    check horizontal.position == 123
    horizontal.position = -1 # Reset automatic positioning.
    expect ValueError: horizontal.packFirst(newLabel())
    expect ValueError: horizontal.packSecond(left)
    expect ValueError: horizontal.position = -2
    when sizeof(int) > sizeof(g.gint):
      expect ValueError: horizontal.position = high(g.gint).int + 1
    horizontal.removeFirst()
    check not left.isDestroyed
    check rawGtk.get_parent(cast[rawGtk.PWidget](left.raw)) == nil
    vertical.packFirst(left)
    horizontal.removeSecond()
    vertical.packSecond(right)
    expect ValueError: horizontal.removeFirst()
    expect ValueError: horizontal.removeSecond()
    vertical.destroy()
    check left.isDestroyed
    check right.isDestroyed
    expect ValueError: discard vertical.position

  test "paned containment rejects cycles, windows and parented children":
    let outer = newHPaned()
    let inner = newVPaned()
    let window = newWindow()
    let label = newLabel()
    defer: outer.destroy()
    defer: window.destroy()
    outer.packFirst(inner)
    inner.packFirst(label)
    expect ValueError: inner.packSecond(outer)
    expect ValueError: inner.packSecond(inner)
    expect ValueError: outer.packSecond(window)
    expect ValueError: outer.packSecond(label)

  test "notebook indices, tab properties, insertion and reordering":
    let book = newNotebook()
    let first = newLabel("First content")
    let second = newLabel("Second content")
    let middle = newLabel("Middle content")
    defer: book.destroy()
    check book.pageCount == 0
    check book.currentPage == -1
    check not first.visible
    check book.appendPage(first, "First") == 0
    check first.visible # Only the content root is shown by insertion.
    check not book.visible
    check book.currentPage == 0
    check book.appendPage(second, "Second") == 1
    check book.insertPage(1, middle, "Middle") == 1
    check book.pageCount == 3
    check book.pageIndex(first) == 0
    check book.pageIndex(middle) == 1
    check book.pageIndex(second) == 2
    book.currentPage = 2
    check book.currentPage == 2
    book.setTabText(second, "Updated λ")
    check book.tabText(second) == "Updated λ"
    book.setTabReorderable(second, true)
    check book.tabReorderable(second)
    book.setTabReorderable(second, false)
    check not book.tabReorderable(second)
    book.reorderPage(second, 0)
    check book.pageIndex(second) == 0
    check book.currentPage == 0
    for position in [tabLeft, tabBottom, tabRight, tabTop]:
      book.tabPosition = position
      check book.tabPosition == position
    book.showTabs = false
    book.showBorder = false
    book.scrollable = true
    check not book.showTabs
    check not book.showBorder
    check book.scrollable
    book.showTabs = true
    book.showBorder = true
    book.scrollable = false
    check book.showTabs
    check book.showBorder
    check not book.scrollable

  test "notebook removal keeps retained content live and reusable":
    let firstBook = newNotebook()
    let secondBook = newNotebook()
    let content = newLabel("Retained")
    defer: firstBook.destroy()
    defer: secondBook.destroy()
    firstBook.appendPage(content, "Original")
    firstBook.removePage(0)
    check firstBook.pageCount == 0
    check firstBook.currentPage == -1
    check not content.isDestroyed
    check rawGtk.get_parent(cast[rawGtk.PWidget](content.raw)) == nil
    secondBook.appendPage(content, "Moved")
    check secondBook.pageIndex(content) == 0
    secondBook.destroy()
    check content.isDestroyed

  test "page switches carry the correct index after the native default handler":
    let book = newNotebook()
    defer: book.destroy()
    book.appendPage(newLabel("One"), "One")
    book.appendPage(newLabel("Two"), "Two")
    var received: seq[int]
    var current: seq[int]
    let connection = book.onSwitchPage(proc (index: int) =
      received.add(index)
      current.add(book.currentPage))
    book.currentPage = 1
    book.currentPage = 0
    check received == @[1, 0]
    check current == received
    connection.disconnect()
    connection.disconnect()
    book.currentPage = 1
    check received == @[1, 0]
    var once: Connection
    once = book.onSwitchPage(proc (index: int) =
      received.add(index)
      once.disconnect())
    book.currentPage = 0
    book.currentPage = 1
    check received == @[1, 0, 0]
    book.onSwitchPage(proc (index: int) =
      raise newException(ValueError, "expected notebook callback error"))
    var survived = false
    book.onSwitchPage(proc (index: int) = survived = true)
    book.currentPage = 0
    check survived
    book.destroy()
    check not once.connected
    check not connection.connected

  test "heap closures may disconnect or destroy their notebook during dispatch":
    proc exerciseCallbacks() =
      let book = newNotebook()
      defer: book.destroy()
      book.appendPage(newLabel("One"), "One")
      book.appendPage(newLabel("Two"), "Two")
      var received: seq[int]
      var connection: Connection
      connection = book.onSwitchPage(proc (index: int) =
        connection.disconnect()
        received.add(index)
        check book.currentPage == index)
      book.currentPage = 1
      book.currentPage = 0
      check received == @[1]
      book.onSwitchPage(proc (index: int) = book.destroy())
      book.currentPage = 1
      check book.isDestroyed
    exerciseCallbacks()

  test "notebook bad arguments fail before native mutations":
    let book = newNotebook()
    let other = newNotebook()
    let page = newLabel("Page")
    let child = newLabel("Not inserted")
    let window = newWindow()
    defer: book.destroy()
    defer: other.destroy()
    defer: child.destroy()
    defer: window.destroy()
    expect ValueError: book.currentPage = 0
    expect ValueError: book.removePage(0)
    expect ValueError: book.insertPage(-1, child, "Bad")
    expect ValueError: book.insertPage(1, child, "Bad")
    expect ValueError: book.appendPage(child, "a\0b")
    check not child.visible
    check book.pageCount == 0
    book.appendPage(page, "Page")
    check book.pageIndex(child) == -1
    expect ValueError: other.appendPage(page, "Already parented")
    expect ValueError: book.appendPage(window, "Window")
    expect ValueError: book.appendPage(book, "Self")
    expect ValueError: book.currentPage = -1
    expect ValueError: book.currentPage = 1
    expect ValueError: book.removePage(1)
    expect ValueError: book.reorderPage(page, 1)
    expect ValueError: book.reorderPage(child, 0)
    expect ValueError: discard book.tabText(child)
    expect ValueError: book.setTabText(page, "a\0b")
    expect ValueError: book.setTabReorderable(child, true)
    expect ValueError: discard book.onSwitchPage(nil)
    page.hide()
    expect ValueError: book.currentPage = 0
    page.show()
    book.currentPage = 0
    book.destroy()
    expect ValueError: discard book.pageCount
    expect ValueError: book.appendPage(child, "Dead notebook")
    expect ValueError: discard page.visible

  test "insertion shows a page root but not its descendants":
    let book = newNotebook()
    let box = newVBox()
    let label = newLabel("Hidden until showAll")
    defer: book.destroy()
    box.packStart(label)
    book.appendPage(box, "Container")
    check box.visible
    check not label.visible

  test "layout callbacks break self-capturing cycles on native destruction":
    var finalized = false
    proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
      cast[ptr bool](data)[] = true
    # A proc-local widget forces a real heap closure environment; module-level
    # test variables may otherwise be lifted to globals by the Nim compiler.
    proc makeCycle(flag: pointer): rawGtk.PNotebook =
      let book = newNotebook()
      result = book.raw
      g.weak_ref(cast[g.PGObject](result), finalizedCallback, flag)
      book.onSwitchPage(proc (index: int) = discard book.pageCount)
      book.appendPage(newLabel("Owned after wrapper leaves scope"), "Page")
    let native = makeCycle(addr finalized)
    require not finalized
    rawGtk.destroy(cast[rawGtk.PWidget](native))
    check finalized

  test "unparented layout handles finalize all five native objects":
    var finalized: array[5, bool]
    proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
      cast[ptr bool](data)[] = true
    block:
      let widgets = @[gtk2ui.Widget(newScrolledWindow()), gtk2ui.Widget(newViewport()),
        gtk2ui.Widget(newNotebook()), gtk2ui.Widget(newHPaned()), gtk2ui.Widget(newVPaned())]
      for i, widget in widgets:
        g.weak_ref(cast[g.PGObject](widget.raw), finalizedCallback, addr finalized[i])
    for done in finalized: check done
