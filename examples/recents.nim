## Build: nim c --path:src examples/recents.nim
## Uses isolated demo history, never your desktop recent-items list.
## Empty lists on unpatched GTK2/modern GLib need the native fix in docs/gtk2.md.
import std/[os, tempfiles]
import gtk2
proc describe(item: RecentItem): string =
  if item.isEmpty: "No selection"
  else: item.displayName & " — " & item.uri

proc runExample(directory: string) =
  gtk2.init()
  let manager = newRecentManager(directory / "history.xbel")
  for i, name in ["first.txt", "second.txt", "third.txt"]:
    let filename = directory / name
    writeFile(filename, "Demo document " & $i)
    manager.addItem(filenameToUri(filename), "text/plain", "Nim GTK2 example", "nim-gtk2-recents %u",
      displayName = "Demo " & $(i + 1), description = "Isolated example document", groups = ["demo"])
  let window = newWindow("GTK2 recent-item choosers", 760, 520)
  defer: window.destroy()
  defer: manager.disconnectSignals()
  let layout = newVBox(spacing = 10)
  layout.borderWidth = 12
  window.add(layout)
  let bar = newMenuBar()
  let recentMenu = newRecentChooserMenu(manager)
  defer: recentMenu.destroy()
  recentMenu.showNumbers = true
  recentMenu.sortOrder = recentMostRecent
  recentMenu.limit = 10
  let recentRoot = newMenuItem("Recent documents")
  recentRoot.submenu = recentMenu
  bar.append(recentRoot)
  layout.packStart(bar, packShrink)
  let status = newLabel("Choose an item; activation is separate from selection.")
  layout.packStart(status, packShrink)
  let panel = newRecentChooserWidget(manager)
  panel.sortOrder = recentMostRecent
  panel.limit = 10
  panel.showTips = true
  # Recent patterns match DISPLAY NAMES, not necessarily URI basenames. Our
  # friendly "Demo 1" titles have no extension, so filter by MIME instead.
  let textFilter = newRecentFilter("Text documents")
  textFilter.addMimeType("text/plain")
  panel.addFilter(textFilter)
  recentMenu.addFilter(textFilter)
  layout.packStart(panel)
  panel.onSelectionChanged(proc (item: RecentItem) = status.text = "Selected: " & describe(item))
  panel.onItemActivated(proc (item: RecentItem) = status.text = "Activated: " & describe(item))
  recentMenu.onItemActivated(proc (item: RecentItem) = status.text = "Menu activated: " & describe(item))
  let row = newHBox(spacing = 8)
  layout.packEnd(row, packShrink)
  let dialogButton = newButton("Recent dialog…")
  let add = newButton("Register first document again")
  let clear = newButton("Clear selection")
  row.packStart(dialogButton, packShrink)
  row.packStart(add, packShrink)
  row.packEnd(clear, packShrink)
  add.onClicked(proc () =
    manager.addItem(filenameToUri(directory / "first.txt"), "text/plain", "Nim GTK2 example", "nim-gtk2-recents %u",
      displayName = "Demo 1", groups = ["demo"]))
  clear.onClicked(proc () = panel.unselectAll())
  dialogButton.onClicked(proc () =
    let dialog = newRecentChooserDialog(window, "Recent documents", manager)
    dialog.sortOrder = recentMostRecent
    dialog.limit = 10
    dialog.addFilter(textFilter)
    dialog.onResponse(proc (id: ResponseId, item: RecentItem) =
      if id == responseAccept and not item.isEmpty:
        # Only report the choice. Never execute stored application commands.
        status.text = "Dialog accepted: " & describe(item)
      dialog.destroy())
    dialog.present())
  window.run()

proc main() =
  let directory = createTempDir("nim-gtk2-recent-example-", "")
  try:
    # Let all owning handles/finalizers finish before removing their storage.
    runExample(directory)
  finally: removeDir(directory)

when isMainModule:
  main()
