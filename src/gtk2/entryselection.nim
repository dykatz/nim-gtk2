# Included by gtk2.nim. GtkEntry/GtkEditable offsets count Unicode code points.
type EntrySelection* = object
  hasSelection*: bool
  first*, last*, anchor*, cursor*: int
proc characterCount*(entry: Entry): int =
  g.g_utf8_strlen(rawGtk.get_text(entry.raw), -1).int
proc cursorOffset*(entry: Entry): int =
  rawGtk.get_position(cast[rawGtk.PEditable](entry.raw)).int
proc copyEntrySelection(p: rawGtk.PEntry): EntrySelection =
  let editable = cast[rawGtk.PEditable](p)
  var first, last: g.gint
  result.hasSelection = g.toBool(rawGtk.get_selection_bounds(editable, addr first, addr last))
  result.cursor = rawGtk.get_position(editable).int
  if result.hasSelection:
    result.first = first.int
    result.last = last.int
    result.anchor = if result.cursor == result.first: result.last else: result.first
  else:
    result.first = result.cursor
    result.last = result.cursor
    result.anchor = result.cursor
proc selectionBounds*(entry: Entry): EntrySelection = copyEntrySelection(entry.raw)
proc hasSelection*(entry: Entry): bool = entry.selectionBounds.hasSelection
proc selectedText*(entry: Entry): string =
  let p = entry.raw
  if not g.toBool(rawGtk.get_visibility(p)):
    raise newException(ValueError, "selectedText is unavailable for password entries")
  let bounds = entry.selectionBounds
  if bounds.hasSelection:
    let text = rawGtk.get_chars(cast[rawGtk.PEditable](p), g.gint(bounds.first), g.gint(bounds.last))
    try: result = $text
    finally: g.g_free(text) # GtkEditable.get_chars transfers an allocated copy.
proc prepareEntrySelection(p: rawGtk.PEntry) =
  let completion = rawGtk.entry_get_completion(p)
  if completion != nil:
    let d = cast[CompletionData](g.get_data(cast[g.PGObject](completion), completionKey))
    if d != nil and d.active:
      if d.matchingUpdate or d.actionsUpdating:
        raise newException(ValueError, "selection access during completion replacement is forbidden")
      # Cancel only stale SDK work, not GTK's popup/history/completion timeout.
      # Subsequent native selection/focus retains GTK's own IM-reset behavior.
      invalidateCompletionMatching(d)
proc selectRange*(entry: Entry, anchor, cursor: int) =
  let p = entry.raw
  let start = checkedInt(anchor)
  let finish = checkedInt(cursor)
  let count = g.g_utf8_strlen(rawGtk.get_text(p), -1).int
  if anchor > count or cursor > count:
    raise newException(ValueError, "entry selection exceeds its character count")
  # Both endpoints are checked before any cancellation, notification or ownership
  # change. Reverse selection is intentional; native end is the active cursor.
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  prepareEntrySelection(p)
  rawGtk.select_region(cast[rawGtk.PEditable](p), start, finish)
proc `cursorOffset=`*(entry: Entry, offset: int) = entry.selectRange(offset, offset)
proc clearSelection*(entry: Entry) =
  let cursor = entry.cursorOffset
  entry.selectRange(cursor, cursor)
proc selectAll*(w: Entry) = w.selectRange(0, w.characterCount)
proc focus*(w: Entry) =
  ## Restore selection direction as well as bounds after select-all-on-focus.
  let p = w.raw
  let state = w.state
  GC_ref(state)
  defer: GC_unref(state)
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let bounds = w.selectionBounds
  prepareEntrySelection(p)
  rawGtk.grab_focus(cast[rawGtk.PWidget](p))
  if state.destroyed: return
  # SpinButton/custom native focus handling may alter the displayed text. Never
  # restore an endpoint past its new length; do not invent a native history reset.
  let count = g.g_utf8_strlen(rawGtk.get_text(p), -1).int
  if bounds.anchor <= count and bounds.cursor <= count:
    rawGtk.select_region(cast[rawGtk.PEditable](p), g.gint(bounds.anchor), g.gint(bounds.cursor))
