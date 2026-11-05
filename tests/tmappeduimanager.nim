import std/[os, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped UIManager tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc settle() =
  for i in 0..<20:
    for step in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    sleep(10)

gtk2.init()
suite "mapped native UIManager":
  test "shared radio proxies, shortcut labels, native tearoff and live merge removal":
    let host = newWindow("Managed UI", 520, 220)
    defer: host.destroy()
    let root = newVBox()
    host.add(root)
    let group = newActionGroup("mapped-ui")
    let select = newRadioAction("Select", "_Select", -7)
    let draw = newRadioAction(select, "Draw", "_Draw", 42)
    let refresh = newAction("Refresh", "Refresh")
    group.add(newAction("File", "_File"))
    group.add(select)
    group.add(draw)
    group.add(refresh)
    let ui = newUIManager([group], tearoffs = true)
    defer: ui.close()
    host.onDestroy(proc () = ui.close())
    ui.attach(host)
    ui.bindShortcut(draw, "<Control>2")
    let base = ui.addUi("""<ui><menubar name="Main"><menu action="File">
      <menuitem action="Select"/><menuitem action="Draw"/><placeholder name="Extra"/>
      </menu></menubar><toolbar name="Tools"><toolitem action="Select"/>
      <toolitem action="Draw"/></toolbar></ui>""")
    root.packStart(ui.get("/Main", MenuBar), packShrink)
    root.packStart(ui.get("/Tools", gtk2.Toolbar), packShrink)
    let entry = newEntry("Keyboard focus")
    root.packStart(entry)
    let menuDraw = ui.get("/Main/File/Draw", CheckMenuItem)
    let toolDraw = ui.get("/Tools/Draw", gtk2.ToggleToolButton)
    let file = ui.get("/Main/File", MenuItem).submenu
    var seen: seq[int32]
    select.onChanged(proc (value: int32) = seen.add(value))
    host.showAll()
    settle()
    require g.toBool(n.get_mapped(cast[n.PWidget](toolDraw.raw)))
    let label = cast[n.PAccelLabel](n.get_child(cast[n.PBin](menuDraw.raw)))
    discard n.refetch(label)
    var size: n.TRequisition
    n.size_request(cast[n.PWidget](label), addr size)
    check n.get_accel_width(label) > 0
    check host.activateShortcut(parseShortcut("<Control>2"))
    settle()
    check draw.active and menuDraw.active and toolDraw.active and seen == @[42'i32]
    select.currentValue = -7
    settle()
    check not menuDraw.active and not toolDraw.active
    file.tornOff = true
    settle()
    check file.tornOff
    file.tornOff = false
    settle()
    let extension = ui.addUi("<ui><menubar name=\"Main\"><menu action=\"File\"><placeholder name=\"Extra\"><menuitem action=\"Refresh\"/></placeholder></menu></menubar></ui>")
    let proxy = ui.get("/Main/File/Extra/Refresh", MenuItem)
    var calls = 0
    refresh.onActivate(proc () = inc calls)
    proxy.activate()
    settle()
    check calls == 1
    ui.remove(extension)
    check proxy.isDestroyed and ui.active(base)
    group.visible = false
    host.showAll()
    check not g.toBool(n.get_visible(cast[n.PWidget](toolDraw.raw)))
    group.visible = true
    draw.onActivate(proc () = host.destroy())
    check host.activateShortcut(parseShortcut("<Control>2"))
    settle()
    check host.isDestroyed and ui.closed and toolDraw.isDestroyed
