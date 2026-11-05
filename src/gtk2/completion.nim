# Included by gtk2.nim. Popup-only text completion with deferred safe commits.
type
  EntryCompletion* = object of ObjectHandle
  CompletionSelection* = object
    index*: int
    text*: string
  CompletionConnection* = object
    binding: RecentBinding[CompletionSelection]
  CompletionData = ref object
    p: rawGtk.PEntryCompletion # Weak; native qdata pins this bridge.
    model: ListStore
    entry: rawGtk.PEntry # Weak; native destroy/visibility hooks detach it.
    destroyId, visibilityId, changedId: g.gulong
    active, applying: bool
    generation: uint64
    idle: g.guint
    pending: CompletionSelection
    key: string
    observers: seq[RecentBinding[CompletionSelection]]
const completionKey = "nim-gtk2-text-completion"
proc clearCompletionBridge(d: CompletionData, detachNative: bool)
proc cancelCompletionCommit(d: CompletionData) =
  inc d.generation
  let idle = d.idle
  d.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  d.pending = CompletionSelection()
  d.key = ""
proc releaseCompletionData(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let d = cast[CompletionData](data)
    d.active = false
    try: clearCompletionBridge(d, false)
    except Exception as error: reportSignalError(error)
    finally: GC_unref(d)
proc releaseCompletionIdle(data: pointer) {.cdecl.} = GC_unref(cast[CompletionData](data))
proc connected*(c: CompletionConnection): bool = c.binding != nil and c.binding.active
proc disconnect*(c: CompletionConnection) =
  if c.connected: releaseRecentBinding[CompletionSelection](cast[pointer](c.binding), nil)
proc clearCompletionBridge(d: CompletionData, detachNative: bool) =
  cancelCompletionCommit(d)
  let observers = d.observers
  d.observers = @[]
  for binding in observers:
    if binding.active: releaseRecentBinding[CompletionSelection](cast[pointer](binding), nil)
  let entry = d.entry
  d.entry = nil
  if entry != nil:
    for id in [d.destroyId, d.visibilityId, d.changedId]:
      if id != 0 and g.g_signal_handler_is_connected(entry, id): g.g_signal_handler_disconnect(entry, id)
    d.destroyId = 0
    d.visibilityId = 0
    d.changedId = 0
    if detachNative and rawGtk.entry_get_completion(entry) == d.p:
      rawGtk.entry_set_completion(entry, nil)
proc raw*(c: EntryCompletion): rawGtk.PEntryCompletion = cast[rawGtk.PEntryCompletion](nativePointer(c))
proc completionData(c: EntryCompletion): CompletionData =
  let p = c.raw
  result = cast[CompletionData](g.get_data(cast[g.PGObject](p), completionKey))
  if result == nil or not result.active: raise newException(ValueError, "not an active SDK text completion")
  if rawGtk.entry_completion_get_entry(p) != cast[rawGtk.PWidget](result.entry):
    raise newException(ValueError, "completion attachment was changed through raw GTK")
  if rawGtk.entry_completion_get_model(p) != result.model.raw or rawGtk.entry_completion_get_text_column(p) != 0:
    raise newException(ValueError, "completion's fixed text model was replaced through raw GTK")
proc closed*(c: EntryCompletion): bool =
  if c.isDestroyed: return true
  let data = cast[CompletionData](g.get_data(cast[g.PGObject](c.state.p), completionKey))
  data == nil or not data.active
proc close*(c: EntryCompletion) =
  if c.closed: return
  let d = cast[CompletionData](g.get_data(cast[g.PGObject](c.state.p), completionKey))
  d.active = false
  clearCompletionBridge(d, true)
  c.state.destroyed = true
  g.set_data(cast[g.PGObject](c.state.p), objectStateKey, cast[pointer](1))
proc detach*(c: EntryCompletion) = clearCompletionBridge(completionData(c), true)
proc completionEntryGone(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let d = cast[CompletionData](data)
    GC_ref(d)
    try: clearCompletionBridge(d, true)
    except Exception as error: reportSignalError(error)
    finally: GC_unref(d)
proc completionEntryChanged(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let d = cast[CompletionData](data)
      if not d.applying: cancelCompletionCommit(d)
    except Exception as error: reportSignalError(error)
proc completionVisibility(instance, spec, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    if not g.toBool(rawGtk.get_visibility(cast[rawGtk.PEntry](instance))):
      completionEntryGone(instance, data)
proc completion*(w: Entry): EntryCompletion =
  let p = rawGtk.entry_get_completion(w.raw)
  if p != nil:
    if g.get_data(cast[g.PGObject](p), completionKey) == nil:
      raise newException(ValueError, "entry uses a raw/native completion, not an SDK text completion")
    result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false)
    discard completionData(result)
proc clearCompletion*(w: Entry) =
  let c = w.completion
  if not c.closed: c.detach()
proc `completion=`*(w: Entry, c: EntryCompletion) =
  let entry = w.raw
  if g.G_OBJECT_TYPE(entry) != rawGtk.entry_get_type():
    raise newException(ValueError, "completion requires an ordinary GtkEntry (not SpinButton/private subclasses)")
  if not w.textVisible: raise newException(ValueError, "password entries cannot use SDK completion")
  let d = completionData(c)
  if d.entry == entry: return
  if d.applying: raise newException(ValueError, "reattach completion after the current text-change callback returns")
  if d.entry != nil: raise newException(ValueError, "completion is attached to another entry; detach first")
  w.clearCompletion()
  cancelCompletionCommit(d)
  d.entry = entry
  d.destroyId = g.g_signal_connect_data(entry, "destroy", cast[g.TGCallback](completionEntryGone), cast[pointer](d), nil, g.TGConnectFlags(0))
  d.visibilityId = g.g_signal_connect_data(entry, "notify::visibility", cast[g.TGCallback](completionVisibility), cast[pointer](d), nil, g.TGConnectFlags(0))
  d.changedId = g.g_signal_connect_data(entry, "changed", cast[g.TGCallback](completionEntryChanged), cast[pointer](d), nil, g.TGConnectFlags(0))
  rawGtk.entry_set_completion(entry, c.raw)
proc attached*(c: EntryCompletion): bool = completionData(c).entry != nil
proc dispatchCompletion(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let d = cast[CompletionData](data)
    d.idle = 0
    try:
      let target = d.entry
      if not d.active or target == nil: return g.gbool(false)
      let value = d.pending
      let key = d.key
      let generation = d.generation
      d.pending = CompletionSelection()
      d.key = ""
      let owner = adoptObject(target, borrowed = true, cache = true)
      if owner.destroyed or not g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](target))) or
          not g.toBool(rawGtk.get_visibility(target)) or $rawGtk.get_text(target) != key:
        return g.gbool(false)
      let native = d.p
      discard g.g_object_ref(native)
      defer: g.g_object_unref(native)
      # gtk_entry_set_text itself blocks its native completion-changed handler.
      # Retain completion across it: a user changed observer may detach/close it.
      d.applying = true
      try: rawGtk.set_text(target, value.text.cstring)
      finally: d.applying = false
      if owner.destroyed or not d.active or d.entry != target or generation != d.generation or
          $rawGtk.get_text(target) != value.text:
        return g.gbool(false)
      rawGtk.set_position(cast[rawGtk.PEditable](target), -1)
      let observers = d.observers
      for binding in observers:
        if binding.active: queueRecent(cast[pointer](binding), value)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc completionSelected(instance: pointer, model: rawGtk.PTreeModel,
    iter: rawGtk.PTreeIter, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let d = cast[CompletionData](data)
      if not d.active or d.entry == nil or model != d.model.raw: return g.gbool(true)
      let path = rawGtk.get_path(model, iter)
      defer: rawGtk.free(path)
      let row = flatPathIndex(path)
      var copy = iter[]
      let value = iterValue(d.model, copy, 0).stringValue
      discard checkedUtf8Text(value)
      d.pending = CompletionSelection(index: row, text: value)
      d.key = $rawGtk.get_text(d.entry)
      if d.idle == 0:
        GC_ref(d)
        d.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchCompletion),
          cast[pointer](d), cast[pointer](releaseCompletionIdle))
    except Exception as error: reportSignalError(error)
    # Handle selection before GTK's default: it writes entry text synchronously
    # and then keeps using entry/popup state. Our commit runs after that emitter.
    g.gbool(true)
proc completionModel(items: openArray[string]): ListStore =
  for text in items: discard checkedUtf8Text(text)
  result = newListStore([cellString])
  for text in items: discard result.appendRow([cell(text)])
proc newEntryCompletion*(items: openArray[string] = []): EntryCompletion =
  let model = completionModel(items)
  let p = rawGtk.entry_completion_new()
  result.state = adoptObject(p, cache = true, hasDestroySignal = false, sink = false)
  let d = CompletionData(p: p, model: model, active: true)
  GC_ref(d)
  g.set_data_full(cast[g.PGObject](p), completionKey, cast[pointer](d), releaseCompletionData)
  rawGtk.entry_completion_set_model(p, model.raw)
  rawGtk.entry_completion_set_text_column(p, 0)
  discard g.g_signal_connect_data(p, "match-selected", cast[g.TGCallback](completionSelected),
    cast[pointer](d), nil, g.TGConnectFlags(0))
proc items*(c: EntryCompletion): seq[string] =
  let d = completionData(c)
  for i in 0..<d.model.rowCount: result.add(d.model.value(i, 0).stringValue)
proc setItems*(c: EntryCompletion, items: openArray[string]) =
  let d = completionData(c)
  let model = completionModel(items) # Atomic validation/construction before replacement.
  cancelCompletionCommit(d)
  for binding in d.observers:
    let idle = binding.idle
    binding.idle = 0
    if idle != 0: discard g.g_source_remove(idle)
    binding.values = @[]
  d.model = model
  rawGtk.entry_completion_set_model(c.raw, model.raw)
proc onSelected*(c: EntryCompletion, fn: proc (selection: CompletionSelection) {.closure.}): CompletionConnection {.discardable.} =
  let d = completionData(c)
  if fn == nil: raise newException(ValueError, "completion callback cannot be nil")
  var live: seq[RecentBinding[CompletionSelection]]
  for previous in d.observers:
    if previous.active: live.add(previous)
  d.observers = live
  let binding = RecentBinding[CompletionSelection](active: true, fn: fn)
  GC_ref(binding)
  d.observers.add(binding)
  CompletionConnection(binding: binding)
proc minimumKeyLength*(c: EntryCompletion): int =
  discard completionData(c)
  rawGtk.entry_completion_get_minimum_key_length(c.raw).int
proc `minimumKeyLength=`*(c: EntryCompletion, value: int) =
  discard completionData(c)
  rawGtk.entry_completion_set_minimum_key_length(c.raw, checkedInt(value))
proc popupCompletion*(c: EntryCompletion): bool =
  discard completionData(c)
  g.toBool(rawGtk.entry_completion_get_popup_completion(c.raw))
proc `popupCompletion=`*(c: EntryCompletion, value: bool) =
  discard completionData(c)
  rawGtk.entry_completion_set_popup_completion(c.raw, g.gbool(value))
proc popupSingleMatch*(c: EntryCompletion): bool =
  discard completionData(c)
  g.toBool(rawGtk.entry_completion_get_popup_single_match(c.raw))
proc `popupSingleMatch=`*(c: EntryCompletion, value: bool) =
  discard completionData(c)
  rawGtk.entry_completion_set_popup_single_match(c.raw, g.gbool(value))
proc popupSetWidth*(c: EntryCompletion): bool =
  discard completionData(c)
  g.toBool(rawGtk.entry_completion_get_popup_set_width(c.raw))
proc `popupSetWidth=`*(c: EntryCompletion, value: bool) =
  discard completionData(c)
  rawGtk.entry_completion_set_popup_set_width(c.raw, g.gbool(value))
proc refilter*(c: EntryCompletion) =
  let d = completionData(c)
  if d.entry == nil: raise newException(ValueError, "completion must be attached before refiltering")
  rawGtk.entry_completion_complete(c.raw)

# Editable ComboBoxText already uses GTK2.24's native entry constructor. Expose
# its public entry child and copied text/selection state without model rebinding.
type ComboTextState* = object
  index*: int
  text*: string
proc entry*(w: ComboBoxText): Entry =
  result.state = adoptObject(comboEntry(w), borrowed = true, cache = true)
proc textState*(w: ComboBoxText): ComboTextState = ComboTextState(index: w.activeIndex, text: w.activeText)
proc comboTextThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let p = cast[rawGtk.PComboBoxText](instance)
      let text = rawGtk.get_active_text(p)
      try:
        queueRecent(data, ComboTextState(index: rawGtk.get_active(cast[rawGtk.PComboBox](p)).int, text: $text))
      finally: g.g_free(text)
    except Exception as error: reportSignalError(error)
proc onTextChanged*(w: ComboBoxText, fn: proc (state: ComboTextState) {.closure.}): Connection {.discardable.} =
  connectRecent(w, "changed", fn, cast[g.TGCallback](comboTextThunk), coalesce = true)
