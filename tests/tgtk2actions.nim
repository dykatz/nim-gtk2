# All widgets remain unmapped; accelerator activation calls public GTK dispatch.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]

gtk2.init()
suite "actions and window-local accelerators (unmapped)":
  test "opaque handles and validated command properties":
    static:
      doAssert typeof(newAction("a", "A").raw) is n.PAction
      doAssert not compiles(default(gtk2.Action).destroy())
    expect ValueError: discard newAction("", "Label")
    expect ValueError: discard newAction("bad\0name", "Label")
    expect ValueError: discard newAction("a", "\xff")
    let a = newAction("save", "_Save", "Save document")
    check a.name == "save" and a.label == "_Save" and a.tooltip == "Save document"
    a.label = "Save λ"
    a.shortLabel = "Save"
    a.tooltip = "Save 🙂"
    a.iconName = "document-save"
    check a.label == "Save λ" and a.shortLabel == "Save" and a.iconName == "document-save"
    expect ValueError: a.label = "bad\0value"
    expect ValueError: discard a.onActivate(nil)
  test "native proxies share label, sensitivity, visibility and toggle state":
    let group = newActionGroup("editor")
    let a = newToggleAction("pin", "_Pin")
    group.add(a)
    let menu = a.createMenuItem()
    let tool = a.createToolItem()
    defer:
      menu.destroy()
      tool.destroy()
      group.disconnectSignals()
    check menu.text == "_Pin" and group.action("pin").asToggleAction.raw == a.raw
    expect ValueError: discard newAction("plain", "Plain").asToggleAction
    var states: seq[bool]
    a.onToggled(proc (value: bool) = states.add(value))
    a.active = true
    check menu.active and tool.active and states.len == 0
    a.active = false
    drain()
    check states == @[true, false]
    a.label = "_Pinned"
    check menu.text == "_Pinned"
    group.sensitive = false
    check a.sensitive and not a.effectiveSensitive and not menu.sensitive
    check not g.toBool(n.get_sensitive(cast[n.PWidget](tool.raw)))
    group.sensitive = true
    a.sensitive = false
    check not a.effectiveSensitive
    a.visible = false
    check not a.effectiveVisible
    a.visible = true
    group.visible = false
    check a.visible and not a.effectiveVisible
  test "group aliases retain command callbacks, reject duplicate/cross-group membership":
    let group = newActionGroup("commands")
    let other = newActionGroup("other")
    var calls = 0
    block:
      let a = newAction("open", "Open")
      a.onActivate(proc () = inc calls)
      group.add(a)
    group.action("open").activate()
    check calls == 0
    drain()
    check calls == 1
    let alias = group
    let a = alias.action("open")
    expect ValueError: other.add(a)
    expect ValueError: group.add(newAction("open", "Duplicate"))
    expect ValueError: other.remove(a)
    expect ValueError: discard group.action("missing")
    group.remove(a)
    other.add(a)
    check other.action("open").raw == a.raw
    other.disconnectSignals()
    a.activate()
    drain()
    check calls == 1
  test "valid shortcuts normalize keys and reject invalid/default/button masks":
    let shortcut = parseShortcut("<Control><Shift>S")
    check shortcut.keyval == uint32('s') and shortcut.modifiers.has(modifierControl)
    check parseShortcut(shortcut.shortcutName) == shortcut
    expect ValueError: discard parseShortcut("")
    expect ValueError: discard parseShortcut("not-a-keysym")
    expect ValueError: discard parseShortcut("<Control>\0x")
    expect ValueError: discard newShortcut(uint32('x'), modifierButton1)
    expect ValueError: discard default(Shortcut).shortcutName
  test "window attach/detach, conflicts, rebinding and disabled actions use native dispatch":
    let window = newWindow()
    let second = newWindow()
    defer:
      window.destroy()
      second.destroy()
    let accelerators = newAccelGroup()
    let other = newAccelGroup()
    let a = newAction("command", "_Command")
    let b = newAction("other", "Other")
    defer:
      accelerators.clearShortcuts()
      a.disconnectSignals()
    let shortcut = parseShortcut("<Control>k")
    var calls = 0
    a.onActivate(proc () = inc calls)
    accelerators.bindShortcut(a, shortcut)
    check accelerators.shortcutFor(a) == shortcut
    expect ValueError: discard accelerators.shortcutFor(b)
    expect ValueError: other.bindShortcut(a, "<Control>l")
    expect ValueError: accelerators.bindShortcut(b, shortcut)
    let menu = a.createMenuItem()
    defer: menu.destroy()
    accelerators.attach(window)
    accelerators.attach(window)
    check accelerators.attached(window) and not accelerators.attached(second)
    check not second.activateShortcut(shortcut)
    check window.activateShortcut(shortcut)
    check calls == 0
    drain()
    check calls == 1
    a.sensitive = false
    check not window.activateShortcut(shortcut)
    a.sensitive = true
    accelerators.detach(window)
    accelerators.detach(window)
    check not window.activateShortcut(shortcut)
    accelerators.attach(window)
    accelerators.unbindShortcut(a)
    check not window.activateShortcut(shortcut)
    other.bindShortcut(a, shortcut)
    other.clearShortcuts()
    accelerators.bindShortcut(a, shortcut)
    check window.activateShortcut(shortcut)
    drain()
    check calls == 2
    let offscreen = newOffscreenWindow()
    defer: offscreen.destroy()
    expect ValueError: accelerators.attach(gtk2.Window(offscreen))
  test "native action emission snapshots are deferred, disconnect cancels, exceptions are contained":
    let a = newAction("command", "Command")
    var calls = 0
    var conn: Connection
    conn = a.onActivate(proc () =
      inc calls
      conn.disconnect()
      raise newException(ValueError, "expected action callback error"))
    a.activate()
    a.activate()
    drain()
    check calls == 1 and not conn.connected
    let pending = a.onActivate(proc () = inc calls)
    a.activate()
    pending.disconnect()
    drain()
    check calls == 1
  test "group and action finalization cancel callbacks and queued delivery without widget owners":
    var actionsGone, groupsGone, calls = 0
    block:
      let group = newActionGroup("temporary")
      let a = newAction("temporary", "Temporary")
      g.weak_ref(cast[g.PGObject](group.raw), finalized, addr groupsGone)
      g.weak_ref(cast[g.PGObject](a.raw), finalized, addr actionsGone)
      group.add(a)
      a.onActivate(proc () = inc calls)
      a.activate()
    drain()
    check actionsGone == 1 and groupsGone == 1 and calls == 0
  test "last accelerator handle unbinds before releasing actions, even when native window retains group":
    let window = newWindow()
    defer: window.destroy()
    var gone = 0
    let shortcut = parseShortcut("<Control>j")
    block:
      let accelerators = newAccelGroup()
      let a = newAction("temporary", "Temporary")
      g.weak_ref(cast[g.PGObject](a.raw), finalized, addr gone)
      accelerators.bindShortcut(a, shortcut)
      accelerators.attach(window)
      check window.activateShortcut(shortcut)
    check gone == 1
    check not window.activateShortcut(shortcut)
    check not g.toBool(n.get_mapped(cast[n.PWidget](window.raw)))
