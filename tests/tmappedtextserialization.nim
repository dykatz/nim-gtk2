# Native restored text/tag/image layout; isolated virtual display only.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped serialization tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)
gtk2.init()
suite "native restored rich text layout":
  test "explicit successful import replaces shared views only after decoding":
    let host = newWindow("Rich-text round trip", 700, 300)
    defer: host.destroy()
    let original = newTextBuffer("λ🙂 line\nSecond line\n")
    let emphasis = original.createTag("emphasis")
    emphasis.bold = true
    emphasis.underline = true
    original.applyTag(emphasis, 0, 2)
    original.insertImage(2, newPixbuf(24, 18, 0x2878c0ff'u32))
    let first = newTextView(original)
    let second = newTextView(original)
    second.editable = false
    let box = newHBox(spacing = 8)
    box.packStart(first)
    box.packStart(second)
    host.add(box)
    host.showAll()
    require awaitUi(proc (): bool = first.allocation.width > 100)
    var changed = 0
    let oldObserver = original.onChanged(proc () = inc changed)
    defer: oldObserver.disconnect()
    let format = newTextFormat("mapped-v1", canCreateTags = true)
    let archived = original.serialize(format)
    var broken = archived.data
    broken[30] = 'X' # Break the first XML start tag, not the trailing image bytes.
    expect TextSerializationError:
      discard format.deserialize(newSerializedText(format, broken))
    check first.buffer.raw == original.raw and second.buffer.raw == original.raw and changed == 0
    let restored = format.deserialize(newSerializedText(format, archived.data))
    check changed == 0 and restored.raw != original.raw
    check restored.characterCount == original.characterCount and restored.text == original.text
    check restored.hasTag(restored.tag("emphasis"), 1) and restored.tag("emphasis").bold
    first.buffer = restored
    second.buffer = restored
    restored.modified = false
    require awaitUi(proc (): bool = first.buffer.raw == restored.raw and second.buffer.raw == restored.raw)
    var iter: n.TTextIter
    n.get_iter_at_offset(restored.raw, addr iter, 2)
    check n.get_pixbuf(addr iter) != nil
    var rect: gd.TRectangle
    n.get_iter_location(first.raw, addr iter, addr rect)
    check rect.height >= 18 and rect.width >= 24
    var observations = 0
    let observer = restored.onChanged(proc () = inc observations)
    defer: observer.disconnect()
    restored.appendText("Edited after import")
    check observations == 1 and changed == 0 and restored.modified
