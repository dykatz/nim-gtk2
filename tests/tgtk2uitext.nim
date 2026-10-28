# Hidden widgets only; no GTK main loop or visible windows.
import std/unittest
import gtk2ui
import gtk2 as rawGtk
import glib2 as g

static:
  doAssert typeof(newTextBuffer().raw) is rawGtk.PTextBuffer
  doAssert typeof(newTextView().raw) is rawGtk.PTextView
  doAssert not compiles(newTextBuffer().destroy())
  doAssert not compiles(newTextView().add(newLabel()))

proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
  cast[ptr bool](data)[] = true

proc runTests() =
  gtk2ui.init()
  suite "gtk2ui text buffers and views":
    test "Unicode character offsets, ordered ranges and copied text":
      let buffer = newTextBuffer("Aλ🙂e\u0301\nZ")
      check buffer.characterCount == 7
      check buffer.lineCount == 2
      check not buffer.modified
      check buffer.textRange(1, 3) == "λ🙂"
      let saved = buffer.text
      buffer.insertText(1, "界")
      check buffer.text == "A界λ🙂e\u0301\nZ"
      check saved == "Aλ🙂e\u0301\nZ"
      buffer.deleteRange(1, 2)
      buffer.appendText("!")
      buffer.cursorOffset = 1
      buffer.insertAtCursor("β")
      check buffer.text == "Aβλ🙂e\u0301\nZ!"
      check buffer.cursorOffset == 2
      check buffer.modified
      buffer.text = ""
      check buffer.characterCount == 0
      check buffer.lineCount == 1

    test "selection direction, cursor collapse and deletion":
      let buffer = newTextBuffer("aλ🙂z")
      buffer.selectRange(3, 1)
      check buffer.hasSelection
      check buffer.selectionBounds == (true, 1, 3)
      check buffer.cursorOffset == 1
      check buffer.selectedText == "λ🙂"
      check buffer.deleteSelection()
      check buffer.text == "az"
      check not buffer.hasSelection
      check not buffer.deleteSelection()
      buffer.cursorOffset = 2
      check buffer.selectionBounds == (false, 2, 2)
      check buffer.selectedText == ""

    test "views share buffers, getters own references and replacement preserves old handles":
      let buffer = newTextBuffer("Shared")
      let first = newTextView(buffer)
      let second = newTextView(buffer)
      defer: first.destroy()
      defer: second.destroy()
      let alias = first.buffer
      var calls = 0
      let connection = buffer.onChanged(proc () = inc calls)
      alias.appendText(" text")
      check first.text == "Shared text"
      check second.text == "Shared text"
      check calls == 1
      alias.disconnectSignals()
      check not connection.connected
      first.buffer = newTextBuffer("New")
      first.text = "Replacement"
      check first.text == "Replacement"
      check second.text == "Shared text"
      first.destroy()
      second.destroy()
      check buffer.text == "Shared text"
      buffer.appendText(" remains alive")
      check alias.text == "Shared text remains alive"
      var finalized = false
      block:
        let view = newTextView("Retained")
        let owning = view.buffer
        g.weak_ref(cast[g.PGObject](owning.raw), finalizedCallback, addr finalized)
        view.destroy()
        check owning.text == "Retained"
        check not finalized
      check finalized

    test "view properties and native ScrolledWindow protocol":
      let view = newTextView("Line one\nLine two")
      let scroll = newScrolledWindow()
      defer: scroll.destroy()
      scroll.add(view)
      check rawGtk.get_child(cast[rawGtk.PBin](scroll.raw)) == cast[rawGtk.PWidget](view.raw)
      view.editable = false
      view.cursorVisible = false
      view.acceptsTab = false
      check not view.editable
      check not view.cursorVisible
      check not view.acceptsTab
      for mode in [wrapNone, wrapChar, wrapWord, wrapWordChar]:
        view.wrapMode = mode
        check view.wrapMode == mode
      view.leftMargin = 8
      view.rightMargin = 9
      view.pixelsAboveLines = 2
      view.pixelsBelowLines = 3
      view.pixelsInsideWrap = 4
      check view.leftMargin == 8
      check view.rightMargin == 9
      check view.pixelsAboveLines == 2
      check view.pixelsBelowLines == 3
      check view.pixelsInsideWrap == 4
      view.buffer.cursorOffset = 4
      view.scrollToCursor()
      view.scrollToCursor(0.2, true, 0.5, 1.0)
      # Read-only is a view policy, not a ban on programmatic buffer updates.
      view.text = "Updated"
      check view.text == "Updated"

    test "signals observe edits, modified state and cursor moves safely":
      let buffer = newTextBuffer("Start")
      var changes, dirtyChanges, cursorChanges = 0
      let changed = buffer.onChanged(proc () =
        inc changes
        check buffer.modified)
      buffer.onModifiedChanged(proc () = inc dirtyChanges)
      buffer.onCursorMoved(proc () = inc cursorChanges)
      buffer.appendText("!")
      check changes == 1
      check dirtyChanges == 1
      buffer.modified = false
      check dirtyChanges == 2
      buffer.cursorOffset = 1
      check cursorChanges > 0
      changed.disconnect()
      buffer.appendText("Again")
      check changes == 1
      buffer.disconnectSignals()
      var once: Connection
      var calls = 0
      once = buffer.onChanged(proc () =
        once.disconnect()
        inc calls)
      buffer.appendText("1")
      buffer.appendText("2")
      check calls == 1
      let throws = buffer.onChanged(proc () =
        raise newException(ValueError, "expected text buffer error"))
      buffer.onChanged(proc () = inc calls)
      buffer.appendText("3")
      check calls == 2
      throws.disconnect()
      buffer.disconnectSignals()
      var cursorOnce: Connection
      var cursorCalls = 0
      cursorOnce = buffer.onCursorMoved(proc () =
        cursorOnce.disconnect()
        inc cursorCalls)
      buffer.cursorOffset = 0
      buffer.cursorOffset = 2
      check cursorCalls == 1
      buffer.onCursorMoved(proc () =
        raise newException(ValueError, "expected text cursor error"))
      buffer.onCursorMoved(proc () = inc cursorCalls)
      buffer.cursorOffset = 0
      check cursorCalls == 2
      buffer.disconnectSignals()

    test "user actions balance notifications even when the body raises":
      let buffer = newTextBuffer()
      var begins, ends: int
      # Observe the zero-argument native action signals through raw callbacks.
      proc countSignal(instance, data: pointer) {.cdecl.} = inc cast[ptr int](data)[]
      let beginId = g.g_signal_connect_data(buffer.raw, "begin-user-action",
        cast[g.TGCallback](countSignal), addr begins, nil, g.TGConnectFlags(0))
      let endId = g.g_signal_connect_data(buffer.raw, "end-user-action",
        cast[g.TGCallback](countSignal), addr ends, nil, g.TGConnectFlags(0))
      expect ValueError:
        buffer.withUserAction:
          buffer.appendText("First")
          buffer.appendText(" second")
          raise newException(ValueError, "body error")
      check buffer.text == "First second"
      check begins == 1
      check ends == 1
      g.g_signal_handler_disconnect(buffer.raw, beginId)
      g.g_signal_handler_disconnect(buffer.raw, endId)

    test "invalid Unicode, offsets, spacing and unsupported destruction fail before GTK":
      let buffer = newTextBuffer("Kept")
      let view = newTextView(buffer)
      defer: view.destroy()
      for invalid in ["a\0b", "\xFF", "\xC0\x80", "\xED\xA0\x80", "\xF4\x90\x80\x80"]:
        expect ValueError: discard newTextBuffer(invalid)
        expect ValueError: buffer.text = invalid
        expect ValueError: buffer.insertText(0, invalid)
      check buffer.text == "Kept"
      expect ValueError: discard buffer.textRange(-1, 1)
      expect ValueError: discard buffer.textRange(3, 2)
      expect ValueError: buffer.insertText(5, "!")
      expect ValueError: buffer.deleteRange(0, 5)
      expect ValueError: buffer.selectRange(0, 5)
      expect ValueError: buffer.cursorOffset = -1
      expect ValueError: view.leftMargin = -1
      expect ValueError: view.pixelsInsideWrap = -1
      expect ValueError: view.scrollToCursor(0.5)
      expect ValueError: view.scrollToCursor(NaN)
      expect ValueError: view.scrollToCursor(xalign = 2.0)
      expect ValueError: discard buffer.onDestroy(proc () = discard)
      expect ValueError: discard buffer.onChanged(nil)
      expect ValueError: discard buffer.onCursorMoved(nil)
      expect ValueError: discard newTextView(gtk2ui.TextBuffer())
      expect ValueError: view.buffer = gtk2ui.TextBuffer()
      check view.text == "Kept"

    test "plain GObject ownership and state-scoped callbacks do not leak":
      var finalized = false
      proc makePlain(flag: pointer) =
        let buffer = newTextBuffer("Owned once")
        g.weak_ref(cast[g.PGObject](buffer.raw), finalizedCallback, flag)
        buffer.onChanged(proc () = discard)
      makePlain(addr finalized)
      check finalized # No extra ref-sink on transfer-full non-floating GObjects.
      let view = newTextView()
      defer: view.destroy()
      var calls = 0
      proc temporaryRegistration(view: TextView, count: ptr int) =
        let handle = view.buffer
        handle.onChanged(proc () = inc count[])
      temporaryRegistration(view, addr calls)
      view.text = "No stale callback after the last handle/connection disappears"
      check calls == 0
      # The weak state cache can be safely rebuilt for the still-live buffer.
      let rebuilt = view.buffer
      check rebuilt.text == view.text

    test "explicit disconnection releases self-captures and captured widget trees":
      var finalized = false
      proc makeCycle(flag: pointer): rawGtk.PTextBuffer =
        let buffer = newTextBuffer()
        result = buffer.raw
        g.weak_ref(cast[g.PGObject](result), finalizedCallback, flag)
        buffer.onChanged(proc () = discard buffer.text)
      let native = makeCycle(addr finalized)
      require not finalized
      block:
        # Borrowed through a view, this getter must recover the same state.
        let view = newTextView()
        rawGtk.set_buffer(view.raw, native)
        let alias = view.buffer
        alias.disconnectSignals()
        view.destroy()
      check finalized
      var windowFinalized, bufferFinalized = false
      proc makeTree(windowFlag, bufferFlag: pointer): rawGtk.PWindow =
        let buffer = newTextBuffer("Tree")
        let window = newWindow()
        window.add(newTextView(buffer))
        result = window.raw
        g.weak_ref(cast[g.PGObject](result), finalizedCallback, windowFlag)
        g.weak_ref(cast[g.PGObject](buffer.raw), finalizedCallback, bufferFlag)
        buffer.onChanged(proc () = window.title = buffer.text)
        window.onDestroy(proc () = buffer.disconnectSignals())
      let window = makeTree(addr windowFinalized, addr bufferFinalized)
      rawGtk.destroy(cast[rawGtk.PWidget](window))
      check windowFinalized
      check bufferFinalized

runTests()
