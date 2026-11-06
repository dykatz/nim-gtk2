# Included by gtk2.nim. Anchors retain no buffer/view; GTK owns embedding slots.
type
  TextChildAnchor* = object of ObjectHandle
  AnchorDeletionBinding = ref object
    fn: proc () {.closure.}
    active: bool
    idle: g.guint
  AnchorConnection* = object
    binding: AnchorDeletionBinding
  AnchorBufferIdentity = ref object
    p: rawGtk.PTextBuffer # Weak, cleared by native weak notification.
    anchors: seq[pointer] # Weak AnchorMetadata pointers, removed at finalization.
  AnchorMetadata = ref object
    p: rawGtk.PTextChildAnchor # Weak; native qdata pins metadata.
    owner: AnchorBufferIdentity
    ready, notified: bool
    observers: seq[AnchorDeletionBinding]
const anchorIdentityKey = "nim-gtk2-anchor-buffer-identity"
const anchorMetadataKey = "nim-gtk2-text-child-anchor"
proc raw*(a: TextChildAnchor): rawGtk.PTextChildAnchor =
  cast[rawGtk.PTextChildAnchor](nativePointer(a))
proc connected*(c: AnchorConnection): bool = c.binding != nil and c.binding.active
proc releaseAnchorIdle(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[AnchorDeletionBinding](data))
proc cancelAnchorBinding(binding: AnchorDeletionBinding) =
  if not binding.active: return
  binding.active = false
  let idle = binding.idle
  binding.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  binding.fn = nil
  GC_unref(binding)
proc disconnect*(c: AnchorConnection) =
  requireOutsideModelFunction()
  if c.connected: cancelAnchorBinding(c.binding)
proc dispatchAnchorDeletion(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[AnchorDeletionBinding](data)
    binding.idle = 0
    if binding.active:
      binding.active = false
      let fn = move(binding.fn)
      GC_unref(binding) # Creation pin; source still owns its separate pin.
      try: fn()
      except Exception as error: reportSignalError(error)
    g.gbool(false)
proc queueAnchorDeletion(binding: AnchorDeletionBinding) =
  if not binding.active or binding.idle != 0: return
  GC_ref(binding)
  binding.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE,
    cast[pointer](dispatchAnchorDeletion), cast[pointer](binding), cast[pointer](releaseAnchorIdle))
proc metadataDeleted(meta: AnchorMetadata): bool =
  meta.owner.p == nil or (meta.ready and g.toBool(rawGtk.anchor_get_deleted(meta.p)))
proc notifyAnchorDeletion(meta: AnchorMetadata) =
  if meta.notified or not metadataDeleted(meta): return
  meta.notified = true
  for binding in meta.observers: queueAnchorDeletion(binding)
proc pollAnchorBuffer(owner: AnchorBufferIdentity) =
  # Polling calls only public getters, never application code or event iteration.
  let anchors = owner.anchors
  for p in anchors: notifyAnchorDeletion(cast[AnchorMetadata](p))
proc anchorBufferChanged(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: pollAnchorBuffer(cast[AnchorBufferIdentity](data))
    except Exception as error: reportSignalError(error)
proc anchorBufferGone(data: pointer, obj: g.PGObject) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let owner = cast[AnchorBufferIdentity](data)
    owner.p = nil
    try: pollAnchorBuffer(owner)
    except Exception as error: reportSignalError(error)
    finally: GC_unref(owner)
proc releaseAnchorBufferSignal(data: pointer, closure: g.PGClosure) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[AnchorBufferIdentity](data))
proc anchorBufferIdentity(p: rawGtk.PTextBuffer): AnchorBufferIdentity =
  result = cast[AnchorBufferIdentity](g.get_data(cast[g.PGObject](p), anchorIdentityKey))
  if result != nil: return
  result = AnchorBufferIdentity(p: p)
  # One native weak-notify pin and a separate native signal-data pin. Neither
  # holds a reference to the buffer. qdata is a borrowed identity lookup only.
  GC_ref(result)
  g.weak_ref(cast[g.PGObject](p), anchorBufferGone, cast[pointer](result))
  GC_ref(result)
  discard g.g_signal_connect_data(p, "changed", cast[g.TGCallback](anchorBufferChanged),
    cast[pointer](result), releaseAnchorBufferSignal, g.G_CONNECT_AFTER)
  g.set_data(cast[g.PGObject](p), anchorIdentityKey, cast[pointer](result))
proc releaseAnchorMetadata(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let meta = cast[AnchorMetadata](data)
    for i, p in meta.owner.anchors:
      if p == data:
        meta.owner.anchors.delete(i)
        break
    for binding in meta.observers: cancelAnchorBinding(binding)
    meta.observers = @[]
    GC_unref(meta)
proc anchorMetadata(a: TextChildAnchor): AnchorMetadata =
  result = cast[AnchorMetadata](g.get_data(cast[g.PGObject](a.raw), anchorMetadataKey))
  if result == nil: raise newException(ValueError, "anchor is not an SDK buffer-bound anchor")
proc deleted*(a: TextChildAnchor): bool =
  if a.isDestroyed: return true
  metadataDeleted(anchorMetadata(a))
proc checkAnchor(b: TextBuffer, a: TextChildAnchor): AnchorMetadata =
  result = anchorMetadata(a)
  if result.owner.p != b.raw or metadataDeleted(result):
    raise newException(ValueError, "anchor is deleted or belongs to another buffer")
proc createChildAnchor*(b: TextBuffer, offset: int): TextChildAnchor =
  var iter = bufferIter(b, offset)
  let buffer = b.raw
  discard g.g_object_ref(buffer)
  defer: g.g_object_unref(buffer)
  # Do not use GTK's borrowed create_child_anchor return: a changed observer may
  # immediately delete it. Own new() BEFORE insertion and keep that reference.
  let p = rawGtk.text_child_anchor_new()
  result.state = adoptObject(p, cache = true, hasDestroySignal = false, sink = false)
  let meta = AnchorMetadata(p: p, owner: anchorBufferIdentity(buffer))
  GC_ref(meta)
  meta.owner.anchors.add(cast[pointer](meta))
  g.set_data_full(cast[g.PGObject](p), anchorMetadataKey, cast[pointer](meta), releaseAnchorMetadata)
  rawGtk.insert_child_anchor(buffer, addr iter, p)
  meta.ready = true
  notifyAnchorDeletion(meta)
proc childAnchorAt*(b: TextBuffer, offset: int): TextChildAnchor =
  var iter = bufferIter(b, offset)
  let p = rawGtk.get_child_anchor(addr iter)
  if p == nil: return
  let meta = cast[AnchorMetadata](g.get_data(cast[g.PGObject](p), anchorMetadataKey))
  if meta == nil or meta.owner.p != b.raw:
    raise newException(ValueError, "buffer contains an anchor not created by the SDK")
  meta.ready = true # Native iterator proves this anchor has already been inserted.
  result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false)
proc buffer*(a: TextChildAnchor): TextBuffer =
  let meta = anchorMetadata(a)
  if metadataDeleted(meta): raise newException(ValueError, "anchor is deleted")
  ownedTextBuffer(meta.owner.p)
proc offset*(a: TextChildAnchor): int =
  let meta = anchorMetadata(a)
  if metadataDeleted(meta): raise newException(ValueError, "anchor is deleted")
  var iter: rawGtk.TTextIter
  rawGtk.get_iter_at_child_anchor(meta.owner.p, addr iter, a.raw)
  rawGtk.get_offset(addr iter).int
proc deleteAnchor*(b: TextBuffer, a: TextChildAnchor) =
  discard checkAnchor(b, a)
  let offset = a.offset
  let p = b.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  b.deleteRange(offset, offset + 1)
proc onDeleted*(a: TextChildAnchor, fn: proc () {.closure.}): AnchorConnection {.discardable.} =
  let meta = anchorMetadata(a)
  if fn == nil: raise newException(ValueError, "anchor callback cannot be nil")
  var live: seq[AnchorDeletionBinding]
  for previous in meta.observers:
    if previous.active: live.add(previous)
  let binding = AnchorDeletionBinding(active: true, fn: fn)
  GC_ref(binding)
  live.add(binding)
  meta.observers = live
  if metadataDeleted(meta): queueAnchorDeletion(binding)
  AnchorConnection(binding: binding)
proc disconnectSignals*(a: TextChildAnchor) =
  let meta = anchorMetadata(a)
  for binding in meta.observers: cancelAnchorBinding(binding)
  meta.observers = @[]
  disconnectObjectSignals(a)
proc widgets*(a: TextChildAnchor): seq[Widget] =
  if a.isDestroyed: return
  let meta = anchorMetadata(a)
  if metadataDeleted(meta): return
  let list = rawGtk.anchor_get_widgets(a.raw)
  defer: g.free(list) # Transfer-container: individual widgets are borrowed.
  var node = list
  while node != nil:
    result.add(Widget(state: adoptObject(node.data, borrowed = true, cache = true)))
    node = node.next
proc addChildAtAnchor*(w: TextView, child: Widget, a: TextChildAnchor) =
  let view = w.raw
  let buffer = w.buffer
  discard checkAnchor(buffer, a)
  checkChild(w, child)
  for existing in a.widgets:
    if rawGtk.get_parent(existing.raw) == cast[rawGtk.PWidget](view):
      raise newException(ValueError, "this anchor already has a widget in this text view")
  rawGtk.add_child_at_anchor(view, child.raw, a.raw)
