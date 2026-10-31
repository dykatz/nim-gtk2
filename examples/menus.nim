## Checked menu-bar trees, stateful items, image items, and accelerator labels.
## Build: nim c --path:src examples/menus.nim
import gtk2

type MenuExample* = object
  window*: Window
  file*: Menu
  tearoff*: TearoffMenuItem
  tearoffButton*: Button
  tearoffState*: Label

proc buildMenuExample*(): MenuExample =
  ## Call gtk2.init() first. Construction shows nothing and starts no loop.
  let window = newWindow("gtk2 menus", 580, 340)
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
  let create = newImageMenuItem("_New", mnemonic = true)
  create.image = newImage(newPixbuf(16, 16, 0x4080e0ff'u32))
  create.alwaysShowImage = true
  file.append(create)
  file.append(newSeparatorMenuItem())
  let quit = newMenuItem("_Quit", mnemonic = true)
  file.append(quit)
  var count = 0
  create.onActivate(proc () =
    inc count
    status.text = "New action " & $count)
  quit.onActivate(proc () = window.destroy())

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

  # Custom accelerator registration is not wrapped yet. This label can monitor
  # shortcuts installed by raw GTK APIs; mnemonics above already work normally.
  let monitor = newAccelLabel("The New action's accelerator label (no custom shortcut installed)")
  monitor.accelWidget = create
  root.packStart(monitor, packShrink)
  result = MenuExample(window: window, file: file, tearoff: tearoff,
    tearoffButton: tearoffButton, tearoffState: tearoffState)
  ready = true

proc main() =
  gtk2.init()
  let example = buildMenuExample()
  defer: example.window.destroy()
  example.window.run()

when isMainModule:
  main()
