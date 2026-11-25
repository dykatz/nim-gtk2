import std/[os, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g

if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1" or getEnv("DISPLAY").len == 0:
  quit("Custom cell renderer tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc settle() =
  for _ in 0..<20:
    for _ in 0..<256:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    sleep(6)

gtk2.init()
suite "native custom cell painting":
  test "row values and state, native progress neighbor, clipped pixels and expired context":
    let host = newOffscreenWindow(260, 140)
    defer: host.destroy()
    let m = newListStore([cellString, cellInt])
    discard m.appendRow([cell("Red"), cell(25)])
    discard m.appendRow([cell("Green"), cell(75)])
    let v = newTreeView(m)
    host.add(v)
    discard v.appendRendererColumn("Native progress", n.cell_renderer_progress_new(), [("value", 1)])
    var saved: DrawContext
    var guards, marked: int
    var seen: seq[ModelRow]
    var failNext = true
    discard v.appendDrawColumn("Custom fill", 65, 22, proc (c: DrawContext, row: ModelRow, info: CellDrawInfo) =
      saved = c
      seen.add(row)
      if info.selected: inc marked
      try: discard m.rowCount
      except ValueError: inc guards
      if failNext:
        failNext = false
        raise newException(ValueError, "expected renderer rejection")
      let color = case row.values[0].stringValue
        of "Red": rgba16(65535, 0, 0)
        of "Green": rgba16(0, 65535, 0)
        else: rgba16(0, 0, 65535)
      c.setSource(color)
      c.paint()) # Draw across the whole surface; SDK clip confines it to the cell.
    v.selectedIndex = 1
    host.showAll()
    settle()
    # The first pass may have failed for Red; require a clean repaint afterward.
    n.queue_draw(cast[n.PWidget](v.raw))
    settle()
    require seen.len > 1 and not failNext
    check guards == seen.len and marked > 0
    expect ValueError: saved.paint()
    var redRows = 0
    var greenRows = 0
    proc countColors(image: gtk2.Pixbuf): tuple[r, g, b: int] =
      let px = image.rgbaPixels()
      let bytes = px.bytes
      for y in 0..<px.height:
        var red, green, blue: bool
        for x in 0..<px.width:
          let i = 4 * (y * px.width + x)
          if bytes[i+3] != 255: continue
          let rgb = (bytes[i], bytes[i+1], bytes[i+2])
          if rgb in [(255'u8, 0'u8, 0'u8), (0'u8, 255'u8, 0'u8), (0'u8, 0'u8, 255'u8)]:
            check x > 30 # Never overpaint the neighboring native renderer.
          red = red or rgb == (255'u8, 0'u8, 0'u8)
          green = green or rgb == (0'u8, 255'u8, 0'u8)
          blue = blue or rgb == (0'u8, 0'u8, 255'u8)
        if red: inc result.r
        if green: inc result.g
        if blue: inc result.b
    let first = countColors(host.pixbuf)
    redRows = first.r
    greenRows = first.g
    check redRows in 15..30 and greenRows in 15..30 and first.b == 0
    m.setValue(0, 0, cell("Blue"))
    settle()
    let second = countColors(host.pixbuf)
    check second.r == 0 and second.g == greenRows and second.b == redRows
    check seen[0].values[0].stringValue == "Red"
