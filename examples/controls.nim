## A small interactive sampler for the next gtk2ui widget batch.
## Build: nim c --path:src examples/controls.nim
import gtk2ui

proc main() =
  gtk2ui.init()
  let window = newWindow("gtk2ui controls", 480, 420)
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
  let aspect = newAspectFrame("Drawing-area placeholder", ratio = 1.0)
  aspect.add(newDrawingArea(120, 80))
  layout.packStart(aspect)
  # Draw/expose callbacks will be wrapped in a later rendering-focused batch.
  square.onToggled do ():
    if square.active: aspect.setAspect(1.0)
  wide.onToggled do ():
    if wide.active: aspect.setAspect(16.0 / 9.0)
  layout.packEnd(newLinkButton("https://github.com/dykatz/nim-gtk2", "SDK source"), packShrink)
  window.run()

when isMainModule:
  main()
