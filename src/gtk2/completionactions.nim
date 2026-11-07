# Included by gtk2.nim. Literal action rows, independently indexed observations.
proc connected*(connection: CompletionActionConnection): bool =
  connection.state != nil and connection.state.active
proc disconnect*(connection: CompletionActionConnection) =
  requireOutsideModelFunction()
  if connection.connected:
    connection.state.active = false
    connection.state.fn = nil
proc installCompletionActions(d: CompletionData, labels: openArray[string]) =
  # Validate/copy before touching native rows. GTK delete_action does not check
  # nth_child success, so only our tracked in-range indices may reach it.
  discard checkedInt(labels.len)
  var copied: seq[string]
  for label in labels:
    discard checkedUtf8Text(label)
    copied.add(label)
  if d.entry != nil:
    raise newException(ValueError, "configure completion actions only while explicitly detached")
  invalidateCompletionMatching(d)
  let p = d.p
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  d.actionsUpdating = true
  defer: d.actionsUpdating = false
  for index in countdown(d.actions.len - 1, 0):
    rawGtk.entry_completion_delete_action(p, g.gint(index))
  for index, label in copied:
    rawGtk.entry_completion_insert_action_text(p, g.gint(index), label.cstring)
  d.actions = move(copied)
proc actions*(completion: EntryCompletion): seq[string] =
  for label in completionData(completion).actions: result.add(label)
proc setActions*(completion: EntryCompletion, labels: openArray[string]) =
  ## Native popup navigation caches a combined suggestion/action index with no
  ## public reset/query. Never mutate that index space on an attached entry.
  installCompletionActions(completionData(completion), labels)
proc clearActions*(completion: EntryCompletion) = completion.setActions([])
proc onActionActivated*(completion: EntryCompletion,
    fn: proc (value: CompletionAction) {.closure.}): CompletionActionConnection {.discardable.} =
  let d = completionData(completion)
  if fn == nil: raise newException(ValueError, "completion action callback cannot be nil")
  var live: seq[CompletionActionState]
  for observer in d.actionObservers:
    if observer.active: live.add(observer)
  let state = CompletionActionState(active: true, fn: fn)
  live.add(state)
  d.actionObservers = move(live)
  CompletionActionConnection(state: state)
proc validCompletionAction(d: CompletionData, pending: PendingCompletionAction): bool =
  d.active and not d.actionsUpdating and d.entry != nil and
    pending.generation == d.actionGeneration and
    rawGtk.entry_get_completion(d.entry) == d.p and
    g.toBool(rawGtk.get_visibility(d.entry)) and
    g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](d.entry))) and
    $rawGtk.get_text(d.entry) == pending.value.key
proc dispatchCompletionActions(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let d = cast[CompletionData](data)
    d.actionIdle = 0
    let pending = move(d.actionPending)
    try:
      for event in pending:
        for observer in event.listeners:
          if not validCompletionAction(d, event): return g.gbool(false)
          if observer.active:
            let fn = observer.fn # Self-disconnection/close may release its captures.
            try: fn(event.value)
            except Exception as error: reportSignalError(error)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc completionActionSignal(instance: pointer, index: g.gint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let d = cast[CompletionData](data)
      if not d.active or d.actionsUpdating or d.entry == nil or index < 0 or
          index.int >= d.actions.len or
          not g.toBool(rawGtk.get_visibility(d.entry)) or
          not g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](d.entry))): return
      # Action activation is not suggestion insertion. The emitter still uses
      # completion/popup state after this signal (mouse popdown / key prefix free).
      if d.idle != 0: cancelCompletionCommit(d)
      cancelCompletionInline(d)
      var event = PendingCompletionAction(generation: d.actionGeneration,
        value: CompletionAction(index: index.int, text: d.actions[index.int],
          key: $rawGtk.get_text(d.entry)))
      for observer in d.actionObservers:
        if observer.active: event.listeners.add(observer)
      if event.listeners.len == 0: return
      d.actionPending.add(move(event))
      if d.actionIdle == 0:
        GC_ref(d)
        d.actionIdle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE,
          cast[pointer](dispatchCompletionActions), cast[pointer](d),
          cast[pointer](releaseCompletionIdle))
    except Exception as error: reportSignalError(error)
