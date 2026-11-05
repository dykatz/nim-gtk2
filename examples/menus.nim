## Checked menu-bar trees, stateful items, image items, and accelerator labels.
## Build: nim c --path:src examples/menus.nim
import gtk2

type MenuExample* = object
  window*: Window
  file*: Menu
  tearoff*: TearoffMenuItem
  tearoffButton*: Button
  tearoffState*: Label
  commands*: ActionGroup
  accelerators*: AccelGroup
  manager*: UIManager

proc buildMenuExample*(): MenuExample =
  ## Call gtk2.init() first. Construction shows nothing and starts no loop.
  let window = newWindow("gtk2 menus and managed commands", 640, 460)
  var ready = false
  defer:
    if not ready: window.destroy()
  let root = newVBox(spacing = 12)
  window.add(root)
  let bar = newMenuBar()
  root.packStart(bar, packShrink)
  let body = newLabel("Click the dashed row at the top of File to detach its menu.\n" &
    "It initially stays in the same position; the arrow row reattaches it.")
  root.packStart(body)
  let status = newLabel("Ready")
  root.packEnd(status, packShrink)

  let fileHeading = newMenuItem("_File", mnemonic = true)
  let file = newMenu()
  bar.append(fileHeading)
  fileHeading.submenu = file
  file.tearoffTitle = "File actions"
  let tearoff = newTearoffMenuItem()
  file.prepend(tearoff)
  let tearoffControls = newHBox(spacing = 8)
  let tearoffButton = newButton("Detach File menu")
  let tearoffState = newLabel("File menu: attached")
  tearoffControls.packStart(tearoffButton, packShrink)
  tearoffControls.packStart(tearoffState)
  root.packStart(tearoffControls, packShrink)
  file.onTearoffChanged(proc (detached: bool) =
    if tearoffButton.isDestroyed or tearoffState.isDestroyed: return
    tearoffButton.text = (if detached: "Reattach File menu" else: "Detach File menu")
    tearoffState.text = (if detached: "File menu: detached (File actions window)" else: "File menu: attached"))
  tearoffButton.onClicked(proc () = file.tornOff = not file.tornOff)
  let commands = newActionGroup("menu-example")
  let accelerators = newAccelGroup()
  accelerators.attach(window)
  let createAction = newAction("new", "_New", "Create an example document")
  createAction.iconName = "document-new"
  let quitAction = newAction("quit", "_Quit")
  commands.add(createAction)
  commands.add(quitAction)
  accelerators.bindShortcut(createAction, "<Control>n")
  accelerators.bindShortcut(quitAction, "<Control>q")
  let create = createAction.createMenuItem()
  file.append(create)
  file.append(newSeparatorMenuItem())
  let quit = quitAction.createMenuItem()
  file.append(quit)
  var count = 0
  createAction.onActivate(proc () =
    inc count
    status.text = "New action " & $count)
  quitAction.onActivate(proc () = window.destroy())
  window.onDestroy(proc () =
    commands.disconnectSignals() # Cancel deferred work and break command -> window captures.
    accelerators.clearShortcuts())

  let viewHeading = newMenuItem("_View", mnemonic = true)
  let view = newMenu()
  bar.append(viewHeading)
  viewHeading.submenu = view
  let showStatus = newCheckMenuItem("_Show status", mnemonic = true)
  showStatus.active = true
  showStatus.onToggled(proc () =
    if showStatus.active: status.show()
    else: status.hide())
  view.append(showStatus)
  view.append(newSeparatorMenuItem())
  let normal = newRadioMenuItem("_Normal", mnemonic = true)
  let compact = newRadioMenuItem(normal, "_Compact", mnemonic = true)
  view.append(normal)
  view.append(compact)
  normal.onToggled(proc () =
    if normal.active: body.text = "Normal view selected")
  compact.onToggled(proc () =
    if compact.active: body.text = "Compact view selected")

  let helpHeading = newMenuItem("_Help", mnemonic = true)
  let help = newMenu()
  let about = newMenuItem("_About this example", mnemonic = true)
  bar.append(helpHeading)
  helpHeading.submenu = help
  help.append(about)
  about.onActivate(proc () =
    body.text = "Menu callbacks are tracked closures; destroying the window cleans up the tree.")

  # A second command collection is laid out and merged by native UIManager.
  let managed = newActionGroup("managed-tools")
  let choose = newRadioAction("Choose", "_Select", 10)
  let draw = newRadioAction(choose, "Draw", "_Draw", 20)
  managed.add(newAction("ManagedTools", "_Managed tools"))
  managed.add(choose)
  managed.add(draw)
  let refresh = newAction("Refresh", "_Refresh")
  managed.add(refresh)
  let manager = newUIManager([managed], tearoffs = true)
  manager.attach(window)
  window.onDestroy(proc () = manager.close())
  manager.bindShortcut(choose, "<Control>1")
  manager.bindShortcut(draw, "<Control>2")
  choose.onChanged(proc (value: int32) =
    body.text = (if value == 10: "Managed selection tool" else: "Managed drawing tool"))
  refresh.onActivate(proc () = status.text = "Merged Refresh command")
  discard manager.addUi("""<ui>
    <menubar name="ManagedBar"><menu action="ManagedTools">
      <menuitem action="Choose"/><menuitem action="Draw"/><placeholder name="Extra"/>
    </menu></menubar>
    <toolbar name="ManagedToolbar"><toolitem action="Choose"/><toolitem action="Draw"/>
      <placeholder name="Extra"/></toolbar>
  </ui>""")
  root.packStart(manager.get("/ManagedBar", MenuBar), packShrink)
  root.packStart(manager.get("/ManagedToolbar", Toolbar), packShrink)
  let toggleMerge = newButton("Add/remove Refresh command")
  root.packStart(toggleMerge, packShrink)
  var extra: UIMerge
  toggleMerge.onClicked(proc () =
    if manager.active(extra): manager.remove(extra)
    else:
      extra = manager.addUi("""<ui>
        <menubar name="ManagedBar"><menu action="ManagedTools"><placeholder name="Extra">
          <menuitem action="Refresh"/></placeholder></menu></menubar>
        <toolbar name="ManagedToolbar"><placeholder name="Extra"><toolitem action="Refresh"/></placeholder></toolbar>
      </ui>"""))

  # Native action menu proxies also display their registered keyboard shortcut.
  let monitor = newAccelLabel("Use Ctrl+N for New; Ctrl+Q to close. Menu mnemonics still work.")
  monitor.accelWidget = create
  root.packStart(monitor, packShrink)
  result = MenuExample(window: window, file: file, tearoff: tearoff,
    tearoffButton: tearoffButton, tearoffState: tearoffState,
    commands: commands, accelerators: accelerators, manager: manager)
  ready = true

proc main() =
  gtk2.init()
  let example = buildMenuExample()
  defer: example.window.destroy()
  example.window.run()

when isMainModule:
  main()
