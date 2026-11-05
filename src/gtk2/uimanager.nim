# Included by gtk2.nim. Fixed command schema, removable native UI merges.
type
  UIManagerError* = object of CatchableError
    domain*: uint32
    code*: int32
  MergeIdentity = ref object
  UIMerge* = object
    owner: MergeIdentity
    id: g.guint
  UIManagerBookObj = object
    owner: ObjectHandle
    identity: MergeIdentity
    groups: seq[ActionGroup]
    shortcuts: AccelGroup
    windows: seq[Window]
    widgets: seq[Widget]
    merges: seq[g.guint]
    closed, busy, closeRequested: bool
  UIManagerBook = ref UIManagerBookObj
  UIManager* = object
    book: UIManagerBook
proc closeManager(book: var UIManagerBookObj)
proc `=destroy`(book: var UIManagerBookObj) =
  try: closeManager(book)
  except Exception as error: reportSignalError(error)
  `=destroy`(book.owner)
  `=destroy`(book.identity)
  `=destroy`(book.groups)
  `=destroy`(book.shortcuts)
  `=destroy`(book.windows)
  `=destroy`(book.widgets)
  `=destroy`(book.merges)
proc closed*(ui: UIManager): bool = ui.book == nil or ui.book.closed or ui.book.closeRequested
proc raw*(ui: UIManager): rawGtk.PUIManager =
  if ui.closed: raise newException(ValueError, "UIManager is closed or uninitialized")
  if ui.book.busy: raise newException(ValueError, "UIManager is updating; defer reentrant access")
  cast[rawGtk.PUIManager](nativePointer(ui.book.owner))
proc closeManager(book: var UIManagerBookObj) =
  if book.closed: return
  if book.busy:
    book.closeRequested = true
    return
  book.closed = true
  book.closeRequested = false
  if book.owner.state == nil: return
  let p = cast[rawGtk.PUIManager](book.owner.state.p)
  for group in book.groups: group.disconnectSignals()
  book.shortcuts.clearShortcuts()
  for window in book.windows:
    if not window.isDestroyed: book.shortcuts.detach(window)
  book.windows = @[]
  for id in book.merges: rawGtk.ui_manager_remove_ui(p, id)
  book.merges = @[]
  rawGtk.ui_manager_ensure_update(p) # Native removal destroys proxies even when parented.
  for widget in book.widgets: widget.destroy()
  book.widgets = @[]
  for group in book.groups:
    rawGtk.ui_manager_remove_action_group(p, group.raw)
    for a in group.members.items: rawGtk.action_set_accel_group(a.raw, nil)
    group.members.manager = nil
    g.set_data(cast[g.PGObject](group.raw), "nim-gtk2-ui-manager", nil)
  rawGtk.ui_manager_ensure_update(p) # Drain the native dirty-tree source before finalization.
  book.groups = @[]
  book.shortcuts = AccelGroup()
  book.owner = ObjectHandle()
proc close*(ui: UIManager) =
  if ui.book != nil:
    let book = ui.book
    GC_ref(book)
    try: closeManager(book[])
    finally: GC_unref(book)
proc retainManagedWidget(book: UIManagerBook, p: rawGtk.PWidget): ObjectState =
  result = adoptObject(p, borrowed = true, cache = true)
  for widget in book.widgets:
    if widget.state == result: return
  book.widgets.add(Widget(state: result))
proc ensureUpdate*(ui: UIManager) =
  let p = ui.raw
  let book = ui.book
  GC_ref(book) # A synchronous destroy observer can drop the caller's last handle.
  book.busy = true
  try:
    rawGtk.ui_manager_ensure_update(p)
    var live: seq[Widget]
    for widget in book.widgets:
      if not widget.isDestroyed: live.add(widget)
    book.widgets = live
    let list = rawGtk.ui_manager_get_toplevels(p, cast[rawGtk.TUIManagerItemType](cint(1 or 4 or 16)))
    defer: g.free(list)
    var node = list
    while node != nil:
      discard retainManagedWidget(book, cast[rawGtk.PWidget](node.data))
      node = node.next
    for group in book.groups:
      for a in group.members.items:
        var proxy = rawGtk.action_get_proxies(a.raw)
        while proxy != nil:
          rawGtk.set_no_show_all(cast[rawGtk.PWidget](proxy.data), g.gbool(true))
          proxy = proxy.next
        let closure = rawGtk.action_get_accel_closure(a.raw)
        syncCommandLabels(a, rawGtk.accel_group_from_accel_closure(closure) != nil)
  finally:
    book.busy = false
    try:
      if book.closeRequested: closeManager(book[])
    finally: GC_unref(book)
proc newUIManager*(groups: openArray[ActionGroup], tearoffs = false): UIManager =
  for i, group in groups:
    discard group.raw
    if group.members.manager != nil: raise newException(ValueError, "action group already belongs to a UIManager")
    for j in 0..<i:
      if groups[j].name == group.name: raise newException(ValueError, "UIManager group names must be unique")
    for a in group.members.items:
      if rawGtk.action_get_accel_path(a.raw) != nil or
          rawGtk.accel_group_from_accel_closure(rawGtk.action_get_accel_closure(a.raw)) != nil:
        raise newException(ValueError, "unbind existing command shortcuts/paths before UIManager registration")
      for j in 0..<i:
        if rawGtk.action_group_get_action(groups[j].raw, a.name.cstring) != nil:
          raise newException(ValueError, "UIManager command names must be unique")
  let p = rawGtk.ui_manager_new()
  result.book = UIManagerBook(owner: ObjectHandle(state: adoptObject(p,
    hasDestroySignal = false, sink = false)), identity: MergeIdentity())
  let nativeGroup = rawGtk.ui_manager_get_accel_group(p)
  result.book.shortcuts.state = adoptObject(nativeGroup, borrowed = true, cache = true, hasDestroySignal = false)
  result.book.shortcuts.book = AccelBook(p: cast[rawGtk.PAccelGroup](g.g_object_ref(nativeGroup)))
  rawGtk.ui_manager_set_add_tearoffs(p, g.gbool(tearoffs))
  for group in groups:
    rawGtk.ui_manager_insert_action_group(p, group.raw, -1)
    group.members.manager = p
    g.set_data(cast[g.PGObject](group.raw), "nim-gtk2-ui-manager", p)
    result.book.groups.add(group)
proc managedAction(ui: UIManager, name: string): bool =
  for group in ui.book.groups:
    if rawGtk.action_group_get_action(group.raw, name.cstring) != nil: return true
proc validateManagedXml(ui: UIManager, node: uiXmlTree.XmlNode) =
  if node.kind != uiXmlTree.xnElement: return
  let action = node.attr("action")
  if node.tag in ["menu", "menuitem", "toolitem", "accelerator"] and action.len == 0:
    raise newException(ValueError, "managed UI element requires an action: " & node.tag)
  if action.len != 0 and not ui.managedAction(action):
    raise newException(ValueError, "unknown managed UI action: " & action)
  for child in node: ui.validateManagedXml(child)
proc addUi*(ui: UIManager, xml: string): UIMerge =
  let p = ui.raw
  discard checkedUtf8Text(xml)
  var tree: uiXmlTree.XmlNode
  try: tree = uiXmlParser.parseXml(xml)
  except uiXmlParser.XmlError as error: raise newException(UIManagerError, error.msg)
  if tree.kind != uiXmlTree.xnElement or tree.tag != "ui":
    raise newException(ValueError, "managed UI XML requires a complete <ui> root")
  if tree.attrsLen != 0: raise newException(ValueError, "managed UI root cannot have attributes")
  ui.validateManagedXml(tree) # Avoid GTK's missing-action warning during lazy update.
  # GTK2 only recognizes a literal <ui> prefix, not <ui/> or an XML declaration.
  # Serialize the validated body beneath a canonical root before native parsing.
  var nativeXml = "<ui>"
  for child in tree: nativeXml.add($child)
  nativeXml.add("</ui>")
  let text = checkedUtf8Text(nativeXml)
  var error: ptr g.GError
  let id = rawGtk.ui_manager_add_ui_from_string(p, text, g.gssize(nativeXml.len), addr error)
  if error != nil:
    let failure = newException(UIManagerError, $error.message)
    failure.domain = uint32(error.domain)
    failure.code = int32(error.code)
    g.g_error_free(error)
    ui.ensureUpdate() # Drain native rollback work under the same reentrancy guard.
    raise failure
  if id == 0:
    ui.ensureUpdate()
    raise newException(UIManagerError, "GTK could not merge the UI")
  ui.book.merges.add(id)
  result = UIMerge(owner: ui.book.identity, id: id)
  ui.ensureUpdate()
proc active*(ui: UIManager, merge: UIMerge): bool =
  if ui.closed or merge.owner != ui.book.identity: return false
  merge.id in ui.book.merges
proc remove*(ui: UIManager, merge: UIMerge) =
  let p = ui.raw
  if merge.owner != ui.book.identity: raise newException(ValueError, "foreign UI merge token")
  for i, id in ui.book.merges:
    if id == merge.id:
      ui.book.merges.delete(i)
      rawGtk.ui_manager_remove_ui(p, id)
      ui.ensureUpdate()
      return
proc managedPath(value: string): cstring =
  result = checkedUtf8Text(value)
  if value.len < 2 or value[0] != '/': raise newException(ValueError, "UI path must start with / and name a node")
proc get*[T](ui: UIManager, path: string, kind: typedesc[T]): T =
  static: doAssert T is Widget, "UIManager lookups return widget views only"
  let name = managedPath(path)
  ui.ensureUpdate()
  let p = rawGtk.ui_manager_get_widget(ui.raw, name)
  if p == nil: raise newException(ValueError, "unknown UI widget path: " & path)
  if not g.G_TYPE_CHECK_INSTANCE_TYPE(p, builderWidgetType(T)):
    raise newException(ValueError, "UI path has incompatible widget type")
  result.state = retainManagedWidget(ui.book, p)
proc action*(ui: UIManager, path: string): Action =
  let name = managedPath(path)
  ui.ensureUpdate()
  let p = rawGtk.ui_manager_get_action(ui.raw, name)
  if p == nil: raise newException(ValueError, "UI path has no action: " & path)
  result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false)
proc uiDescription*(ui: UIManager): string =
  ui.ensureUpdate()
  let text = rawGtk.ui_manager_get_ui(ui.raw)
  try: result = $text
  finally: g.g_free(text)
proc tearoffs*(ui: UIManager): bool = g.toBool(rawGtk.ui_manager_get_add_tearoffs(ui.raw))
proc `tearoffs=`*(ui: UIManager, value: bool) =
  rawGtk.ui_manager_set_add_tearoffs(ui.raw, g.gbool(value))
  ui.ensureUpdate()
proc requireManagedAction(ui: UIManager, a: Action) =
  discard ui.raw
  let owner = actionOwner(a)
  if owner == nil or g.get_data(cast[g.PGObject](owner), "nim-gtk2-ui-manager") != cast[pointer](ui.raw):
    raise newException(ValueError, "command does not belong to this UIManager")
proc bindShortcut*(ui: UIManager, a: Action, shortcut: Shortcut) =
  ui.requireManagedAction(a)
  ui.book.shortcuts.bindShortcut(a, shortcut)
  ui.ensureUpdate()
proc bindShortcut*(ui: UIManager, a: Action, shortcut: string) = ui.bindShortcut(a, parseShortcut(shortcut))
proc unbindShortcut*(ui: UIManager, a: Action) =
  ui.requireManagedAction(a)
  ui.book.shortcuts.unbindShortcut(a)
proc attach*(ui: UIManager, window: Window) =
  discard ui.raw
  ui.book.shortcuts.attach(window)
  for previous in ui.book.windows:
    if previous.state == window.state: return
  ui.book.windows.add(window)
proc detach*(ui: UIManager, window: Window) =
  discard ui.raw
  ui.book.shortcuts.detach(window)
  for i, previous in ui.book.windows:
    if previous.state == window.state:
      ui.book.windows.delete(i)
      break
