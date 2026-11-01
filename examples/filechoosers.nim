## Build: nim c --path:src examples/filechoosers.nim
## Save-mode completion on older GTK2 builds with modern GIO may need the native
## library patch described in docs/gtk2.md (not an SDK runtime workaround).
import std/os
import gtk2

proc installFilters(w: FileChooserButton | FileChooserWidget | FileChooserDialog,
                    filters: openArray[FileFilter]) =
  for filter in filters: w.addFilter(filter)
proc describe(value: FileSelection): string =
  if value.uris.len == 0: "No selection"
  elif value.uris.len == 1: value.uris[0]
  else: $value.uris.len & " selected; first: " & value.uris[0]

proc main() =
  gtk2.init()
  let window = newWindow("GTK2 file choosers", 900, 650)
  defer: window.destroy()
  let layout = newVBox(spacing = 8)
  layout.borderWidth = 12
  window.add(layout)
  let status = newLabel("Choose files; selection notifications are not acceptance.")
  layout.packStart(status, packShrink)
  let filters = @[
    newFileFilter("Text and Nim sources", ["*.txt", "*.nim"]),
    newFileFilter("All files", ["*"])]
  let rows = newHBox(spacing = 8)
  layout.packStart(rows, packShrink)
  let file = newFileChooserButton("Select a file")
  file.widthChars = 24
  let folder = newFileChooserButton("Select a folder", fileSelectFolder)
  folder.widthChars = 24
  installFilters(file, filters)
  rows.packStart(file)
  rows.packStart(folder)
  file.onFileSet(proc (value: FileSelection) = status.text = "Button accepted: " & describe(value))
  folder.onFileSet(proc (value: FileSelection) = status.text = "Folder accepted: " & describe(value))

  let panel = newFileChooserWidget()
  panel.selectMultiple = true
  installFilters(panel, filters)
  discard panel.setCurrentFolder(getCurrentDir()) # Native asynchronous request.
  layout.packStart(panel)
  panel.onSelectionChanged(proc (value: FileSelection) = status.text = "Panel: " & describe(value))
  panel.onFileActivated(proc (value: FileSelection) = status.text = "Activated: " & describe(value))

  let actions = newHBox(spacing = 8)
  layout.packEnd(actions, packShrink)
  let open = newButton("Open dialog…")
  let save = newButton("Save As dialog…")
  let clear = newButton("Clear panel selection")
  actions.packStart(open, packShrink)
  actions.packStart(save, packShrink)
  actions.packEnd(clear, packShrink)
  clear.onClicked(proc () = panel.unselectAll())
  open.onClicked(proc () =
    let dialog = newFileChooserDialog(window, "Open files")
    dialog.selectMultiple = true
    installFilters(dialog, filters)
    discard dialog.setCurrentFolder(getCurrentDir())
    dialog.onResponse(proc (id: ResponseId, value: FileSelection) =
      if id == responseAccept: status.text = "Open accepted: " & describe(value)
      dialog.destroy())
    dialog.present())
  save.onClicked(proc () =
    let dialog = newFileChooserDialog(window, "Save As", fileSave)
    installFilters(dialog, filters)
    dialog.overwriteConfirmation = true # Native GTK may run its own confirmation.
    discard dialog.setCurrentFolder(getCurrentDir())
    dialog.setCurrentName("untitled.txt")
    dialog.onResponse(proc (id: ResponseId, value: FileSelection) =
      if id == responseAccept:
        # This example selects a target; it never writes or replaces any file.
        status.text = "Save target (not written): " & describe(value)
      dialog.destroy())
    dialog.present())
  window.run()

when isMainModule:
  main()
