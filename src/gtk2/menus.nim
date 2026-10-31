# Included by gtk2.nim. Menu-bar trees and checked submenu ownership.
type
  Item* = object of Bin
  MenuShell* = object of Container
  MenuBar* = object of MenuShell
  Menu* = object of MenuShell
  MenuItem* = object of Item
  CheckMenuItem* = object of MenuItem
  RadioMenuItem* = object of CheckMenuItem
  ImageMenuItem* = object of MenuItem
  SeparatorMenuItem* = object of MenuItem
  TearoffMenuItem* = object of MenuItem
  AccelLabel* = object of Label

proc raw*(w: MenuShell): rawGtk.PMenuShell = cast[rawGtk.PMenuShell](raw(Widget(w)))
proc raw*(w: MenuBar): rawGtk.PMenuBar = cast[rawGtk.PMenuBar](raw(Widget(w)))
proc raw*(w: Menu): rawGtk.PMenu = cast[rawGtk.PMenu](raw(Widget(w)))
proc raw*(w: Item): rawGtk.PItem = cast[rawGtk.PItem](raw(Widget(w)))
proc raw*(w: MenuItem): rawGtk.PMenuItem = cast[rawGtk.PMenuItem](raw(Widget(w)))
proc raw*(w: CheckMenuItem): rawGtk.PCheckMenuItem = cast[rawGtk.PCheckMenuItem](raw(Widget(w)))
proc raw*(w: RadioMenuItem): rawGtk.PRadioMenuItem = cast[rawGtk.PRadioMenuItem](raw(Widget(w)))
proc raw*(w: ImageMenuItem): rawGtk.PImageMenuItem = cast[rawGtk.PImageMenuItem](raw(Widget(w)))
proc raw*(w: SeparatorMenuItem): rawGtk.PSeparatorMenuItem = cast[rawGtk.PSeparatorMenuItem](raw(Widget(w)))
proc raw*(w: TearoffMenuItem): rawGtk.PTearoffMenuItem = cast[rawGtk.PTearoffMenuItem](raw(Widget(w)))
proc raw*(w: AccelLabel): rawGtk.PAccelLabel = cast[rawGtk.PAccelLabel](raw(Widget(w)))

proc newMenuBar*(): MenuBar = result.state = adoptWidget(rawGtk.menu_bar_new())
proc newMenu*(): Menu = result.state = adoptWidget(rawGtk.menu_new())
proc newMenuItem*(text = "", mnemonic = false): MenuItem =
  let label = checkedUtf8Text(text)
  result.state = adoptWidget(if mnemonic: rawGtk.menu_item_new_with_mnemonic(label)
    else: rawGtk.menu_item_new(label))
proc newCheckMenuItem*(text = "", mnemonic = false): CheckMenuItem =
  let label = checkedUtf8Text(text)
  result.state = adoptWidget(if mnemonic: rawGtk.check_menu_item_new_with_mnemonic(label)
    else: rawGtk.check_menu_item_new(label))
proc makeRadioMenuItem(group: g.PGSList, text: string, mnemonic: bool): RadioMenuItem =
  let label = checkedUtf8Text(text)
  result.state = adoptWidget(if mnemonic: rawGtk.radio_menu_item_new_with_mnemonic(group, label)
    else: rawGtk.radio_menu_item_new(group, label))
proc newRadioMenuItem*(text = "", mnemonic = false): RadioMenuItem =
  makeRadioMenuItem(nil, text, mnemonic)
proc newRadioMenuItem*(group: RadioMenuItem, text = "", mnemonic = false): RadioMenuItem =
  makeRadioMenuItem(rawGtk.item_get_group(group.raw), text, mnemonic)
proc joinGroup*(w: RadioMenuItem, group: RadioMenuItem) =
  let p = w.raw
  let target = rawGtk.item_get_group(group.raw)
  if rawGtk.item_get_group(p) != target:
    rawGtk.item_set_group(p, target)
    # GTK2's group setter can leave two formerly independent active members.
    # Keep the existing group's choice; activation of an already-active joiner
    # deactivates it when another member is active.
    if g.toBool(rawGtk.item_get_active(cast[rawGtk.PCheckMenuItem](p))):
      var node = rawGtk.item_get_group(p)
      while node != nil:
        if node.data != cast[pointer](p) and
            g.toBool(rawGtk.item_get_active(cast[rawGtk.PCheckMenuItem](node.data))):
          rawGtk.activate(cast[rawGtk.PMenuItem](p))
          break
        node = node.next
proc newImageMenuItem*(text = "", mnemonic = false): ImageMenuItem =
  let label = checkedUtf8Text(text)
  result.state = adoptWidget(if mnemonic: rawGtk.image_menu_item_new_with_mnemonic(label)
    else: rawGtk.image_menu_item_new(label))
proc newSeparatorMenuItem*(): SeparatorMenuItem =
  result.state = adoptWidget(rawGtk.separator_menu_item_new())

proc newTearoffMenuItem*(): TearoffMenuItem =
  result.state = adoptWidget(rawGtk.tearoff_menu_item_new())

proc labelMenuItem(w: MenuItem): rawGtk.PMenuItem =
  result = w.raw
  if rawGtk.IS_SEPARATOR_MENU_ITEM(result) or rawGtk.IS_TEAROFF_MENU_ITEM(result):
    raise newException(ValueError, "separator and tearoff menu items have no label or submenu")
proc text*(w: MenuItem): string = $rawGtk.get_label(labelMenuItem(w))
proc `text=`*(w: MenuItem, value: string) =
  let label = checkedUtf8Text(value)
  rawGtk.set_label(labelMenuItem(w), label)
proc useUnderline*(w: MenuItem): bool = g.toBool(rawGtk.get_use_underline(labelMenuItem(w)))
proc `useUnderline=`*(w: MenuItem, value: bool) = rawGtk.set_use_underline(labelMenuItem(w), g.gbool(value))
proc active*(w: CheckMenuItem): bool = g.toBool(rawGtk.item_get_active(w.raw))
proc `active=`*(w: CheckMenuItem, value: bool) = rawGtk.item_set_active(w.raw, g.gbool(value))
proc inconsistent*(w: CheckMenuItem): bool = g.toBool(rawGtk.item_get_inconsistent(w.raw))
proc `inconsistent=`*(w: CheckMenuItem, value: bool) = rawGtk.item_set_inconsistent(w.raw, g.gbool(value))
proc drawAsRadio*(w: CheckMenuItem): bool = g.toBool(rawGtk.get_draw_as_radio(w.raw))
proc `drawAsRadio=`*(w: CheckMenuItem, value: bool) = rawGtk.set_draw_as_radio(w.raw, g.gbool(value))

proc menuAncestorContains(start, target: rawGtk.PWidget): bool =
  # GtkMenu's native parent is a private popup window, not its logical owner.
  var p = start
  var seen: seq[rawGtk.PWidget]
  while p != nil:
    if p == target: return true
    if p in seen: raise newException(ValueError, "native menu ownership already contains a cycle")
    seen.add(p)
    p = if rawGtk.IS_MENU(p): rawGtk.get_attach_widget(cast[rawGtk.PMenu](p))
        else: rawGtk.get_parent(p)
proc itemCount*(w: MenuShell): int =
  let children = rawGtk.get_children(cast[rawGtk.PContainer](w.raw))
  defer: g.free(children)
  var node = children
  while node != nil:
    inc result
    node = node.next
proc insert*(w: MenuShell, item: MenuItem, index: int) =
  checkChild(w, item)
  if index < 0 or index > w.itemCount:
    raise newException(ValueError, "menu insertion index out of bounds")
  if menuAncestorContains(cast[rawGtk.PWidget](w.raw), cast[rawGtk.PWidget](item.raw)):
    raise newException(ValueError, "menu insertion would contain an ownership cycle")
  if rawGtk.IS_MENU_BAR(w.raw) and
      (rawGtk.IS_SEPARATOR_MENU_ITEM(item.raw) or rawGtk.IS_TEAROFF_MENU_ITEM(item.raw)):
    raise newException(ValueError, "separator and tearoff menu items belong in menus, not menu bars")
  rawGtk.insert(w.raw, cast[rawGtk.PWidget](item.raw), checkedInt(index))
proc append*(w: MenuShell, item: MenuItem) = w.insert(item, w.itemCount)
proc prepend*(w: MenuShell, item: MenuItem) = w.insert(item, 0)
proc itemAt*(w: MenuShell, index: int): MenuItem =
  let children = rawGtk.get_children(cast[rawGtk.PContainer](w.raw))
  defer: g.free(children)
  if index < 0: raise newException(ValueError, "menu index out of bounds")
  var node = children
  var position = 0
  while node != nil and position < index:
    node = node.next
    inc position
  if node == nil: raise newException(ValueError, "menu index out of bounds")
  result.state = adoptObject(node.data, borrowed = true, cache = true)
proc hasSubmenu*(w: MenuItem): bool = rawGtk.get_submenu(w.raw) != nil
proc submenu*(w: MenuItem): Menu =
  let p = rawGtk.get_submenu(w.raw)
  if p != nil: result.state = adoptObject(p, borrowed = true, cache = true)
proc `submenu=`*(w: MenuItem, value: Menu) =
  let p = labelMenuItem(w)
  let menu = value.raw
  if rawGtk.get_submenu(p) == cast[rawGtk.PWidget](menu): return
  let owner = rawGtk.get_attach_widget(menu)
  if owner != nil:
    raise newException(ValueError, "submenu is already attached; clear its existing owner first")
  if menuAncestorContains(cast[rawGtk.PWidget](p), cast[rawGtk.PWidget](menu)):
    raise newException(ValueError, "submenu attachment would contain an ownership cycle")
  rawGtk.set_submenu(p, cast[rawGtk.PWidget](menu))
proc clearSubmenu*(w: MenuItem) = rawGtk.set_submenu(w.raw, nil)

proc image*(w: ImageMenuItem): Image =
  let p = rawGtk.item_get_image(w.raw)
  if p != nil: result.state = adoptObject(p, borrowed = true, cache = true)
proc `image=`*(w: ImageMenuItem, value: Image) =
  let p = w.raw
  if rawGtk.item_get_image(p) == cast[rawGtk.PWidget](value.raw): return
  checkChild(w, value)
  rawGtk.item_set_image(p, cast[rawGtk.PWidget](value.raw))
proc clearImage*(w: ImageMenuItem) = rawGtk.item_set_image(w.raw, nil)
proc alwaysShowImage*(w: ImageMenuItem): bool = g.toBool(rawGtk.get_always_show_image(w.raw))
proc `alwaysShowImage=`*(w: ImageMenuItem, value: bool) = rawGtk.set_always_show_image(w.raw, g.gbool(value))
proc activatableMenuItem(w: MenuItem): rawGtk.PMenuItem =
  result = w.raw
  if rawGtk.IS_SEPARATOR_MENU_ITEM(result):
    raise newException(ValueError, "separator menu items cannot be activated")
proc activate*(w: MenuItem) =
  let p = activatableMenuItem(w)
  if rawGtk.IS_TEAROFF_MENU_ITEM(p):
    let parent = rawGtk.get_parent(cast[rawGtk.PWidget](p))
    if parent == nil or not rawGtk.IS_MENU(parent):
      raise newException(ValueError, "tearoff menu item must belong to a menu before activation")
    # GTK2 dereferences the menu's GdkWindow while creating a tearoff. A menu
    # activated before its first popup has not normally been realized yet.
    rawGtk.realize(parent)
  rawGtk.activate(p)
proc tornOff*(w: Menu): bool = g.toBool(rawGtk.get_tearoff_state(w.raw))
proc `tornOff=`*(w: Menu, value: bool) =
  let p = w.raw
  if value: rawGtk.realize(cast[rawGtk.PWidget](p))
  rawGtk.set_tearoff_state(p, g.gbool(value))
proc tearoffTitle*(w: Menu): string = $rawGtk.get_title(w.raw)
proc `tearoffTitle=`*(w: Menu, value: string) =
  let title = checkedUtf8Text(value)
  rawGtk.set_title(w.raw, if value.len == 0: nil else: title)
proc tearoffStateThunk(instance, pspec, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[SelectorCallback[bool]](data).fn
    try: fn(g.toBool(rawGtk.get_tearoff_state(cast[rawGtk.PMenu](instance))))
    except Exception as error: reportSignalError(error)
proc onTearoffChanged*(w: Menu, fn: proc (tornOff: bool) {.closure.}): Connection {.discardable.} =
  connectSelector(w, "notify::tearoff-state", fn, cast[g.TGCallback](tearoffStateThunk))
proc onActivate*(w: MenuItem, fn: proc () {.closure.}): Connection {.discardable.} =
  discard activatableMenuItem(w)
  connect(w, "activate", fn, after = true)
proc onToggled*(w: CheckMenuItem, fn: proc () {.closure.}): Connection {.discardable.} =
  connect(w, "toggled", fn, after = true)

proc newAccelLabel*(text = ""): AccelLabel =
  result.state = adoptWidget(rawGtk.accel_label_new(checkedUtf8Text(text)))
proc accelWidth*(w: AccelLabel): int = rawGtk.get_accel_width(w.raw).int
proc refetch*(w: AccelLabel): bool = g.toBool(rawGtk.refetch(w.raw))
proc accelWidget*(w: AccelLabel): Widget =
  let p = rawGtk.get_accel_widget(w.raw)
  if p != nil: result.state = adoptObject(p, borrowed = true, cache = true)
proc `accelWidget=`*(w: AccelLabel, value: Widget) =
  let p = w.raw
  let target = value.raw
  if cast[rawGtk.PWidget](p) == target:
    raise newException(ValueError, "an accelerator label cannot monitor itself")
  rawGtk.set_accel_widget(p, target)
proc clearAccelWidget*(w: AccelLabel) = rawGtk.set_accel_widget(w.raw, nil)
