## Standalone chooser panels and directly managed, nonblocking GTK2 dialogs.
## Build with: nim c --path:src examples/choosers.nim
import gtk2

proc describe(color: Color): string =
  "RGBA16: " & $color.red & ", " & $color.green & ", " & $color.blue & ", " & $color.alpha
proc openColorDialog(parent: Window, source: ColorSelection, status: Label) =
  let dialog = newColorSelectionDialog(parent, color = source.color,
    useAlpha = source.useAlpha, hasPalette = true)
  dialog.onColorChanged(proc (value: Color) = status.text = "Dialog preview — " & describe(value))
  dialog.onResponse(proc (response: ResponseId) =
    if response == responseOk:
      let old = source.color
      source.color = dialog.color
      source.previousColor = old
      status.text = "Accepted — " & describe(source.color)
    else:
      status.text = "Color dialog cancelled; embedded selection unchanged"
    dialog.destroy())
  dialog.present() # Does not enter a nested main loop.
proc openFontDialog(parent: Window, source: FontSelection, status: Label) =
  let dialog = newFontSelectionDialog(parent)
  dialog.fontName = source.fontName
  dialog.previewText = source.previewText
  dialog.showApply = true
  dialog.onFontChanged(proc (value: string) = status.text = "Dialog preview — " & value)
  dialog.onResponse(proc (response: ResponseId) =
    if response == responseOk or response == responseApply:
      source.fontName = dialog.fontName
      source.previewText = dialog.previewText
      status.text = "Applied — " & source.fontName
    else:
      status.text = "Font dialog cancelled; previously applied changes remain"
    if response != responseApply: dialog.destroy())
  dialog.present()

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 embedded choosers and direct dialogs", 720, 600)
  defer: window.destroy()
  let root = newVBox(spacing = 8)
  root.borderWidth = 10
  window.add(root)
  root.packStart(newLabel("Embedded panels change live; dialog changes apply only on OK/Apply."), packShrink)
  let status = newLabel("Choose a color or font in the embedded panels.")
  root.packEnd(status, packShrink)
  let actions = newHButtonBox()
  root.packEnd(actions, packShrink)
  let notebook = newNotebook()
  root.packStart(notebook)
  let colors = newColorSelection(rgba16(12000, 28000, 48000, 50000), useAlpha = true, hasPalette = true)
  notebook.appendPage(colors, "Embedded color selection")
  colors.onColorChanged(proc (value: Color) = status.text = "Embedded — " & describe(value))
  let fonts = newFontSelection()
  notebook.appendPage(fonts, "Embedded font selection")
  # A FontSelection needs a screen: set the font after parenting into the window.
  fonts.fontName = "Sans 12"
  fonts.previewText = "The quick brown fox — café 123"
  fonts.onFontChanged(proc (value: string) = status.text = "Embedded — " & value)
  let colorDialog = newButton("Open color dialog")
  let fontDialog = newButton("Open font dialog")
  actions.packStart(colorDialog, packShrink)
  actions.packStart(fontDialog, packShrink)
  colorDialog.onClicked(proc () = openColorDialog(window, colors, status))
  fontDialog.onClicked(proc () = openFontDialog(window, fonts, status))
  window.run()

when isMainModule:
  main()
