# Included by printing.nim only on GTK Unix-print platforms.
type
  PrintUnixDialog* = object of Dialog
  PageSetupUnixDialog* = object of Dialog
  Printer* = object of ObjectHandle
  PrinterInfo* = object
    name*, description*, location*, stateMessage*, iconName*: string
    active*, paused*, acceptingJobs*, isVirtual*, isDefault*, acceptsPdf*, acceptsPs*: bool
    jobCount*: int
  PrintSelection* = object
    settings*: PrintSettings
    pageSetup*: PageSetup
    printer*: PrinterInfo
  PrintDialogLike = PrintUnixDialog | PageSetupUnixDialog
  PrintResponse = tuple[id: ResponseId, selection: PrintSelection]
proc raw*(w: PrintUnixDialog): ptr rawGtk.PrintUnixDialog = cast[ptr rawGtk.PrintUnixDialog](raw(Widget(w)))
proc raw*(w: PageSetupUnixDialog): ptr rawGtk.PageSetupUnixDialog = cast[ptr rawGtk.PageSetupUnixDialog](raw(Widget(w)))
proc raw*(p: Printer): ptr rawGtk.Printer = cast[ptr rawGtk.Printer](nativePointer(p))
proc isEmpty*(p: Printer): bool = p.state == nil
proc ownedPrinter(p: ptr rawGtk.Printer): Printer =
  if p != nil: result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false, sink = false)
proc printerInfo(p: ptr rawGtk.Printer): PrinterInfo =
  if p == nil: return
  result = PrinterInfo(name: $rawGtk.printer_get_name(p), description: $rawGtk.printer_get_description(p),
    location: $rawGtk.printer_get_location(p), stateMessage: $rawGtk.printer_get_state_message(p),
    iconName: $rawGtk.printer_get_icon_name(p), jobCount: rawGtk.printer_get_job_count(p).int,
    active: g.toBool(rawGtk.printer_is_active(p)), paused: g.toBool(rawGtk.printer_is_paused(p)),
    acceptingJobs: g.toBool(rawGtk.printer_is_accepting_jobs(p)), isVirtual: g.toBool(rawGtk.printer_is_virtual(p)),
    isDefault: g.toBool(rawGtk.printer_is_default(p)), acceptsPdf: g.toBool(rawGtk.printer_accepts_pdf(p)),
    acceptsPs: g.toBool(rawGtk.printer_accepts_ps(p)))
proc info*(p: Printer): PrinterInfo = printerInfo(p.raw)
proc name*(p: Printer): string = $rawGtk.printer_get_name(p.raw)
proc selectedPrinter*(w: PrintUnixDialog): Printer = ownedPrinter(rawGtk.print_unix_dialog_get_selected_printer(w.raw))
proc settings*(w: PrintUnixDialog): PrintSettings = ownedPrintSettings(rawGtk.print_unix_dialog_get_settings(w.raw)) # Transfer full.
proc `settings=`*(w: PrintUnixDialog, value: PrintSettings) =
  # Generic backend keys / loaded files can bypass the typed setter checks.
  if value.copies <= 0 or finite(value.scale) <= 0:
    raise newException(ValueError, "invalid print copies or scale")
  discard value.pageRanges
  let detached = value.copy()
  rawGtk.print_unix_dialog_set_settings(w.raw, detached.raw)
proc pageSetup*(w: PrintUnixDialog): PageSetup =
  ownedPageSetup(rawGtk.page_setup_copy(rawGtk.print_unix_dialog_get_page_setup(w.raw)))
proc `pageSetup=`*(w: PrintUnixDialog, value: PageSetup) =
  let detached = value.copy()
  rawGtk.print_unix_dialog_set_page_setup(w.raw, detached.raw)
proc settings*(w: PageSetupUnixDialog): PrintSettings =
  let p = rawGtk.page_setup_unix_dialog_get_print_settings(w.raw)
  if p != nil: result = ownedPrintSettings(rawGtk.print_settings_copy(p))
proc `settings=`*(w: PageSetupUnixDialog, value: PrintSettings) =
  let detached = value.copy()
  rawGtk.page_setup_unix_dialog_set_print_settings(w.raw, detached.raw)
proc pageSetup*(w: PageSetupUnixDialog): PageSetup =
  # GTK2.24's annotation says transfer-none, but get_current_page_setup uses
  # gtk_tree_model_get (object ref) or page_setup_new. Both return a FULL ref.
  let p = rawGtk.page_setup_unix_dialog_get_page_setup(w.raw)
  if p != nil:
    defer: g.g_object_unref(p)
    result = ownedPageSetup(rawGtk.page_setup_copy(p))
proc `pageSetup=`*(w: PageSetupUnixDialog, value: PageSetup) =
  let detached = value.copy()
  rawGtk.page_setup_unix_dialog_set_page_setup(w.raw, detached.raw)
proc `title=`*(w: PrintUnixDialog, value: string) = rawGtk.set_title(cast[rawGtk.PWindow](w.raw), checkedUtf8Text(value))
proc `title=`*(w: PageSetupUnixDialog, value: string) = rawGtk.set_title(cast[rawGtk.PWindow](w.raw), checkedUtf8Text(value))
proc newPrintUnixDialog*(title = "Print", modal = false): PrintUnixDialog =
  result.state = adoptWidget(rawGtk.print_unix_dialog_new(checkedUtf8Text(title), nil))
  result.modal = modal
proc newPrintUnixDialog*(parent: Window, title = "Print", modal = false,
                         destroyWithParent = true): PrintUnixDialog =
  discard parent.raw
  result = newPrintUnixDialog(title, modal)
  attachDialogParent(result, parent, destroyWithParent)
proc newPageSetupUnixDialog*(title = "Page setup", modal = false): PageSetupUnixDialog =
  result.state = adoptWidget(rawGtk.page_setup_unix_dialog_new(checkedUtf8Text(title), nil))
  result.modal = modal
proc newPageSetupUnixDialog*(parent: Window, title = "Page setup", modal = false,
                             destroyWithParent = true): PageSetupUnixDialog =
  discard parent.raw
  result = newPageSetupUnixDialog(title, modal)
  attachDialogParent(result, parent, destroyWithParent)
proc currentPage*(w: PrintUnixDialog): int = rawGtk.print_unix_dialog_get_current_page(w.raw).int
proc `currentPage=`*(w: PrintUnixDialog, value: int) =
  if value < -1 or value.int64 > high(g.gint).int64: raise newException(ValueError, "current page must be -1 or a nonnegative gint")
  rawGtk.print_unix_dialog_set_current_page(w.raw, g.gint(value))
proc manualCapabilities*(w: PrintUnixDialog): PrintCapabilities =
  let bits = rawGtk.print_unix_dialog_get_manual_capabilities(w.raw).cint
  for capability in PrintCapability:
    if (bits and (1 shl ord(capability))) != 0: result.incl(capability)
proc `manualCapabilities=`*(w: PrintUnixDialog, values: PrintCapabilities) =
  var bits: cint
  for value in values: bits = bits or (1.cint shl ord(value))
  rawGtk.print_unix_dialog_set_manual_capabilities(w.raw, rawGtk.PrintCapabilities(bits))
template printDialogBool(getter, setter, nativeGet, nativeSet: untyped) =
  proc getter*(w: PrintUnixDialog): bool = g.toBool(nativeGet(w.raw))
  proc setter*(w: PrintUnixDialog, value: bool) = nativeSet(w.raw, g.gbool(value))
printDialogBool(supportSelection, `supportSelection=`, rawGtk.print_unix_dialog_get_support_selection, rawGtk.print_unix_dialog_set_support_selection)
printDialogBool(hasSelection, `hasSelection=`, rawGtk.print_unix_dialog_get_has_selection, rawGtk.print_unix_dialog_set_has_selection)
printDialogBool(embedPageSetup, `embedPageSetup=`, rawGtk.print_unix_dialog_get_embed_page_setup, rawGtk.print_unix_dialog_set_embed_page_setup)
proc pageSetupSet*(w: PrintUnixDialog): bool = g.toBool(rawGtk.print_unix_dialog_get_page_setup_set(w.raw))
proc addCustomTab*(w: PrintUnixDialog, child, label: Widget) =
  checkChild(w, child)
  checkChild(w, label)
  if child.raw == label.raw: raise newException(ValueError, "custom tab content and label must be distinct")
  rawGtk.print_unix_dialog_add_custom_tab(w.raw, child.raw, label.raw)
  child.showAll()
  label.showAll()
proc selection*(w: PrintUnixDialog): PrintSelection =
  PrintSelection(settings: w.settings, pageSetup: w.pageSetup,
    printer: printerInfo(rawGtk.print_unix_dialog_get_selected_printer(w.raw)))
proc selection*(w: PageSetupUnixDialog): PrintSelection =
  PrintSelection(settings: w.settings, pageSetup: w.pageSetup)
proc printResponseThunk(instance: pointer, id: g.gint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      # Borrow only during emission; don't create/cache a Nim widget state.
      var value: PrintResponse
      value.id = ResponseId(id)
      if g.G_TYPE_CHECK_INSTANCE_TYPE(instance, rawGtk.print_unix_dialog_get_type()):
        let p = cast[ptr rawGtk.PrintUnixDialog](instance)
        value.selection.settings = ownedPrintSettings(rawGtk.print_unix_dialog_get_settings(p))
        value.selection.pageSetup = ownedPageSetup(rawGtk.page_setup_copy(rawGtk.print_unix_dialog_get_page_setup(p)))
        value.selection.printer = printerInfo(rawGtk.print_unix_dialog_get_selected_printer(p))
      else:
        let p = cast[ptr rawGtk.PageSetupUnixDialog](instance)
        let settings = rawGtk.page_setup_unix_dialog_get_print_settings(p)
        if settings != nil: value.selection.settings = ownedPrintSettings(rawGtk.print_settings_copy(settings))
        let setup = rawGtk.page_setup_unix_dialog_get_page_setup(p)
        if setup != nil:
          defer: g.g_object_unref(setup)
          value.selection.pageSetup = ownedPageSetup(rawGtk.page_setup_copy(setup))
      queueRecent(data, value)
    except Exception as error: reportSignalError(error)
proc onResponse*(w: PrintDialogLike, fn: proc (id: ResponseId, value: PrintSelection) {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectRecent(w, "response", proc (value: PrintResponse) = fn(value.id, value.selection), cast[g.TGCallback](printResponseThunk))
proc connectPrintResponse(w: Widget, fn: proc (id: ResponseId) {.closure.}): Connection =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectRecent(w, "response", proc (value: PrintResponse) = fn(value.id), cast[g.TGCallback](printResponseThunk))
