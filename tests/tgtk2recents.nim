import std/[unittest, os, tempfiles, times]
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newRecentManager("/tmp/unused").raw) is ptr rawGtk.RecentManager
  doAssert typeof(newRecentChooserWidget().raw) is ptr rawGtk.RecentChooserWidget
  doAssert typeof(newRecentChooserMenu().raw) is ptr rawGtk.RecentChooserMenu
  doAssert typeof(newRecentChooserDialog().raw) is ptr rawGtk.RecentChooserDialog
proc drainUi() =
  for i in 0..<256:
    if rawGtk.events_pending() == 0: return
    discard rawGtk.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "continuously pending UI source")
proc awaitUi(predicate: proc (): bool): bool =
  let until = epochTime() + 5.0
  while epochTime() < until:
    drainUi()
    if predicate(): return true
    sleep(5)
proc fileUri(path: string): string =
  let text = g.g_filename_to_uri(path.cstring, nil, nil)
  doAssert text != nil
  result = $text
  g.g_free(text)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  freed, calls: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc track(w: gtk2.RecentChooserWidget, freed, calls: ptr int): Connection =
  let capture = Capture(freed: freed, calls: calls)
  w.onItemActivated(proc (item: RecentItem) = inc capture.calls[])
proc trackManager(m: gtk2.RecentManager, freed, calls: ptr int): Connection =
  let capture = Capture(freed: freed, calls: calls)
  m.onChanged(proc () = inc capture.calls[])

let sandbox = createTempDir("nim-gtk2-recents-", "")
putEnv("XDG_CONFIG_HOME", sandbox)
putEnv("XDG_DATA_HOME", sandbox)
let first = sandbox / "first.txt"
let second = sandbox / "café.txt"
writeFile(first, "first")
writeFile(second, "second")
let firstUri = filenameToUri(first)
let secondUri = filenameToUri(second)
let missingUri = filenameToUri(sandbox / "missing.txt")
gtk2.init()
proc fixture(name: string): gtk2.RecentManager =
  result = newRecentManager(sandbox / (name & ".xbel"))
  result.addItem(firstUri, "text/plain", "Nim GTK2 tests", "nim-gtk2-test %u", displayName = "First", groups = ["tests"])
  result.addItem(secondUri, "text/plain", "Nim GTK2 tests", "nim-gtk2-test %u", displayName = "Café", description = "Copied description")
proc load(w: gtk2.RecentChooserWidget) =
  # Hidden choosers normally load on map; changing the limit starts their native
  # idle loader without mapping. Keep a nonempty eligible list on unpatched GTK2
  # (see the standalone native cleanup diagnostic and source patch).
  w.limit = 20
  drainUi()
proc load(w: gtk2.RecentChooserDialog) =
  w.limit = 20
  drainUi()

proc temporaryChooser(m: gtk2.RecentManager, freed, calls: ptr int): ptr rawGtk.RecentChooserWidget =
  let w = newRecentChooserWidget(m)
  w.load()
  discard g.g_object_ref(w.raw)
  discard track(w, freed, calls)
  g.g_signal_emit_by_name(w.raw, "item-activated")
  w.raw

suite "recent managers, filters and chooser widgets (hidden)":
  test "isolated manager metadata, vectors, native errors, move/removal/purge":
    expect ValueError: discard newRecentManager("relative.xbel")
    expect ValueError: discard newRecentManager(sandbox)
    expect ValueError: discard filenameToUri("relative.txt")
    expect ValueError: discard filenameToUri(first & "\0tail")
    check filenameToUri(second) == fileUri(second)
    let manager = fixture("manager")
    check manager.items.len == 2 and manager.hasItem(firstUri)
    check manager.filename == sandbox / "manager.xbel"
    let saved = manager.lookupItem(secondUri)
    check saved.uri == secondUri and saved.displayName == "Café"
    check saved.description == "Copied description" and saved.mimeType == "text/plain"
    check saved.isLocal and not saved.isPrivate and saved.age >= 0
    check "Nim GTK2 tests" in saved.applications
    check saved.lastApplication == "Nim GTK2 tests"
    check manager.lookupItem(firstUri).groups == @["tests"]
    check saved.shortName.len > 0
    manager.removeItem(secondUri)
    check not manager.hasItem(secondUri) and saved.uri == secondUri
    try:
      discard manager.lookupItem(secondUri)
      check false
    except RecentError as error:
      check error.domain != 0 and error.msg.len > 0
    expect RecentError: manager.removeItem(secondUri)
    manager.moveItem(firstUri, secondUri)
    check not manager.hasItem(firstUri) and manager.hasItem(secondUri)
    expect RecentError: manager.moveItem(firstUri, missingUri)
    expect ValueError: discard manager.addItem("not-a-uri", "text/plain", "app", "app %u")
    expect ValueError: discard manager.addItem(firstUri, "", "app", "app %u")
    expect ValueError: discard manager.addItem(firstUri, "text/plain", "app", "app %u", displayName = "\xff")
    expect ValueError: discard manager.addItem(firstUri, "text/plain", "app", "app %u", groups = ["bad\0group"])
    check manager.purgeItems() == 1
    check manager.items.len == 0

  test "plain GObject changed observers defer, disconnect and persist isolated history":
    let manager = fixture("changed")
    var count, freed, calls = 0
    manager.onChanged(proc () = inc count)
    let canceled = trackManager(manager, addr freed, addr calls)
    g.g_signal_emit_by_name(manager.raw, "changed") # Native changed class handler saves the XBEL.
    check count == 0 and calls == 0
    canceled.disconnect()
    check freed == 1
    drainUi()
    check count == 1 and fileExists(sandbox / "changed.xbel")
    let another = trackManager(manager, addr freed, addr calls)
    g.g_signal_emit_by_name(manager.raw, "changed")
    manager.disconnectSignals()
    drainUi()
    check not another.connected and freed == 2 and calls == 0

  test "default manager is an owning borrowed singleton view, without desktop writes":
    let first = defaultRecentManager()
    let second = defaultRecentManager()
    check first.raw == second.raw
    check first.filename == sandbox / "recently-used.xbel"
    let menu = newRecentChooserMenu()
    defer: menu.destroy()
    drainUi()
    check menu.manager.raw == first.raw

  test "all chooser types share checked settings and retain borrowed native managers":
    let manager = fixture("settings")
    let panel = newRecentChooserWidget(manager)
    let menu = newRecentChooserMenu(manager)
    let dialog = newRecentChooserDialog("Recent café %s", manager, modal = true)
    defer:
      panel.destroy()
      menu.destroy()
      dialog.destroy()
    panel.load()
    dialog.load()
    check panel.manager.raw == manager.raw and menu.manager.raw == manager.raw
    check dialog.title == "Recent café %s" and dialog.modal
    expect ValueError: dialog.title = "bad\0title"
    expect ValueError: discard newRecentChooserDialog("\xff", manager)
    panel.limit = -1
    check panel.limit == -1
    expect ValueError: panel.limit = -2
    for sort in RecentSort:
      panel.sortOrder = sort
      check panel.sortOrder == sort
    panel.showPrivate = true
    panel.showNotFound = false
    panel.showTips = true
    panel.showIcons = false
    panel.localOnly = false
    check panel.showPrivate and not panel.showNotFound and panel.showTips
    check not panel.showIcons and not panel.localOnly
    panel.selectMultiple = false
    expect ValueError: panel.selectMultiple = true
    menu.selectMultiple = false # Do not invoke native menu's always-warning setter.
    expect ValueError: menu.selectMultiple = true
    menu.showNumbers = true
    check menu.showNumbers
    menu.showNumbers = false
    menu.showPrivate = true
    menu.showPrivate = false
    menu.limit = 1
    check menu.items.len == 1
    menu.limit = 20
    menu.sortOrder = recentMostRecent
    menu.showTips = true
    menu.refresh()
    let extra = newLabel("Private controls are managed")
    defer: extra.destroy()
    expect ValueError: gtk2.VBox(panel).packStart(extra)
    let item = newMenuItem("Extra")
    defer: item.destroy()
    expect ValueError: gtk2.MenuShell(menu).append(item)
    expect ValueError: discard gtk2.MenuShell(menu).itemAt(0)
    let host = newMenuItem("Recent")
    defer: host.destroy()
    host.submenu = menu
    check host.submenu.raw == cast[rawGtk.PMenu](menu.raw)
    host.clearSubmenu()
    drainUi() # Finish native reloads before destroying an unpatched GTK2 panel.

  test "items are eligible metadata, not selected rows; selection and activation differ":
    let manager = fixture("selection")
    let w = newRecentChooserWidget(manager)
    defer: w.destroy()
    w.load()
    check w.items.len == 2 and w.currentItem.isEmpty
    var selected: seq[RecentItem]
    var activated: seq[RecentItem]
    let selection = w.onSelectionChanged(proc (item: RecentItem) = selected.add(item))
    w.onItemActivated(proc (item: RecentItem) = activated.add(item))
    w.selectUri(firstUri)
    w.selectUri(secondUri)
    check selected.len == 0 and activated.len == 0
    drainUi()
    check selected.len == 1 and selected[0].uri == secondUri
    check w.items.len == 2 and w.currentUri == secondUri
    expect RecentError: w.selectUri(missingUri)
    w.activateUri(firstUri) # Select FIRST, before GTK2 emits activation.
    drainUi()
    check activated.len == 1 and activated[0].uri == firstUri
    check w.currentItem.uri == firstUri and w.items.len == 2
    w.unselectUri(firstUri)
    drainUi()
    check w.currentItem.isEmpty and selected[^1].isEmpty
    selection.disconnect()
    check not selection.connected
    w.unselectAll()
    let copy = activated[0]
    manager.removeItem(firstUri)
    check copy.uri == firstUri and copy.displayName == "First"

  test "recent filter rules, shared owning getters and menu's single filter slot":
    let manager = fixture("filters")
    let w = newRecentChooserWidget(manager)
    let menu = newRecentChooserMenu(manager)
    defer:
      w.destroy()
      menu.destroy()
    w.load()
    let texts = newRecentFilter("Text", ["*.txt"])
    let all = newRecentFilter("All", ["*"])
    let byGroup = newRecentFilter("Grouped")
    byGroup.addGroup("tests")
    let byApp = newRecentFilter("Application")
    byApp.addApplication("Nim GTK2 tests")
    all.addPixbufFormats()
    var info = rawGtk.RecentFilterInfo(contains: rawGtk.RECENT_FILTER_DISPLAY_NAME or
      rawGtk.RECENT_FILTER_URI or rawGtk.RECENT_FILTER_MIME_TYPE,
      display_name: "Friendly title", uri: "file:///first.txt", mime_type: "text/plain")
    check not g.toBool(rawGtk.recent_filter_filter(texts.raw, addr info))
    texts.addMimeType("text/plain")
    check g.toBool(rawGtk.recent_filter_filter(texts.raw, addr info))
    byApp.addAge(7)
    expect ValueError: byApp.addAge(-1)
    expect ValueError: texts.addPattern("")
    expect ValueError: texts.addGroup("bad\0group")
    expect ValueError: discard newRecentFilter(patterns = ["\xff"])
    texts.name = "Text café"
    w.addFilter(texts)
    w.addFilter(all)
    w.addFilter(byGroup)
    w.addFilter(byApp)
    check w.filters.len == 4 and w.filter.raw == texts.raw
    w.filter = byGroup
    check w.items.len == 1 and w.items[0].uri == firstUri
    w.filter = byApp
    check w.items.len == 2
    expect ValueError: w.addFilter(texts)
    let foreign = newRecentFilter("Foreign")
    expect ValueError: w.removeFilter(foreign)
    expect ValueError: w.filter = foreign
    menu.addFilter(texts)
    expect ValueError: menu.addFilter(all)
    menu.filter = all
    menu.filter = all # Same assignment must not unref/ref a dying pointer.
    check menu.filters.len == 1 and menu.filter.raw == all.raw
    let retained = menu.filter
    menu.removeFilter(all)
    check menu.filter.isEmpty and retained.name == "All"
    let aliases = w.filters
    w.removeFilter(byApp)
    check aliases[3].raw == byApp.raw
    w.filter = all
    drainUi()
    check texts.name == "Text café" and w.items.len == 2

  test "recent menu native activation snapshots, refresh, and empty menu placeholder":
    let manager = fixture("menu-activation")
    let menu = newRecentChooserMenu(manager)
    defer: menu.destroy()
    menu.limit = 20
    drainUi()
    var seen: seq[RecentItem]
    menu.onItemActivated(proc (item: RecentItem) = seen.add(item))
    # Establish the active row as GTK's real pointer selection would, then
    # exercise native recent-menu item activation without mapping its popup.
    rawGtk.set_active(cast[rawGtk.PMenu](menu.raw), g.guint(0))
    let target = menu.currentUri
    require target.len > 0
    var error: ptr g.GError
    check g.toBool(rawGtk.recent_chooser_set_current_uri(cast[ptr rawGtk.RecentChooser](menu.raw), target.cstring, addr error))
    check error == nil and seen.len == 0
    drainUi()
    check seen.len == 1 and seen[0].uri == target
    let emptyManager = newRecentManager(sandbox / "empty-menu.xbel")
    let empty = newRecentChooserMenu(emptyManager)
    defer: empty.destroy()
    drainUi() # The menu's empty path is valid; panel's cleanup bug is separate.
    check empty.items.len == 0 and empty.currentItem.isEmpty

  test "copied response snapshots, Dialog upcasts, native activation, parent ownership":
    let manager = fixture("dialog")
    let parent = newWindow()
    defer: parent.destroy()
    let w = newRecentChooserDialog(parent, "Recent", manager)
    defer: w.destroy()
    w.load()
    check w.destroyWithParent
    expect ValueError: parent.transientFor = w
    w.selectUri(firstUri)
    var snapshots: seq[RecentItem]
    var ids: seq[ResponseId]
    w.onResponse(proc (id: ResponseId, item: RecentItem) =
      ids.add(id)
      snapshots.add(item))
    var generic = 0
    gtk2.Dialog(w).onResponse(proc (id: ResponseId) = inc generic)
    w.respond(responseAccept)
    check snapshots.len == 0 and generic == 0
    w.selectUri(secondUri)
    drainUi()
    check ids == @[responseAccept] and snapshots[0].uri == firstUri and generic == 1
    w.onResponse(proc (id: ResponseId) = w.destroy())
    # Hidden buttons cannot perform GTK's animated default activation. Clear
    # that default so its native item-activation handler uses the Accept fallback.
    rawGtk.set_default(cast[rawGtk.PWindow](w.raw), nil)
    w.activateUri(firstUri)
    drainUi()
    check w.isDestroyed and snapshots[^1].uri == firstUri
    let child = newRecentChooserDialog(parent, "Child", manager)
    child.load()
    parent.destroy()
    check child.isDestroyed
    expect ValueError: discard newRecentChooserDialog(gtk2.Window(), manager = manager)

  test "heap captures, cancellation, exception containment and callback destruction":
    let manager = fixture("callbacks")
    let w = newRecentChooserWidget(manager)
    defer: w.destroy()
    w.load()
    var freed, calls = 0
    let cancel = track(w, addr freed, addr calls)
    w.selectUri(firstUri)
    g.g_signal_emit_by_name(w.raw, "item-activated")
    cancel.disconnect()
    check freed == 1
    drainUi()
    check calls == 0
    let pending = track(w, addr freed, addr calls)
    g.g_signal_emit_by_name(w.raw, "item-activated")
    w.destroy()
    drainUi()
    check not pending.connected and freed == 2 and calls == 0
    let native = temporaryChooser(manager, addr freed, addr calls)
    rawGtk.destroy(cast[rawGtk.PWidget](native))
    g.g_object_unref(native)
    drainUi()
    check freed == 3 and calls == 0
    let next = newRecentChooserWidget(manager)
    defer: next.destroy()
    next.load()
    var connection: Connection
    connection = next.onSelectionChanged(proc (item: RecentItem) =
      connection.disconnect()
      next.destroy()
      raise newException(ValueError, "expected recent callback error"))
    next.selectUri(firstUri)
    drainUi()
    check next.isDestroyed and not connection.connected

  test "nil observers reject without retaining partial callback state":
    let manager = fixture("nil-callbacks")
    let panel = newRecentChooserWidget(manager)
    let dialog = newRecentChooserDialog(manager = manager)
    defer:
      panel.destroy()
      dialog.destroy()
    panel.load()
    dialog.load()
    expect ValueError: discard manager.onChanged(nil)
    expect ValueError: discard panel.onSelectionChanged(nil)
    expect ValueError: discard panel.onItemActivated(nil)
    let fn: proc (id: ResponseId, item: RecentItem) {.closure.} = nil
    expect ValueError: discard dialog.onResponse(fn)

  test "native manager retention outlives temporary handles and releases on finalization":
    var managerGone, widgetGone, filterGone = 0
    block:
      var w: gtk2.RecentChooserWidget
      block:
        let manager = fixture("retained")
        g.weak_ref(cast[g.PGObject](manager.raw), finalized, addr managerGone)
        w = newRecentChooserWidget(manager)
      check managerGone == 0
      w.load()
      check w.manager.hasItem(firstUri) and w.items.len == 2
      g.weak_ref(cast[g.PGObject](w.raw), finalized, addr widgetGone)
      block:
        let filter = newRecentFilter("Temporary", ["*"])
        g.weak_ref(cast[g.PGObject](filter.raw), finalized, addr filterGone)
        w.addFilter(filter)
      drainUi()
      w.destroy()
    check awaitUi(proc (): bool = managerGone == 1 and widgetGone == 1 and filterGone == 1)

# Last native manager references can flush queued changes on release. Finish
# sources before deleting our isolated storage; no desktop history is touched.
drainUi()
removeDir(sandbox)
