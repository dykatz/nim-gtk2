# No mapped widgets, clipboard ownership changes, or clipboard requests here.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g

static:
  doAssert typeof(getClipboard().raw) is n.PClipboard
  doAssert not compiles(default(Clipboard).destroy())
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  freed: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watch(w: gtk2.Widget, freed: ptr int): TextDropSite =
  let capture = Capture(freed: freed)
  w.onTextDrop(proc (value: TextDrop) = discard capture.freed)

gtk2.init()
suite "text transfer configuration (never mapped; no clipboard mutation)":
  test "empty requests cancel idempotently and invalid clipboard handles fail before GTK":
    let request = TextRequest()
    check not request.pending
    request.cancel()
    expect ValueError: default(Clipboard).setText("test")
    expect ValueError: discard default(Clipboard).requestText(nil)
  test "text pads validate UTF-8, guard private native sites and permit independent source/destination":
    let w = newEventBox()
    defer: w.destroy()
    let source = w.enableTextDrag("λ🙂")
    check source.connected and source.text == "λ🙂"
    source.text = "new"
    check source.text == "new"
    expect ValueError: source.text = "bad\0text"
    expect ValueError: source.text = "\xff"
    check source.text == "new"
    expect ValueError: discard w.enableTextDrag("duplicate")
    let site = w.onTextDrop(proc (value: TextDrop) = discard)
    check site.connected
    expect ValueError: discard w.onTextDrop(proc (value: TextDrop) = discard)
    source.disconnect()
    source.disconnect()
    check not source.connected and site.connected
    expect ValueError: discard source.text
    site.disconnect()
    check not site.connected
    let next = w.enableTextDrag("")
    let target = w.onTextDrop(proc (value: TextDrop) = discard)
    w.destroy()
    check not next.connected and not target.connected
    let entry = newEntry()
    defer: entry.destroy()
    expect ValueError: discard gtk2.Widget(entry).enableTextDrag("private native DnD")
    expect ValueError: discard gtk2.Widget(entry).onTextDrop(proc (value: TextDrop) = discard)
    let area = newDrawingArea()
    defer: area.destroy()
    expect ValueError: discard area.onTextDrop(nil)
    var targetEntry = n.TTargetEntry(target: "UTF8_STRING", info: 1)
    n.drag_dest_set(gtk2.Widget(area).raw, n.DEST_DEFAULT_ALL, addr targetEntry, 1, 2)
    expect ValueError: discard area.onTextDrop(proc (value: TextDrop) = discard)
    n.drag_dest_unset(gtk2.Widget(area).raw)
  test "dropping site handles does not cancel; native destruction releases captures without cycles":
    var freed, gone = 0
    block:
      let w = newDrawingArea()
      g.weak_ref(cast[g.PGObject](w.raw), finalized, addr gone)
      discard watch(w, addr freed)
      discard w.enableTextDrag("text")
    check freed == 1 and gone == 1
    let w = newEventBox()
    defer: w.destroy()
    let site = watch(w, addr freed)
    site.disconnect()
    check freed == 2
    let next = watch(w, addr freed)
    w.destroy()
    check freed == 3 and not next.connected
  test "Entry editable and password visibility use their native properties":
    let entry = newEntry("password")
    defer: entry.destroy()
    entry.editable = false
    entry.textVisible = false
    check not entry.editable and not entry.textVisible
