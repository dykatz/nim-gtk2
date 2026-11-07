# Included by gtk2.nim. Pure matching on copied fixed-model rows only.
proc deactivateCompletionMatch(state: CompletionMatchState) =
  state.active = false
  state.fn = nil
proc connected*(connection: CompletionMatchConnection): bool =
  connection.state != nil and connection.state.active
proc disconnect*(connection: CompletionMatchConnection) =
  requireOutsideModelFunction()
  if connection.connected: deactivateCompletionMatch(connection.state)
proc releaseCompletionMatch(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let slot = cast[CompletionMatchSlot](data)
    slot.nativeAlive = false
    try: deactivateCompletionMatch(slot.state)
    except Exception as error: reportSignalError(error)
    finally:
      slot.model = ListStore()
      GC_unref(slot)
proc completionMatchThunk(completion: rawGtk.PEntryCompletion, key: cstring,
    iter: rawGtk.PTreeIter, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let slot = cast[CompletionMatchSlot](data)
      let state = slot.state
      if not slot.nativeAlive or not state.active or key == nil or iter == nil:
        return g.gbool(false)
      if rawGtk.entry_completion_get_model(completion) != slot.model.raw:
        raise newException(ValueError, "completion matcher model was changed through raw GTK")
      let path = rawGtk.get_path(slot.model.raw, iter)
      if path == nil: return g.gbool(false)
      defer: rawGtk.free(path)
      var copy = iter[]
      let input = CompletionMatchInput(key: $key,
        text: iterValue(slot.model, copy, 0).stringValue, index: flatPathIndex(path))
      # Copy the function/inputs before entering the shared synchronous decision
      # guard. No native handle/iterator is exposed to application code.
      let fn = state.fn
      inc modelFunctionDepth
      try: result = g.gbool(fn(input))
      finally: dec modelFunctionDepth
    except Exception as error:
      reportSignalError(error)
      result = g.gbool(false)
proc invalidateCompletionMatching(d: CompletionData) =
  cancelCompletionCommit(d)
  cancelCompletionInline(d)
  for binding in d.observers:
    let idle = binding.idle
    binding.idle = 0
    if idle != 0: discard g.g_source_remove(idle)
    binding.values = @[]
proc replaceCompletionMatcher(d: CompletionData, slot: CompletionMatchSlot) =
  # GTK destroys old callback data BEFORE assigning the new callback. Independent
  # slots/pins and a traversal guard prevent old cleanup erasing the replacement.
  let p = d.p
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  d.matchingUpdate = true
  defer: d.matchingUpdate = false
  d.matcher = slot
  if slot == nil:
    rawGtk.entry_completion_set_match_func(p, nil, nil, nil)
  else:
    GC_ref(slot)
    rawGtk.entry_completion_set_match_func(p, completionMatchThunk,
      cast[pointer](slot), releaseCompletionMatch)
proc resetCompletionMatch(d: CompletionData) =
  if d.matcher != nil: replaceCompletionMatcher(d, nil)
proc setMatch*(completion: EntryCompletion, fn: CompletionMatch): CompletionMatchConnection {.discardable.} =
  ## Replace the predicate. Call refilter() (or await native typing) to refresh
  ## GTK's cached visible rows. Exceptions/disconnected predicates reject rows.
  let d = completionData(completion)
  if fn == nil: raise newException(ValueError, "completion match predicate cannot be nil")
  invalidateCompletionMatching(d)
  let slot = CompletionMatchSlot(nativeAlive: true, model: d.model,
    state: CompletionMatchState(active: true, fn: fn))
  replaceCompletionMatcher(d, slot)
  CompletionMatchConnection(state: slot.state)
proc clearMatch*(completion: EntryCompletion) =
  ## Restore the exact native default matcher, not a guessed SDK casefold/prefix
  ## algorithm. Refilter explicitly; existing text/native history are not undone.
  let d = completionData(completion)
  invalidateCompletionMatching(d)
  resetCompletionMatch(d)
proc customMatching*(completion: EntryCompletion): bool = completionData(completion).matcher != nil
proc matchConnection*(completion: EntryCompletion): CompletionMatchConnection =
  let d = completionData(completion)
  if d.matcher != nil: result.state = d.matcher.state
