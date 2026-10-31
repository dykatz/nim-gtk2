## GTK2 alignment, button boxes, table forms, fixed positioning and event boxes.
## Build: nim c --path:src examples/containers.nim
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 layout containers", 580, 350)
  defer: window.destroy()
  window.borderWidth = 12
  let root = newVBox(spacing = 10)
  window.add(root)

  let alignment = newAlignment(0, 0, 1, 0)
  alignment.setPadding(4, 8, 12, 12)
  let form = newTable(2, 2)
  form.rowSpacing = 8
  form.columnSpacing = 12
  let name = newEntry("A table-based form")
  let number = newSpinButton(0, 100)
  form.attach(newLabel("Name:"), 0, 1, 0, 1, xoptions = {}, yoptions = {})
  form.attach(name, 1, 2, 0, 1, yoptions = {})
  form.attach(newLabel("Amount:"), 0, 1, 1, 2, xoptions = {}, yoptions = {})
  form.attach(number, 1, 2, 1, 2, yoptions = {})
  alignment.add(form)
  root.packStart(alignment, packShrink)

  let eventBox = newEventBox()
  eventBox.add(newLabel("EventBox gives this windowless label a native event window."))
  root.packStart(eventBox, packShrink)
  let row = newHBox(spacing = 8)
  let fixed = newFixed()
  fixed.setSizeRequest(350, 85)
  let movable = newButton("Move me")
  fixed.put(movable, 15, 15)
  movable.onClicked(proc () =
    let position = fixed.position(movable)
    fixed.move(movable, (if position.x == 15: 170 else: 15), 15))
  row.packStart(fixed)
  let vertical = newVButtonBox(style = buttonsStart)
  let top = newButton("Top left")
  let bottom = newButton("Bottom right")
  top.onClicked(proc () = fixed.move(movable, 15, 0))
  bottom.onClicked(proc () = fixed.move(movable, 170, 45))
  vertical.packStart(top, packShrink)
  vertical.packStart(bottom, packShrink)
  row.packStart(vertical, packShrink)
  root.packStart(row)

  let buttons = newHButtonBox(style = buttonsEnd)
  let help = newButton("Help")
  let reset = newButton("Reset")
  let close = newButton("Close")
  help.onClicked(proc () = name.text = "Click Move me, or use the vertical action box.")
  reset.onClicked(proc () =
    name.text = "A table-based form"
    number.value = 0
    fixed.move(movable, 15, 15))
  close.onClicked(proc () = window.destroy())
  buttons.packStart(help, packShrink)
  buttons.packStart(reset, packShrink)
  buttons.packStart(close, packShrink)
  buttons.setSecondary(help)
  root.packEnd(buttons, packShrink)
  window.run()

when isMainModule:
  main()
