## GtkBuilder layout with checked handles and Nim closures, never symbol lookup.
## nim c -r --path:src examples/ergonomic.nim
import gtk2

type ErgonomicExample* = object
  ui*: Builder
  window*: Window
  name*: Entry
  greeting*: Label
  greet*, close*: Button

proc buildErgonomicExample*(): ErgonomicExample =
  ## Requires gtk2.init(). The XML explicitly leaves its window unmapped.
  const layoutXml = staticRead("ergonomic.ui")
  let ui = newBuilder(layoutXml)
  var ready = false
  defer:
    if not ready: ui.close()
  let window = ui.get("window", Window)
  let name = ui.get("name", Entry)
  let greeting = ui.get("greeting", Label)
  let greet = ui.get("greet", Button)
  let close = ui.get("close", Button)
  ui.connectSignals([
    BuilderHandler(name: "greet", fn: proc () = greeting.text = "Hello, " & name.text & "!"),
    BuilderHandler(name: "close", fn: proc () = ui.close())])
  result = ErgonomicExample(ui: ui, window: window, name: name,
    greeting: greeting, greet: greet, close: close)
  ready = true

proc main() =
  gtk2.init()
  let example = buildErgonomicExample()
  defer: example.ui.close() # Also breaks callbacks capturing the document itself.
  example.window.run()

when isMainModule and not defined(gtk2DisableMain):
  main()
