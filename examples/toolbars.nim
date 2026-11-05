## Modern toolbars and palettes. Build with nim c --path:src examples/toolbars.nim.
import gtk2

proc addPaletteTool(group: ToolItemGroup, status: Label, text, suffix: string) =
  let button = newToolButton(text)
  button.onClicked(proc () = status.text = text & suffix)
  group.append(button)

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 toolbars and palettes", 760, 520)
  defer: window.destroy()
  let root = newVBox(spacing = 8)
  root.borderWidth = 10
  window.add(root)
  let status = newLabel("Use the toolbar, dropdown arrow, or collapsible palette groups.")
  root.packEnd(status, packShrink)
  let toolbar = newToolbar()
  toolbar.toolbarStyle = toolbarBothHorizontal
  root.packStart(toolbar, packShrink)

  let commands = newActionGroup("toolbar-example")
  let shortcuts = newAccelGroup()
  shortcuts.attach(window)
  window.onDestroy(proc () =
    commands.disconnectSignals()
    shortcuts.clearShortcuts())
  let openAction = newAction("open", "_Open", "Open an example document (Ctrl+O)")
  openAction.iconName = "document-open"
  openAction.important = true
  commands.add(openAction)
  shortcuts.bindShortcut(openAction, "<Control>o")
  openAction.onActivate(proc () = status.text = "Open: shared toolbar/menu/keyboard command")
  let open = openAction.createToolItem()
  toolbar.append(open)
  toolbar.append(newSeparatorToolItem())
  let pinAction = newToggleAction("pin", "_Pin", "Shared toggle (Ctrl+P)")
  pinAction.iconName = "emblem-favorite"
  pinAction.important = true
  commands.add(pinAction)
  shortcuts.bindShortcut(pinAction, "<Control>p")
  pinAction.onToggled(proc (active: bool) = status.text = "Pinned: " & $active)
  let pin = pinAction.createToolItem()
  toolbar.append(pin)
  let selectAction = newRadioAction("select", "_Select", 10)
  let drawAction = newRadioAction(selectAction, "draw", "_Draw", 20)
  commands.add(selectAction)
  commands.add(drawAction)
  selectAction.important = true
  drawAction.important = true
  selectAction.onChanged(proc (value: int32) =
    status.text = (if value == 10: "Selection tool" else: "Drawing tool"))
  let select = selectAction.createToolItem()
  let draw = drawAction.createToolItem()
  toolbar.append(select)
  toolbar.append(draw)
  let spacer = newSeparatorToolItem(draw = false)
  spacer.expand = true
  toolbar.append(spacer)
  let custom = newToolItem()
  custom.add(newEntry("Search"))
  custom.tooltipText = "Custom ToolItem content"
  toolbar.append(custom)

  let more = newMenuToolButton("More")
  more.iconName = "view-more"
  more.important = true
  more.arrowTooltipText = "Additional actions"
  more.onClicked(proc () = status.text = "Main More action (separate from its arrow)")
  let menu = newMenu()
  defer: menu.destroy() # MenuToolButton detaches retained menus on destruction.
  menu.append(openAction.createMenuItem())
  menu.append(pinAction.createMenuItem())
  menu.append(selectAction.createMenuItem())
  menu.append(drawAction.createMenuItem())
  menu.append(newSeparatorMenuItem())
  let refresh = newMenuItem("_Refresh", mnemonic = true)
  refresh.onActivate(proc () = status.text = "Refresh selected from toolbar dropdown")
  menu.append(refresh)
  menu.showAll() # Attached menus are not ordinary children of a MenuToolButton.
  more.menu = menu
  toolbar.append(more)

  let enabled = newCheckButton("Shared commands enabled")
  enabled.active = true
  enabled.onToggled(proc () = commands.sensitive = enabled.active)
  root.packStart(enabled, packShrink)
  let scroller = newScrolledWindow()
  root.packStart(scroller)
  let palette = newToolPalette()
  palette.toolbarStyle = toolbarText
  palette.iconSize = iconLargeToolbar
  scroller.add(palette) # Uses native scrolling, not a Viewport.
  let tools = newToolItemGroup("Tools")
  let shapes = newToolItemGroup("Shapes")
  palette.add(tools)
  palette.add(shapes)
  for name in ["Cut", "Copy", "Paste"]:
    addPaletteTool(tools, status, name, " from palette")
  for name in ["Circle", "Square", "Triangle"]:
    addPaletteTool(shapes, status, name, " selected")
  let entryItem = newToolItem()
  entryItem.add(newEntry("Custom palette content"))
  shapes.append(entryItem)
  shapes.setItemPacking(entryItem, homogeneous = false, expand = true, newRow = true)
  window.run()

when isMainModule:
  main()
