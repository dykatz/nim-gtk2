# Included by gtk2.nim. Native command proxies and window-local accelerators.
type
  Action* = object of ObjectHandle
  ToggleAction* = object of Action
  RadioAction* = object of ToggleAction
  ActionMembers = ref object
    items: seq[Action]
    manager: pointer # Weak UIManager schema reservation, cleared before native release.
  ActionGroup* = object of ObjectHandle
    members: ActionMembers
  Shortcut* = object
    key: uint32
    mods: ModifierMask
  ShortcutEntry = object
    shortcut: Shortcut
    action: Action
  AccelBookObj = object
    p: rawGtk.PAccelGroup # An extra native ref keeps cleanup independent of field destruction order.
    entries: seq[ShortcutEntry]
  AccelBook = ref AccelBookObj
  AccelGroup* = object of ObjectHandle
    book: AccelBook

proc `=destroy`(book: var AccelBookObj)

proc raw*(a: Action): rawGtk.PAction = cast[rawGtk.PAction](nativePointer(a))
proc raw*(a: ToggleAction): rawGtk.PToggleAction = cast[rawGtk.PToggleAction](nativePointer(a))
proc raw*(a: ActionGroup): rawGtk.PActionGroup = cast[rawGtk.PActionGroup](nativePointer(a))
proc raw*(a: AccelGroup): rawGtk.PAccelGroup = cast[rawGtk.PAccelGroup](nativePointer(a))
proc commandName(value: string): cstring =
  result = checkedUtf8Text(value)
  if value.len == 0: raise newException(ValueError, "command/group name cannot be empty")
proc newAction*(name, label: string, tooltip = ""): Action =
  let n = commandName(name)
  let l = checkedUtf8Text(label)
  let t = checkedUtf8Text(tooltip)
  result.state = adoptObject(rawGtk.action_new(n, l, t, nil), cache = true,
    hasDestroySignal = false, sink = false)
proc newToggleAction*(name, label: string, tooltip = "", active = false): ToggleAction =
  let n = commandName(name)
  let l = checkedUtf8Text(label)
  let t = checkedUtf8Text(tooltip)
  result.state = adoptObject(rawGtk.toggle_action_new(n, l, t, nil), cache = true,
    hasDestroySignal = false, sink = false)
  if active: rawGtk.toggle_action_set_active(result.raw, g.gbool(true))
proc newActionGroup*(name: string): ActionGroup =
  result.state = adoptObject(rawGtk.action_group_new(commandName(name)), cache = true,
    hasDestroySignal = false, sink = false)
  result.members = ActionMembers()
proc name*(a: Action): string = $rawGtk.action_get_name(a.raw)
proc label*(a: Action): string = $rawGtk.action_get_label(a.raw)
proc `label=`*(a: Action, value: string) = rawGtk.action_set_label(a.raw, checkedUtf8Text(value))
proc shortLabel*(a: Action): string = $rawGtk.action_get_short_label(a.raw)
proc `shortLabel=`*(a: Action, value: string) = rawGtk.action_set_short_label(a.raw, checkedUtf8Text(value))
proc tooltip*(a: Action): string = $rawGtk.action_get_tooltip(a.raw)
proc `tooltip=`*(a: Action, value: string) = rawGtk.action_set_tooltip(a.raw, checkedUtf8Text(value))
proc iconName*(a: Action): string = $rawGtk.action_get_icon_name(a.raw)
proc `iconName=`*(a: Action, value: string) = rawGtk.action_set_icon_name(a.raw, checkedUtf8Text(value))
proc important*(a: Action): bool = g.toBool(rawGtk.action_get_is_important(a.raw))
proc `important=`*(a: Action, value: bool) = rawGtk.action_set_is_important(a.raw, g.gbool(value))
proc asToggleAction*(a: Action): ToggleAction =
  if not g.G_TYPE_CHECK_INSTANCE_TYPE(a.raw, rawGtk.toggle_action_get_type()):
    raise newException(ValueError, "action is not a toggle action")
  result.state = a.state
proc sensitive*(a: Action): bool = g.toBool(rawGtk.action_get_sensitive(a.raw))
proc `sensitive=`*(a: Action, value: bool) = rawGtk.action_set_sensitive(a.raw, g.gbool(value))
proc effectiveSensitive*(a: Action): bool = g.toBool(rawGtk.action_is_sensitive(a.raw))
proc visible*(a: Action): bool = g.toBool(rawGtk.action_get_visible(a.raw))
proc `visible=`*(a: Action, value: bool) = rawGtk.action_set_visible(a.raw, g.gbool(value))
proc effectiveVisible*(a: Action): bool = g.toBool(rawGtk.action_is_visible(a.raw))
proc active*(a: ToggleAction): bool = g.toBool(rawGtk.toggle_action_get_active(a.raw))
proc `active=`*(a: ToggleAction, value: bool) = rawGtk.toggle_action_set_active(a.raw, g.gbool(value))
proc activate*(a: Action) = rawGtk.action_activate(a.raw)
proc disconnectSignals*(a: Action) = disconnectObjectSignals(a)
proc actionActivateThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: queueRecent(data, true)
    except Exception as error: reportSignalError(error)
proc actionToggleThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: queueRecent(data, g.toBool(rawGtk.toggle_action_get_active(cast[rawGtk.PToggleAction](instance))))
    except Exception as error: reportSignalError(error)
proc onActivate*(a: Action, fn: proc () {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "action callback cannot be nil")
  connectRecent(a, "activate", proc (unused: bool) = fn(), cast[g.TGCallback](actionActivateThunk))
proc onToggled*(a: ToggleAction, fn: proc (active: bool) {.closure.}): Connection {.discardable.} =
  connectRecent(a, "toggled", fn, cast[g.TGCallback](actionToggleThunk))
proc name*(group: ActionGroup): string = $rawGtk.action_group_get_name(group.raw)
proc sensitive*(group: ActionGroup): bool = g.toBool(rawGtk.action_group_get_sensitive(group.raw))
proc `sensitive=`*(group: ActionGroup, value: bool) = rawGtk.action_group_set_sensitive(group.raw, g.gbool(value))
proc visible*(group: ActionGroup): bool = g.toBool(rawGtk.action_group_get_visible(group.raw))
proc `visible=`*(group: ActionGroup, value: bool) = rawGtk.action_group_set_visible(group.raw, g.gbool(value))
proc actionOwner(a: Action): pointer =
  var value = typedProperty(a.raw, "action-group")
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](a.raw), "action-group", addr value)
  g.get_object(addr value) # Native group owns action; action-group property itself is weak.
proc add*(group: ActionGroup, a: Action) =
  let p = group.raw
  let action = a.raw
  if group.members.manager != nil: raise newException(ValueError, "UIManager action-group membership is frozen")
  if actionOwner(a) != nil: raise newException(ValueError, "action already belongs to a group")
  if rawGtk.action_group_get_action(p, checkedUtf8Text(a.name)) != nil:
    raise newException(ValueError, "duplicate action name")
  rawGtk.action_group_add_action(p, action)
  group.members.items.add(a) # Keep SDK callbacks alive along with the native group membership.
proc action*(group: ActionGroup, name: string): Action =
  let p = rawGtk.action_group_get_action(group.raw, commandName(name))
  if p == nil: raise newException(ValueError, "unknown action name")
  result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false)
proc remove*(group: ActionGroup, a: Action) =
  let p = group.raw
  if group.members.manager != nil: raise newException(ValueError, "UIManager action-group membership is frozen")
  if actionOwner(a) != cast[pointer](p): raise newException(ValueError, "action is not in this group")
  rawGtk.action_group_remove_action(p, a.raw)
  for i, member in group.members.items:
    if member.raw == a.raw:
      group.members.items.delete(i)
      break
proc disconnectSignals*(group: ActionGroup) =
  discard group.raw
  let items = group.members.items
  for item in items: item.disconnectSignals()

proc keyval*(s: Shortcut): uint32 = s.key
proc modifiers*(s: Shortcut): ModifierMask = s.mods
proc newShortcut*(keyval: uint32, modifiers: ModifierMask): Shortcut =
  const allowed = 1'u32 or 4'u32 or 8'u32 or (1'u32 shl 26) or (1'u32 shl 27) or (1'u32 shl 28)
  if (uint32(modifiers) and not allowed) != 0:
    raise newException(ValueError, "shortcut modifiers cannot include buttons, locks or reserved bits")
  let key = rawGdk.keyval_to_lower(g.guint(keyval))
  if key == 0 or not g.toBool(rawGtk.accelerator_valid(key, rawGdk.TModifierType(uint32(modifiers)))):
    raise newException(ValueError, "invalid GTK accelerator key")
  Shortcut(key: uint32(key), mods: modifiers)
proc parseShortcut*(text: string): Shortcut =
  let value = checkedUtf8Text(text)
  var key: g.guint
  var mods: rawGdk.TModifierType
  rawGtk.accelerator_parse(value, addr key, addr mods)
  newShortcut(key.uint32, ModifierMask(uint32(mods)))
proc shortcutName*(s: Shortcut): string =
  discard newShortcut(s.key, s.mods)
  let text = rawGtk.accelerator_name(g.guint(s.key), rawGdk.TModifierType(uint32(s.mods)))
  try: result = $text
  finally: g.g_free(text)
proc `==`*(a, b: Shortcut): bool = a.key == b.key and a.mods == b.mods

proc syncCommandLabel(proxy: rawGtk.PWidget, closure: g.PGClosure) =
  if not rawGtk.IS_MENU_ITEM(proxy): return
  let child = rawGtk.get_child(cast[rawGtk.PBin](proxy))
  if child != nil and rawGtk.IS_ACCEL_LABEL(child):
    let label = cast[rawGtk.PAccelLabel](child)
    rawGtk.set_accel_widget(label, nil)
    rawGtk.set_accel_closure(label, closure)
proc syncCommandLabels(a: Action, connected: bool) =
  let closure = if connected: rawGtk.action_get_accel_closure(a.raw) else: nil
  var node = rawGtk.action_get_proxies(a.raw) # Borrowed public list, not private widget storage.
  while node != nil:
    syncCommandLabel(cast[rawGtk.PWidget](node.data), closure)
    node = node.next
proc commandProxy(a: Action, toolbar: bool): ObjectState =
  let p = if toolbar: rawGtk.action_create_tool_item(a.raw) else: rawGtk.action_create_menu_item(a.raw)
  result = adoptWidget(p)
  # Visibility is controlled by the action; a parent showAll must not override it.
  rawGtk.set_no_show_all(p, g.gbool(true))
  let closure = rawGtk.action_get_accel_closure(a.raw)
  if not toolbar and rawGtk.accel_group_from_accel_closure(closure) != nil:
    syncCommandLabel(p, closure)
proc createMenuItem*(a: Action): MenuItem = result.state = commandProxy(a, false)
proc createMenuItem*(a: ToggleAction): CheckMenuItem = result.state = commandProxy(a, false)
proc createToolItem*(a: Action): ToolButton = result.state = commandProxy(a, true)
proc createToolItem*(a: ToggleAction): ToggleToolButton = result.state = commandProxy(a, true)

proc `=destroy`(book: var AccelBookObj) =
  if book.p != nil:
    for entry in book.entries:
      try:
        syncCommandLabels(entry.action, false)
        discard rawGtk.disconnect(book.p, rawGtk.action_get_accel_closure(entry.action.raw))
      except Exception as error: reportSignalError(error)
    g.g_object_unref(book.p)
  `=destroy`(book.entries)
proc newAccelGroup*(): AccelGroup =
  result.state = adoptObject(rawGtk.accel_group_new(), cache = true, hasDestroySignal = false, sink = false)
  result.book = AccelBook(p: cast[rawGtk.PAccelGroup](g.g_object_ref(result.raw)))
proc attached*(group: AccelGroup, window: Window): bool =
  let p = group.raw
  var node = rawGtk.accel_groups_from_object(cast[g.PGObject](window.raw))
  while node != nil:
    if node.data == cast[pointer](p): return true
    node = node.next
proc attach*(group: AccelGroup, window: Window) =
  let p = group.raw
  let w = window.raw
  if g.G_TYPE_CHECK_INSTANCE_TYPE(w, rawGtk.offscreen_window_get_type()):
    raise newException(ValueError, "accelerators require an onscreen window")
  if not group.attached(window): rawGtk.add_accel_group(w, p)
proc detach*(group: AccelGroup, window: Window) =
  if group.attached(window): rawGtk.remove_accel_group(window.raw, group.raw)
proc bindShortcut*(group: AccelGroup, a: Action, shortcut: Shortcut) =
  let p = group.raw
  let owner = actionOwner(a)
  if owner != nil:
    let manager = g.get_data(cast[g.PGObject](owner), "nim-gtk2-ui-manager")
    if manager != nil and rawGtk.ui_manager_get_accel_group(cast[rawGtk.PUIManager](manager)) != p:
      raise newException(ValueError, "bind managed command shortcuts through their UIManager")
  discard newShortcut(shortcut.key, shortcut.mods)
  let closure = rawGtk.action_get_accel_closure(a.raw)
  if rawGtk.action_get_accel_path(a.raw) != nil or rawGtk.accel_group_from_accel_closure(closure) != nil:
    raise newException(ValueError, "action already has an accelerator/path; unbind before rebinding")
  var count: g.guint
  discard rawGtk.query(p, g.guint(shortcut.key), rawGdk.TModifierType(uint32(shortcut.mods)), addr count)
  if count != 0: raise newException(ValueError, "shortcut already bound in this accelerator group")
  group.book.entries.add(ShortcutEntry(shortcut: shortcut, action: a))
  rawGtk.connect(p, g.guint(shortcut.key), rawGdk.TModifierType(uint32(shortcut.mods)), rawGtk.ACCEL_VISIBLE, closure)
  syncCommandLabels(a, true)
proc bindShortcut*(group: AccelGroup, a: Action, shortcut: string) = group.bindShortcut(a, parseShortcut(shortcut))
proc unbindShortcut*(group: AccelGroup, a: Action) =
  let p = group.raw
  for i, entry in group.book.entries:
    if entry.action.raw == a.raw:
      syncCommandLabels(a, false)
      discard rawGtk.disconnect(p, rawGtk.action_get_accel_closure(a.raw))
      group.book.entries.delete(i)
      return
proc shortcutFor*(group: AccelGroup, a: Action): Shortcut =
  discard group.raw
  for entry in group.book.entries:
    if entry.action.raw == a.raw: return entry.shortcut
  raise newException(ValueError, "action has no shortcut in this group")
proc clearShortcuts*(group: AccelGroup) =
  discard group.raw
  let entries = group.book.entries
  for entry in entries: group.unbindShortcut(entry.action)
proc activateShortcut*(window: Window, shortcut: Shortcut): bool =
  discard newShortcut(shortcut.key, shortcut.mods)
  g.toBool(rawGtk.accel_groups_activate(cast[g.PGObject](window.raw), g.guint(shortcut.key),
    rawGdk.TModifierType(uint32(shortcut.mods))))
