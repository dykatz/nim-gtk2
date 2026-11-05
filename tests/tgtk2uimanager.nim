# Never map generated widgets or host windows.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
const layout = """<ui>
  <menubar name="Main"><menu action="File"><menuitem action="Open"/>
    <placeholder name="Extra"/><separator/><menuitem action="Select"/><menuitem action="Draw"/>
  </menu></menubar>
  <toolbar name="Tools"><toolitem action="Open"/><toolitem action="Select"/><toolitem action="Draw"/></toolbar>
</ui>"""
type Commands = object
  group: ActionGroup
  open: gtk2.Action
  select, draw: RadioAction
proc commands(): Commands =
  result.group = newActionGroup("editor")
  result.open = newAction("Open", "_Open")
  result.select = newRadioAction("Select", "_Select", -7)
  result.draw = newRadioAction(result.select, "Draw", "_Draw", 42)
  result.group.add(newAction("File", "_File"))
  result.group.add(result.open)
  result.group.add(result.select)
  result.group.add(result.draw)

gtk2.init()
suite "radio commands and managed UI (unmapped)":
  test "radio groups validate values, retain selection when joining/moving, copy changed snapshots":
    let a = newRadioAction("a", "A", -7)
    let b = newRadioAction(a, "b", "B", 42)
    check a.active and not b.active and b.currentValue == -7
    expect ValueError: discard newRadioAction(a, "duplicate", "Duplicate", 42)
    expect ValueError: a.currentValue = 999
    expect ValueError: discard newAction("plain", "Plain").asRadioAction
    check gtk2.Action(a).asRadioAction.raw == a.raw
    var snapshots: seq[int32]
    a.onChanged(proc (value: int32) = snapshots.add(value))
    defer: a.disconnectSignals()
    a.currentValue = 42
    a.currentValue = -7
    check snapshots.len == 0 and a.active
    drain()
    check snapshots == @[42'i32, -7'i32]
    let c = newRadioAction("c", "C", 90)
    c.sensitive = false
    c.joinGroup(a)
    check a.active and not c.active
    let other = newRadioAction("other", "Other", 100)
    a.joinGroup(other)
    check (b.active != c.active) and other.active and not a.active
  test "GtkBuilder radio lookup preserves native groupless objects until explicitly selected":
    let document = newBuilder("<interface><object class=\"GtkRadioAction\" id=\"radio\"><property name=\"value\">-9</property></object></interface>")
    defer: document.close()
    let radio = document.get("radio", RadioAction)
    check radio.value == -9
    radio.currentValue = -9
    check radio.active
  test "fixed schema guards, checked paths, native menu/toolbar proxies and scoped shortcuts":
    let c = commands()
    let ui = newUIManager([c.group], tearoffs = true)
    defer: ui.close()
    expect ValueError: c.group.add(newAction("late", "Late"))
    expect ValueError: c.group.remove(c.open)
    expect ValueError: discard newUIManager([c.group])
    expect ValueError: discard ui.addUi("<ui><menubar name=\"bad\"><menu action=\"Missing\"/></menubar></ui>")
    expect ValueError: discard ui.addUi("<ui><menubar name=\"bad\"><menu/></menubar></ui>")
    let merge = ui.addUi(layout)
    check ui.active(merge) and ui.tearoffs
    let bar = ui.get("/Main", MenuBar)
    let tool = ui.get("/Tools/Open", gtk2.ToolButton)
    let menu = ui.get("/Main/File/Open", MenuItem)
    check menu.text == "_Open" and ui.action("/Tools/Open").raw == c.open.raw
    expect ValueError: discard ui.get("/Main", gtk2.Toolbar)
    expect ValueError: discard ui.get("/missing", Widget)
    expect ValueError: discard ui.get("bad-path", Widget)
    expect ValueError: discard ui.action("/Main")
    check ui.uiDescription.len > 0
    let host = newWindow()
    defer: host.destroy()
    host.add(newVBox())
    ui.attach(host)
    ui.attach(host)
    var calls = 0
    c.open.onActivate(proc () = inc calls)
    ui.bindShortcut(c.open, "<Control>o")
    let foreign = newAccelGroup()
    expect ValueError: foreign.bindShortcut(c.draw, "<Control>d")
    expect ValueError: ui.bindShortcut(newAction("stranger", "Stranger"), "<Control>s")
    check host.activateShortcut(parseShortcut("<Control>o"))
    drain()
    check calls == 1
    c.group.sensitive = false
    check not menu.sensitive and not host.activateShortcut(parseShortcut("<Control>o"))
    c.group.sensitive = true
    ui.remove(merge)
    ui.remove(merge)
    check not ui.active(merge) and bar.isDestroyed and tool.isDestroyed and menu.isDestroyed
    ui.close()
    check not host.activateShortcut(parseShortcut("<Control>o"))
    c.group.add(newAction("reusable", "Reusable"))
    let next = newUIManager([c.group])
    defer: next.close()
    expect ValueError: next.remove(merge)
  test "overlays can be removed independently; invalid XML never corrupts previous merges":
    let c = commands()
    let ui = newUIManager([c.group])
    defer: ui.close()
    let empty = ui.addUi("<?xml version=\"1.0\"?><ui/>")
    check ui.active(empty)
    ui.remove(empty)
    let base = ui.addUi(layout)
    let open = ui.get("/Main/File/Open", MenuItem)
    let extra = ui.addUi("<ui><menubar name=\"Main\"><menu action=\"File\"><placeholder name=\"Extra\"><menuitem name=\"ExtraOpen\" action=\"Open\"/></placeholder></menu></menubar></ui>")
    let extraItem = ui.get("/Main/File/Extra/ExtraOpen", MenuItem)
    expect UIManagerError: discard ui.addUi("<ui><broken/></ui>")
    check ui.active(base) and ui.active(extra) and not open.isDestroyed
    ui.remove(extra)
    check extraItem.isDestroyed and not open.isDestroyed
    let again = ui.addUi(layout)
    ui.remove(base)
    check not open.isDestroyed and ui.active(again)
    ui.remove(again)
    check open.isDestroyed
  test "close from a synchronous destroy observer is deferred until native unmerge finishes":
    let c = commands()
    let ui = newUIManager([c.group])
    let merge = ui.addUi(layout)
    let item = ui.get("/Main/File/Open", MenuItem)
    item.onDestroy(proc () = ui.close())
    ui.remove(merge)
    check ui.closed and item.isDestroyed
  test "dropping the last caller handle inside native destroy cannot finalize the active traversal":
    let c = commands()
    var ui = newUIManager([c.group])
    var finalized = 0
    g.weak_ref(cast[g.PGObject](ui.raw), gone, addr finalized)
    let merge = ui.addUi(layout)
    let item = ui.get("/Main/File/Open", MenuItem)
    item.onDestroy(proc () = ui = UIManager())
    ui.remove(merge)
    check ui.closed and item.isDestroyed and finalized == 1
  test "close cancels action observations and unfreezes retained groups; last handle finalizes":
    let c = commands()
    let ui = newUIManager([c.group])
    discard ui.addUi(layout)
    var calls = 0
    c.draw.onChanged(proc (value: int32) = inc calls)
    c.draw.currentValue = 42
    ui.close()
    drain()
    check calls == 0
    c.group.remove(c.open)
    var finalized = 0
    block:
      let temporary = newUIManager([c.group])
      g.weak_ref(cast[g.PGObject](temporary.raw), gone, addr finalized)
      discard temporary.addUi("<ui><toolbar name=\"tools\"><toolitem action=\"Draw\"/></toolbar></ui>")
    check finalized == 1
