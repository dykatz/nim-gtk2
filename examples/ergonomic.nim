import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("Hello from Nim", width = 360, height = 180)
  defer: window.destroy()
  window.borderWidth = 12

  let layout = newVBox(spacing = 8)
  let name = newEntry("Nim")
  let greeting = newLabel("Enter your name")
  let button = newButton("_Greet", mnemonic = true)
  window.add(layout)
  layout.packStart(name, packShrink)
  layout.packStart(greeting)
  layout.packEnd(button, packShrink)

  button.onClicked do ():
    greeting.text = "Hello, " & name.text & "!"

  window.run()

when not defined(gtk2DisableMain):
  main()
