# Validation/purity only. No file creation, codec invocation, realized widgets or selections.
import std/unittest
import gtk2
import headers/gdk2pixbuf as p
import headers/glib2 as g
static:
  var error: ptr g.GError
  doAssert typeof(p.savev(default(p.PPixbuf), "ignored", "png", nil, nil, addr error)) is g.gboolean
  when defined(windows):
    doAssert typeof(p.savev_utf8(default(p.PPixbuf), "ignored", "png", nil, nil, addr error)) is g.gboolean
    doAssert typeof(p.pixbuf_new_from_file_utf8("ignored", addr error)) is p.PPixbuf
gtk2.init()
suite "explicit PNG file encoding validation":
  test "empty handles and NUL reject before native encoder/file access":
    expect ValueError: default(Pixbuf).savePng("not-created.png")
    let image = newPixbuf(2, 3)
    expect ValueError: image.savePng("not-created.png\0suffix")
    expect ValueError: discard loadPixbuf("not-opened.png\0suffix")
    check image.width == 2 and image.height == 3
  test "synchronous pure scopes reject before filenames/handles/codecs or file work":
    let image = newPixbuf(2, 3)
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      try: image.savePng("not-created.png")
      except ValueError as error:
        if error.msg == guard: inc denied
      try: default(Pixbuf).savePng("not-created.png\0suffix")
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard loadPixbuf("not-opened.png\0suffix")
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 3
