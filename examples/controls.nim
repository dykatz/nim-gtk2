## A small interactive sampler for the next gtk2 widget batch.
## Build: nim c --path:src examples/controls.nim
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 controls and Cairo input", 560, 600)
  defer: window.destroy()
  window.borderWidth = 12
  let layout = newVBox(spacing = 8)
  window.add(layout)

  let frame = newFrame("Task progress")
  let task = newVBox(spacing = 6)
  task.borderWidth = 8
  frame.add(task)
  layout.packStart(frame, packShrink)
  let progress = newProgressBar(text = "Ready")
  let spinner = newSpinner()
  let buttons = newHBox(spacing = 6)
  let animate = newToggleButton("_Animate", mnemonic = true)
  let advance = newButton("Advance")
  buttons.packStart(animate)
  buttons.packStart(advance)
  task.packStart(buttons, packShrink)
  task.packStart(progress, packShrink)
  task.packStart(spinner, packShrink)
  animate.onToggled do ():
    if animate.active: spinner.start()
    else: spinner.stop()
  layout.packStart(newHSeparator(), packShrink)
  let expander = newExpander("_Display options", mnemonic = true)
  let options = newVBox(spacing = 6)
  expander.add(options)
  expander.expanded = true
  layout.packStart(expander, packShrink)
  let showProgressText = newCheckButton("Show progress text")
  showProgressText.active = true
  options.packStart(showProgressText, packShrink)
  showProgressText.onToggled do ():
    progress.text = if showProgressText.active:
      $int(progress.fraction * 100.0 + 0.5) & "%"
      else: ""
  advance.onClicked do ():
    progress.fraction = min(1.0, progress.fraction + 0.1)
    progress.text = if showProgressText.active:
      $int(progress.fraction * 100.0 + 0.5) & "%"
      else: ""
    if progress.fraction == 1.0: animate.active = false

  let ratios = newHBox(spacing = 6)
  let square = newRadioButton("Square")
  let wide = newRadioButton(square, "Wide")
  ratios.packStart(square)
  ratios.packStart(newVSeparator(), packShrink)
  ratios.packStart(wide)
  options.packStart(ratios, packShrink)
  let aspect = newAspectFrame("Native Cairo drawing", ratio = 1.0)
  let canvas = newDrawingArea(160, 100)
  canvas.canFocus = true
  aspect.add(canvas)
  layout.packStart(aspect)
  options.packStart(newLabel("Click/drag to move; scroll to resize; arrow keys also move."), packShrink)
  var markerX = 0.5
  var markerY = 0.5
  var radius = 16.0
  canvas.onDraw(proc (c: DrawContext, info: DrawInfo) =
    c.setSource(rgba16(5000, 6500, 10000))
    c.paint()
    c.setSource(rgba16(12000, 50000, 65535))
    c.circle(markerX * info.width.float64, markerY * info.height.float64, radius)
    c.fill()
    c.setSource(rgba16(65535, 65535, 65535))
    c.setLineWidth(2)
    c.moveTo(0, markerY * info.height.float64)
    c.lineTo(info.width.float64, markerY * info.height.float64)
    c.stroke())
  proc moveMarker(x, y: float64) =
    let size = canvas.allocation
    if size.width > 0 and size.height > 0:
      markerX = max(0.0, min(1.0, x / size.width.float64))
      markerY = max(0.0, min(1.0, y / size.height.float64))
      canvas.queueDraw()
  canvas.onButtonPress(proc (e: ButtonEvent): bool =
    if e.button != 1: return false
    canvas.focus()
    moveMarker(e.x, e.y)
    true)
  canvas.onMotion(proc (e: MotionEvent): bool =
    if not e.modifiers.has(modifierButton1): return false
    moveMarker(e.x, e.y)
    true)
  canvas.onScroll(proc (e: ScrollEvent): bool =
    if e.direction notin {scrollUp, scrollDown}: return false
    radius = max(3.0, min(60.0, radius + (if e.direction == scrollUp: 2.0 else: -2.0)))
    canvas.queueDraw()
    true)
  canvas.onKeyPress(proc (e: KeyEvent): bool =
    case e.keyval
    of keyLeft: markerX = max(0.0, markerX - 0.05)
    of keyRight: markerX = min(1.0, markerX + 0.05)
    of keyUp: markerY = max(0.0, markerY - 0.05)
    of keyDown: markerY = min(1.0, markerY + 0.05)
    else: return false
    canvas.queueDraw()
    true)
  square.onToggled do ():
    if square.active: aspect.setAspect(1.0)
  wide.onToggled do ():
    if wide.active: aspect.setAspect(16.0 / 9.0)
  layout.packEnd(newLinkButton("https://github.com/dykatz/nim-gtk2", "SDK source"), packShrink)
  window.run()

when isMainModule:
  main()
