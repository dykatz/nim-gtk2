## Shared TextBuffer, editable/read-only views and nonblocking status updates.
## Build: nim c --path:src examples/text.nim
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 text editor", 760, 460)
  defer: window.destroy()
  window.borderWidth = 10
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let actions = newHBox(spacing = 6)
  let append = newButton("Append Unicode")
  let clearSelection = newButton("Delete selection")
  let markSaved = newButton("Mark saved")
  let copy = newButton("Copy")
  let cut = newButton("Cut")
  let paste = newButton("Paste")
  actions.packStart(append, packShrink)
  actions.packStart(clearSelection, packShrink)
  actions.packStart(markSaved, packShrink)
  for button in [copy, cut, paste]: actions.packStart(button, packShrink)
  layout.packStart(actions, packShrink)
  layout.packStart(newLabel("Edit on the left; the right view shares the same buffer."), packShrink)

  let buffer = newTextBuffer("Hello, Nim!\nUnicode: λ, 界, 🙂\nSelect some text or start typing.\n")
  let emphasis = buffer.createTag("emphasis")
  emphasis.bold = true
  emphasis.underline = true
  emphasis.setForeground(rgba16(5000, 12000, 50000))
  let bookmark = buffer.createMark(0, "bookmark", leftGravity = true)
  let tools = newHBox(spacing = 6)
  let query = newEntry("λ")
  let find = newButton("Find next")
  let style = newButton("Emphasize selection")
  let saveMark = newButton("Bookmark")
  let goMark = newButton("Go to mark")
  let insertImage = newButton("Insert image")
  tools.packStart(query)
  for button in [find, style, saveMark, goMark, insertImage]:
    tools.packStart(button, packShrink)
  layout.packStart(tools, packShrink)
  let anchorTools = newHBox(spacing = 6)
  let insertAnchor = newButton("Insert inline widget")
  let removeAnchor = newButton("Remove inline widget")
  anchorTools.packStart(insertAnchor, packShrink)
  anchorTools.packStart(removeAnchor, packShrink)
  anchorTools.packStart(newLabel("One buffer anchor, different widgets in each view"), packShrink)
  layout.packStart(anchorTools, packShrink)
  var inline: TextChildAnchor
  let editor = newTextView(buffer)
  let mirror = newTextView(buffer)
  editor.wrapMode = wrapWordChar
  mirror.wrapMode = wrapWordChar
  editor.acceptsTab = false
  mirror.editable = false
  mirror.cursorVisible = false
  editor.leftMargin = 8
  mirror.leftMargin = 8
  let left = newScrolledWindow()
  let right = newScrolledWindow()
  left.add(editor)
  right.add(mirror)
  let panes = newHPaned()
  panes.packFirst(left, resize = true, shrink = false)
  panes.packSecond(right, resize = true, shrink = false)
  layout.packStart(panes)
  let status = newLabel()
  layout.packStart(status, packShrink)

  proc refresh() =
    status.text = $buffer.characterCount & " characters; " & $buffer.lineCount &
      " lines; cursor " & $buffer.cursorOffset &
      (if buffer.modified: " — modified" else: " — saved")

  buffer.onChanged(proc () = refresh())
  buffer.onModifiedChanged(proc () = refresh())
  buffer.onCursorMoved(proc () = refresh())
  # GObject buffers have no destroy signal. Break buffer -> closure -> widget
  # cycles when closing the window, while retaining normal native ownership.
  window.onDestroy(proc () =
    buffer.disconnectSignals()
    if not inline.isDestroyed: inline.disconnectSignals())
  defer:
    buffer.disconnectSignals()
    if not inline.isDestroyed: inline.disconnectSignals()
  append.onClicked do ():
    buffer.withUserAction:
      buffer.appendText("More text: λ🙂\n")
    buffer.cursorOffset = buffer.characterCount
    editor.scrollToCursor()
  style.onClicked(proc () =
    let selection = buffer.selectionBounds
    if selection.hasSelection:
      buffer.applyTag(emphasis, selection.first, selection.last))
  find.onClicked(proc () =
    if query.text.len == 0: return
    var match = buffer.findText(query.text, first = buffer.cursorOffset, visibleOnly = true)
    if not match.found: match = buffer.findText(query.text, visibleOnly = true)
    if match.found:
      buffer.selectRange(match.first, match.last)
      editor.scrollToCursor()
    else: status.text = "Not found: " & query.text)
  saveMark.onClicked(proc () = buffer.moveMark(bookmark, buffer.cursorOffset))
  goMark.onClicked(proc () =
    buffer.cursorOffset = bookmark.offset
    editor.scrollToMark(bookmark))
  let sampleImage = newPixbuf(16, 16, 0x2090ffff'u32)
  insertImage.onClicked(proc () = buffer.insertImage(buffer.cursorOffset, sampleImage))
  insertAnchor.onClicked(proc () =
    if not inline.deleted:
      status.text = "An inline anchor is already present"
      return
    inline = buffer.createChildAnchor(buffer.cursorOffset)
    if inline.deleted: return
    let button = newButton("Inline λ🙂")
    let label = newLabel("[Shared inline object]")
    editor.addChildAtAnchor(button, inline)
    mirror.addChildAtAnchor(label, inline)
    button.onClicked(proc () = status.text = "Inline button activated")
    inline.onDeleted(proc () = status.text = "Anchor deleted; both inline widgets were destroyed")
    button.showAll()
    label.showAll())
  removeAnchor.onClicked(proc () =
    if not inline.deleted: buffer.deleteAnchor(inline))
  editor.onKeyPress(proc (event: KeyEvent): bool =
    if event.modifiers.has(modifierControl) and event.unicode in [uint32(ord('f')), uint32(ord('F'))]:
      query.focus()
      query.selectAll()
      return true
    false)
  clearSelection.onClicked(proc () = discard buffer.deleteSelection())
  let clipboard = getClipboard() # Merely obtaining it does not overwrite its contents.
  copy.onClicked(proc () =
    if not editor.copySelection(clipboard): status.text = "No text selected")
  cut.onClicked(proc () = discard editor.cutSelection(clipboard))
  paste.onClicked(proc () =
    # Cancellable, plain-text request. Automatically canceled if editor closes;
    # ignores the result if its buffer was replaced while waiting for the owner.
    editor.focus()
    discard editor.pasteClipboard(clipboard))
  markSaved.onClicked(proc () = buffer.modified = false)
  refresh()
  window.run()

when isMainModule:
  main()
