## Build: nim c -r --path:src examples/printing.nim
## Configuration only: neither accepting this dialog nor this example prints.
when defined(posix) and not defined(macosx):
  import gtk2

  proc main() =
    gtk2.init()
    var settings = newPrintSettings()
    var setup = newPageSetup()
    let window = newWindow("GTK2 print configuration (no job submission)", 640, 230)
    defer: window.destroy()
    let layout = newVBox(spacing = 12)
    layout.borderWidth = 16
    window.add(layout)
    layout.packStart(newLabel("These dialogs configure printing; this demo never submits a job."), packShrink)
    let status = newLabel("Choose page setup or inspect print settings.")
    layout.packStart(status)
    let row = newHBox(spacing = 10)
    layout.packEnd(row, packShrink)
    let pages = newButton("Page setup…")
    let printing = newButton("Print settings…")
    row.packStart(pages, packShrink)
    row.packStart(printing, packShrink)
    pages.onClicked(proc () =
      let dialog = newPageSetupUnixDialog(window)
      dialog.settings = settings
      dialog.pageSetup = setup
      dialog.onResponse(proc (id: ResponseId, choice: PrintSelection) =
        if id == responseOk:
          setup = choice.pageSetup
          if not choice.settings.isEmpty: settings = choice.settings
          status.text = "Page setup: " & setup.paperSize.displayName & " (no job submitted)"
        dialog.destroy())
      dialog.present())
    printing.onClicked(proc () =
      let dialog = newPrintUnixDialog(window, "Inspect print settings — does not print")
      # Illustrative capabilities enable controls. A real printing application
      # must actually implement these features in its renderer/job pipeline.
      # Stock GTK2 can warn GTK_IS_PRINTER here while refiltering an lpr
      # selection; see docs/gtk2.md and gtk2-print-dialog-null-printer.patch.
      dialog.manualCapabilities = {capCopies, capCollate, capScale, capGeneratePdf}
      dialog.currentPage = 0
      dialog.embedPageSetup = true
      dialog.pageSetup = setup
      dialog.settings = settings
      let extra = newVBox(spacing = 8)
      extra.borderWidth = 12
      extra.packStart(newLabel("Application-specific print configuration can go here."), packShrink)
      dialog.addCustomTab(extra, newLabel("Application"))
      dialog.onResponse(proc (id: ResponseId, choice: PrintSelection) =
        if id == responseOk:
          settings = choice.settings
          setup = choice.pageSetup
          let printer = if choice.printer.name.len == 0: "no selected printer" else: choice.printer.name
          status.text = "Accepted settings: " & $settings.copies & " copies; " & printer & ". No job submitted."
        dialog.destroy())
      dialog.present())
    window.run()
  when isMainModule: main()
else:
  when isMainModule:
    echo "GTK2 Unix print dialogs are not available on Windows or macOS."
    echo "PrintSettings, PageSetup and PaperSize remain available."
