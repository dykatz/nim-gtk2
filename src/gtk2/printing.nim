# Included by gtk2.nim. Cross-platform print configuration, never job submission.
type
  PrintUnit* = enum
    unitPoints, unitInches, unitMillimeters
  PageOrientation* = enum
    pagePortrait, pageLandscape, pageReversePortrait, pageReverseLandscape
  PrintPages* = enum
    printAllPages, printCurrentPage, printPageRanges, printSelection
  PageSet* = enum
    pagesAll, pagesEven, pagesOdd
  PrintDuplex* = enum
    duplexSimplex, duplexHorizontal, duplexVertical
  PrintQuality* = enum
    qualityLow, qualityNormal, qualityHigh, qualityDraft
  PrintCapability* = enum
    capPageSet, capCopies, capCollate, capReverse, capScale, capGeneratePdf,
    capGeneratePs, capPreview, capNumberUp, capNumberUpLayout
  PrintCapabilities* = set[PrintCapability]
  PageRange* = object
    first*, last*: int # Zero-based, inclusive.
  PageMargins* = object
    top*, bottom*, left*, right*: float64
  PrintSettings* = object of ObjectHandle
  PageSetup* = object of ObjectHandle
  PrintError* = object of CatchableError
    domain*: g.TGQuark
    code*: int
  PaperStateObj = object
    p: ptr rawGtk.PaperSize
  PaperState = ref PaperStateObj
  PaperSize* = object
    state: PaperState
proc `=destroy`(s: var PaperStateObj) =
  if s.p != nil: rawGtk.paper_size_free(s.p)
proc raw*(p: PaperSize): ptr rawGtk.PaperSize =
  if p.state == nil: raise newException(ValueError, "paper size is uninitialized")
  p.state.p
proc isEmpty*(p: PaperSize): bool = p.state == nil
proc ownedPaper(p: ptr rawGtk.PaperSize): PaperSize =
  if p != nil: result.state = PaperState(p: p)
proc copy*(p: PaperSize): PaperSize = ownedPaper(rawGtk.paper_size_copy(p.raw))
proc raw*(s: PrintSettings): ptr rawGtk.PrintSettings = cast[ptr rawGtk.PrintSettings](nativePointer(s))
proc raw*(s: PageSetup): ptr rawGtk.PageSetup = cast[ptr rawGtk.PageSetup](nativePointer(s))
proc isEmpty*(s: PrintSettings): bool = s.state == nil
proc isEmpty*(s: PageSetup): bool = s.state == nil
proc ownedPrintSettings(p: ptr rawGtk.PrintSettings): PrintSettings =
  if p != nil: result.state = adoptObject(p, cache = true, hasDestroySignal = false, sink = false)
proc ownedPageSetup(p: ptr rawGtk.PageSetup): PageSetup =
  if p != nil: result.state = adoptObject(p, cache = true, hasDestroySignal = false, sink = false)
proc newPrintSettings*(): PrintSettings = ownedPrintSettings(rawGtk.print_settings_new())
proc newPageSetup*(): PageSetup = ownedPageSetup(rawGtk.page_setup_new())
proc copy*(s: PrintSettings): PrintSettings = ownedPrintSettings(rawGtk.print_settings_copy(s.raw))
proc copy*(s: PageSetup): PageSetup = ownedPageSetup(rawGtk.page_setup_copy(s.raw))
proc printUnit(unit: PrintUnit): rawGtk.Unit = rawGtk.Unit(ord(unit) + 1) # Never GTK_UNIT_PIXEL.
proc printLength(value: float64, unit: PrintUnit, positive = false): float64 =
  result = finite(value)
  if result < 0 or (positive and result == 0): raise newException(ValueError, "invalid print length")
  # Native conversions may multiply by 25.4 or 72 before dividing.
  discard finite(result * 72)
proc requiredPrintText(value: string): cstring =
  result = checkedUtf8Text(value)
  if value.len == 0: raise newException(ValueError, "print name/key cannot be empty")
proc checkedPrintKey(value: string): cstring =
  result = requiredPrintText(value)
  if value[0] in {' ', '\t'} or value[^1] in {' ', '\t'}:
    raise newException(ValueError, "print keys cannot have surrounding whitespace")
  for ch in value:
    if ch < ' ' or ch in {'[', ']', '='}:
      raise newException(ValueError, "print keys must be valid key-file names")
proc name*(p: PaperSize): string = $rawGtk.paper_size_get_name(p.raw)
proc displayName*(p: PaperSize): string = $rawGtk.paper_size_get_display_name(p.raw)
proc isCustom*(p: PaperSize): bool = g.toBool(rawGtk.paper_size_is_custom(p.raw))
proc width*(p: PaperSize, unit = unitMillimeters): float64 = finite(rawGtk.paper_size_get_width(p.raw, printUnit(unit)))
proc height*(p: PaperSize, unit = unitMillimeters): float64 = finite(rawGtk.paper_size_get_height(p.raw, printUnit(unit)))
proc standardPaperSizes*(): seq[PaperSize] =
  let list = rawGtk.paper_size_get_paper_sizes(g.gbool(false))
  defer:
    var current = list
    while current != nil:
      rawGtk.paper_size_free(cast[ptr rawGtk.PaperSize](current.data))
      current = current.next
    g.free(list)
  var current = list
  while current != nil:
    result.add(ownedPaper(rawGtk.paper_size_copy(cast[ptr rawGtk.PaperSize](current.data))))
    current = current.next
proc newPaperSize*(name = ""): PaperSize =
  discard checkedUtf8Text(name)
  if name.len == 0: return ownedPaper(rawGtk.paper_size_new(nil))
  # Unknown names make native GTK warn and silently substitute A4. Reject them.
  for paper in standardPaperSizes():
    if paper.name == name: return paper
  raise newException(ValueError, "unknown standard paper name; use newCustomPaperSize for custom dimensions")
proc newCustomPaperSize*(name, displayName: string, width, height: float64,
                         unit = unitMillimeters): PaperSize =
  let key = requiredPrintText(name)
  let label = requiredPrintText(displayName)
  let w = printLength(width, unit, positive = true)
  let h = printLength(height, unit, positive = true)
  ownedPaper(rawGtk.paper_size_new_custom(key, label, w, h, printUnit(unit)))
proc orientation*(s: PageSetup): PageOrientation = PageOrientation(rawGtk.page_setup_get_orientation(s.raw).int)
proc `orientation=`*(s: PageSetup, value: PageOrientation) = rawGtk.page_setup_set_orientation(s.raw, rawGtk.PageOrientation(ord(value)))
proc paperSize*(s: PageSetup): PaperSize = ownedPaper(rawGtk.paper_size_copy(rawGtk.page_setup_get_paper_size(s.raw)))
proc `paperSize=`*(s: PageSetup, value: PaperSize) = rawGtk.page_setup_set_paper_size(s.raw, value.raw)
proc setPaperWithDefaultMargins*(s: PageSetup, value: PaperSize) = rawGtk.page_setup_set_paper_size_and_default_margins(s.raw, value.raw)
proc margins*(s: PageSetup, unit = unitMillimeters): PageMargins =
  let p = s.raw
  let u = printUnit(unit)
  PageMargins(top: rawGtk.page_setup_get_top_margin(p, u), bottom: rawGtk.page_setup_get_bottom_margin(p, u),
    left: rawGtk.page_setup_get_left_margin(p, u), right: rawGtk.page_setup_get_right_margin(p, u))
proc setMargins*(s: PageSetup, value: PageMargins, unit = unitMillimeters) =
  for length in [value.top, value.bottom, value.left, value.right]: discard printLength(length, unit)
  let p = s.raw
  let u = printUnit(unit)
  rawGtk.page_setup_set_top_margin(p, value.top, u)
  rawGtk.page_setup_set_bottom_margin(p, value.bottom, u)
  rawGtk.page_setup_set_left_margin(p, value.left, u)
  rawGtk.page_setup_set_right_margin(p, value.right, u)
proc paperWidth*(s: PageSetup, unit = unitMillimeters): float64 = finite(rawGtk.page_setup_get_paper_width(s.raw, printUnit(unit)))
proc paperHeight*(s: PageSetup, unit = unitMillimeters): float64 = finite(rawGtk.page_setup_get_paper_height(s.raw, printUnit(unit)))
proc pageWidth*(s: PageSetup, unit = unitMillimeters): float64 = finite(rawGtk.page_setup_get_page_width(s.raw, printUnit(unit)))
proc pageHeight*(s: PageSetup, unit = unitMillimeters): float64 = finite(rawGtk.page_setup_get_page_height(s.raw, printUnit(unit)))
proc hasKey*(s: PrintSettings, key: string): bool = g.toBool(rawGtk.print_settings_has_key(s.raw, checkedPrintKey(key)))
proc get*(s: PrintSettings, key: string): string = $rawGtk.print_settings_get(s.raw, checkedPrintKey(key))
proc set*(s: PrintSettings, key, value: string) =
  let k = checkedPrintKey(key)
  let v = checkedUtf8Text(value)
  rawGtk.print_settings_set(s.raw, k, v)
proc unset*(s: PrintSettings, key: string) = rawGtk.print_settings_unset(s.raw, checkedPrintKey(key))
proc collectPrintPair(key, value: cstring, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: cast[ptr seq[tuple[key, value: string]]](data)[].add(($key, $value))
proc pairs*(s: PrintSettings): seq[tuple[key, value: string]] =
  rawGtk.print_settings_foreach(s.raw, collectPrintPair, addr result)
proc printerName*(s: PrintSettings): string = $rawGtk.print_settings_get_printer(s.raw)
proc `printerName=`*(s: PrintSettings, value: string) = rawGtk.print_settings_set_printer(s.raw, requiredPrintText(value))
proc orientation*(s: PrintSettings): PageOrientation = PageOrientation(rawGtk.print_settings_get_orientation(s.raw).int)
proc `orientation=`*(s: PrintSettings, value: PageOrientation) = rawGtk.print_settings_set_orientation(s.raw, rawGtk.PageOrientation(ord(value)))
proc `paperSize=`*(s: PrintSettings, value: PaperSize) = rawGtk.print_settings_set_paper_size(s.raw, value.raw)
proc paperSize*(s: PrintSettings): PaperSize =
  let format = s.get("paper-format")
  if format.len == 0: return
  if format.len >= 7 and format[0..<7] == "custom-":
    let name = format[7..^1]
    return newCustomPaperSize(name, name,
      rawGtk.print_settings_get_paper_width(s.raw, printUnit(unitMillimeters)),
      rawGtk.print_settings_get_paper_height(s.raw, printUnit(unitMillimeters)))
  newPaperSize(format)
template printBool(getter, setter, nativeGet, nativeSet: untyped) =
  proc getter*(s: PrintSettings): bool = g.toBool(nativeGet(s.raw))
  proc setter*(s: PrintSettings, value: bool) = nativeSet(s.raw, g.gbool(value))
printBool(useColor, `useColor=`, rawGtk.print_settings_get_use_color, rawGtk.print_settings_set_use_color)
printBool(collate, `collate=`, rawGtk.print_settings_get_collate, rawGtk.print_settings_set_collate)
printBool(reverse, `reverse=`, rawGtk.print_settings_get_reverse, rawGtk.print_settings_set_reverse)
proc copies*(s: PrintSettings): int = rawGtk.print_settings_get_n_copies(s.raw).int
proc `copies=`*(s: PrintSettings, value: int) =
  let n = checkedInt(value)
  if n == 0: raise newException(ValueError, "copies must be positive")
  rawGtk.print_settings_set_n_copies(s.raw, n)
proc scale*(s: PrintSettings): float64 = rawGtk.print_settings_get_scale(s.raw)
proc `scale=`*(s: PrintSettings, value: float64) =
  if finite(value) <= 0: raise newException(ValueError, "print scale must be positive")
  rawGtk.print_settings_set_scale(s.raw, value)
proc numberUp*(s: PrintSettings): int = rawGtk.print_settings_get_number_up(s.raw).int
proc `numberUp=`*(s: PrintSettings, value: int) =
  if value notin [1, 2, 4, 6, 9, 16]: raise newException(ValueError, "unsupported number-up layout count")
  rawGtk.print_settings_set_number_up(s.raw, g.gint(value))
proc resolution*(s: PrintSettings): tuple[x, y: int] =
  (rawGtk.print_settings_get_resolution_x(s.raw).int, rawGtk.print_settings_get_resolution_y(s.raw).int)
proc setResolution*(s: PrintSettings, x, y: int) =
  let a = checkedInt(x)
  let b = checkedInt(y)
  if a == 0 or b == 0: raise newException(ValueError, "print resolution must be positive")
  rawGtk.print_settings_set_resolution_xy(s.raw, a, b)
proc duplex*(s: PrintSettings): PrintDuplex = PrintDuplex(rawGtk.print_settings_get_duplex(s.raw).int)
proc `duplex=`*(s: PrintSettings, value: PrintDuplex) = rawGtk.print_settings_set_duplex(s.raw, rawGtk.PrintDuplex(ord(value)))
proc quality*(s: PrintSettings): PrintQuality = PrintQuality(rawGtk.print_settings_get_quality(s.raw).int)
proc `quality=`*(s: PrintSettings, value: PrintQuality) = rawGtk.print_settings_set_quality(s.raw, rawGtk.PrintQuality(ord(value)))
proc printPages*(s: PrintSettings): PrintPages = PrintPages(rawGtk.print_settings_get_print_pages(s.raw).int)
proc `printPages=`*(s: PrintSettings, value: PrintPages) = rawGtk.print_settings_set_print_pages(s.raw, rawGtk.PrintPages(ord(value)))
proc pageSet*(s: PrintSettings): PageSet = PageSet(rawGtk.print_settings_get_page_set(s.raw).int)
proc `pageSet=`*(s: PrintSettings, value: PageSet) = rawGtk.print_settings_set_page_set(s.raw, rawGtk.PageSet(ord(value)))
proc checkedPageRange(value: PageRange): rawGtk.PageRange =
  let first = checkedInt(value.first)
  let last = checkedInt(value.last)
  if last < first: raise newException(ValueError, "page range end precedes its start")
  rawGtk.PageRange(start: first, `end`: last)
proc `pageRanges=`*(s: PrintSettings, values: openArray[PageRange]) =
  let count = checkedInt(values.len)
  var ranges = newSeq[rawGtk.PageRange](values.len)
  for i, value in values: ranges[i] = checkedPageRange(value)
  rawGtk.print_settings_set_page_ranges(s.raw, (if count == 0: nil else: addr ranges[0]), count)
proc pageRanges*(s: PrintSettings): seq[PageRange] =
  var count: g.gint
  let ranges = rawGtk.print_settings_get_page_ranges(s.raw, addr count)
  defer: g.g_free(ranges)
  let data = cast[ptr UncheckedArray[rawGtk.PageRange]](ranges)
  for i in 0..<count.int:
    let value = PageRange(first: data[i].start.int, last: data[i].`end`.int)
    discard checkedPageRange(value)
    result.add(value)
proc checkPrintError(error: ptr g.GError) =
  if error != nil:
    let failure = newException(PrintError, $error.message)
    failure.domain = error.domain
    failure.code = error.code.int
    g.g_error_free(error)
    raise failure
proc loadPrintSettings*(filename: string): PrintSettings =
  let name = checkedChooserFilename(filename)
  var error: ptr g.GError
  let p = rawGtk.print_settings_new_from_file(name, addr error)
  if error != nil:
    if p != nil: g.g_object_unref(p)
    checkPrintError(error)
  result = ownedPrintSettings(p)
  if result.isEmpty: raise newException(PrintError, "could not load print settings")
proc loadPageSetup*(filename: string): PageSetup =
  let name = checkedChooserFilename(filename)
  var error: ptr g.GError
  let p = rawGtk.page_setup_new_from_file(name, addr error)
  if error != nil:
    if p != nil: g.g_object_unref(p)
    checkPrintError(error)
  result = ownedPageSetup(p)
  if result.isEmpty: raise newException(PrintError, "could not load page setup")
proc save*(s: PrintSettings, filename: string) =
  let name = checkedChooserFilename(filename)
  var error: ptr g.GError
  let ok = rawGtk.print_settings_to_file(s.raw, name, addr error)
  checkPrintError(error)
  if not g.toBool(ok): raise newException(PrintError, "could not save print settings")
proc save*(s: PageSetup, filename: string) =
  let name = checkedChooserFilename(filename)
  var error: ptr g.GError
  let ok = rawGtk.page_setup_to_file(s.raw, name, addr error)
  checkPrintError(error)
  if not g.toBool(ok): raise newException(PrintError, "could not save page setup")

when defined(posix) and not defined(macosx):
  include printingunix
