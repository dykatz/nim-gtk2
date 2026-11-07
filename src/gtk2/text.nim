# Included by gtk2.nim. TextBuffer is a non-floating GObject, not GtkObject.
type
  TextBuffer* = object of ObjectHandle
  TextView* = object of Container
  TextWrapMode* = enum
    wrapNone, wrapChar, wrapWord, wrapWordChar
  TextSelection* = tuple[hasSelection: bool, first, last: int]

proc raw*(b: TextBuffer): rawGtk.PTextBuffer = cast[rawGtk.PTextBuffer](nativePointer(b))
proc raw*(w: TextView): rawGtk.PTextView = cast[rawGtk.PTextView](raw(Widget(w)))

template pinTextBuffer(b: TextBuffer, p: untyped) =
  let p = b.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)

proc newTextBuffer*(text = ""): TextBuffer =
  let value = checkedUtf8Text(text)
  result.state = adoptObject(rawGtk.text_buffer_new(nil), cache = true,
    hasDestroySignal = false, sink = false)
  if text.len > 0:
    rawGtk.set_text(result.raw, value, g.gint(text.len))
    rawGtk.set_modified(result.raw, g.gbool(false))
proc ownedTextBuffer(p: rawGtk.PTextBuffer): TextBuffer =
  result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false)
proc characterCount*(b: TextBuffer): int = rawGtk.get_char_count(b.raw).int
proc lineCount*(b: TextBuffer): int = rawGtk.get_line_count(b.raw).int
proc modified*(b: TextBuffer): bool = g.toBool(rawGtk.get_modified(b.raw))
proc `modified=`*(b: TextBuffer, value: bool) =
  pinTextBuffer(b, p)
  rawGtk.set_modified(p, g.gbool(value))

proc bufferIter(b: TextBuffer, offset: int): rawGtk.TTextIter =
  let position = checkedInt(offset)
  if offset > b.characterCount:
    raise newException(ValueError, "text offset exceeds the buffer's character count")
  rawGtk.get_iter_at_offset(b.raw, addr result, position)
proc bufferRange(b: TextBuffer, first, last: int): tuple[first, last: rawGtk.TTextIter] =
  if first > last: raise newException(ValueError, "text range must be ordered")
  result.first = bufferIter(b, first)
  result.last = bufferIter(b, last)
proc copyBufferText(b: TextBuffer, first, last: var rawGtk.TTextIter,
                    includeHidden: bool): string =
  let value = rawGtk.get_text(b.raw, addr first, addr last, g.gbool(includeHidden))
  try: result = $value
  finally: g.g_free(value)
proc text*(b: TextBuffer): string =
  var first, last: rawGtk.TTextIter
  rawGtk.get_bounds(b.raw, addr first, addr last)
  copyBufferText(b, first, last, true)
proc `text=`*(b: TextBuffer, text: string) =
  let value = checkedUtf8Text(text)
  pinTextBuffer(b, p)
  rawGtk.set_text(p, value, g.gint(text.len))
proc textRange*(b: TextBuffer, first, last: int, includeHidden = true): string =
  var bounds = bufferRange(b, first, last)
  copyBufferText(b, bounds.first, bounds.last, includeHidden)
proc insertText*(b: TextBuffer, offset: int, text: string) =
  let value = checkedUtf8Text(text)
  var iter = bufferIter(b, offset)
  pinTextBuffer(b, p)
  rawGtk.insert(p, addr iter, value, g.gint(text.len))
proc appendText*(b: TextBuffer, text: string) = b.insertText(b.characterCount, text)
proc insertAtCursor*(b: TextBuffer, text: string) =
  let value = checkedUtf8Text(text)
  pinTextBuffer(b, p)
  rawGtk.insert_at_cursor(p, value, g.gint(text.len))
proc deleteRange*(b: TextBuffer, first, last: int) =
  var bounds = bufferRange(b, first, last)
  pinTextBuffer(b, p)
  rawGtk.delete(p, addr bounds.first, addr bounds.last)
proc cursorOffset*(b: TextBuffer): int =
  let p = b.raw
  var iter: rawGtk.TTextIter
  rawGtk.get_iter_at_mark(p, addr iter, rawGtk.get_insert(p))
  rawGtk.get_offset(addr iter).int
proc `cursorOffset=`*(b: TextBuffer, offset: int) =
  var iter = bufferIter(b, offset)
  pinTextBuffer(b, p)
  rawGtk.place_cursor(p, addr iter)
proc selectRange*(b: TextBuffer, anchor, cursor: int) =
  var first = bufferIter(b, anchor)
  var last = bufferIter(b, cursor)
  pinTextBuffer(b, p)
  rawGtk.select_range(p, addr last, addr first)
proc hasSelection*(b: TextBuffer): bool = g.toBool(rawGtk.get_has_selection(b.raw))
proc selectionBounds*(b: TextBuffer): TextSelection =
  var first, last: rawGtk.TTextIter
  result.hasSelection = g.toBool(rawGtk.get_selection_bounds(b.raw, addr first, addr last))
  result.first = rawGtk.get_offset(addr first).int
  result.last = rawGtk.get_offset(addr last).int
proc selectedText*(b: TextBuffer): string =
  let bounds = b.selectionBounds
  if bounds.hasSelection: b.textRange(bounds.first, bounds.last) else: ""
proc deleteSelection*(b: TextBuffer, interactive = false, defaultEditable = true): bool =
  ## Native return reports a nonempty selection, not successful deletion of text.
  pinTextBuffer(b, p)
  g.toBool(rawGtk.delete_selection(p, g.gbool(interactive), g.gbool(defaultEditable)))

template withUserAction*(buffer: TextBuffer, body: untyped) =
  ## Groups native user-action notifications; GTK2 itself has no undo stack.
  block:
    let owner = buffer
    pinTextBuffer(owner, p)
    rawGtk.begin_user_action(p)
    try: body
    finally: rawGtk.end_user_action(owner.raw)

proc disconnectSignals*(b: TextBuffer) =
  ## Disconnect every callback registered through this buffer's shared state.
  disconnectObjectSignals(b)

proc onChanged*(b: TextBuffer, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(b, "changed", fn, after = true)
proc onModifiedChanged*(b: TextBuffer, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(b, "modified-changed", fn)
proc textCursorThunk(instance, paramSpec, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[Callback](data).fn
    try: fn()
    except Exception as error: reportSignalError(error)
proc onCursorMoved*(b: TextBuffer, fn: proc () {.closure.}): Connection {.discardable.} =
  let p = b.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let callback = Callback(fn: fn)
  GC_ref(callback)
  let id = g.g_signal_connect_data(p, "notify::cursor-position", cast[g.TGCallback](textCursorThunk),
    cast[pointer](callback), releaseCallback, g.TGConnectFlags(0))
  b.state.handlers.add(id)
  Connection(state: b.state, id: id)

proc newTextView*(buffer: TextBuffer): TextView =
  result.state = adoptWidget(rawGtk.text_view_new(buffer.raw))
proc newTextView*(text = ""): TextView = newTextView(newTextBuffer(text))
proc buffer*(w: TextView): TextBuffer = ownedTextBuffer(rawGtk.get_buffer(w.raw))
proc `buffer=`*(w: TextView, buffer: TextBuffer) = rawGtk.set_buffer(w.raw, buffer.raw)
proc text*(w: TextView): string = w.buffer.text
proc `text=`*(w: TextView, text: string) = w.buffer.text = text
proc editable*(w: TextView): bool = g.toBool(rawGtk.get_editable(w.raw))
proc `editable=`*(w: TextView, value: bool) =
  let p = w.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_editable(p, g.gbool(value))
proc cursorVisible*(w: TextView): bool = g.toBool(rawGtk.get_cursor_visible(w.raw))
proc `cursorVisible=`*(w: TextView, value: bool) =
  let p = w.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_cursor_visible(p, g.gbool(value))
proc acceptsTab*(w: TextView): bool = g.toBool(rawGtk.get_accepts_tab(w.raw))
proc `acceptsTab=`*(w: TextView, value: bool) =
  let p = w.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_accepts_tab(p, g.gbool(value))
proc overwriteMode*(w: TextView): bool = g.toBool(rawGtk.get_overwrite(w.raw))
proc `overwriteMode=`*(w: TextView, value: bool) =
  let p = w.raw
  # Stock GTK2 invalidates missing layout/windows before realization. Reject a
  # changing policy rather than realize, suppress warnings or inspect private state.
  if not g.toBool(rawGtk.get_realized(cast[rawGtk.PWidget](p))) and
      g.toBool(rawGtk.get_overwrite(p)) != value:
    raise newException(ValueError, "TextView overwrite changes require a realized view")
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.set_overwrite(p, g.gbool(value))
proc wrapMode*(w: TextView): TextWrapMode = TextWrapMode(rawGtk.get_wrap_mode(w.raw))
proc `wrapMode=`*(w: TextView, mode: TextWrapMode) = rawGtk.set_wrap_mode(w.raw, rawGtk.TWrapMode(ord(mode)))

template textViewSpacing(name, setterName, getter, setter: untyped) =
  proc name*(w: TextView): int = getter(w.raw).int
  proc setterName*(w: TextView, value: int) = setter(w.raw, checkedInt(value))
textViewSpacing(leftMargin, `leftMargin=`, rawGtk.get_left_margin, rawGtk.set_left_margin)
textViewSpacing(rightMargin, `rightMargin=`, rawGtk.get_right_margin, rawGtk.set_right_margin)
textViewSpacing(pixelsAboveLines, `pixelsAboveLines=`, rawGtk.get_pixels_above_lines, rawGtk.set_pixels_above_lines)
textViewSpacing(pixelsBelowLines, `pixelsBelowLines=`, rawGtk.get_pixels_below_lines, rawGtk.set_pixels_below_lines)
textViewSpacing(pixelsInsideWrap, `pixelsInsideWrap=`, rawGtk.get_pixels_inside_wrap, rawGtk.set_pixels_inside_wrap)

proc scrollToCursor*(w: TextView, withinMargin = 0.0, useAlign = false,
                     xalign = 0.0, yalign = 0.0) =
  let margin = finite(withinMargin)
  let x = finite(xalign)
  let y = finite(yalign)
  if margin < 0 or margin >= 0.5 or x < 0 or x > 1 or y < 0 or y > 1:
    raise newException(ValueError, "scroll margin must be in [0, 0.5), alignments in [0, 1]")
  let b = w.buffer
  rawGtk.scroll_to_mark(w.raw, rawGtk.get_insert(b.raw), margin, g.gbool(useAlign), x, y)
