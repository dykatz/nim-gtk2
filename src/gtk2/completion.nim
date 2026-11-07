# Included by gtk2.nim. Owned-string completion; native inline text changes run
# with deferred SDK Entry/ComboBox observations, not synchronous application code.
type
  EntryCompletion* = object of ObjectHandle
  CompletionSelection* = object
    index*: int
    text*: string
  CompletionConnection* = object
    binding: RecentBinding[CompletionSelection]
  CompletionInlineKind* = enum inlinePrefix, inlinePreview
  CompletionPrefix* = object
    available*: bool
    text*: string
  CompletionInlineState* = object
    kind*: CompletionInlineKind
    key*, text*: string
    index*: int # -1 for a common prefix, source suggestion index for a preview.
    first*, last*, cursor*: int # Current native Unicode character offsets.
  CompletionInlineConnection* = object
    binding: RecentBinding[CompletionInlineState]
  CompletionMatchInput* = object
    key*, text*: string # Native normalized/casefolded key; literal suggestion text.
    index*: int # Source suggestion index, not the filtered popup position.
  CompletionMatch* = proc (input: CompletionMatchInput): bool {.closure.}
  CompletionMatchState = ref object
    active: bool
    fn: CompletionMatch
  CompletionMatchConnection* = object
    state: CompletionMatchState # Does not own the completion/native callback slot.
  CompletionMatchSlot = ref object
    state: CompletionMatchState
    model: ListStore
    nativeAlive: bool
  CompletionData = ref object
    p: rawGtk.PEntryCompletion # Weak; native qdata pins this bridge.
    model: ListStore
    entry: rawGtk.PEntry # Weak; native destroy/visibility hooks detach it.
    destroyId, visibilityId, changedId, editableId: g.gulong
    deferredParent: rawGtk.PWidget
    inlineCompletion, inlineSelection: bool
    inlineIdle: g.guint
    inlinePending: bool
    inlineExpected: string
    inlineValue: CompletionInlineState
    inlineObservers: seq[RecentBinding[CompletionInlineState]]
    active, applying, matchingUpdate: bool
    matcher: CompletionMatchSlot
    generation: uint64
    idle: g.guint
    pending: CompletionSelection
    key: string
    observers: seq[RecentBinding[CompletionSelection]]
const completionKey = "nim-gtk2-text-completion"
proc clearCompletionBridge(d: CompletionData, detachNative: bool)
proc resetCompletionMatch(d: CompletionData)
proc cancelCompletionInline(d: CompletionData) =
  let idle = d.inlineIdle
  d.inlineIdle = 0
  if idle != 0: discard g.g_source_remove(idle)
  d.inlinePending = false
  d.inlineExpected = ""
  d.inlineValue = CompletionInlineState()
  for binding in d.inlineObservers:
    let source = binding.idle
    binding.idle = 0
    if source != 0: discard g.g_source_remove(source)
    binding.values = @[]
proc syncCompletionInline(d: CompletionData) =
  let enabled = d.entry == nil or g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](d.entry)))
  rawGtk.entry_completion_set_inline_completion(d.p, g.gbool(d.inlineCompletion and enabled))
  rawGtk.entry_completion_set_inline_selection(d.p, g.gbool(d.inlineSelection and enabled))
  if d.entry != nil:
    let flag = if d.inlineCompletion or d.inlineSelection: cast[pointer](1) else: nil
    g.set_data(cast[g.PGObject](d.entry), completionDeferredKey, flag)
    let parent = rawGtk.get_parent(cast[rawGtk.PWidget](d.entry))
    if parent != nil and g.G_TYPE_CHECK_INSTANCE_TYPE(parent, rawGtk.combo_box_get_type()):
      d.deferredParent = parent
      g.set_data(cast[g.PGObject](parent), completionDeferredKey, flag)
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
  requireOutsideModelFunction()
  if c.connected: releaseRecentBinding[CompletionSelection](cast[pointer](c.binding), nil)
proc connected*(c: CompletionInlineConnection): bool = c.binding != nil and c.binding.active
proc disconnect*(c: CompletionInlineConnection) =
  requireOutsideModelFunction()
  if c.connected: releaseRecentBinding[CompletionInlineState](cast[pointer](c.binding), nil)
proc clearCompletionBridge(d: CompletionData, detachNative: bool) =
  cancelCompletionCommit(d)
  cancelCompletionInline(d)
  let inlineObservers = move(d.inlineObservers)
  for binding in inlineObservers:
    if binding.active: releaseRecentBinding[CompletionInlineState](cast[pointer](binding), nil)
  let observers = d.observers
  d.observers = @[]
  for binding in observers:
    if binding.active: releaseRecentBinding[CompletionSelection](cast[pointer](binding), nil)
  let entry = d.entry
  d.entry = nil
  if entry != nil:
    g.set_data(cast[g.PGObject](entry), completionDeferredKey, nil)
    if d.deferredParent != nil:
      g.set_data(cast[g.PGObject](d.deferredParent), completionDeferredKey, nil)
      d.deferredParent = nil
    for id in [d.destroyId, d.visibilityId, d.changedId, d.editableId]:
      if id != 0 and g.g_signal_handler_is_connected(entry, id): g.g_signal_handler_disconnect(entry, id)
    d.destroyId = 0
    d.visibilityId = 0
    d.changedId = 0
    d.editableId = 0
    if detachNative and rawGtk.entry_get_completion(entry) == d.p:
      rawGtk.entry_set_completion(entry, nil)
    if d.active: syncCompletionInline(d)
proc raw*(c: EntryCompletion): rawGtk.PEntryCompletion = cast[rawGtk.PEntryCompletion](nativePointer(c))
proc completionData(c: EntryCompletion): CompletionData =
  let p = c.raw
  result = cast[CompletionData](g.get_data(cast[g.PGObject](p), completionKey))
  if result == nil or not result.active: raise newException(ValueError, "not an active SDK text completion")
  if result.matchingUpdate: raise newException(ValueError, "completion access during matcher replacement is forbidden")
  if result.matcher != nil and not result.matcher.nativeAlive:
    raise newException(ValueError, "completion match function was changed through raw GTK")
  if rawGtk.entry_completion_get_entry(p) != cast[rawGtk.PWidget](result.entry):
    raise newException(ValueError, "completion attachment was changed through raw GTK")
  if rawGtk.entry_completion_get_model(p) != result.model.raw or rawGtk.entry_completion_get_text_column(p) != 0:
    raise newException(ValueError, "completion's fixed text model was replaced through raw GTK")
  let enabled = result.entry == nil or g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](result.entry)))
  if g.toBool(rawGtk.entry_completion_get_inline_completion(p)) != (result.inlineCompletion and enabled) or
      g.toBool(rawGtk.entry_completion_get_inline_selection(p)) != (result.inlineSelection and enabled):
    raise newException(ValueError, "completion inline policy was changed through raw GTK")
proc closed*(c: EntryCompletion): bool =
  requireOutsideModelFunction()
  if c.isDestroyed: return true
  let data = cast[CompletionData](g.get_data(cast[g.PGObject](c.state.p), completionKey))
  data == nil or not data.active
proc close*(c: EntryCompletion) =
  if c.closed: return
  let state = c.state
  GC_ref(state) # Clearing a self-capturing matcher may drop the final public alias.
  defer: GC_unref(state)
  let d = cast[CompletionData](g.get_data(cast[g.PGObject](state.p), completionKey))
  if d.matchingUpdate: raise newException(ValueError, "completion close during matcher replacement is forbidden")
  d.active = false
  clearCompletionBridge(d, true)
  resetCompletionMatch(d)
  state.destroyed = true
  g.set_data(cast[g.PGObject](state.p), objectStateKey, cast[pointer](1))
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
      if not d.applying:
        cancelCompletionCommit(d)
        if d.inlinePending and $rawGtk.get_text(d.entry) != d.inlineExpected:
          cancelCompletionInline(d)
    except Exception as error: reportSignalError(error)
proc completionEditable(instance, spec, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let d = cast[CompletionData](data)
    try:
      cancelCompletionCommit(d)
      cancelCompletionInline(d)
      syncCompletionInline(d)
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
  d.editableId = g.g_signal_connect_data(entry, "notify::editable", cast[g.TGCallback](completionEditable), cast[pointer](d), nil, g.TGConnectFlags(0))
  syncCompletionInline(d)
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
      cancelCompletionInline(d)
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
proc dispatchCompletionInline(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let d = cast[CompletionData](data)
    d.inlineIdle = 0
    try:
      if not d.active or d.entry == nil: return g.gbool(false)
      if not g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](d.entry))) or
          $rawGtk.get_text(d.entry) != d.inlineExpected: return g.gbool(false)
      var value = d.inlineValue
      value.text = $rawGtk.get_text(d.entry)
      value.cursor = rawGtk.get_position(cast[rawGtk.PEditable](d.entry)).int
      var first, last: g.gint
      if g.toBool(rawGtk.get_selection_bounds(cast[rawGtk.PEditable](d.entry), addr first, addr last)):
        value.first = first.int
        value.last = last.int
      else:
        value.first = value.cursor
        value.last = value.cursor
      let observers = d.inlineObservers
      for binding in observers:
        if binding.active: queueRecent(cast[pointer](binding), value)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc queueCompletionInline(d: CompletionData, value: CompletionInlineState, expected: string) =
  d.inlinePending = true
  d.inlineValue = value
  d.inlineExpected = expected
  if d.inlineIdle == 0:
    GC_ref(d)
    d.inlineIdle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchCompletionInline),
      cast[pointer](d), cast[pointer](releaseCompletionIdle))
proc completionPrefixSignal(instance: pointer, prefix: cstring, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let d = cast[CompletionData](data)
      if not d.active or d.entry == nil or not d.inlineCompletion or
          not g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](d.entry))): return g.gbool(true)
      let text = $prefix
      discard checkedUtf8Text(text)
      let key = $rawGtk.get_text(d.entry)
      if text != key:
        queueCompletionInline(d, CompletionInlineState(kind: inlinePrefix, key: key, index: -1), text)
      # Let GTK set has_completion and select the native Unicode suffix. All SDK
      # changed/activate observers on the entry (and its combo) are deferred.
      return g.gbool(false)
    except Exception as error: reportSignalError(error)
    g.gbool(true)
proc completionCursorSignal(instance: pointer, model: rawGtk.PTreeModel,
    iter: rawGtk.PTreeIter, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let d = cast[CompletionData](data)
      if not d.active or d.entry == nil or not d.inlineSelection or model != d.model.raw or
          not g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](d.entry))): return g.gbool(true)
      let path = rawGtk.get_path(model, iter)
      defer: rawGtk.free(path)
      var copy = iter[]
      let text = iterValue(d.model, copy, 0).stringValue
      let prefix = rawGtk.entry_completion_get_completion_prefix(d.p)
      let key = if prefix == nil: $rawGtk.get_text(d.entry) else: $prefix
      queueCompletionInline(d, CompletionInlineState(kind: inlinePreview, key: key,
        index: flatPathIndex(path)), text)
      return g.gbool(false) # Native preview and Escape/Left/Right/Tab behavior.
    except Exception as error: reportSignalError(error)
    g.gbool(true)
proc newEntryCompletion*(items: openArray[string] = []): EntryCompletion =
  requireOutsideModelFunction()
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
  discard g.g_signal_connect_data(p, "insert-prefix", cast[g.TGCallback](completionPrefixSignal),
    cast[pointer](d), nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(p, "cursor-on-match", cast[g.TGCallback](completionCursorSignal),
    cast[pointer](d), nil, g.TGConnectFlags(0))
proc items*(c: EntryCompletion): seq[string] =
  let d = completionData(c)
  for i in 0..<d.model.rowCount: result.add(d.model.value(i, 0).stringValue)
proc setItems*(c: EntryCompletion, items: openArray[string]) =
  let d = completionData(c)
  let model = completionModel(items) # Atomic validation/construction before replacement.
  cancelCompletionCommit(d)
  cancelCompletionInline(d)
  for binding in d.observers:
    let idle = binding.idle
    binding.idle = 0
    if idle != 0: discard g.g_source_remove(idle)
    binding.values = @[]
  d.model = model
  if d.matcher != nil: d.matcher.model = model
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
proc onInlineChanged*(c: EntryCompletion, fn: proc (value: CompletionInlineState) {.closure.}): CompletionInlineConnection {.discardable.} =
  let d = completionData(c)
  if fn == nil: raise newException(ValueError, "inline callback cannot be nil")
  var live: seq[RecentBinding[CompletionInlineState]]
  for previous in d.inlineObservers:
    if previous.active: live.add(previous)
  let binding = RecentBinding[CompletionInlineState](active: true, coalesce: true, fn: fn)
  GC_ref(binding)
  live.add(binding)
  d.inlineObservers = live
  CompletionInlineConnection(binding: binding)
proc inlineCompletion*(c: EntryCompletion): bool = completionData(c).inlineCompletion
proc `inlineCompletion=`*(c: EntryCompletion, enabled: bool) =
  let d = completionData(c)
  if d.inlineCompletion == enabled: return
  cancelCompletionCommit(d)
  cancelCompletionInline(d)
  d.inlineCompletion = enabled
  syncCompletionInline(d)
proc inlineSelection*(c: EntryCompletion): bool = completionData(c).inlineSelection
proc `inlineSelection=`*(c: EntryCompletion, enabled: bool) =
  let d = completionData(c)
  if d.inlineSelection == enabled: return
  cancelCompletionCommit(d)
  cancelCompletionInline(d)
  d.inlineSelection = enabled
  syncCompletionInline(d)
proc completionPrefix*(c: EntryCompletion): CompletionPrefix =
  discard completionData(c)
  let text = rawGtk.entry_completion_get_completion_prefix(c.raw)
  if text != nil: result = CompletionPrefix(available: true, text: $text)
proc insertPrefix*(c: EntryCompletion) =
  let d = completionData(c)
  if d.entry == nil or not d.inlineCompletion or
      not g.toBool(rawGtk.get_editable(cast[rawGtk.PEditable](d.entry))):
    raise newException(ValueError, "prefix insertion requires attached editable inline completion")
  let p = c.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  rawGtk.entry_completion_complete(p)
  rawGtk.entry_completion_insert_prefix(p)
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
  cancelCompletionCommit(d)
  cancelCompletionInline(d)
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
