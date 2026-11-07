# Included by gtk2.nim. Notify handlers only schedule; sampling/user code is idle.
type
  EntrySelectionObserver = ref object
    active, initialPending: bool
    entry: rawGtk.PEntry # Weak: native signal closures pin data, not the widget.
    ids: array[3, g.gulong]
    idle: g.guint
    last: EntrySelection
    fn: proc (value: EntrySelection) {.closure.}
  EntrySelectionConnection* = object
    observer: EntrySelectionObserver
proc deactivateEntrySelection(s: EntrySelectionObserver) =
  s.active = false
  s.entry = nil
  let idle = s.idle
  s.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  s.fn = nil
proc releaseEntrySelectionSignal(data: pointer, closure: g.PGClosure) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[EntrySelectionObserver](data)
    # May run during native finalization: never touch/ref the weak widget here.
    try: deactivateEntrySelection(s)
    except Exception as error: reportSignalError(error)
    finally: GC_unref(s)
proc releaseEntrySelectionSource(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[EntrySelectionObserver](data))
proc dispatchEntrySelection(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    # Checked event pumping is forbidden in model functions. Also avoid delivering
    # application code if an unsupported raw nested pump reaches this source.
    if modelFunctionDepth != 0: return g.gbool(true)
    let s = cast[EntrySelectionObserver](data)
    s.idle = 0
    try:
      if not s.active or s.entry == nil: return g.gbool(false)
      let value = copyEntrySelection(s.entry)
      if not s.initialPending and value == s.last: return g.gbool(false)
      s.initialPending = false
      s.last = value
      let fn = s.fn # Self-disconnect/destroy can release the stored closure.
      fn(value)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc queueEntrySelection(s: EntrySelectionObserver) =
  if s.active and s.idle == 0:
    GC_ref(s)
    s.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE,
      cast[pointer](dispatchEntrySelection), cast[pointer](s),
      cast[pointer](releaseEntrySelectionSource))
proc entrySelectionNotify(instance: g.PGObject, spec: g.PGParamSpec,
    data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: queueEntrySelection(cast[EntrySelectionObserver](data))
    except Exception as error: reportSignalError(error)
proc entrySelectionDestroyed(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: deactivateEntrySelection(cast[EntrySelectionObserver](data))
    except Exception as error: reportSignalError(error)
proc connected*(connection: EntrySelectionConnection): bool =
  connection.observer != nil and connection.observer.active
proc disconnect*(connection: EntrySelectionConnection) =
  requireOutsideModelFunction()
  let s = connection.observer
  if s == nil or not s.active: return
  GC_ref(s)
  defer: GC_unref(s)
  let p = s.entry
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  # Remove bookkeeping before capture teardown can destroy/drop shared handles.
  let data = g.get_data(cast[g.PGObject](p), objectStateKey)
  if data != nil and data != cast[pointer](1):
    let state = cast[ObjectState](data)
    var live: seq[g.gulong]
    for id in state.handlers:
      if id notin s.ids: live.add(id)
    state.handlers = move(live)
  deactivateEntrySelection(s)
  for id in s.ids:
    if id != 0 and g.g_signal_handler_is_connected(p, id):
      g.g_signal_handler_disconnect(p, id)
proc onSelectionChanged*(entry: Entry,
    fn: proc (value: EntrySelection) {.closure.}, initial = false): EntrySelectionConnection {.discardable.} =
  ## Final-state coordinate observations; no text or PRIMARY operations. Optional
  ## initial delivery is asynchronous and samples the final state at that idle.
  let p = entry.raw
  if fn == nil: raise newException(ValueError, "entry selection callback cannot be nil")
  let s = EntrySelectionObserver(active: true, entry: p, fn: fn,
    initialPending: initial, last: copyEntrySelection(p))
  for index, name in ["notify::cursor-position", "notify::selection-bound", "destroy"]:
    GC_ref(s) # Independent pin for each native closure/destroy notification.
    let callback = if index == 2: cast[g.TGCallback](entrySelectionDestroyed)
                   else: cast[g.TGCallback](entrySelectionNotify)
    s.ids[index] = g.g_signal_connect_data(p, name.cstring, callback,
      cast[pointer](s), releaseEntrySelectionSignal, g.TGConnectFlags(0))
    entry.state.handlers.add(s.ids[index])
  if initial: queueEntrySelection(s)
  EntrySelectionConnection(observer: s)
