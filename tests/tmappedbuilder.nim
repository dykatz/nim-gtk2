# Explicit opt-in only: this maps the GtkBuilder-created example window.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import ../examples/ergonomic
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped builder tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 5
  while epochTime() < deadline:
    for step in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)

gtk2.init()
suite "mapped GtkBuilder example":
  test "XML layout, repeated handler names, native widget activation and document close":
    let example = buildErgonomicExample()
    defer: example.ui.close()
    check not g.toBool(n.get_mapped(cast[n.PWidget](example.window.raw)))
    example.window.showAll()
    require awaitUi(proc (): bool = g.toBool(n.get_mapped(cast[n.PWidget](example.greet.raw))))
    example.name.text = "λ🙂"
    require g.toBool(n.activate(cast[n.PWidget](example.name.raw)))
    require awaitUi(proc (): bool = example.greeting.text == "Hello, λ🙂!")
    example.name.text = "Builder"
    # Native GtkButton activation includes its mapped animation/timeout before
    # clicked; this is not a manual emit-by-name shortcut around GTK behavior.
    require g.toBool(n.activate(cast[n.PWidget](example.greet.raw)))
    require awaitUi(proc (): bool = example.greeting.text == "Hello, Builder!")
    require g.toBool(n.activate(cast[n.PWidget](example.close.raw)))
    require awaitUi(proc (): bool = example.ui.closed)
    check example.window.isDestroyed and example.name.isDestroyed and example.greeting.isDestroyed
    expect ValueError: discard example.ui.get("window", gtk2.Window)
  test "closing a document with queued XML signals cancels callbacks before layout teardown":
    let ui = newBuilder("<interface><object class=\"GtkWindow\" id=\"window\"><child>" &
      "<object class=\"GtkButton\" id=\"button\"><signal name=\"clicked\" handler=\"click\"/>" &
      "</object></child></object></interface>")
    defer: ui.close()
    let window = ui.get("window", gtk2.Window)
    let button = ui.get("button", gtk2.Button)
    var calls = 0
    ui.connectSignals([BuilderHandler(name: "click", fn: proc () = inc calls)])
    window.showAll()
    require awaitUi(proc (): bool = g.toBool(n.get_mapped(cast[n.PWidget](button.raw))))
    button.click()
    ui.close()
    discard awaitUi(proc (): bool = ui.closed)
    check calls == 0 and window.isDestroyed and button.isDestroyed
