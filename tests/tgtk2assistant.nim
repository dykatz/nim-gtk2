import std/unittest
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newAssistant().raw) is ptr rawGtk.Assistant
proc drainUi() =
  for i in 0..<128:
    if rawGtk.events_pending() == 0: return
    discard rawGtk.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "unexpected continuously pending UI source")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  released, calls: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.released[]
type Capture = ref CaptureObj
proc track(w: gtk2.Assistant, released, calls: ptr int): Connection =
  let capture = Capture(released: released, calls: calls)
  w.onApply(proc () = inc capture.calls[])
proc emit(w: gtk2.Assistant, signal: cstring) = g.g_signal_emit_by_name(w.raw, signal)
proc temporaryAssistant(released, calls: ptr int): ptr rawGtk.Assistant =
  let w = newAssistant()
  discard track(w, released, calls)
  emit(w, "apply")
  w.raw

gtk2.init()
suite "nonblocking Assistant workflows (hidden)":
  test "window properties, validation, transient ownership and managed Bin upcasts":
    expect ValueError: discard newAssistant("\xff")
    expect ValueError: discard newAssistant(width = -1)
    expect ValueError: discard newAssistant(gtk2.Window())
    let parent = newWindow()
    defer: parent.destroy()
    let w = newAssistant(parent, "Wizard café %s", modal = true)
    defer: w.destroy()
    check w.title == "Wizard café %s" and w.modal and w.destroyWithParent
    check rawGtk.get_transient_for(cast[rawGtk.PWindow](w.raw)) == parent.raw
    expect ValueError: w.title = "bad\0title"
    expect ValueError: parent.transientFor = w
    let page = newVBox()
    defer: page.destroy()
    expect ValueError: gtk2.Bin(w).add(page)
    w.appendPage(page, "Intro", assistantIntro, complete = true)
    parent.destroy()
    check w.isDestroyed
    # GTK2 deliberately unparents retained page roots; it doesn't destroy them.
    check not page.isDestroyed
    check rawGtk.get_parent(cast[rawGtk.PWidget](page.raw)) == nil

  test "page indices, copied titles, completion, types and checked mutation":
    let w = newAssistant()
    defer: w.destroy()
    check w.pageCount == 0 and w.currentPage == -1
    expect ValueError: w.currentPage = 0
    let intro = newLabel("Welcome")
    let content = newVBox()
    let final = newLabel("Done")
    defer:
      intro.destroy()
      content.destroy()
      final.destroy()
    w.appendPage(content, "Content")
    w.prependPage(intro, "Intro", assistantIntro, complete = true)
    w.insertPage(2, final, "Final", assistantSummary, complete = true)
    check w.pageCount == 3 and w.pageIndex(content) == 1
    check w.pageAt(0).raw == cast[rawGtk.PWidget](intro.raw)
    check w.pageType(intro) == assistantIntro and w.pageComplete(intro)
    check w.pageType(content) == assistantContent and not w.pageComplete(content)
    check w.pageComplete(final)
    w.setPageTitle(content, "Edited café")
    check w.pageTitle(content) == "Edited café"
    w.setPageComplete(content)
    check w.pageComplete(content)
    for kind in AssistantPageKind:
      w.setPageType(content, kind)
      check w.pageType(content) == kind
    w.setPageType(content, assistantContent)
    expect ValueError: w.setPageTitle(content, "\xff")
    check w.pageTitle(content) == "Edited café"
    expect ValueError: w.appendPage(content)
    expect ValueError: w.insertPage(-1, newLabel())
    expect ValueError: discard w.pageAt(3)
    expect ValueError: w.removePage(-1)
    expect ValueError: w.appendPage(w)
    let other = newLabel("Other")
    defer: other.destroy()
    check w.pageIndex(other) == -1
    expect ValueError: w.setPageComplete(other)
    expect ValueError: discard w.pageTitle(other)
    expect ValueError: w.insertPage(4, other)
    expect ValueError: w.appendPage(other, "bad\0title")
    check rawGtk.get_parent(cast[rawGtk.PWidget](other.raw)) == nil
    w.currentPage = 0
    check w.currentPage == 0
    w.setPageVisible(content, false)
    check not w.pageVisible(content)
    rawGtk.show_all(cast[rawGtk.PWidget](content.raw))
    check not w.pageVisible(content) # Explicit hiding survives showAll.
    expect ValueError: w.currentPage = 1
    expect ValueError: w.setPageVisible(intro, false)
    w.setPageVisible(content, true)
    w.currentPage = 1
    check w.currentPage == 1
    w.updateButtons()
    w.removePage(0)
    check w.pageCount == 2 and w.pageIndex(content) == 0
    check not intro.isDestroyed
    w.currentPage = 1
    w.removePage(1) # Removing current final page is supported natively.
    check not final.isDestroyed and w.pageCount == 1

  test "owning nullable page image getters retain native Pixbuf references":
    let w = newAssistant()
    defer: w.destroy()
    let page = newVBox()
    defer: page.destroy()
    w.appendPage(page, "Images", assistantIntro, complete = true)
    check w.pageHeaderImage(page).isEmpty and w.pageSideImage(page).isEmpty
    let header = newPixbuf(24, 24, 0xff8800ff'u32)
    let side = newPixbuf(32, 48, 0x0088ffff'u32)
    w.setPageHeaderImage(page, header)
    w.setPageSideImage(page, side)
    let a = w.pageHeaderImage(page)
    let b = w.pageSideImage(page)
    check a.raw == header.raw and b.raw == side.raw
    w.currentPage = 0
    w.setPageHeaderImage(page, gtk2.Pixbuf())
    w.setPageSideImage(page, gtk2.Pixbuf())
    check w.pageHeaderImage(page).isEmpty and w.pageSideImage(page).isEmpty
    check a.width == 24 and b.height == 48
    w.removePage(0)
    expect ValueError: w.setPageSideImage(page, side)
    check a.width == 24

  test "action widgets require checked owner membership and detach retained buttons":
    let w = newAssistant()
    defer: w.destroy()
    let other = newAssistant()
    defer: other.destroy()
    let button = newButton("Help")
    defer: button.destroy()
    w.addActionWidget(button)
    expect ValueError: w.addActionWidget(button)
    expect ValueError: other.removeActionWidget(button)
    let page = newVBox()
    defer: page.destroy()
    w.appendPage(page, "Page")
    let inside = newButton("Page button")
    page.packStart(inside)
    expect ValueError: w.removeActionWidget(inside)
    w.removeActionWidget(button)
    check not button.isDestroyed
    expect ValueError: w.removeActionWidget(button)
    other.addActionWidget(button)
    other.destroy()
    check button.isDestroyed
    w.commit()
    w.updateButtons()

  test "prepare observers defer/coalesce owning snapshots and can disconnect themselves":
    let w = newAssistant()
    defer: w.destroy()
    let a = newLabel("A")
    let b = newLabel("B")
    defer:
      a.destroy()
      b.destroy()
    w.appendPage(a, "A", assistantIntro, complete = true)
    w.appendPage(b, "B", assistantSummary, complete = true)
    var seen: seq[Widget]
    var connection: Connection
    connection = w.onPrepare(proc (page: Widget) =
      seen.add(page)
      connection.disconnect())
    w.currentPage = 0
    w.currentPage = 1
    check seen.len == 0
    drainUi()
    check seen.len == 1 and seen[0].raw == cast[rawGtk.PWidget](b.raw)
    check not connection.connected
    w.removePage(1)
    check not seen[0].isDestroyed
    b.destroy()
    check seen[0].isDestroyed

  test "prepare callbacks may remove pages/destroy owners and exceptions stay contained":
    let w = newAssistant()
    defer: w.destroy()
    let a = newLabel("A")
    let b = newLabel("B")
    defer:
      a.destroy()
      b.destroy()
    w.appendPage(a, "A", assistantIntro, complete = true)
    w.appendPage(b, "B", assistantSummary, complete = true)
    w.onPrepare(proc (page: Widget) =
      w.removePage(w.pageIndex(page))
      w.destroy()
      raise newException(ValueError, "expected assistant prepare callback error"))
    w.currentPage = 0
    drainUi()
    check w.isDestroyed and not a.isDestroyed and not b.isDestroyed

  test "apply/cancel/close observers queue each event and allow safe shutdown":
    let w = newAssistant()
    defer: w.destroy()
    var applies, cancels, closes = 0
    w.onApply(proc () = inc applies)
    w.onCancel(proc () = inc cancels)
    w.onClose(proc () = inc closes)
    emit(w, "apply")
    emit(w, "apply")
    emit(w, "cancel")
    emit(w, "close")
    check applies == 0 and cancels == 0 and closes == 0
    drainUi()
    check applies == 2 and cancels == 1 and closes == 1
    check not w.isDestroyed # Signals do not close the wizard automatically.
    w.onApply(proc () = w.destroy())
    emit(w, "apply")
    drainUi()
    check w.isDestroyed
    expect ValueError: discard w.onApply(nil)
    let fresh = newAssistant()
    defer: fresh.destroy()
    expect ValueError: discard fresh.onPrepare(nil)
    expect ValueError: discard fresh.onClose(nil)
    expect ValueError: discard fresh.onCancel(nil)

  test "disconnection/destruction cancel idle work and release heap/native captures":
    var released, calls, gone = 0
    block:
      let w = newAssistant()
      g.weak_ref(cast[g.PGObject](w.raw), finalized, addr gone)
      let connection = track(w, addr released, addr calls)
      emit(w, "apply")
      connection.disconnect()
      check released == 1
      drainUi()
      check calls == 0
      let second = track(w, addr released, addr calls)
      emit(w, "apply")
      w.destroy()
      check not second.connected and released == 2
      drainUi()
      check calls == 0
    check gone == 1
    let native = temporaryAssistant(addr released, addr calls)
    rawGtk.destroy(cast[rawGtk.PWidget](native))
    drainUi()
    check released == 3 and calls == 0
