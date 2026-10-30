# Included by gtk2.nim. TextBuffer is a non-floating GObject, not GtkObject.
type
  TextBuffer* = object of ObjectHandle
  TextView* = object of Container
  TextWrapMode* = enum
    wrapNone, wrapChar, wrapWord, wrapWordChar
  TextSelection* = tuple[hasSelection: bool, first, last: int]

proc raw*(b: TextBuffer): rawGtk.PTextBuffer = cast[rawGtk.PTextBuffer](nativePointer(b))
proc raw*(w: TextView): rawGtk.PTextView = cast[rawGtk.PTextView](raw(Widget(w)))

proc checkedUtf8Text(text: string): cstring =
  result = checkedString(text)
  discard checkedInt(text.len)
  if not g.toBool(g.g_utf8_validate(result, g.gssize(text.len), nil)):
    raise newException(ValueError, "GTK text must be valid UTF-8")

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
proc `modified=`*(b: TextBuffer, value: bool) = rawGtk.set_modified(b.raw, g.gbool(value))

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
  rawGtk.set_text(b.raw, value, g.gint(text.len))
proc textRange*(b: TextBuffer, first, last: int, includeHidden = true): string =
  var bounds = bufferRange(b, first, last)
  copyBufferText(b, bounds.first, bounds.last, includeHidden)
proc insertText*(b: TextBuffer, offset: int, text: string) =
  let value = checkedUtf8Text(text)
  var iter = bufferIter(b, offset)
  rawGtk.insert(b.raw, addr iter, value, g.gint(text.len))
proc appendText*(b: TextBuffer, text: string) = b.insertText(b.characterCount, text)
proc insertAtCursor*(b: TextBuffer, text: string) =
  let value = checkedUtf8Text(text)
  rawGtk.insert_at_cursor(b.raw, value, g.gint(text.len))
proc deleteRange*(b: TextBuffer, first, last: int) =
  var bounds = bufferRange(b, first, last)
  rawGtk.delete(b.raw, addr bounds.first, addr bounds.last)
proc cursorOffset*(b: TextBuffer): int =
  let p = b.raw
  var iter: rawGtk.TTextIter
  rawGtk.get_iter_at_mark(p, addr iter, rawGtk.get_insert(p))
  rawGtk.get_offset(addr iter).int
proc `cursorOffset=`*(b: TextBuffer, offset: int) =
  var iter = bufferIter(b, offset)
  rawGtk.place_cursor(b.raw, addr iter)
proc selectRange*(b: TextBuffer, anchor, cursor: int) =
  var first = bufferIter(b, anchor)
  var last = bufferIter(b, cursor)
  rawGtk.select_range(b.raw, addr last, addr first)
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
  g.toBool(rawGtk.delete_selection(b.raw, g.gbool(interactive), g.gbool(defaultEditable)))

template withUserAction*(buffer: TextBuffer, body: untyped) =
  ## Groups native user-action notifications; GTK2 itself has no undo stack.
  block:
    let owner = buffer
    rawGtk.begin_user_action(owner.raw)
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
proc `editable=`*(w: TextView, value: bool) = rawGtk.set_editable(w.raw, g.gbool(value))
proc cursorVisible*(w: TextView): bool = g.toBool(rawGtk.get_cursor_visible(w.raw))
proc `cursorVisible=`*(w: TextView, value: bool) = rawGtk.set_cursor_visible(w.raw, g.gbool(value))
proc acceptsTab*(w: TextView): bool = g.toBool(rawGtk.get_accepts_tab(w.raw))
proc `acceptsTab=`*(w: TextView, value: bool) = rawGtk.set_accepts_tab(w.raw, g.gbool(value))
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
