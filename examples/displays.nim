## Build: nim c -r --path:src examples/displays.nim
## OffscreenWindow uses a real GTK/GDK display connection, but no onscreen window.
import std/strutils
import gtk2

proc packed(color: Color): uint32 =
  (color.red.uint32 shr 8) shl 24 or (color.green.uint32 shr 8) shl 16 or
    (color.blue.uint32 shr 8) shl 8 or 255'u32
proc main() =
  gtk2.init()
  let window = newWindow("CellView, HSV and offscreen rendering", 820, 360)
  defer: window.destroy()
  let row = newHBox(spacing = 16)
  row.borderWidth = 16
  window.add(row)
  let left = newVBox(spacing = 12)
  let right = newVBox(spacing = 12)
  row.packStart(left, packShrink)
  row.packStart(right)
  left.packStart(newLabel("Normalized HSV color selector"), packShrink)
  let selector = newHSV(hsvColor(0.55, 0.7, 0.9), diameter = 210, ringWidth = 20)
  left.packStart(selector, packShrink)
  let status = newLabel()
  left.packStart(status, packShrink)
  let preview = newImage()
  right.packStart(newLabel("Live copy of a separate offscreen widget tree"), packShrink)
  right.packStart(preview)
  let offscreen = newOffscreenWindow(430, 150)
  defer: offscreen.destroy() # Cancel damage delivery before releasing captures.
  let content = newVBox(spacing = 12)
  content.borderWidth = 12
  offscreen.add(content)
  content.packStart(newCellView("<b>Plain text, not markup</b>"), packShrink)
  let model = newListStore([cellString, cellPixbuf])
  discard model.appendRow([cell("Rendered model row"), cell(newPixbuf(32, 32))])
  let display = newCellView(model, textColumn = 0, pixbufColumn = 1)
  display.displayedRow = 0
  content.packStart(display, packShrink)
  content.packStart(newButton("Rendered button (not interactive in the image)"), packShrink)
  offscreen.onSnapshot(proc (image: Pixbuf) =
    if not image.isEmpty: preview.pixbuf = image)
  proc update(color: HSVColor) =
    let rgb = color.toColor()
    let description = "H " & formatFloat(color.hue, ffDecimal, 2) & "  S " &
      formatFloat(color.saturation, ffDecimal, 2) & "  V " & formatFloat(color.value, ffDecimal, 2)
    status.text = description
    # Native row-reference bookkeeping and redraw are observed automatically.
    model.setRow(0, [cell(description), cell(newPixbuf(32, 32, packed(rgb)))])
  selector.onChanged(proc (value: HSVState) = update(value.color))
  update(selector.color)
  offscreen.showAll() # Maps only a GDK offscreen drawable, never an onscreen toplevel.
  window.run()

when isMainModule: main()
