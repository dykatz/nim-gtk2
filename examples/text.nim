## Shared TextBuffer, editable/read-only views and nonblocking status updates.
## Build: nim c --path:src examples/text.nim
import gtk2ui

proc main() =
  gtk2ui.init()
  let window = newWindow("gtk2ui text editor", 760, 460)
  defer: window.destroy()
  window.borderWidth = 10
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let actions = newHBox(spacing = 6)
  let append = newButton("Append Unicode")
  let clearSelection = newButton("Delete selection")
  let markSaved = newButton("Mark saved")
  actions.packStart(append, packShrink)
  actions.packStart(clearSelection, packShrink)
  actions.packStart(markSaved, packShrink)
  layout.packStart(actions, packShrink)
  layout.packStart(newLabel("Edit on the left; the right view shares the same buffer."), packShrink)

  let buffer = newTextBuffer("Hello, Nim!\nUnicode: λ, 界, 🙂\nSelect some text or start typing.\n")
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
  window.onDestroy(proc () = buffer.disconnectSignals())
  defer: buffer.disconnectSignals()
  append.onClicked do ():
    buffer.withUserAction:
      buffer.appendText("More text: λ🙂\n")
    buffer.cursorOffset = buffer.characterCount
    editor.scrollToCursor()
  clearSelection.onClicked(proc () = discard buffer.deleteSelection())
  markSaved.onClicked(proc () = buffer.modified = false)
  refresh()
  window.run()

when isMainModule:
  main()
