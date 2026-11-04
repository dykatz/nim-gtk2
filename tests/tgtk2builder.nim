# Every XML toplevel has visible=false. No native signal symbol lookup occurs.
import std/[unittest, os, tempfiles]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
const sample = """<interface>
  <requires lib="gtk+" version="2.24"/>
  <object class="GtkTextBuffer" id="document"><property name="text">λ🙂</property></object>
  <object class="GtkAdjustment" id="amount"><property name="upper">100</property></object>
  <object class="GtkAction" id="command"><property name="name">command</property><property name="label">Run</property>
    <signal name="activate" handler="run"/></object>
  <object class="GtkWindow" id="window"><property name="visible">False</property>
    <child><object class="GtkVBox" id="box">
      <child><object class="GtkEntry" id="name"><property name="text">Nim</property></object></child>
      <child><object class="GtkLabel" id="greeting"><property name="label">Ready</property></object></child>
      <child><object class="GtkButton" id="button"><property name="label">Greet</property>
        <signal name="clicked" handler="greet" after="yes"/>
      </object></child>
    </object></child>
  </object>
</interface>"""
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc windows(): int =
  let list = n.window_list_toplevels()
  defer: g.free(list)
  var node = list
  while node != nil:
    inc result
    node = node.next

gtk2.init()
suite "owned GtkBuilder documents (never mapped)":
  test "typed lookups share states, copy strings and reject missing/mistyped IDs":
    let ui = newBuilder(sample, "nim-gtk2-tests")
    defer: ui.close()
    check not ui.closed
    check ui.translationDomain == "nim-gtk2-tests"
    check ui.hasObject("button") and not ui.hasObject("absent")
    let window = ui.get("window", gtk2.Window)
    let entry = ui.get("name", Entry)
    let button = ui.get("button", gtk2.Button)
    check entry.text == "Nim" and button.text == "Greet"
    check ui.get("document", TextBuffer).text == "λ🙂"
    check ui.get("amount", Adjustment).upper == 100
    check ui.get("command", gtk2.Action).label == "Run"
    check ui.get("button", Widget).raw == cast[n.PWidget](button.raw)
    check not g.toBool(n.get_mapped(cast[n.PWidget](window.raw)))
    expect ValueError: discard ui.get("button", Entry)
    expect ValueError: discard ui.get("document", Widget)
    expect ValueError: discard ui.get("absent", Label)
    expect ValueError: discard ui.hasObject("")
    expect ValueError: discard ui.get("bad\0id", Widget)
    static:
      doAssert not compiles(default(Builder).get("column", TextColumn))
      doAssert not compiles(default(Builder).get("group", ActionGroup))
    let objects = ui.objects
    check objects.len == 8
    let declarations = ui.declarations
    check declarations.len == 2
    var found = false
    for declaration in declarations:
      if declaration.objectId == "button":
        found = declaration.handlerName == "greet" and declaration.after and not declaration.swapped
    check found
    let alias = ui
    alias.close()
    check ui.closed and window.isDestroyed and entry.isDestroyed
    check objects.len == 8 and declarations.len == 2
    expect ValueError: discard ui.raw
    expect ValueError: discard ui.objects
    ui.close()
  test "all signal mappings validate before connection; deferred callbacks and explicit unwiring":
    let ui = newBuilder(sample)
    defer: ui.close()
    let button = ui.get("button", gtk2.Button)
    let command = ui.get("command", gtk2.Action)
    var clicks, runs = 0
    expect ValueError: ui.connectSignals([BuilderHandler(name: "greet", fn: proc () = inc clicks)])
    button.click()
    drain()
    check clicks == 0
    expect ValueError: ui.connectSignals([BuilderHandler(name: "typo", fn: proc () = discard)])
    expect ValueError: ui.connectSignals([BuilderHandler(name: "greet", fn: nil)])
    ui.connectSignals([
      BuilderHandler(name: "greet", fn: proc () = inc clicks),
      BuilderHandler(name: "run", fn: proc () = inc runs)])
    expect ValueError: ui.connectSignals([])
    button.click()
    button.click()
    command.activate()
    check clicks == 0 and runs == 0
    drain()
    check clicks == 2 and runs == 1
    button.click()
    ui.disconnectSignals()
    drain()
    check clicks == 2
    ui.connectSignals([
      BuilderHandler(name: "greet", fn: proc () =
        inc clicks
        ui.close()
        raise newException(ValueError, "expected builder callback error")),
      BuilderHandler(name: "run", fn: proc () = inc runs)])
    button.click()
    command.activate()
    drain()
    check clicks == 3 and runs == 1 and ui.closed
  test "parameterized, result, destroy, swapped and object-connected signals require explicit typed wiring":
    for signal in ["<signal name=\"notify::label\" handler=\"handler\"/>",
        "<signal name=\"button-press-event\" handler=\"handler\"/>",
        "<signal name=\"destroy\" handler=\"handler\"/>",
        "<signal name=\"clicked\" handler=\"handler\" swapped=\"yes\"/>",
        "<signal name=\"clicked\" handler=\"handler\" object=\"other\"/>"]:
      let ui = newBuilder("<interface><object class=\"GtkButton\" id=\"other\"/>" &
        "<object class=\"GtkButton\" id=\"button\">" & signal & "</object></interface>")
      defer: ui.close()
      expect ValueError: ui.connectSignals([BuilderHandler(name: "handler", fn: proc () = discard)])
  test "retained widgets invalidate, plain data survives close, and direct connections are released":
    let ui = newBuilder(sample)
    let doc = ui.get("document", TextBuffer)
    let command = ui.get("command", gtk2.Action)
    let entry = ui.get("name", Entry)
    var calls = 0
    command.onActivate(proc () = inc calls)
    doc.onChanged(proc () = inc calls)
    command.activate()
    ui.close()
    drain()
    check calls == 0 and entry.isDestroyed
    check doc.text == "λ🙂"
    doc.text = "independent document"
    command.activate()
    drain()
    check calls == 0
  test "dropping the last document closes all widgets, including unnamed-to-SDK roots":
    let before = windows()
    var builderGone, widgetGone = 0
    block:
      let ui = newBuilder(sample)
      g.weak_ref(cast[g.PGObject](ui.raw), finalized, addr builderGone)
      # Merely query raw native ownership here; no SDK handle keeps the widget alive.
      let widget = n.builder_get_object(ui.raw, "window")
      g.weak_ref(widget, finalized, addr widgetGone)
    check builderGone == 1 and widgetGone == 1 and windows() == before
  test "copied GErrors and partial parse failure cleanup; input validation precedes construction":
    let before = windows()
    expect ValueError: discard newBuilder("bad\0XML")
    expect ValueError: discard newBuilder("\xff")
    expect ValueError: discard loadBuilder("")
    try:
      discard newBuilder("<interface><object class=\"GtkWindow\" id=\"partial\"><child><object class=\"GtkLabel\" id=\"label\"/></child></object><broken/></interface>")
      check false
    except BuilderError as error:
      check error.msg.len > 0 and error.domain != 0
    check windows() == before
    expect BuilderError: discard newBuilder("<interface><object class=\"NotARegisteredGtkType\" id=\"bad\"/></interface>")
    let directory = createTempDir("nim-gtk2-builder-", "")
    defer: removeDir(directory)
    expect BuilderError: discard loadBuilder(directory / "missing.ui")
    let filename = directory / "example.ui"
    writeFile(filename, sample)
    defer: removeFile(filename)
    let ui = loadBuilder(filename)
    check ui.get("name", Entry).text == "Nim"
    ui.close()
    let relative = loadBuilder("examples/ergonomic.ui")
    check relative.get("name", Entry).text == "Nim"
    relative.close()
