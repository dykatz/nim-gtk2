# Included by gtk2.nim. Native icon configuration and copied deferred button events.
type
  EntryIconPosition* = enum iconPrimary, iconSecondary
  EntryIconEvent* = object
    position*: EntryIconPosition
    event*: ButtonEvent # Coordinates are relative to the icon's GdkWindow.
  EntryIconObserver = ref object
    active: bool
    fn: proc (value: EntryIconEvent) {.closure.}
  EntryIconConnection* = object
    observer: EntryIconObserver
  PendingEntryIcon = object
    value: EntryIconEvent
    generation: uint64
    listeners: seq[EntryIconObserver]
  EntryIconData = ref object
    p: rawGtk.PEntry # Weak. Qdata, native closures and sources pin only this data.
    active, updating: bool
    generations: array[2, uint64]
    observers: seq[EntryIconObserver]
    pending: seq[PendingEntryIcon]
    idle: g.guint
const entryIconKey = "nim-gtk2-entry-icons"
proc checkedIconPosition(pos: EntryIconPosition): rawGtk.TEntryIconPosition =
  if ord(pos) notin 0..1: raise newException(ValueError, "invalid entry icon position")
  rawGtk.TEntryIconPosition(ord(pos))
proc iconData(p: rawGtk.PEntry): EntryIconData =
  cast[EntryIconData](g.get_data(cast[g.PGObject](p), entryIconKey))
proc cancelEntryIcon(d: EntryIconData, pos: EntryIconPosition) =
  inc d.generations[ord(pos)]
  var live: seq[PendingEntryIcon]
  for event in d.pending:
    if event.value.position != pos: live.add(event)
  d.pending = move(live)
  if d.pending.len == 0 and d.idle != 0:
    let idle = d.idle
    d.idle = 0
    discard g.g_source_remove(idle)
proc deactivateEntryIcons(d: EntryIconData) =
  d.active = false
  d.p = nil
  let idle = d.idle
  d.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  d.pending = @[]
  let observers = move(d.observers)
  for observer in observers:
    observer.active = false
    observer.fn = nil
proc releaseEntryIconData(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let d = cast[EntryIconData](data)
    try: deactivateEntryIcons(d)
    except Exception as error: reportSignalError(error)
    finally: GC_unref(d)
proc releaseEntryIconHook(data: pointer, closure: g.PGClosure) {.cdecl, gcsafe.} =
  releaseEntryIconData(data) # Independent pin; never touch a finalizing widget.
proc releaseEntryIconIdle(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[EntryIconData](data))
proc connected*(connection: EntryIconConnection): bool =
  connection.observer != nil and connection.observer.active
proc disconnect*(connection: EntryIconConnection) =
  requireOutsideModelFunction()
  if connection.connected:
    connection.observer.active = false
    connection.observer.fn = nil
proc eligibleEntryIcon(p: rawGtk.PEntry, pos: rawGtk.TEntryIconPosition): bool =
  if not (g.toBool(rawGtk.is_sensitive(cast[rawGtk.PWidget](p))) and
      rawGtk.entry_get_icon_storage_type(p, pos) != rawGtk.IMAGE_EMPTY and
      g.toBool(rawGtk.entry_get_icon_sensitive(p, pos)) and
      g.toBool(rawGtk.entry_get_icon_activatable(p, pos))): return false
  # GTK2 can leave child widget mapped flags set when an ancestor window hides.
  # Public GdkWindow viewability catches that case without private popup/window
  # fields or a synthetic reset. Unrealized test emissions have no native window.
  let window = rawGtk.entry_get_icon_window(p, pos)
  window == nil or g.toBool(rawGdk.is_viewable(window))
proc dispatchEntryIcons(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    if modelFunctionDepth != 0: return g.gbool(true)
    let d = cast[EntryIconData](data)
    d.idle = 0
    let pending = move(d.pending)
    try:
      for item in pending:
        for observer in item.listeners:
          if not d.active or d.p == nil: return g.gbool(false)
          let pos = item.value.position
          if item.generation != d.generations[ord(pos)] or
              not eligibleEntryIcon(d.p, rawGtk.TEntryIconPosition(ord(pos))): break
          if observer.active:
            let fn = observer.fn
            try: fn(item.value)
            except Exception as error: reportSignalError(error)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc entryIconSignal(instance: pointer, pos: rawGtk.TEntryIconPosition,
    event: rawGdk.PEvent, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let d = cast[EntryIconData](data)
      if not d.active or d.updating or d.p == nil or ord(pos) notin 0..1 or event == nil: return
      if cast[rawGdk.PEventAny](event).type notin {rawGdk.BUTTON_PRESS, rawGdk.TWO_BUTTON_PRESS,
                          rawGdk.THREE_BUTTON_PRESS, rawGdk.BUTTON_RELEASE}: return
      if not eligibleEntryIcon(d.p, pos): return
      var pending = PendingEntryIcon(generation: d.generations[ord(pos)],
        value: EntryIconEvent(position: EntryIconPosition(ord(pos)), event: copyInput(event, ButtonEvent)))
      for observer in d.observers:
        if observer.active: pending.listeners.add(observer)
      if pending.listeners.len == 0: return
      d.pending.add(move(pending))
      if d.idle == 0:
        GC_ref(d)
        d.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchEntryIcons),
          cast[pointer](d), cast[pointer](releaseEntryIconIdle))
    except Exception as error: reportSignalError(error)
proc entryIconsDestroyed(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: deactivateEntryIcons(cast[EntryIconData](data))
    except Exception as error: reportSignalError(error)
proc entryIconsHidden(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let d = cast[EntryIconData](data)
      cancelEntryIcon(d, iconPrimary)
      cancelEntryIcon(d, iconSecondary)
    except Exception as error: reportSignalError(error)
proc onIconEvent*(entry: Entry, fn: proc (value: EntryIconEvent) {.closure.}): EntryIconConnection {.discardable.} =
  let p = entry.raw
  if fn == nil: raise newException(ValueError, "entry icon callback cannot be nil")
  var d = iconData(p)
  if d == nil:
    d = EntryIconData(p: p, active: true)
    GC_ref(d)
    g.set_data_full(cast[g.PGObject](p), entryIconKey, cast[pointer](d), releaseEntryIconData)
    for index, signal in ["icon-press", "icon-release", "destroy", "hide", "unmap"]:
      let callback = case index
        of 0, 1: cast[g.TGCallback](entryIconSignal)
        of 2: cast[g.TGCallback](entryIconsDestroyed)
        else: cast[g.TGCallback](entryIconsHidden)
      GC_ref(d)
      let id = g.g_signal_connect_data(p, signal.cstring, callback, cast[pointer](d),
        releaseEntryIconHook, g.TGConnectFlags(0))
      entry.state.handlers.add(id)
  if not d.active: raise newException(ValueError, "entry icon bridge was invalidated")
  var live: seq[EntryIconObserver]
  for observer in d.observers:
    if observer.active: live.add(observer)
  let observer = EntryIconObserver(active: true, fn: fn)
  live.add(observer)
  d.observers = move(live)
  EntryIconConnection(observer: observer)
# Configuration uses public APIs only. Pin across native notifications/capture
# cleanup; invalidate only this icon's queued events before changing its policy.
template mutateEntryIcon(p: rawGtk.PEntry, position: EntryIconPosition, body: untyped) =
  block:
    discard g.g_object_ref(p)
    defer: g.g_object_unref(p)
    let data = iconData(p)
    if data != nil:
      if data.updating: raise newException(ValueError, "recursive entry icon configuration is forbidden")
      cancelEntryIcon(data, position)
      data.updating = true
    defer:
      if data != nil: data.updating = false
    body
proc iconStorage*(entry: Entry, position: EntryIconPosition): ImageStorage =
  let p = entry.raw
  ImageStorage(ord(rawGtk.entry_get_icon_storage_type(p, checkedIconPosition(position))))
proc setIcon*(entry: Entry, position: EntryIconPosition, pixbuf: Pixbuf) =
  let p = entry.raw
  let pos = checkedIconPosition(position)
  let value = pixbuf.pixbufPointer
  mutateEntryIcon(p, position): rawGtk.entry_set_icon_from_pixbuf(p, pos, value)
proc setIconName*(entry: Entry, position: EntryIconPosition, name: string) =
  let p = entry.raw
  let pos = checkedIconPosition(position)
  let value = checkedUtf8Text(name)
  if name.len == 0: raise newException(ValueError, "icon name must be nonempty; use clearIcon")
  mutateEntryIcon(p, position): rawGtk.entry_set_icon_from_icon_name(p, pos, value)
proc clearIcon*(entry: Entry, position: EntryIconPosition) = entry.setIcon(position, Pixbuf())
proc iconPixbuf*(entry: Entry, position: EntryIconPosition): Pixbuf =
  let p = entry.raw
  let pos = checkedIconPosition(position)
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let value = rawGtk.entry_get_icon_pixbuf(p, pos)
  if value != nil: result = ownedPixbuf(value, borrowed = true)
proc iconName*(entry: Entry, position: EntryIconPosition): string =
  let p = entry.raw
  let pos = checkedIconPosition(position)
  let kind = rawGtk.entry_get_icon_storage_type(p, pos)
  if kind == rawGtk.IMAGE_EMPTY: return ""
  if kind != rawGtk.IMAGE_ICON_NAME: raise newException(ValueError, "entry icon is not a named icon")
  $rawGtk.entry_get_icon_name(p, pos)
proc iconSensitive*(entry: Entry, position: EntryIconPosition): bool =
  g.toBool(rawGtk.entry_get_icon_sensitive(entry.raw, checkedIconPosition(position)))
proc setIconSensitive*(entry: Entry, position: EntryIconPosition, value: bool) =
  let p = entry.raw
  let pos = checkedIconPosition(position)
  mutateEntryIcon(p, position): rawGtk.entry_set_icon_sensitive(p, pos, g.gbool(value))
proc iconActivatable*(entry: Entry, position: EntryIconPosition): bool =
  g.toBool(rawGtk.entry_get_icon_activatable(entry.raw, checkedIconPosition(position)))
proc setIconActivatable*(entry: Entry, position: EntryIconPosition, value: bool) =
  let p = entry.raw
  let pos = checkedIconPosition(position)
  mutateEntryIcon(p, position): rawGtk.entry_set_icon_activatable(p, pos, g.gbool(value))
proc setIconTooltip*(entry: Entry, position: EntryIconPosition, text: string) =
  let p = entry.raw
  let pos = checkedIconPosition(position)
  let value = checkedUtf8Text(text) # GTK treats empty plain text as removal.
  mutateEntryIcon(p, position): rawGtk.entry_set_icon_tooltip_text(p, pos, value)
proc iconTooltip*(entry: Entry, position: EntryIconPosition): string =
  let p = entry.raw
  let value = rawGtk.entry_get_icon_tooltip_text(p, checkedIconPosition(position))
  try: result = $value
  finally: g.g_free(value) # Transfer-full, unlike borrowed icon-name/pixbuf getters.
