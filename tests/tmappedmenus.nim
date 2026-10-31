# Maps GTK windows: run ONLY on an isolated virtual display, never a desktop.
# GTK2_TEST_VIRTUAL_DISPLAY=1 xvfb-run -a nimble testMappedMenus
import std/[os, unittest]
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g
import ../examples/menus as menuExample

if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped menu tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)

proc drainUi() =
  for i in 0..<128:
    if rawGtk.events_pending() == 0: return
    discard rawGtk.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "unexpected continuously pending UI source")
proc top(menu: gtk2.Menu): rawGtk.PWidget =
  rawGtk.get_toplevel(cast[rawGtk.PWidget](menu.raw))
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]

gtk2.init()
suite "mapped menu behavior on an isolated virtual display":
  test "example button detaches before the first popup, updates state, and reattaches":
    let example = buildMenuExample()
    defer: example.window.destroy()
    example.window.showAll()
    drainUi()
    var states: seq[bool]
    example.file.onTearoffChanged(proc (value: bool) = states.add(value))
    check not example.file.tornOff
    check example.tearoffState.text == "File menu: attached"
    example.tearoffButton.click() # Never opened File first: previously a GDK critical.
    drainUi()
    check example.file.tornOff
    check states == @[true]
    check example.tearoffButton.text == "Reattach File menu"
    check example.tearoffState.text == "File menu: detached (File actions window)"
    let floating = top(example.file)
    check rawGtk.IS_WINDOW(floating)
    check g.toBool(rawGtk.get_visible(floating))
    check $rawGtk.get_title(cast[rawGtk.PWindow](floating)) == "File actions"
    example.file.tearoffTitle = "Updated café title"
    check $rawGtk.get_title(cast[rawGtk.PWindow](floating)) == "Updated café title"
    var gone = 0
    g.weak_ref(cast[g.PGObject](floating), finalized, addr gone)
    example.tearoffButton.click()
    drainUi()
    check not example.file.tornOff
    check states == @[true, false]
    check example.tearoffButton.text == "Detach File menu"
    check example.tearoffState.text == "File menu: attached"
    check gone == 1

  test "tearoff activation works before any popup and the native close path updates the example":
    let example = buildMenuExample()
    defer: example.window.destroy()
    example.window.showAll()
    drainUi()
    example.tearoff.activate() # Also requires realizing the not-yet-popped-up Menu.
    drainUi()
    check example.file.tornOff
    check example.tearoffButton.text == "Reattach File menu"
    rawGtk.destroy(top(example.file)) # Same destroy path used by WM close requests.
    drainUi()
    check not example.file.tornOff
    check example.tearoffButton.text == "Detach File menu"
    check example.tearoffState.text == "File menu: attached"

  test "native menu-shell activation toggles the dashed row and window destruction closes tearoffs":
    let example = buildMenuExample()
    defer: example.window.destroy()
    example.window.showAll()
    drainUi()
    rawGtk.popup(example.file.raw, nil, nil, nil, nil, 0, 0)
    drainUi()
    rawGtk.activate_item(cast[rawGtk.PMenuShell](example.file.raw),
      cast[rawGtk.PWidget](example.tearoff.raw), g.gbool(true))
    drainUi()
    check example.file.tornOff
    check example.tearoffState.text == "File menu: detached (File actions window)"
    var gone = 0
    g.weak_ref(cast[g.PGObject](top(example.file)), finalized, addr gone)
    example.window.destroy()
    drainUi()
    check example.file.isDestroyed
    check example.tearoff.isDestroyed
    check gone == 1

  test "tearoff state callbacks self-disconnect, contain exceptions and allow destruction":
    let menu = newMenu()
    defer: menu.destroy()
    menu.append(newTearoffMenuItem())
    menu.append(newMenuItem("Action"))
    menu.showAll()
    var connection: Connection
    var calls = 0
    connection = menu.onTearoffChanged(proc (value: bool) =
      inc calls
      check value
      connection.disconnect()
      menu.destroy()
      raise newException(ValueError, "expected tearoff state callback error"))
    menu.tornOff = true
    drainUi()
    check menu.isDestroyed
    check not connection.connected
    check calls == 1
