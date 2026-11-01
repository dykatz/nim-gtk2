import std/[unittest, os, tempfiles]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g

static:
  doAssert typeof(newPrintSettings().raw) is ptr n.PrintSettings
  doAssert typeof(newPageSetup().raw) is ptr n.PageSetup
  doAssert typeof(newPaperSize().raw) is ptr n.PaperSize
  when defined(posix) and not defined(macosx):
    doAssert typeof(newPrintUnixDialog().raw) is ptr n.PrintUnixDialog
    doAssert typeof(newPageSetupUnixDialog().raw) is ptr n.PageSetupUnixDialog
    doAssert typeof(newPrintUnixDialog().selectedPrinter.raw) is ptr n.Printer
  when defined(windows) or defined(macosx):
    doAssert not declared(gtk2.PrintUnixDialog)
    doAssert not declared(gtk2.PageSetupUnixDialog)
    doAssert not declared(gtk2.Printer)
proc drain() =
  for i in 0..<256:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "print UI sources did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
let sandbox = createTempDir("nim-gtk2-printing-", "")
putEnv("XDG_CONFIG_HOME", sandbox)
putEnv("XDG_DATA_HOME", sandbox)
gtk2.init()

suite "cross-platform print configuration":
  test "boxed paper sizes, validated names, physical units and owned copies":
    let a4 = newPaperSize("iso_a4")
    check a4.name == "iso_a4" and a4.displayName.len > 0 and not a4.isCustom
    check abs(a4.width - 210) < 1e-8 and abs(a4.height - 297) < 1e-8
    check abs(a4.width(unitInches) - 210/25.4) < 1e-8
    check standardPaperSizes().len > 10
    let clone = a4.copy()
    check clone.raw != a4.raw and clone.name == a4.name
    let custom = newCustomPaperSize("card", "Carte café", 4, 6, unitInches)
    check custom.isCustom and custom.displayName == "Carte café"
    check abs(custom.width - 101.6) < 1e-8 and abs(custom.height - 152.4) < 1e-8
    expect ValueError: discard newPaperSize("unknown-paper")
    expect ValueError: discard newPaperSize("bad\0paper")
    expect ValueError: discard newCustomPaperSize("", "Card", 10, 10)
    expect ValueError: discard newCustomPaperSize("x", "\xff", 10, 10)
    for bad in [0.0, -1.0, Inf, NaN]:
      expect ValueError: discard newCustomPaperSize("card", "Card", bad, 10)
    expect ValueError: discard gtk2.PaperSize().raw

  test "page setup copies, orientations, margins and detached paper getters":
    let setup = newPageSetup()
    setup.setPaperWithDefaultMargins(newPaperSize("iso_a4"))
    setup.orientation = pageLandscape
    setup.setMargins(PageMargins(top: 1, bottom: 2, left: 3, right: 4))
    check setup.orientation == pageLandscape
    check abs(setup.paperWidth - 297) < 1e-8 and abs(setup.paperHeight - 210) < 1e-8
    check abs(setup.pageWidth - 290) < 1e-8 and abs(setup.pageHeight - 207) < 1e-8
    check setup.margins == PageMargins(top: 1, bottom: 2, left: 3, right: 4)
    let saved = setup.copy()
    let paper = setup.paperSize
    setup.paperSize = newPaperSize("na_letter")
    check paper.name == "iso_a4" and saved.paperSize.name == "iso_a4"
    expect ValueError: setup.setMargins(PageMargins(top: 1, bottom: -1))
    check setup.margins.top == 1 and setup.margins.bottom == 2
    expect ValueError: setup.setMargins(PageMargins(top: NaN))
    expect ValueError: setup.paperSize = gtk2.PaperSize()

  test "typed settings, copied key/value pairs, ranges and atomic input validation":
    let settings = newPrintSettings()
    settings.printerName = "Printer café"
    settings.orientation = pageReverseLandscape
    settings.paperSize = newCustomPaperSize("demo", "Demo", 120, 180)
    settings.copies = 3
    settings.scale = 80
    settings.numberUp = 4
    settings.setResolution(300, 600)
    settings.duplex = duplexVertical
    settings.quality = qualityHigh
    settings.useColor = false
    settings.collate = true
    settings.reverse = true
    settings.printPages = printPageRanges
    settings.pageSet = pagesOdd
    settings.pageRanges = [gtk2.PageRange(first: 0, last: 2), gtk2.PageRange(first: 4, last: 7)]
    check settings.printerName == "Printer café" and settings.orientation == pageReverseLandscape
    check settings.paperSize.name == "demo" and settings.paperSize.isCustom
    check settings.copies == 3 and settings.scale == 80 and settings.numberUp == 4
    check settings.resolution == (300, 600) and settings.duplex == duplexVertical
    check settings.quality == qualityHigh and not settings.useColor and settings.collate and settings.reverse
    check settings.printPages == printPageRanges and settings.pageSet == pagesOdd
    check settings.pageRanges == @[gtk2.PageRange(first: 0, last: 2), gtk2.PageRange(first: 4, last: 7)]
    let saved = settings.copy()
    settings.set("example-option", "Café")
    let values = settings.pairs
    check (key: "example-option", value: "Café") in values
    check settings.hasKey("example-option") and settings.get("example-option") == "Café"
    settings.unset("example-option")
    check not settings.hasKey("example-option") and settings.get("example-option") == ""
    check (key: "example-option", value: "Café") in values
    settings.copies = 4
    check saved.copies == 3
    for bad in [-1, 0]:
      expect ValueError: settings.copies = bad
    expect ValueError: settings.scale = NaN
    expect ValueError: settings.scale = 0
    expect ValueError: settings.numberUp = 3
    expect ValueError: settings.setResolution(0, 300)
    expect ValueError: settings.pageRanges = [gtk2.PageRange(first: 0, last: 1), gtk2.PageRange(first: 3, last: 2)]
    check settings.pageRanges.len == 2
    settings.pageRanges = []
    check settings.pageRanges.len == 0
    expect ValueError: settings.set("", "value")
    expect ValueError: settings.set("option", "bad\0value")
    expect ValueError: settings.set("\xff", "value")
    for key in ["bad\nkey", "bad=key", "bad[key]", " leading", "trailing "]:
      expect ValueError: settings.set(key, "value")
    settings.set("paper-format", "unknown-paper")
    expect ValueError: discard settings.paperSize

  test "configuration files use explicit storage and typed GError ownership":
    let settings = newPrintSettings()
    settings.copies = 5
    settings.save(sandbox / "print.ini")
    check loadPrintSettings(sandbox / "print.ini").copies == 5
    let setup = newPageSetup()
    setup.orientation = pageReversePortrait
    setup.save(sandbox / "page.ini")
    check loadPageSetup(sandbox / "page.ini").orientation == pageReversePortrait
    expect ValueError: settings.save("relative.ini")
    expect PrintError: setup.save(sandbox / "absent" / "page.ini")
    try:
      discard loadPrintSettings(sandbox / "missing.ini")
      check false
    except PrintError as error:
      check error.domain != 0 and error.msg.len > 0
    writeFile(sandbox / "bad.ini", "not a key file")
    expect PrintError: discard loadPageSetup(sandbox / "bad.ini")

when defined(posix) and not defined(macosx):
  type CaptureObj = object
    freed, calls: ptr int
  proc `=destroy`(c: var CaptureObj) = inc c.freed[]
  type Capture = ref CaptureObj
  proc watch(w: gtk2.PrintUnixDialog, freed, calls: ptr int): Connection =
    let capture = Capture(freed: freed, calls: calls)
    w.onResponse(proc (id: ResponseId, value: PrintSelection) = inc capture.calls[])
  proc temporaryDialog(freed, calls: ptr int): ptr n.PrintUnixDialog =
    let w = newPrintUnixDialog()
    discard g.g_object_ref(w.raw)
    discard watch(w, freed, calls)
    w.respond(responseCancel)
    w.raw
  # No network, printers, modules or job submission: disable backend discovery
  # for this process, restoring the native setting after all fixtures finish.
  let anchor = newLabel()
  let nativeSettings = n.get_settings(anchor.raw)
  var original: g.TGValue
  discard g.init(addr original, g.G_TYPE_STRING)
  g.get_property(cast[g.PGObject](nativeSettings), "gtk-print-backends", addr original)
  var empty: g.TGValue
  discard g.init(addr empty, g.G_TYPE_STRING)
  g.set_string(addr empty, "")
  g.set_property(cast[g.PGObject](nativeSettings), "gtk-print-backends", addr empty)
  g.unset(addr empty)
  suite "Unix print dialogs (hidden, no backend/job submission)":
    test "checked constructors, parenting, flags and custom tabs":
      let parent = newWindow()
      defer: parent.destroy()
      let w = newPrintUnixDialog(parent, "Print café %s", modal = true)
      let page = newPageSetupUnixDialog(parent)
      defer:
        w.destroy()
        page.destroy()
      check w.title == "Print café %s" and w.modal and w.destroyWithParent
      check w.selectedPrinter.isEmpty and w.selection.printer.name.len == 0
      expect ValueError: discard newPrintUnixDialog("\xff")
      expect ValueError: discard newPageSetupUnixDialog("bad\0title")
      w.currentPage = 2
      check w.currentPage == 2
      w.currentPage = -1
      expect ValueError: w.currentPage = -2
      w.manualCapabilities = {capCopies, capCollate, capScale, capGeneratePdf}
      check w.manualCapabilities == {capCopies, capCollate, capScale, capGeneratePdf}
      var all: gtk2.PrintCapabilities
      for flag in PrintCapability: all.incl(flag)
      w.manualCapabilities = all
      check w.manualCapabilities == all
      w.supportSelection = true
      w.hasSelection = true
      w.embedPageSetup = true
      check w.supportSelection and w.hasSelection and w.embedPageSetup
      let content = newVBox()
      let label = newLabel("Application options")
      let custom = newCheckButton("Example option")
      content.packStart(custom)
      w.addCustomTab(content, label)
      check g.toBool(n.get_visible(custom.raw))
      check not g.toBool(n.WIDGET_MAPPED(w.raw))
      expect ValueError: w.addCustomTab(content, label)
      let extra = newLabel("No private dialog packing")
      defer: extra.destroy()
      expect ValueError: gtk2.Dialog(w).packStart(extra)
      expect ValueError: gtk2.Dialog(page).packEnd(extra)
      expect ValueError: parent.transientFor = w
      parent.destroy()
      check w.isDestroyed and page.isDestroyed and custom.isDestroyed and label.isDestroyed

    test "dialog getters/setters detach mutable data; page setup getter full refs do not leak":
      let w = newPrintUnixDialog()
      let page = newPageSetupUnixDialog()
      defer:
        w.destroy()
        page.destroy()
      w.manualCapabilities = {capCopies}
      let settings = newPrintSettings()
      settings.copies = 3
      settings.set("format-for-printer", "Example printer")
      let setup = newPageSetup()
      setup.orientation = pageLandscape
      w.settings = settings
      w.pageSetup = setup
      page.settings = settings
      page.pageSetup = setup
      check w.pageSetupSet
      settings.copies = 8
      settings.set("scale", "nan")
      expect ValueError: w.settings = settings
      settings.scale = 100
      setup.orientation = pagePortrait
      check w.settings.copies == 3 and page.settings.copies == 3
      check w.pageSetup.orientation == pageLandscape and page.pageSetup.orientation == pageLandscape
      let detached = w.pageSetup
      detached.orientation = pageReverseLandscape
      check w.pageSetup.orientation == pageLandscape
      let detachedSettings = page.settings
      detachedSettings.copies = 20
      check page.settings.copies == 3
      let emptyPage = newPageSetupUnixDialog()
      defer: emptyPage.destroy()
      check emptyPage.settings.isEmpty
      var gone = 0
      block:
        let d = newPageSetupUnixDialog()
        let nativeSetup = n.page_setup_unix_dialog_get_page_setup(d.raw)
        g.weak_ref(cast[g.PGObject](nativeSetup), finalized, addr gone)
        g.g_object_unref(nativeSetup) # The native implementation returned a full ref.
        let refs = cast[g.PGObject](nativeSetup).ref_count
        for i in 0..<12: discard d.pageSetup
        check cast[g.PGObject](nativeSetup).ref_count == refs
        # GTK2 itself leaks its LAST selected setup (see native diagnostic/patch).
        # Switch away so this probe tests our getter ownership independently.
        let different = newPageSetup()
        different.setPaperWithDefaultMargins(newPaperSize("na_letter"))
        if different.paperSize.name == d.pageSetup.paperSize.name:
          different.setPaperWithDefaultMargins(newPaperSize("iso_a4"))
        d.pageSetup = different
        d.destroy()
      check gone == 1

    test "response snapshots queue each event, preserve state and route through Dialog upcasts":
      let w = newPrintUnixDialog()
      defer: w.destroy()
      w.manualCapabilities = {capCopies}
      let settings = newPrintSettings()
      settings.copies = 2
      w.settings = settings
      var seen: seq[PrintSelection]
      var ids: seq[ResponseId]
      w.onResponse(proc (id: ResponseId, value: PrintSelection) =
        ids.add(id)
        seen.add(value))
      var generic = 0
      gtk2.Dialog(w).onResponse(proc (id: ResponseId) = inc generic)
      w.respond(responseCancel)
      settings.copies = 4
      w.settings = settings
      w.respond(responseClose)
      check seen.len == 0 and generic == 0
      drain()
      check ids == @[responseCancel, responseClose] and generic == 2
      check seen[0].settings.copies == 2 and seen[1].settings.copies == 4
      w.destroy()
      check seen[0].pageSetup.paperSize.name.len > 0
      let page = newPageSetupUnixDialog()
      defer: page.destroy()
      let setup = newPageSetup()
      setup.orientation = pageLandscape
      page.pageSetup = setup
      var captured: PrintSelection
      page.onResponse(proc (id: ResponseId, value: PrintSelection) = captured = value)
      page.respond(responseCancel)
      setup.orientation = pagePortrait
      page.pageSetup = setup
      drain()
      check captured.pageSetup.orientation == pageLandscape
      gtk2.Dialog(page).onResponse(proc (id: ResponseId) = page.destroy())
      page.respond(responseCancel)
      drain()
      check page.isDestroyed

    test "capture cancellation, temporary native owners, self-disconnection and exceptions":
      let w = newPrintUnixDialog()
      defer: w.destroy()
      var freed, calls = 0
      let canceled = watch(w, addr freed, addr calls)
      w.respond(responseCancel)
      canceled.disconnect()
      drain()
      check freed == 1 and calls == 0
      let pending = watch(w, addr freed, addr calls)
      w.respond(responseCancel)
      w.destroy()
      drain()
      check freed == 2 and calls == 0 and not pending.connected
      block:
        let once = newPrintUnixDialog()
        var released = 0
        once.onResponse(proc (id: ResponseId, value: PrintSelection) =
          g.weak_ref(cast[g.PGObject](value.settings.raw), finalized, addr released))
        once.respond(responseCancel)
        drain()
        check released == 1 # No observer-held previous snapshot after delivery.
        once.destroy()
      let native = temporaryDialog(addr freed, addr calls)
      n.destroy(cast[n.PWidget](native))
      g.g_object_unref(native)
      drain()
      check freed == 3 and calls == 0
      let next = newPrintUnixDialog()
      defer: next.destroy()
      var connection: Connection
      connection = next.onResponse(proc (id: ResponseId, value: PrintSelection) =
        connection.disconnect()
        next.destroy()
        raise newException(ValueError, "expected print callback error"))
      next.respond(responseCancel)
      drain()
      check not connection.connected and next.isDestroyed
      let callback: proc (id: ResponseId, value: PrintSelection) {.closure.} = nil
      expect ValueError: discard next.onResponse(callback)

  drain()
  g.set_property(cast[g.PGObject](nativeSettings), "gtk-print-backends", addr original)
  g.unset(addr original)
  anchor.destroy()
removeDir(sandbox)
