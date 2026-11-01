# Maps windows ONLY on an explicitly opted-in isolated virtual display.
import std/[os, tempfiles, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g

if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped printing tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)

when defined(posix) and not defined(macosx):
  proc drain() =
    for i in 0..<512:
      if n.events_pending() == 0: return
      discard n.main_iteration_do(g.gbool(false))
    raise newException(ValueError, "printing UI sources did not settle")
  proc conflictBanner(p: n.PWidget): n.PWidget =
    # Test-only inspection through public GTK APIs, not GTK private structs.
    if n.IS_LABEL(p) and $n.get_text(cast[n.PLabel](p)) == "Some of the settings in the dialog conflict":
      return n.get_parent(p)
    if n.IS_CONTAINER(p):
      let children = n.get_children(cast[n.PContainer](p))
      defer: g.free(children)
      var current = children
      while current != nil:
        result = conflictBanner(cast[n.PWidget](current.data))
        if result != nil: return
        current = current.next
  proc runTests() =
    let sandbox = createTempDir("nim-gtk2-mapped-printing-", "")
    defer: removeDir(sandbox)
    putEnv("XDG_CONFIG_HOME", sandbox)
    putEnv("XDG_DATA_HOME", sandbox)
    putEnv("LC_ALL", "C")
    putEnv("LANGUAGE", "C")
    gtk2.init()
    let anchor = newLabel()
    defer: anchor.destroy()
    let settings = n.get_settings(anchor.raw)
    var value: g.TGValue
    discard g.init(addr value, g.G_TYPE_STRING)
    defer: g.unset(addr value)
    g.set_string(addr value, "") # No backend discovery, printer jobs or output.
    g.set_property(cast[g.PGObject](settings), "gtk-print-backends", addr value)
    suite "mapped print dialog visibility on an isolated virtual display":
      test "Window present and Widget showAll preserve native conditional visibility":
        let dialog = newPrintUnixDialog()
        defer: dialog.destroy()
        dialog.manualCapabilities = {capCopies}
        let banner = conflictBanner(gtk2.Widget(dialog).raw)
        require banner != nil
        let preview = n.get_widget_for_response(gtk2.Dialog(dialog).raw, g.gint(responseApply))
        require preview != nil
        check not g.toBool(n.get_visible(banner))
        check not g.toBool(n.get_visible(preview))
        let content = newVBox()
        let child = newLabel("Application tab child")
        content.packStart(child)
        dialog.addCustomTab(content, newLabel("Application"))
        check g.toBool(n.get_visible(child.raw))
        gtk2.Window(dialog).present() # Must not recurse into private controls.
        check g.toBool(n.WIDGET_MAPPED(dialog.raw))
        check not g.toBool(n.get_visible(banner))
        check not g.toBool(n.get_visible(preview))
        drain()
        gtk2.Widget(dialog).showAll() # Same behavior through the base upcast.
        check not g.toBool(n.get_visible(banner))
        check not g.toBool(n.get_visible(preview))
        dialog.manualCapabilities = {capCopies, capPreview}
        check g.toBool(n.get_visible(preview))
        gtk2.Window(dialog).present()
        check g.toBool(n.get_visible(preview))
        dialog.manualCapabilities = {capCopies}
        check not g.toBool(n.get_visible(preview))
        # Do not blanket-hide a banner that the native side has made visible.
        # This simulates its visibility decision, not an actual backend conflict.
        n.show(banner)
        gtk2.Window(dialog).present()
        check g.toBool(n.get_visible(banner))
        n.hide(banner)
        drain()
      test "page setup dialog still presents normally through Window":
        let dialog = newPageSetupUnixDialog()
        defer: dialog.destroy()
        gtk2.Window(dialog).present()
        check g.toBool(n.WIDGET_MAPPED(dialog.raw))
        drain()
  runTests()
else:
  quit("Mapped printing tests require GTK Unix printing", 1)
