# Included by gtk2.nim. No blocking wait_for_* or nested GTK main loops.
type
  Clipboard* = object of ObjectHandle
  ClipboardKind* = enum clipboardStandard, clipboardPrimary
  ClipboardText* = object
    available*: bool
    text*: string
  TextRequestState = ref object
    active, nativePending: bool
    idle: g.guint
    target: int
    clipboard: Clipboard
    owner: Connection
    fn: proc (value: ClipboardText) {.closure.}
    value: ClipboardText
  TextRequest* = object
    state: TextRequestState

proc raw*(c: Clipboard): rawGtk.PClipboard = cast[rawGtk.PClipboard](nativePointer(c))
proc getClipboard*(kind = clipboardStandard): Clipboard =
  let name = if kind == clipboardStandard: "CLIPBOARD" else: "PRIMARY"
  let atom = rawGdk.atom_intern(name.cstring, g.gbool(false))
  result.state = adoptObject(rawGtk.clipboard_get(atom), borrowed = true, cache = true,
    hasDestroySignal = false, sink = false)
proc setText*(c: Clipboard, text: string) =
  let value = checkedUtf8Text(text)
  rawGtk.set_text(c.raw, value, g.gint(text.len))
proc clear*(c: Clipboard) = rawGtk.clear(c.raw)
proc pending*(r: TextRequest): bool = r.state != nil and r.state.active
proc detachRequestOwner(s: TextRequestState) =
  s.owner.disconnect()
  s.owner = Connection()
proc cancel*(r: TextRequest) =
  let s = r.state
  if s == nil or not s.active: return
  s.active = false
  s.fn = nil
  s.value = ClipboardText()
  detachRequestOwner(s)
  let idle = s.idle
  s.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  # GTK has no cancellation API for request_contents' borrowed callback data. Keep
  # its small bridge/native clipboard reference until that callback really ends.
  if not s.nativePending: s.clipboard = Clipboard()
proc releaseTextRequest(data: pointer) {.cdecl.} = GC_unref(cast[TextRequestState](data))
proc dispatchTextRequest(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[TextRequestState](data)
    s.idle = 0
    if s.active:
      let fn = s.fn
      let value = s.value
      s.active = false
      s.fn = nil
      s.value = ClipboardText()
      detachRequestOwner(s)
      s.clipboard = Clipboard()
      try: fn(value)
      except Exception as error: reportSignalError(error)
    g.gbool(false)
proc transferAtom(name: cstring): rawGdk.TAtom = rawGdk.atom_intern(name, g.gbool(false))
proc clipboardTarget(index: int): rawGdk.TAtom =
  case index
  of 0: transferAtom("UTF8_STRING")
  of 1: transferAtom("COMPOUND_TEXT")
  else: transferAtom("STRING")
proc readSelectionText(selection: rawGtk.PSelectionData): ClipboardText =
  if selection == nil: return
  let size = rawGtk.selection_data_get_length(selection).int
  if size < 0 or rawGtk.selection_data_get_format(selection) != 8: return
  let kind = rawGtk.selection_data_get_data_type(selection)
  var charset: cstring
  let localeUtf8 = g.toBool(g.g_get_charset(addr charset))
  let locale = "text/plain;charset=" & $charset
  let localeType = transferAtom(locale.cstring)
  let utf8 = kind == transferAtom("UTF8_STRING") or kind == transferAtom("text/plain;charset=utf-8") or
    (localeUtf8 and kind == localeType)
  let known = utf8 or kind == transferAtom("STRING") or kind == transferAtom("COMPOUND_TEXT") or
    kind == transferAtom("text/plain") or kind == localeType
  if not known: return
  if utf8:
    let data = rawGtk.selection_data_get_data(selection)
    if size > 0 and data == nil: return
    var bytes = newString(size)
    if size > 0: copyMem(addr bytes[0], data, size)
    discard checkedUtf8Text(bytes) # Reject NUL/malformed UTF-8 before native conversion can warn.
  # GTK2's get_text/request_text can return nil for a valid empty UTF8_STRING.
  # Preserve the explicit length/type here rather than conflating it with failure.
  if size == 0: return ClipboardText(available: true)
  let text = rawGtk.get_text(selection)
  if text != nil:
    try:
      result.text = $cast[cstring](text)
      discard checkedUtf8Text(result.text)
      result.available = true
    finally: g.g_free(text)
proc clipboardContentsThunk(clipboard: rawGtk.PClipboard, selection: rawGtk.PSelectionData, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[TextRequestState](data)
    if s.active:
      try: s.value = readSelectionText(selection)
      except ValueError: s.value = ClipboardText()
      except Exception as error: reportSignalError(error)
      if not s.value.available and s.target < 2:
        inc s.target
        rawGtk.request_contents(clipboard, clipboardTarget(s.target), clipboardContentsThunk, data)
        return # The one native pin spans every fallback, including synchronous recursion.
    s.nativePending = false
    defer: GC_unref(s)
    if not s.active:
      s.clipboard = Clipboard()
      return
    GC_ref(s)
    s.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchTextRequest),
      cast[pointer](s), cast[pointer](releaseTextRequest))
proc requestClipboardText(c: Clipboard, owner: Widget,
                          fn: proc (value: ClipboardText) {.closure.}): TextRequest =
  let p = c.raw
  if fn == nil: raise newException(ValueError, "clipboard callback cannot be nil")
  if owner.state != nil: discard owner.raw
  let s = TextRequestState(active: true, nativePending: true, clipboard: c, fn: fn)
  result.state = s
  if owner.state != nil:
    let request = result
    s.owner = owner.onDestroy(proc () = request.cancel())
  GC_ref(s)
  rawGtk.request_contents(p, clipboardTarget(0), clipboardContentsThunk, cast[pointer](s))
proc requestText*(c: Clipboard, fn: proc (value: ClipboardText) {.closure.}): TextRequest =
  requestClipboardText(c, Widget(), fn)
proc requestText*(c: Clipboard, owner: Widget,
                  fn: proc (value: ClipboardText) {.closure.}): TextRequest =
  discard owner.raw # Empty owners are not an accidental request without ownership.
  requestClipboardText(c, owner, fn)

proc editable*(w: Entry): bool = g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](w.raw)))
proc `editable=`*(w: Entry, value: bool) = rawGtk.set_editable(cast[rawGtk.PEditable](w.raw), g.gbool(value))
proc textVisible*(w: Entry): bool = g.toBool(rawGtk.get_visibility(w.raw))
proc `textVisible=`*(w: Entry, value: bool) =
  let p = w.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_visibility(p, g.gbool(value))
proc copySelection*(w: Entry, clipboard = getClipboard()): bool =
  let p = cast[rawGtk.PEditable](w.raw)
  if not w.textVisible: return false # Match native password-entry copy protection.
  var a, z: g.gint
  if not g.toBool(rawGtk.get_selection_bounds(p, addr a, addr z)): return false
  let text = rawGtk.get_chars(p, a, z)
  var value: string
  try: value = $text
  finally: g.g_free(text)
  clipboard.setText(value)
  true
proc cutSelection*(w: Entry, clipboard = getClipboard()): bool =
  if not w.editable or not w.copySelection(clipboard): return false
  if w.isDestroyed: return false
  rawGtk.delete_selection(cast[rawGtk.PEditable](w.raw))
  true
proc pasteClipboard*(w: Entry, clipboard = getClipboard()): TextRequest =
  discard w.raw
  clipboard.requestText(w, proc (value: ClipboardText) =
    if value.available and w.editable: w.insertText(value.text))
proc copySelection*(w: TextView, clipboard = getClipboard()): bool =
  let b = w.buffer
  let selection = b.selectionBounds
  if not selection.hasSelection: return false
  clipboard.setText(b.textRange(selection.first, selection.last, includeHidden = false))
  true
proc cutSelection*(w: TextView, clipboard = getClipboard()): bool =
  let b = w.buffer
  if not w.copySelection(clipboard): return false
  if w.isDestroyed or w.buffer.raw != b.raw: return false
  b.deleteSelection(interactive = true, defaultEditable = w.editable)
proc pasteClipboard*(w: TextView, clipboard = getClipboard()): TextRequest =
  let b = w.buffer # Do not paste into a different document after buffer replacement.
  clipboard.requestText(w, proc (value: ClipboardText) =
    if not value.available or w.buffer.raw != b.raw: return
    let editable = w.editable
    var it = bufferIter(b, b.cursorOffset)
    if not g.toBool(rawGtk.can_insert(addr it, g.gbool(editable))): return
    b.withUserAction:
      discard b.deleteSelection(interactive = true, defaultEditable = editable)
      if not w.isDestroyed and w.buffer.raw == b.raw:
        discard rawGtk.insert_interactive_at_cursor(b.raw, checkedUtf8Text(value.text),
          g.gint(value.text.len), g.gbool(editable)))
