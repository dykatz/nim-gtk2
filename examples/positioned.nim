## Scrollable positioning and a detachable toolbar. No raw imports required.
## Build with: nim c --path:src examples/positioned.nim
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 Layout and HandleBox", 740, 480)
  defer: window.destroy()
  let root = newVBox(spacing = 8)
  root.borderWidth = 10
  window.add(root)
  let status = newLabel("Toolbar attached. Drag its left handle to detach; drag back to snap.")
  root.packEnd(status, packShrink)
  let handle = newHandleBox(handleLeft, shadowOut, snapTop)
  root.packStart(handle, packShrink)
  let toolbar = newToolbar()
  toolbar.toolbarStyle = toolbarText
  handle.add(toolbar)
  handle.onChildDetached(proc (child: Widget) =
    status.text = "Toolbar detached. Drag back or close its floating window to reattach.")
  handle.onChildAttached(proc (child: Widget) =
    status.text = "Toolbar attached again")

  let scroller = newScrolledWindow()
  root.packStart(scroller)
  let canvas = newLayout(1600, 1000)
  scroller.add(canvas) # Native adjustments: no intermediate Viewport.
  canvas.put(newLabel("A 1600 × 1000 scrollable canvas; positions are pixels."), 25, 25)
  let moving = newButton("Move me")
  canvas.put(moving, 40, 90)
  moving.onClicked(proc () =
    let current = canvas.position(moving)
    let x = (current.x + 60) mod 1200
    canvas.move(moving, x, current.y)
    status.text = "Button position: " & $x & ", " & $current.y)
  let frame = newFrame("Positioned content")
  frame.add(newLabel("Layout preserves child coordinates while scrolling."))
  canvas.put(frame, 240, 200)
  canvas.put(newEntry("Independent positioned entry"), 950, 700)
  canvas.put(newLabel("Far corner of the canvas"), 1300, 900)

  let origin = newToolButton("Scroll to origin")
  origin.onClicked(proc () =
    canvas.horizontalAdjustment.value = 0
    canvas.verticalAdjustment.value = 0)
  toolbar.append(origin)
  let far = newToolButton("Scroll to far content")
  far.onClicked(proc () =
    canvas.horizontalAdjustment.value = 900
    canvas.verticalAdjustment.value = 650)
  toolbar.append(far)
  window.run()

when isMainModule:
  main()
