# Isolated native offscreen rendering only; no selection requests/input synthesis.
import std/[os, unittest]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as pix
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Entry progress rendering requires an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "native progress rendering did not settle")
proc image(host: ui.OffscreenWindow): string =
  drain()
  let p = host.pixbuf
  let data = cast[ptr UncheckedArray[uint8]](pix.get_pixels(p.raw))
  let stride = pix.get_rowstride(p.raw).int
  let columns = p.width * pix.get_n_channels(p.raw).int
  # Ignore padding bytes; copy actual rendered pixels before the next draw.
  result = newString(columns * p.height)
  for y in 0..<p.height:
    copyMem(addr result[y * columns], addr data[y * stride], columns)
proc geometry(entry: Entry): seq[tuple[x, y, width, height: int]] =
  for pos in [n.ENTRY_ICON_PRIMARY, n.ENTRY_ICON_SECONDARY]:
    let window = n.entry_get_icon_window(entry.raw, pos)
    doAssert window != nil
    var x, y, w, h, depth: g.gint
    gd.get_geometry(window, addr x, addr y, addr w, addr h, addr depth)
    result.add((x.int, y.int, w.int, h.int))
ui.init()
suite "native Entry progress rendering":
  test "determinate/activity/clear redraw without changing text, selection or icon geometry":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let entry = newEntry("λ🙂 progress")
    entry.setSizeRequest(360, 44)
    entry.setIconName(iconPrimary, "edit-find")
    entry.setIconName(iconSecondary, "edit-clear")
    host.add(entry)
    host.showAll()
    let baseline = host.image()
    let bounds = entry.selectionBounds
    let icons = entry.geometry()
    entry.progressFraction = 0.6
    let partial = host.image()
    check partial != baseline
    entry.progressPulseStep = 0.2
    entry.progressPulse()
    let first = host.image()
    check first != baseline and first != partial and entry.progressFraction == 0
    entry.progressPulse()
    let second = host.image()
    check second != first
    entry.progressFraction = 0
    check host.image() == baseline # Zero explicitly ends native activity.
    entry.progressPulseStep = 0
    entry.progressPulse()
    entry.progressPulse()
    check host.image() == baseline # Native zero-width pulse block.
    entry.progressPulseStep = 1
    entry.progressPulse()
    check host.image() != baseline
    entry.progressFraction = 0
    check host.image() == baseline
    check entry.text == "λ🙂 progress" and entry.selectionBounds == bounds
    check entry.geometry() == icons
    # Hide/re-show retains native progress policy; no implicit loop or source.
    host.hide()
    entry.progressFraction = 0.375
    host.showAll()
    discard host.image()
    check entry.progressFraction == 0.375
    entry.progressFraction = 0
    n.set_direction(cast[n.PWidget](entry.raw), n.TEXT_DIR_RTL)
    let rtlBaseline = host.image()
    let rtlIcons = entry.geometry()
    entry.progressFraction = 0.5
    check host.image() != rtlBaseline
    entry.progressFraction = 0
    check host.image() == rtlBaseline and entry.geometry() == rtlIcons
  test "protected readonly password combo and inherited SpinButton render native feedback":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let box = newVBox()
    let combo = newComboBoxText(["λ🙂 sample"], editable = true)
    combo.activeIndex = 0
    let entry = combo.entry
    entry.editable = false
    entry.textVisible = false
    entry.invisibleChar = 0x2a
    let spin = newSpinButton(newAdjustment(12.5, 0, 100, 0.1), digits = 1)
    box.packStart(combo)
    box.packStart(spin)
    host.add(box)
    host.showAll()
    let baseline = host.image()
    entry.progressFraction = 0.75
    spin.progressPulseStep = 0.25
    spin.progressPulse()
    check host.image() != baseline
    check combo.activeIndex == 0 and entry.text == "λ🙂 sample" and spin.value == 12.5
    check not entry.textVisible and not entry.editable
    entry.progressFraction = 0
    spin.progressFraction = 0
    check host.image() == baseline
