import std/[unittest, os, tempfiles, times]
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newFileChooserButton().raw) is rawGtk.PFileChooserButton
  doAssert typeof(newFileChooserWidget().raw) is ptr rawGtk.FileChooserWidget
  doAssert typeof(newFileChooserDialog().raw) is rawGtk.PFileChooserDialog
  doAssert sizeof(rawGtk.TFileChooserAction) == sizeof(cint)
  doAssert sizeof(rawGtk.TFileFilterFlags) == sizeof(cint)
proc drainUi() =
  for i in 0..<256:
    if rawGtk.events_pending() == 0: return
    discard rawGtk.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "continuously pending UI source")
proc awaitUi(predicate: proc (): bool): bool =
  let until = epochTime() + 6.0
  while epochTime() < until:
    drainUi()
    if predicate(): return true
    sleep(5)
proc fileUri(path: string): string =
  let uri = g.g_filename_to_uri(path.cstring, nil, nil)
  doAssert uri != nil
  result = $uri
  g.g_free(uri)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  released, calls: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.released[]
type Capture = ref CaptureObj
proc track(w: gtk2.FileChooserWidget, released, calls: ptr int): Connection =
  let capture = Capture(released: released, calls: calls)
  w.onSelectionChanged(proc (value: FileSelection) = inc capture.calls[])
proc temporaryChooser(released, calls: ptr int): ptr rawGtk.FileChooserWidget =
  let w = newFileChooserWidget()
  discard g.g_object_ref(w.raw) # Standalone non-window needs an external owner.
  discard track(w, released, calls)
  g.g_signal_emit_by_name(w.raw, "selection-changed")
  w.raw

# Keep GTK's native chooser/recent settings outside the user's home directory.
let sandbox = createTempDir("nim-gtk2-files-", "")
putEnv("XDG_CONFIG_HOME", sandbox / "config")
putEnv("XDG_DATA_HOME", sandbox / "data")
createDir(sandbox / "config")
createDir(sandbox / "data")
let folder = sandbox / "files"
createDir(folder)
let first = folder / "first.txt"
let second = folder / "café.txt"
writeFile(first, "first")
writeFile(second, "second")
let firstUri = fileUri(first)
let folderUri = fileUri(folder)
gtk2.init()
suite "file chooser widgets (hidden)":
  test "constructors, actions and checked single/multiple selection configuration":
    let button = newFileChooserButton("Pick café %s")
    let panel = newFileChooserWidget()
    let dialog = newFileChooserDialog("Files", modal = true)
    defer:
      button.destroy()
      panel.destroy()
      dialog.destroy()
    check button.title == "Pick café %s" and button.action == fileOpen
    button.title = "Pick a folder"
    button.action = fileSelectFolder
    check button.action == fileSelectFolder
    expect ValueError: button.action = fileSave
    expect ValueError: discard newFileChooserButton(action = fileCreateFolder)
    expect ValueError: discard newFileChooserButton("\xff")
    expect ValueError: button.title = "bad\0title"
    expect ValueError: discard newFileChooserDialog("\xff")
    button.widthChars = 24
    check button.widthChars == 24
    expect ValueError: button.widthChars = -1
    button.focusOnClick = false
    check not button.focusOnClick
    button.focusOnClick = true
    check button.focusOnClick
    let extra = newLabel("Not private content")
    defer: extra.destroy()
    expect ValueError: gtk2.HBox(button).packStart(extra)
    expect ValueError: gtk2.VBox(panel).packEnd(extra)
    button.selectMultiple = false # Must not call GTK's always-warning setter.
    expect ValueError: button.selectMultiple = true
    expect ValueError: discard button.selectFilename(first)
    for kind in FileChooserAction:
      panel.action = kind
      check panel.action == kind
    panel.action = fileSave
    expect ValueError: panel.selectMultiple = true
    panel.action = fileOpen
    panel.selectMultiple = true
    check panel.selectMultiple
    expect ValueError: panel.action = fileSave
    check panel.action == fileOpen and panel.selectMultiple
    panel.selectMultiple = false
    panel.localOnly = false
    check not panel.localOnly
    panel.localOnly = true
    panel.showHidden = true
    check panel.showHidden
    panel.createFolders = false
    check not panel.createFolders
    panel.overwriteConfirmation = true
    check panel.overwriteConfirmation
    check dialog.modal and dialog.action == fileOpen
    dialog.action = fileSave
    check dialog.action == fileSave
    let accept = rawGtk.get_widget_for_response(cast[rawGtk.PDialog](dialog.raw), g.gint(responseAccept))
    check $rawGtk.get_label(cast[rawGtk.PButton](accept)) == "gtk-save"

  test "absolute native paths and URIs validate before mutating selection":
    let w = newFileChooserWidget()
    defer: w.destroy()
    expect ValueError: discard w.setFilename("relative.txt")
    expect ValueError: discard w.setCurrentFolder("")
    expect ValueError: discard w.setFilename(first & "\0tail")
    expect ValueError: discard w.setUri("relative/path")
    expect ValueError: discard w.setCurrentFolderUri("file:///space here")
    expect ValueError: discard w.setUri("1bad:whatever")
    expect ValueError: discard w.setUri("file:///\xff")
    expect ValueError: w.setCurrentName("new.txt")
    check w.setCurrentFolder(folder)
    check awaitUi(proc (): bool = w.currentFolder == folder)
    check w.currentFolderUri == folderUri
    check w.setFilename(first)
    check awaitUi(proc (): bool = w.filename == first)
    check w.uri == firstUri
    let copy = w.selection
    check copy.filenames == @[first] and copy.uris == @[firstUri]
    w.unselectAll()
    check w.filenames.len == 0
    check copy.filenames == @[first] # Native list and strings were copied/freed.
    check w.setUri(firstUri)
    check awaitUi(proc (): bool = w.uri == firstUri)
    w.unselectUri(firstUri)
    check w.uris.len == 0
    check w.setCurrentFolderUri(folderUri)
    check awaitUi(proc (): bool = w.currentFolder == folder)

  when defined(posix) and not defined(macosx):
    test "Unix filename bytes are not incorrectly restricted to UTF-8":
      let nativeFolder = sandbox / "native-names"
      createDir(nativeFolder)
      let nativeName = nativeFolder / "bytes-\xff.txt"
      writeFile(nativeName, "native bytes")
      let w = newFileChooserWidget()
      defer: w.destroy()
      check w.setFilename(nativeName)
      check awaitUi(proc (): bool = w.filename == nativeName)
      check w.filenames == @[nativeName] and w.uris.len == 1
      check w.uri == fileUri(nativeName)

  test "multiple selections and Save/CreateFolder names without mapping a window":
    let w = newFileChooserWidget()
    defer: w.destroy()
    w.selectMultiple = true
    check w.setCurrentFolder(folder)
    check awaitUi(proc (): bool = w.currentFolder == folder)
    check w.selectFilename(first)
    check awaitUi(proc (): bool = w.filenames == @[first])
    check w.selectFilename(second)
    check awaitUi(proc (): bool = second in w.filenames)
    # Native GTK2 select_filename moves the cursor and can replace prior rows,
    # even in multiple mode. selectAll and user Ctrl/Shift selections are native.
    w.selectAll()
    check w.filenames.len == 2
    check first in w.filenames and second in w.filenames
    let copied = w.selection
    w.unselectFilename(first)
    check w.filenames == @[second] and copied.filenames.len == 2
    w.unselectAll()
    w.selectAll()
    check w.filenames.len == 2
    w.unselectAll()
    w.selectMultiple = false
    expect ValueError: w.selectAll()
    # GTK2's completion model omits GIO is-hidden/is-backup attributes. An empty
    # folder avoids that native dependency bug, without suppressing warnings.
    # See docs/gtk2.md and tests/headers/filechooser_completion.c for its C repro.
    let saveFolder = sandbox / "save"
    createDir(saveFolder)
    let save = newFileChooserWidget(fileSave)
    defer: save.destroy()
    check save.setCurrentFolder(saveFolder)
    check awaitUi(proc (): bool = save.currentFolder == saveFolder)
    save.setCurrentName("output.txt")
    check awaitUi(proc (): bool = save.filename == saveFolder / "output.txt")
    expect ValueError: save.setCurrentName("../escape")
    expect ValueError: save.setCurrentName("\xff")
    save.action = fileCreateFolder
    save.setCurrentName("new-folder")
    check awaitUi(proc (): bool = save.filename == saveFolder / "new-folder")
    check not dirExists(saveFolder / "new-folder") # Selection APIs never create it.

  test "FileFilter rules and owning getters, checked membership, shared native refs":
    let w = newFileChooserWidget()
    let button = newFileChooserButton()
    defer:
      w.destroy()
      button.destroy()
    check w.filter.isEmpty
    let text = newFileFilter("Text", ["*.txt", "*.nim"])
    let all = newFileFilter("All", ["*"])
    var info = rawGtk.TFileFilterInfo(contains: rawGtk.FILE_FILTER_DISPLAY_NAME,
      display_name: "source.nim")
    check g.toBool(rawGtk.filter(text.raw, addr info))
    info.display_name = "image.png"
    check not g.toBool(rawGtk.filter(text.raw, addr info))
    text.addMimeType("text/plain")
    all.addPixbufFormats()
    expect ValueError: text.addPattern("")
    expect ValueError: text.addMimeType("bad\0mime")
    expect ValueError: discard newFileFilter(patterns = ["*.txt", "\xff"])
    text.name = "Sources café"
    check text.name == "Sources café"
    w.addFilter(text)
    w.addFilter(all)
    button.addFilter(text)
    check w.filters.len == 2 and button.filters.len == 1
    check w.filter.raw == text.raw
    expect ValueError: w.addFilter(text)
    let unknown = newFileFilter("Unknown")
    expect ValueError: w.removeFilter(unknown)
    expect ValueError: w.filter = unknown
    expect ValueError: w.addFilter(gtk2.FileFilter())
    w.filter = all
    let retained = w.filter
    let aliases = w.filters
    w.removeFilter(all)
    check retained.name == "All" and aliases[1].raw == all.raw
    w.destroy()
    check text.name == "Sources café" and retained.name == "All"
    check button.filter.raw == text.raw

  test "button programmatic changes differ from explicit user file-set events":
    let w = newFileChooserButton()
    defer: w.destroy()
    var changed, accepted = 0
    w.onSelectionChanged(proc (value: FileSelection) = inc changed)
    w.onFileSet(proc (value: FileSelection) =
      check value.filenames == @[first]
      inc accepted)
    check w.setFilename(first)
    check awaitUi(proc (): bool = changed > 0)
    check w.filename == first and accepted == 0
    g.g_signal_emit_by_name(w.raw, "file-set")
    check accepted == 0
    drainUi()
    check accepted == 1

  test "coalesced final selections, reentrancy, cancellation, and contained exceptions":
    let w = newFileChooserWidget()
    defer: w.destroy()
    check w.setCurrentFolder(folder)
    check awaitUi(proc (): bool = w.currentFolder == folder)
    var seen: seq[FileSelection]
    var connection: Connection
    connection = w.onSelectionChanged(proc (value: FileSelection) =
      seen.add(value)
      if value.filenames == @[first]: w.unselectAll()
      else:
        connection.disconnect()
        raise newException(ValueError, "expected file selection callback error"))
    check w.setFilename(first)
    check awaitUi(proc (): bool = seen.len == 2)
    check seen[0].filenames == @[first] and seen[1].filenames.len == 0
    check not connection.connected
    var activations = 0
    let activation = w.onFileActivated(proc (value: FileSelection) = inc activations)
    g.g_signal_emit_by_name(w.raw, "file-activated")
    activation.disconnect()
    drainUi()
    check activations == 0
    w.onFileActivated(proc (value: FileSelection) = w.destroy())
    g.g_signal_emit_by_name(w.raw, "file-activated")
    drainUi()
    check w.isDestroyed

  test "dialog response snapshots defer even through a Dialog upcast; parent destruction":
    let parent = newWindow()
    defer: parent.destroy()
    let w = newFileChooserDialog(parent, "Open", fileOpen)
    defer: w.destroy()
    check w.destroyWithParent
    expect ValueError: parent.transientFor = w
    check w.setCurrentFolder(folder)
    check awaitUi(proc (): bool = w.currentFolder == folder)
    check w.setFilename(first)
    check awaitUi(proc (): bool = w.filename == first)
    var snapshots: seq[FileSelection]
    var responses: seq[ResponseId]
    w.onResponse(proc (id: ResponseId, value: FileSelection) =
      responses.add(id)
      snapshots.add(value))
    var generic = 0
    gtk2.Dialog(w).onResponse(proc (id: ResponseId) = inc generic)
    w.respond(customResponse(42)) # No accept validation/recent-history writes.
    check responses.len == 0 and generic == 0
    w.unselectAll()
    drainUi()
    check responses == @[customResponse(42)] and generic == 1
    check snapshots[0].filenames == @[first]
    check w.filenames.len == 0 and not w.isDestroyed
    w.onResponse(proc (id: ResponseId) = w.destroy())
    w.respond(responseCancel)
    drainUi()
    check w.isDestroyed
    let child = newFileChooserDialog(parent)
    parent.destroy()
    check child.isDestroyed
    expect ValueError: discard newFileChooserDialog(gtk2.Window())

  test "idle work, native finalization, captures, and temporary handles":
    var released, calls, gone, filterGone = 0
    block:
      let w = newFileChooserWidget()
      g.weak_ref(cast[g.PGObject](w.raw), finalized, addr gone)
      let filter = newFileFilter("Temporary", ["*"])
      g.weak_ref(cast[g.PGObject](filter.raw), finalized, addr filterGone)
      w.addFilter(filter)
      let connection = track(w, addr released, addr calls)
      g.g_signal_emit_by_name(w.raw, "selection-changed")
      connection.disconnect()
      check released == 1
      let second = track(w, addr released, addr calls)
      g.g_signal_emit_by_name(w.raw, "selection-changed")
      w.destroy()
      check not second.connected and released == 2
      drainUi()
      check calls == 0
    check awaitUi(proc (): bool = gone == 1 and filterGone == 1)
    let native = temporaryChooser(addr released, addr calls)
    rawGtk.destroy(cast[rawGtk.PWidget](native))
    g.g_object_unref(native)
    drainUi()
    check released == 3 and calls == 0
    let fresh = newFileChooserWidget()
    defer: fresh.destroy()
    expect ValueError: discard fresh.onSelectionChanged(nil)
    expect ValueError: discard fresh.onFileActivated(nil)
    let dialog = newFileChooserDialog()
    defer: dialog.destroy()
    let nilResponse: proc (id: ResponseId, value: FileSelection) {.closure.} = nil
    expect ValueError: discard dialog.onResponse(nilResponse)
# Canceled native GIO requests can complete after a chooser has been destroyed.
discard awaitUi(proc (): bool = true)
removeDir(sandbox)
