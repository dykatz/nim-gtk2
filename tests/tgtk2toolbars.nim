import std/[os, unittest]
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newToolbar().raw) is rawGtk.PToolbar
  doAssert typeof(newToolButton().raw) is ptr rawGtk.ToolButton
  doAssert typeof(newToggleToolButton().raw) is ptr rawGtk.ToggleToolButton
  doAssert typeof(newRadioToolButton().raw) is ptr rawGtk.RadioToolButton
  doAssert typeof(newMenuToolButton().raw) is ptr rawGtk.MenuToolButton
  doAssert typeof(newSeparatorToolItem().raw) is ptr rawGtk.SeparatorToolItem
  doAssert typeof(newToolItem().raw) is ptr rawGtk.ToolItem
  doAssert typeof(newToolPalette().raw) is ptr rawGtk.ToolPalette
  doAssert typeof(newToolItemGroup().raw) is ptr rawGtk.ToolItemGroup

type CaptureObj = object
  released: ptr int
  calls: ptr int
  fail: bool
proc `=destroy`(v: var CaptureObj) = inc v.released[]
type Capture = ref CaptureObj
proc track(w: gtk2.ToolButton, released, calls: ptr int, fail = false): Connection =
  let c = Capture(released: released, calls: calls, fail: fail)
  w.onClicked(proc () =
    inc c.calls[]
    if c.fail: raise newException(ValueError, "expected tool button callback error"))
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc temporaryPalette(parent: gtk2.Window, gone: ptr int) =
  let palette = newToolPalette()
  parent.add(palette)
  g.weak_ref(cast[g.PGObject](palette.raw), finalized, gone)
  for i in 0..<4:
    let group = newToolItemGroup($i)
    let button = newToolButton($i)
    g.weak_ref(cast[g.PGObject](group.raw), finalized, gone)
    g.weak_ref(cast[g.PGObject](button.raw), finalized, gone)
    palette.add(group)
    group.append(button)
proc clicked(w: gtk2.ToolButton) = g.g_signal_emit_by_name(w.raw, "clicked")

gtk2.init()
suite "checked toolbar and palette widgets (hidden)":
  test "toolbar insertion, owning aliases, native style and item flags":
    let bar = newToolbar()
    defer: bar.destroy()
    let a = newToolButton("_Open", mnemonic = true)
    let b = newToggleToolButton("Pin")
    let separator = newSeparatorToolItem()
    bar.append(a)
    bar.prepend(separator)
    bar.insert(b, 1)
    check bar.itemCount == 3
    check bar.itemIndex(a) == 2
    check bar.itemAt(1).raw == cast[ptr rawGtk.ToolItem](b.raw)
    check a.text == "_Open" and a.useUnderline
    a.text = "café"
    a.useUnderline = false
    a.homogeneous = false
    a.expand = true
    a.visibleHorizontal = false
    a.visibleVertical = true
    a.important = true
    a.tooltipText = "plain <not markup>"
    separator.draw = false
    check not a.homogeneous and a.expand and a.important
    check not a.visibleHorizontal and a.visibleVertical
    check not separator.draw
    bar.orientation = vertical
    bar.toolbarStyle = toolbarBothHorizontal
    bar.iconSize = iconDialog
    bar.showArrow = false
    check bar.orientation == vertical and a.orientation == vertical
    check bar.toolbarStyle == toolbarBothHorizontal and a.toolbarStyle == toolbarBothHorizontal
    check bar.iconSize == iconDialog and a.iconSize == iconDialog
    check not bar.showArrow
    discard bar.reliefStyle
    discard a.reliefStyle
    bar.resetToolbarStyle()
    bar.resetIconSize()
    expect ValueError: bar.append(a)
    expect ValueError: discard bar.itemAt(-1)
    expect ValueError: discard bar.itemAt(3)
    let unparented = newToolItem()
    defer: unparented.destroy()
    expect ValueError: bar.insert(unparented, -1)
    expect ValueError: bar.insert(unparented, 4)
    expect ValueError: discard bar.itemIndex(unparented)
    let alias = bar.itemAt(2)
    bar.remove(a)
    check not alias.isDestroyed
    bar.append(a)
    bar.destroy()
    check alias.isDestroyed and a.isDestroyed and b.isDestroyed

  test "custom items and separators reject invalid content even through Bin upcasts":
    let bar = newToolbar()
    defer: bar.destroy()
    let custom = newToolItem()
    let entry = newEntry("Search")
    custom.add(entry)
    bar.append(custom)
    let separator = newSeparatorToolItem(false)
    bar.append(separator)
    let button = newMenuToolButton("More")
    bar.append(button)
    let child = newLabel("unparented")
    defer: child.destroy()
    expect ValueError: gtk2.Bin(separator).add(child)
    expect ValueError: gtk2.Bin(button).add(child)
    expect ValueError: custom.add(bar)
    expect ValueError: custom.add(child)
    custom.remove(entry)
    check not entry.isDestroyed
    entry.destroy()
    custom.add(child)

  test "UTF-8 text, native stock/name properties, and cached owning Image aliases":
    let button = newToolButton()
    defer: button.destroy()
    expect ValueError: discard newToolButton("\xff")
    expect ValueError: discard newToggleToolButton("\0")
    expect ValueError: discard newRadioToolButton("\xff")
    expect ValueError: discard newMenuToolButton("\xff")
    expect ValueError: discard newToolItemGroup("\xff")
    expect ValueError: button.text = "\xff"
    expect ValueError: button.iconName = "bad\0name"
    expect ValueError: button.tooltipText = "\xff"
    button.stockId = "gtk-open"
    check button.stockId == "gtk-open"
    button.stockId = ""
    button.iconName = "document-open"
    check button.iconName == "document-open"
    button.iconName = ""
    check button.stockId == "" and button.iconName == ""
    let image = newImageFromIcon("document-open")
    defer: image.destroy()
    button.image = image
    let alias = button.image
    check alias.raw == image.raw
    button.image = alias
    let other = newToolButton()
    defer: other.destroy()
    expect ValueError: other.image = image
    button.clearImage()
    check button.image.isDestroyed
    check not alias.isDestroyed
    other.image = alias
    other.clearImage()
    alias.destroy()
    check image.isDestroyed

  test "toggle and radio state are native, groups merge and remain exclusive":
    let bar = newToolbar()
    defer: bar.destroy()
    let toggle = newToggleToolButton("Pin")
    let a = newRadioToolButton("A")
    let b = newRadioToolButton(a, "B")
    let c = newRadioToolButton("C")
    for item in [gtk2.ToolItem(toggle), gtk2.ToolItem(a), gtk2.ToolItem(b), gtk2.ToolItem(c)]: bar.append(item)
    var toggles, clicks = 0
    toggle.onToggled(proc () = inc toggles)
    toggle.onClicked(proc () = inc clicks)
    toggle.active = true
    toggle.active = true
    toggle.active = false
    check toggles == 2 and clicks == 2
    check a.active and not b.active and c.active
    b.active = true
    check b.active and not a.active
    c.joinGroup(b)
    check not c.active and b.active
    c.joinGroup(b)
    c.active = true
    check c.active and not a.active and not b.active
    a.destroy()
    b.active = true
    check b.active and not c.active

  test "menus have one logical owner, reject cycles and detach retained handles":
    let bar = newToolbar()
    defer: bar.destroy()
    let button = newMenuToolButton("More")
    let other = newMenuToolButton("Other")
    bar.append(button)
    bar.append(other)
    let menu = newMenu()
    defer: menu.destroy()
    menu.append(newMenuItem("Action"))
    button.menu = menu
    let alias = button.menu
    check button.hasMenu and alias.raw == menu.raw
    button.menu = alias
    button.arrowTooltipText = "More actions"
    expect ValueError: button.arrowTooltipText = "\xff"
    expect ValueError: other.menu = menu
    let heading = newMenuItem("Heading")
    defer: heading.destroy()
    expect ValueError: heading.submenu = menu
    button.clearMenu()
    check not button.hasMenu and not alias.isDestroyed
    heading.submenu = menu
    expect ValueError: button.menu = menu
    heading.clearSubmenu()
    other.menu = menu
    other.destroy()
    # Native MenuToolButton destroys its private controls, but only detaches Menu.
    check not menu.isDestroyed
    check rawGtk.get_attach_widget(menu.raw) == nil
    let cycle = newMenu()
    defer: cycle.destroy()
    let item = newMenuItem("Custom")
    cycle.append(item)
    let nestedBar = newToolbar()
    rawGtk.remove(cast[rawGtk.PContainer](item.raw), rawGtk.get_child(cast[rawGtk.PBin](item.raw)))
    item.add(nestedBar)
    let nestedButton = newMenuToolButton()
    nestedBar.append(nestedButton)
    expect ValueError: nestedButton.menu = cycle
    let owner = newMenuToolButton("Owner")
    let wrapper = newToolItem()
    defer: wrapper.destroy()
    owner.menu = cycle
    wrapper.add(owner)
    expect ValueError: nestedBar.append(wrapper)
    owner.clearMenu()

  test "palette grouping, native order, packing, presentation and scrolling":
    let scroller = newScrolledWindow()
    defer: scroller.destroy()
    let palette = newToolPalette()
    expect ValueError: discard palette.horizontalAdjustment
    scroller.add(palette)
    check palette.horizontalAdjustment.raw == scroller.horizontalAdjustment.raw
    check palette.verticalAdjustment.raw == scroller.verticalAdjustment.raw
    let first = newToolItemGroup("Tools")
    let second = newToolItemGroup("Other")
    palette.add(first)
    palette.add(second)
    let a = newToolButton("A")
    let b = newToggleToolButton("B")
    let custom = newToolItem()
    custom.add(newEntry())
    first.append(a)
    first.prepend(b)
    first.insert(custom, 1)
    check palette.groupCount == 2 and palette.groupIndex(second) == 1
    check palette.groupAt(0).raw == first.raw
    check palette.groupAt(1).raw == second.raw
    first.moveItem(a, 0)
    check first.itemAt(0).raw == cast[ptr rawGtk.ToolItem](a.raw)
    check first.itemIndex(custom) == 2
    first.setItemPacking(custom, homogeneous = false, expand = true, fill = false, newRow = true)
    check first.itemPacking(custom) == ToolItemPacking(homogeneous: false, expand: true, fill: false, newRow: true)
    palette.setExclusive(first)
    palette.setGroupExpand(first)
    check palette.exclusive(first) and palette.groupExpand(first)
    first.text = "Edited café"
    first.collapsed = true
    first.ellipsize = ellipsizeEnd
    first.headerRelief = reliefNone
    check first.text == "Edited café" and first.collapsed
    check first.ellipsize == ellipsizeEnd and first.headerRelief == reliefNone
    first.collapsed = false
    palette.orientation = horizontal
    palette.toolbarStyle = toolbarText
    palette.iconSize = iconButton
    check palette.orientation == horizontal and palette.toolbarStyle == toolbarText
    check palette.iconSize == iconButton
    palette.resetToolbarStyle()
    palette.resetIconSize()
    expect ValueError: palette.add(first)
    expect ValueError: discard palette.groupAt(-1)
    expect ValueError: second.moveItem(a, 0)
    expect ValueError: first.moveItem(a, 3)
    expect ValueError: discard second.itemPacking(a)
    let unparented = newToolItemGroup("unparented")
    defer: unparented.destroy()
    expect ValueError: palette.setExclusive(unparented)
    let alias = first.itemAt(0)
    first.remove(a)
    second.append(a)
    palette.setExclusive(second)
    palette.remove(second)
    second.collapsed = true
    second.collapsed = false
    palette.add(second)
    scroller.destroy()
    check alias.isDestroyed and first.isDestroyed and second.isDestroyed

  test "callbacks own captures, self-disconnect, contain errors and permit destruction":
    var released, calls = 0
    let button = newToolButton()
    let aliasBar = newToolbar()
    defer: aliasBar.destroy()
    aliasBar.append(button)
    let alias = aliasBar.itemAt(0)
    let connection = track(button, addr released, addr calls, fail = true)
    clicked(button)
    check calls == 1 and connection.connected
    var self: Connection
    self = button.onClicked(proc () = self.disconnect())
    clicked(button)
    check not self.connected
    button.onClicked(proc () = button.destroy())
    clicked(button)
    check alias.isDestroyed and released == 1
    check not connection.connected
    expect ValueError: discard button.onClicked(nil)
    let toggle = newToggleToolButton()
    defer: toggle.destroy()
    toggle.onToggled(proc () = toggle.destroy())
    toggle.active = true
    check toggle.isDestroyed
    let radioBar = newToolbar()
    defer: radioBar.destroy()
    let a = newRadioToolButton("A")
    let b = newRadioToolButton(a, "B")
    radioBar.append(a)
    radioBar.append(b)
    b.onToggled(proc () = radioBar.destroy())
    b.active = true
    check a.isDestroyed and b.isDestroyed
    let menuButton = newMenuToolButton()
    defer: menuButton.destroy()
    var showCalls = 0
    menuButton.onShowMenu(proc () =
      inc showCalls
      menuButton.destroy())
    g.g_signal_emit_by_name(menuButton.raw, "show-menu")
    check showCalls == 1 and menuButton.isDestroyed

  test "palette destruction survives sibling destruction and temporary handles":
    let palette = newToolPalette()
    defer: palette.destroy()
    var groups: seq[gtk2.ToolItemGroup]
    for i in 0..<4:
      let group = newToolItemGroup($i)
      palette.add(group)
      groups.add(group)
    let last = groups[3]
    groups[0].onDestroy(proc () = last.destroy())
    palette.destroy()
    for group in groups: check group.isDestroyed
    var gone = 0
    let window = newWindow()
    defer: window.destroy()
    temporaryPalette(window, addr gone)
    window.destroy()
    check gone == 9

  test "destroying an animated anchored group cancels native timeouts before release":
    block:
      let window = newWindow()
      defer: window.destroy()
      let settings = cast[g.PGObject](rawGtk.get_settings(cast[rawGtk.PWidget](window.raw)))
      var original, enabled: g.TGValue
      discard g.init(addr original, g.G_TYPE_BOOLEAN)
      discard g.init(addr enabled, g.G_TYPE_BOOLEAN)
      g.get_property(settings, "gtk-enable-animations", addr original)
      g.set_boolean(addr enabled, g.gbool(true))
      g.set_property(settings, "gtk-enable-animations", addr enabled)
      defer:
        g.set_property(settings, "gtk-enable-animations", addr original)
        g.unset(addr original)
        g.unset(addr enabled)
      let palette = newToolPalette()
      window.add(palette) # Anchored, but never realized, mapped, or shown.
      let group = newToolItemGroup("Animated")
      palette.add(group)
      let p = group.raw
      group.collapsed = true
      check g.g_main_context_find_source_by_user_data(nil, p) != nil
      window.destroy()
      check group.isDestroyed
      check g.g_main_context_find_source_by_user_data(nil, p) == nil
    # The group is now freed. Dispatching these sources used to segfault.
    for i in 0..<15:
      sleep(20)
      for j in 0..<128:
        if rawGtk.events_pending() == 0: break
        discard rawGtk.main_iteration_do(g.gbool(false))

  test "explicit root destruction finalizes native toolbar objects":
    var gone = 0
    block:
      let bar = newToolbar()
      let button = newToggleToolButton()
      let palette = newToolPalette()
      let group = newToolItemGroup("Group")
      let item = newToolButton()
      for p in [cast[pointer](bar.raw), cast[pointer](button.raw), cast[pointer](palette.raw),
          cast[pointer](group.raw), cast[pointer](item.raw)]:
        g.weak_ref(cast[g.PGObject](p), finalized, addr gone)
      bar.append(button)
      palette.add(group)
      group.append(item)
      bar.destroy()
      palette.destroy()
    check gone == 5
