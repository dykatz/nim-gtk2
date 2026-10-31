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

  let open = newToolButton("_Open", mnemonic = true)
  open.image = newImageFromIcon("document-open", iconLargeToolbar)
  open.important = true
  open.tooltipText = "Open an example document"
  open.onClicked(proc () = status.text = "Open clicked")
  toolbar.append(open)
  toolbar.append(newSeparatorToolItem())
  let pin = newToggleToolButton("Pin")
  pin.iconName = "emblem-favorite"
  pin.important = true
  pin.onToggled(proc () = status.text = "Pinned: " & $pin.active)
  toolbar.append(pin)
  let select = newRadioToolButton("Select")
  let draw = newRadioToolButton(select, "Draw")
  select.important = true
  draw.important = true
  select.onToggled(proc () =
    if select.active: status.text = "Selection tool")
  draw.onToggled(proc () =
    if draw.active: status.text = "Drawing tool")
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
  let refresh = newMenuItem("_Refresh", mnemonic = true)
  refresh.onActivate(proc () = status.text = "Refresh selected from toolbar dropdown")
  menu.append(refresh)
  menu.showAll() # Attached menus are not ordinary children of a MenuToolButton.
  more.menu = menu
  toolbar.append(more)

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
