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

  var buffer = newTextBuffer("Hello, Nim!\nUnicode: λ, 界, 🙂\nSelect some text or start typing.\n")
  var emphasis = buffer.createTag("emphasis")
  emphasis.bold = true
  emphasis.underline = true
  emphasis.setForeground(rgba16(5000, 12000, 50000))
  let underlineEmphasis = newCheckButton("Underline override (manual)")
  underlineEmphasis.active = emphasis.underline
  underlineEmphasis.onToggled(proc () = emphasis.underline = underlineEmphasis.active)
  let tagPolicy = newHBox(spacing = 6)
  let inheritUnderline = newButton("Unset underline override")
  tagPolicy.packStart(underlineEmphasis, packShrink)
  tagPolicy.packStart(inheritUnderline, packShrink)
  let toggleHighlight = newButton("Toggle highlight tag")
  var highlight: TextTag
  tagPolicy.packStart(toggleHighlight, packShrink)
  layout.packStart(tagPolicy, packShrink)
  toggleHighlight.onClicked(proc () =
    if highlight.isDestroyed:
      highlight = buffer.createTag() # Anonymous; no imported-name collisions.
      highlight.setBackground(rgba16(65535, 60000, 35000))
      buffer.applyTag(highlight, 0, buffer.characterCount)
    else:
      buffer.deleteTag(highlight) # Table-wide removal, visible in both views.
      highlight = default(TextTag) # Explicit app state, not a membership query.
    # GTK manages buffer registration. Do not walk/mutate private table lists.
  )
  inheritUnderline.onClicked(proc () = emphasis.clearUnderline())
  # Checkbox assigns a value; this button removes its override, not the tag ranges.
  var bookmark = buffer.createMark(0, "bookmark", leftGravity = true)
  let showBookmark = newCheckButton("Show bookmark cursor (not document text)")
  showBookmark.onToggled(proc () = bookmark.visible = showBookmark.active)
  layout.packStart(showBookmark, packShrink)
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
  let files = newHBox(spacing = 6)
  let filePath = newEntry("text.gtk2rt")
  let saveRich = newButton("Save native rich text")
  let loadRich = newButton("Load trusted file")
  files.packStart(filePath)
  files.packStart(saveRich, packShrink)
  files.packStart(loadRich, packShrink)
  layout.packStart(files, packShrink)
  let richTools = newHBox(spacing = 6)
  let richCopy = newButton("Copy document (includes hidden text)")
  let richImport = newButton("Import clipboard as document")
  let trustRich = newCheckButton("Trust native rich owner")
  richTools.packStart(richCopy, packShrink)
  richTools.packStart(richImport, packShrink)
  richTools.packStart(trustRich, packShrink)
  layout.packStart(richTools, packShrink)
  let clipboard = getClipboard() # Does not overwrite its contents.
  var richRequest: RichTextRequest
  # Native GTK2 binary data, not RTF/HTML. The application
  # explicitly selects this named codec and permits imported tags in a fresh buffer.
  let richFormat = newTextFormat("nim-gtk2-text-example", canCreateTags = true)
  let editor = newTextView(buffer)
  let mirror = newTextView(buffer)
  editor.wrapMode = wrapWordChar
  mirror.wrapMode = wrapWordChar
  editor.acceptsTab = false
  mirror.editable = false
  mirror.cursorVisible = false
  let policies = newHBox(spacing = 6)
  let readOnly = newCheckButton("Read-only editor")
  let caret = newCheckButton("Show editor caret")
  caret.active = editor.cursorVisible
  let overwrite = newCheckButton("Overwrite typed text")
  let tabs = newCheckButton("Tab inserts a character")
  for control in [readOnly, caret, overwrite, tabs]: policies.packStart(control, packShrink)
  layout.packStart(policies, packShrink)
  # Real public view policy; never edit private flags or replace the shared buffer.
  readOnly.onToggled(proc () = editor.editable = not readOnly.active)
  caret.onToggled(proc () = editor.cursorVisible = caret.active)
  overwrite.onToggled(proc () = editor.overwriteMode = overwrite.active)
  tabs.onToggled(proc () = editor.acceptsTab = tabs.active)
  # Insert can toggle overwrite independently; this is a manual setting, not a binding.
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

  proc watchBuffer() =
    buffer.onChanged(proc () = refresh())
    buffer.onModifiedChanged(proc () = refresh())
    buffer.onCursorMoved(proc () = refresh())
  watchBuffer()
  proc replaceDocument(loaded: TextBuffer) =
    var imported: TextTag
    try: imported = loaded.tag("emphasis")
    except ValueError:
      imported = loaded.createTag("emphasis")
      imported.bold = true
      imported.underline = true
    let mark = loaded.createMark(0, "bookmark", leftGravity = true)
    richRequest.cancel()
    buffer.disconnectSignals()
    if not inline.isDestroyed: inline.disconnectSignals()
    inline = default(TextChildAnchor)
    highlight = default(TextTag) # Release old document's table handle on real import.
    editor.buffer = loaded
    mirror.buffer = loaded
    buffer = loaded
    emphasis = imported
    underlineEmphasis.active = emphasis.underline
    bookmark = mark
    bookmark.visible = showBookmark.active
    watchBuffer()
    buffer.modified = false
    refresh()
  richCopy.onClicked(proc () =
    try:
      # Explicit whole document snapshot: tags/images/hidden text, never widgets.
      discard clipboard.offerRichText(buffer.serialize(richFormat), buffer.text)
      status.text = "Offered a document snapshot, not a live buffer"
    except CatchableError as error: status.text = error.msg)
  trustRich.onToggled(proc () = richRequest.cancel())
  richImport.onClicked(proc () =
    richRequest.cancel()
    richRequest = clipboard.requestRichText(editor, richFormat, trustRich.active,
      proc (value: RichClipboardResult) =
        case value.kind
        of richDocument:
          replaceDocument(value.document)
          status.text = "Imported trusted rich clipboard as a new document"
        of richPlainText:
          replaceDocument(newTextBuffer(value.text))
          status.text = "Imported plain text as a new document"
        of richRejected: status.text = "Rich clipboard rejected: " & value.error
        of richUnavailable: status.text = "Clipboard has no compatible document/text"))
  saveRich.onClicked(proc () =
    try:
      let snapshot = buffer.serialize(richFormat)
      writeFile(filePath.text, snapshot.data) # Binary string, including NUL bytes.
      buffer.modified = false
      status.text = "Saved " & $snapshot.byteCount & " bytes to " & filePath.text
    except CatchableError as error: status.text = error.msg)
  loadRich.onClicked(proc () =
    try:
      # Decode detached before touching either live view. Failure leaves the editor
      # unchanged; no live changed observers can invalidate native import iterators.
      let loaded = richFormat.deserialize(newSerializedText(richFormat, readFile(filePath.text)))
      replaceDocument(loaded)
      status.text = "Loaded " & filePath.text & "; marks/history/inline widgets are not serialized"
    except CatchableError as error: status.text = error.msg)
  # GObject buffers have no destroy signal. Break buffer -> closure -> widget
  # cycles when closing the window, while retaining normal native ownership.
  window.onDestroy(proc () =
    richRequest.cancel()
    buffer.disconnectSignals()
    if not inline.isDestroyed: inline.disconnectSignals())
  defer:
    richRequest.cancel()
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
