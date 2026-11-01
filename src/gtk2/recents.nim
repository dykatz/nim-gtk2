# Included by gtk2.nim. GTK2 recent-resource models, filters and single choosers.
type
  RecentManager* = object of ObjectHandle
  RecentFilter* = object of ObjectHandle
  RecentChooserWidget* = object of VBox
  RecentChooserMenu* = object of Menu
  RecentChooserDialog* = object of Dialog
  RecentSort* = enum
    recentUnsorted, recentMostRecent, recentLeastRecent
  RecentItem* = object
    ## Copied metadata, NOT a GObject/RecentInfo pointer or permission to open it.
    uri*, displayName*, description*, mimeType*: string
    shortName*, uriDisplay*, lastApplication*: string
    applications*, groups*: seq[string]
    age*: int
    isPrivate*, isLocal*: bool
  RecentError* = object of CatchableError
    domain*: uint32
    code*: int
  RecentChooserLike = RecentChooserWidget | RecentChooserMenu | RecentChooserDialog
  RecentPanelLike = RecentChooserWidget | RecentChooserDialog

proc raw*(m: RecentManager): ptr rawGtk.RecentManager = cast[ptr rawGtk.RecentManager](nativePointer(m))
proc raw*(f: RecentFilter): ptr rawGtk.RecentFilter = cast[ptr rawGtk.RecentFilter](nativePointer(f))
proc raw*(w: RecentChooserWidget): ptr rawGtk.RecentChooserWidget = cast[ptr rawGtk.RecentChooserWidget](raw(Widget(w)))
proc raw*(w: RecentChooserMenu): ptr rawGtk.RecentChooserMenu = cast[ptr rawGtk.RecentChooserMenu](raw(Widget(w)))
proc raw*(w: RecentChooserDialog): ptr rawGtk.RecentChooserDialog = cast[ptr rawGtk.RecentChooserDialog](raw(Widget(w)))
proc recentChooser(w: RecentChooserLike): ptr rawGtk.RecentChooser = cast[ptr rawGtk.RecentChooser](raw(Widget(w)))
proc isEmpty*(item: RecentItem): bool = item.uri.len == 0
proc isEmpty*(f: RecentFilter): bool = f.state == nil
proc checkRecentResult(ok: g.gboolean, error: ptr g.GError) =
  if error != nil:
    let failure = newException(RecentError, $error.message)
    failure.domain = error.domain
    failure.code = error.code.int
    g.g_error_free(error)
    raise failure
  if not g.toBool(ok): raise newException(RecentError, "GTK recent-resource operation failed")
proc ownedRecentManager(p: ptr rawGtk.RecentManager, borrowed = false): RecentManager =
  result.state = adoptObject(p, borrowed = borrowed, cache = true, hasDestroySignal = false, sink = false)
proc newRecentManager*(filename: string): RecentManager =
  let path = checkedChooserFilename(filename)
  if g.toBool(g.g_file_test(path, g.G_FILE_TEST_IS_DIR)):
    raise newException(ValueError, "recent manager storage must be a file, not a directory")
  ownedRecentManager(cast[ptr rawGtk.RecentManager](g.g_object_new(rawGtk.recent_manager_get_type(),
    "filename", path, nil)))
proc defaultRecentManager*(): RecentManager = ownedRecentManager(rawGtk.recent_manager_get_default(), borrowed = true)
proc filename*(m: RecentManager): string =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_STRING)
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](m.raw), "filename", addr value)
  $g.get_string(addr value)
proc disconnectSignals*(m: RecentManager) = disconnectObjectSignals(m)
proc recentText(value: string): cstring =
  result = checkedUtf8Text(value)
  if value.len == 0: raise newException(ValueError, "recent metadata field cannot be empty")
proc addItem*(m: RecentManager, uri, mimeType, appName, appExec: string,
              displayName = "", description = "", groups: openArray[string] = [],
              isPrivate = false): bool {.discardable.} =
  let location = checkedChooserUri(uri)
  let mime = recentText(mimeType)
  let app = recentText(appName)
  let command = recentText(appExec)
  let title = checkedUtf8Text(displayName)
  let desc = checkedUtf8Text(description)
  var nativeGroups: seq[cstring]
  for group in groups: nativeGroups.add(recentText(group))
  nativeGroups.add(nil)
  var data = rawGtk.RecentData(display_name: (if displayName.len == 0: nil else: title),
    description: (if description.len == 0: nil else: desc), mime_type: mime,
    app_name: app, app_exec: command, groups: addr nativeGroups[0], is_private: g.gbool(isPrivate))
  g.toBool(rawGtk.recent_manager_add_full(m.raw, location, addr data))
proc hasItem*(m: RecentManager, uri: string): bool =
  g.toBool(rawGtk.recent_manager_has_item(m.raw, checkedChooserUri(uri)))
proc removeItem*(m: RecentManager, uri: string) =
  var error: ptr g.GError
  let ok = rawGtk.recent_manager_remove_item(m.raw, checkedChooserUri(uri), addr error)
  checkRecentResult(ok, error)
proc moveItem*(m: RecentManager, uri, newUri: string) =
  let oldLocation = checkedChooserUri(uri)
  let newLocation = checkedChooserUri(newUri)
  var error: ptr g.GError
  let ok = rawGtk.recent_manager_move_item(m.raw, oldLocation, newLocation, addr error)
  checkRecentResult(ok, error)
proc purgeItems*(m: RecentManager): int =
  var error: ptr g.GError
  let count = rawGtk.recent_manager_purge_items(m.raw, addr error)
  checkRecentResult(g.gbool(count >= 0), error)
  count.int
proc copiedRecentVector(values: ptr cstring, length: g.gsize): seq[string] =
  defer: g.g_strfreev(values)
  if length > g.gsize(high(int)): raise newException(ValueError, "recent string vector is too large")
  let entries = cast[ptr UncheckedArray[cstring]](values)
  for i in 0..<int(length): result.add($entries[i])
proc copyRecentItem(p: ptr rawGtk.RecentInfo): RecentItem =
  if p == nil: return
  result.uri = $rawGtk.recent_info_get_uri(p)
  result.displayName = $rawGtk.recent_info_get_display_name(p)
  result.description = $rawGtk.recent_info_get_description(p)
  result.mimeType = $rawGtk.recent_info_get_mime_type(p)
  result.shortName = copiedFileText(rawGtk.recent_info_get_short_name(p))
  result.uriDisplay = copiedFileText(rawGtk.recent_info_get_uri_display(p))
  result.lastApplication = copiedFileText(rawGtk.recent_info_last_application(p))
  result.age = rawGtk.recent_info_get_age(p).int
  result.isPrivate = g.toBool(rawGtk.recent_info_get_private_hint(p))
  result.isLocal = g.toBool(rawGtk.recent_info_is_local(p))
  var length: g.gsize
  let apps = rawGtk.recent_info_get_applications(p, addr length)
  result.applications = copiedRecentVector(apps, length)
  let groups = rawGtk.recent_info_get_groups(p, addr length)
  result.groups = copiedRecentVector(groups, length)
proc copiedRecentItems(list: g.PGList): seq[RecentItem] =
  defer:
    var node = list
    while node != nil:
      rawGtk.recent_info_unref(cast[ptr rawGtk.RecentInfo](node.data))
      node = node.next
    g.free(list)
  var node = list
  while node != nil:
    result.add(copyRecentItem(cast[ptr rawGtk.RecentInfo](node.data)))
    node = node.next
proc items*(m: RecentManager): seq[RecentItem] = copiedRecentItems(rawGtk.recent_manager_get_items(m.raw))
proc lookupItem*(m: RecentManager, uri: string): RecentItem =
  var error: ptr g.GError
  let info = rawGtk.recent_manager_lookup_item(m.raw, checkedChooserUri(uri), addr error)
  defer:
    if info != nil: rawGtk.recent_info_unref(info)
  checkRecentResult(g.gbool(info != nil), error)
  copyRecentItem(info)

proc ownedRecentFilter(p: ptr rawGtk.RecentFilter, borrowed = true): RecentFilter =
  if p != nil: result.state = adoptObject(p, borrowed = borrowed, cache = true)
proc destroy*(f: RecentFilter) =
  if not f.isDestroyed: rawGtk.destroy(cast[rawGtk.PObject](f.raw))
proc name*(f: RecentFilter): string = $rawGtk.recent_filter_get_name(f.raw)
proc `name=`*(f: RecentFilter, value: string) = rawGtk.recent_filter_set_name(f.raw, checkedUtf8Text(value))
proc addPattern*(f: RecentFilter, value: string) = rawGtk.recent_filter_add_pattern(f.raw, checkedFilterRule(value))
proc addMimeType*(f: RecentFilter, value: string) = rawGtk.recent_filter_add_mime_type(f.raw, checkedFilterRule(value))
proc addApplication*(f: RecentFilter, value: string) = rawGtk.recent_filter_add_application(f.raw, recentText(value))
proc addGroup*(f: RecentFilter, value: string) = rawGtk.recent_filter_add_group(f.raw, recentText(value))
proc addAge*(f: RecentFilter, days: int) = rawGtk.recent_filter_add_age(f.raw, checkedInt(days))
proc addPixbufFormats*(f: RecentFilter) = rawGtk.recent_filter_add_pixbuf_formats(f.raw)
proc newRecentFilter*(name = "", patterns: openArray[string] = []): RecentFilter =
  let label = checkedUtf8Text(name)
  for pattern in patterns: discard checkedFilterRule(pattern)
  result = ownedRecentFilter(rawGtk.recent_filter_new(), borrowed = false)
  rawGtk.recent_filter_set_name(result.raw, label)
  for pattern in patterns: result.addPattern(pattern)

proc items*(w: RecentChooserLike): seq[RecentItem] =
  ## All eligible items after filtering/sorting/limit, NOT selected items.
  copiedRecentItems(rawGtk.recent_chooser_get_items(recentChooser(w)))
proc currentUri*(w: RecentChooserLike): string = copiedFileText(rawGtk.recent_chooser_get_current_uri(recentChooser(w)))
proc readRecentItem(p: ptr rawGtk.RecentChooser): RecentItem =
  let info = rawGtk.recent_chooser_get_current_item(p)
  if info != nil:
    try: result = copyRecentItem(info)
    finally: rawGtk.recent_info_unref(info)
proc currentItem*(w: RecentChooserLike): RecentItem = readRecentItem(recentChooser(w))
proc selectUri*(w: RecentPanelLike, uri: string) =
  var error: ptr g.GError
  let ok = rawGtk.recent_chooser_select_uri(recentChooser(w), checkedChooserUri(uri), addr error)
  checkRecentResult(ok, error)
proc activateUri*(w: RecentPanelLike, uri: string) =
  # GTK2 set_current_uri emits activation BEFORE selecting the row. Select first
  # so both dialog responses and action observers see the intended target.
  w.selectUri(uri)
  var error: ptr g.GError
  let ok = rawGtk.recent_chooser_set_current_uri(recentChooser(w), checkedChooserUri(uri), addr error)
  checkRecentResult(ok, error)
proc unselectUri*(w: RecentPanelLike, uri: string) = rawGtk.recent_chooser_unselect_uri(recentChooser(w), checkedChooserUri(uri))
proc unselectAll*(w: RecentPanelLike) = rawGtk.recent_chooser_unselect_all(recentChooser(w))
proc selectMultiple*(w: RecentChooserLike): bool = g.toBool(rawGtk.recent_chooser_get_select_multiple(recentChooser(w)))
proc `selectMultiple=`*(w: RecentChooserLike, value: bool) =
  discard recentChooser(w)
  if value: raise newException(ValueError, "recent choosers support single selection in this API; native get_items/get_uris are NOT selected rows")
  when w isnot RecentChooserMenu:
    rawGtk.recent_chooser_set_select_multiple(recentChooser(w), g.gbool(false))
proc refresh*(w: RecentChooserMenu) =
  # Several native menu property setters don't rebuild existing rows. Reapply
  # the nullable public filter property, retaining it through the replacement.
  var value: g.TGValue
  discard g.init(addr value, rawGtk.recent_filter_get_type())
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](w.raw), "filter", addr value)
  g.set_property(cast[g.PGObject](w.raw), "filter", addr value)
proc limit*(w: RecentChooserLike): int = rawGtk.recent_chooser_get_limit(recentChooser(w)).int
proc `limit=`*(w: RecentChooserLike, value: int) =
  if value < -1 or value > high(g.gint).int: raise newException(ValueError, "recent limit must be -1 or a nonnegative gint")
  rawGtk.recent_chooser_set_limit(recentChooser(w), g.gint(value))
  when w is RecentChooserMenu: w.refresh()
proc sortOrder*(w: RecentChooserLike): RecentSort = RecentSort(cint(rawGtk.recent_chooser_get_sort_type(recentChooser(w))))
proc `sortOrder=`*(w: RecentChooserLike, value: RecentSort) =
  rawGtk.recent_chooser_set_sort_type(recentChooser(w), rawGtk.RecentSortType(ord(value)))
  when w is RecentChooserMenu: w.refresh()
template recentBoolProperty(name, setterName, getter, setter: untyped) =
  proc name*(w: RecentChooserLike): bool = g.toBool(getter(recentChooser(w)))
  proc setterName*(w: RecentChooserLike, value: bool) =
    setter(recentChooser(w), g.gbool(value))
    when w is RecentChooserMenu: w.refresh()
recentBoolProperty(showPrivate, `showPrivate=`, rawGtk.recent_chooser_get_show_private, rawGtk.recent_chooser_set_show_private)
recentBoolProperty(showNotFound, `showNotFound=`, rawGtk.recent_chooser_get_show_not_found, rawGtk.recent_chooser_set_show_not_found)
recentBoolProperty(localOnly, `localOnly=`, rawGtk.recent_chooser_get_local_only, rawGtk.recent_chooser_set_local_only)
recentBoolProperty(showTips, `showTips=`, rawGtk.recent_chooser_get_show_tips, rawGtk.recent_chooser_set_show_tips)
recentBoolProperty(showIcons, `showIcons=`, rawGtk.recent_chooser_get_show_icons, rawGtk.recent_chooser_set_show_icons)
proc showNumbers*(w: RecentChooserMenu): bool = g.toBool(rawGtk.recent_chooser_menu_get_show_numbers(w.raw))
proc `showNumbers=`*(w: RecentChooserMenu, value: bool) =
  rawGtk.recent_chooser_menu_set_show_numbers(w.raw, g.gbool(value))
  w.refresh()
proc filters*(w: RecentChooserLike): seq[RecentFilter] =
  let list = rawGtk.recent_chooser_list_filters(recentChooser(w))
  defer: g.free(list)
  var node = list
  while node != nil:
    result.add(ownedRecentFilter(cast[ptr rawGtk.RecentFilter](node.data)))
    node = node.next
proc filter*(w: RecentChooserLike): RecentFilter = ownedRecentFilter(rawGtk.recent_chooser_get_filter(recentChooser(w)))
proc hasRecentFilter(w: RecentChooserLike, f: RecentFilter): bool =
  let p = f.raw
  for candidate in w.filters:
    if candidate.raw == p: return true
proc `filter=`*(w: RecentChooserLike, value: RecentFilter) =
  let p = value.raw
  if not w.filter.isEmpty and w.filter.raw == p: return
  when w isnot RecentChooserMenu:
    if not hasRecentFilter(w, value): raise newException(ValueError, "add the recent filter before selecting it")
  rawGtk.recent_chooser_set_filter(recentChooser(w), p)
proc addFilter*(w: RecentChooserLike, value: RecentFilter) =
  if hasRecentFilter(w, value): raise newException(ValueError, "recent filter is already in chooser")
  when w is RecentChooserMenu:
    if not w.filter.isEmpty: raise newException(ValueError, "recent menus have one filter slot; assign filter to replace it")
  rawGtk.recent_chooser_add_filter(recentChooser(w), value.raw)
proc removeFilter*(w: RecentChooserLike, value: RecentFilter) =
  if not hasRecentFilter(w, value): raise newException(ValueError, "recent filter is not in chooser")
  when w is RecentChooserMenu:
    # GTK2 remove_filter clears the slot without repopulating the menu. Setting
    # its nullable GObject property instead performs the necessary refresh.
    var native: g.TGValue
    discard g.init(addr native, rawGtk.recent_filter_get_type())
    defer: g.unset(addr native)
    g.set_object(addr native, nil)
    g.set_property(cast[g.PGObject](w.raw), "filter", addr native)
  else: rawGtk.recent_chooser_remove_filter(recentChooser(w), value.raw)

const recentManagerKey = "nim-gtk2-recent-manager-owner"
proc releaseRecentManager(data: pointer) {.cdecl.} = g.g_object_unref(data)
proc keepRecentManager(w: Widget, m: RecentManager) =
  # Native GTK2 choosers BORROW their manager. Retain it until widget native
  # finalization, after delegate disposal disconnects the manager's signals.
  g.set_data_full(cast[g.PGObject](w.raw), recentManagerKey, g.g_object_ref(m.raw), releaseRecentManager)
proc manager*(w: RecentChooserLike): RecentManager =
  ownedRecentManager(cast[ptr rawGtk.RecentManager](g.get_data(cast[g.PGObject](w.raw), recentManagerKey)), borrowed = true)
proc resolvedRecentManager(m: RecentManager): RecentManager =
  if m.state == nil: defaultRecentManager() else: m
proc newRecentChooserWidget*(manager = RecentManager()): RecentChooserWidget =
  let m = resolvedRecentManager(manager)
  result.state = adoptWidget(rawGtk.recent_chooser_widget_new_for_manager(m.raw))
  keepRecentManager(result, m)
proc newRecentChooserMenu*(manager = RecentManager()): RecentChooserMenu =
  let m = resolvedRecentManager(manager)
  result.state = adoptWidget(rawGtk.recent_chooser_menu_new_for_manager(m.raw))
  keepRecentManager(result, m)
proc `title=`*(w: RecentChooserDialog, value: string) = rawGtk.set_title(cast[rawGtk.PWindow](w.raw), checkedUtf8Text(value))
proc newRecentChooserDialog*(title = "Recent items", manager = RecentManager(), modal = false): RecentChooserDialog =
  let caption = checkedUtf8Text(title)
  let m = resolvedRecentManager(manager)
  result.state = adoptWidget(rawGtk.recent_chooser_dialog_new_for_manager(caption, nil, m.raw, nil))
  keepRecentManager(result, m)
  result.modal = modal
  discard Dialog(result).addButton("gtk-cancel", responseCancel)
  discard Dialog(result).addButton("gtk-open", responseAccept)
  result.defaultResponse = responseAccept
proc newRecentChooserDialog*(parent: Window, title = "Recent items", manager = RecentManager(),
                             modal = false, destroyWithParent = true): RecentChooserDialog =
  discard parent.raw
  result = newRecentChooserDialog(title, manager, modal)
  attachDialogParent(result, parent, destroyWithParent)

# Snapshot signals are copied inside native emission but delivered at idle, so
# user closures cannot destroy GTK objects still in use by native handlers.
type
  RecentResponse = tuple[id: ResponseId, item: RecentItem]
  RecentBinding[T] = ref object
    fn: proc (value: T) {.closure.}
    values: seq[T]
    last: T
    active, coalesce, dedup: bool
    idle: g.guint
proc releaseRecentIdle[T](data: pointer) {.cdecl.} = GC_unref(cast[RecentBinding[T]](data))
proc releaseRecentBinding[T](data: pointer, closure: g.PGClosure) {.cdecl.} =
  let binding = cast[RecentBinding[T]](data)
  binding.active = false
  let idle = binding.idle
  binding.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  binding.fn = nil
  binding.values = @[]
  GC_unref(binding)
proc dispatchRecent[T](data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[RecentBinding[T]](data)
    if binding.active and binding.values.len > 0:
      let value = binding.values[0]
      binding.values.delete(0)
      if not binding.dedup or value != binding.last:
        if binding.dedup: binding.last = value
        let fn = binding.fn
        try: fn(value)
        except Exception as error: reportSignalError(error)
    if not binding.active or binding.values.len == 0:
      binding.idle = 0
      return g.gbool(false)
    g.gbool(true)
proc queueRecent[T](data: pointer, value: T) =
  let binding = cast[RecentBinding[T]](data)
  if not binding.active: return
  if binding.coalesce: binding.values.setLen(0)
  binding.values.add(value)
  if binding.idle == 0:
    GC_ref(binding)
    binding.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchRecent[T]),
      cast[pointer](binding), cast[pointer](releaseRecentIdle[T]))
proc recentItemThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: queueRecent(data, readRecentItem(cast[ptr rawGtk.RecentChooser](instance)))
    except Exception as error: reportSignalError(error)
proc recentResponseThunk(instance: pointer, id: g.gint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let value: RecentResponse = (id: ResponseId(id), item: readRecentItem(cast[ptr rawGtk.RecentChooser](instance)))
      queueRecent(data, value)
    except Exception as error: reportSignalError(error)
proc recentManagerThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueRecent(data, true)
proc connectRecent[T](w: ObjectHandle, signal: cstring, fn: proc (value: T) {.closure.},
                       thunk: g.TGCallback, coalesce = false, dedup = false, last = default(T)): Connection =
  let p = nativePointer(w)
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let binding = RecentBinding[T](fn: fn, active: true, coalesce: coalesce, dedup: dedup, last: last)
  GC_ref(binding)
  let id = g.g_signal_connect_data(p, signal, thunk, cast[pointer](binding), releaseRecentBinding[T], g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
proc onChanged*(m: RecentManager, fn: proc () {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectRecent(m, "changed", proc (unused: bool) = fn(), cast[g.TGCallback](recentManagerThunk), coalesce = true)
proc onSelectionChanged*(w: RecentPanelLike, fn: proc (item: RecentItem) {.closure.}): Connection {.discardable.} =
  connectRecent(w, "selection-changed", fn, cast[g.TGCallback](recentItemThunk), coalesce = true, dedup = true, last = w.currentItem)
proc onItemActivated*(w: RecentChooserLike, fn: proc (item: RecentItem) {.closure.}): Connection {.discardable.} =
  connectRecent(w, "item-activated", fn, cast[g.TGCallback](recentItemThunk))
proc onResponse*(w: RecentChooserDialog, fn: proc (id: ResponseId, item: RecentItem) {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectRecent(w, "response", proc (value: RecentResponse) = fn(value.id, value.item), cast[g.TGCallback](recentResponseThunk))
proc connectRecentResponse(w: Widget, fn: proc (id: ResponseId) {.closure.}): Connection =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectRecent(w, "response", proc (value: RecentResponse) = fn(value.id), cast[g.TGCallback](recentResponseThunk))
