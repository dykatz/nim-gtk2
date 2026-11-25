# Lazy format-8 application targets, with a unique native owner per publication.
type
  ClipboardProvider* = proc (mime: string): BinaryData {.closure.}
    ## Return matching bytes, or default BinaryData to decline this conversion.
  CustomClipboardOffer* = object
    state: CustomClipboardState
  CustomClipboardState = ref object
    clipboard: Clipboard
    owner: g.PGObject # Publication pin, independent of GTK's persistence ref.
    names: seq[string]
    atoms: seq[rawGdk.TAtom]
    maxBytes: int
    provider: ClipboardProvider
    serving: bool

const customClipboardKey = "nim-gtk2-custom-clipboard-owner"

proc active*(offer: CustomClipboardOffer): bool =
  offer.state != nil and offer.state.owner != nil

proc releaseCustomClipboard(data: pointer) {.cdecl.} = GC_unref(cast[CustomClipboardState](data))

proc clearCustomClipboard(s: CustomClipboardState) =
  let owner = s.owner
  if owner == nil: return
  s.owner = nil # Invalidate before dropping captures or native refs.
  defer: g.g_object_unref(owner)
  s.clipboard = Clipboard()
  s.names = @[]
  s.atoms = @[]
  s.provider = nil

proc customClipboardClear(clipboard: rawGtk.PClipboard, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[CustomClipboardState](g.get_data(cast[g.PGObject](data), customClipboardKey))
    if s != nil: clearCustomClipboard(s)

proc customClipboardGet(clipboard: rawGtk.PClipboard, selection: rawGtk.PSelectionData,
                        info: g.guint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let owner = cast[g.PGObject](data)
    let s = cast[CustomClipboardState](g.get_data(owner, customClipboardKey))
    if s == nil or s.owner != owner or s.serving or modelFunctionDepth != 0 or
        info.uint64 >= s.names.len.uint64: return
    let i = int(info)
    let name = s.names[i]
    let atom = s.atoms[i]
    if rawGtk.selection_data_get_target(selection) != atom: return
    discard g.g_object_ref(owner)
    defer: g.g_object_unref(owner)
    let provider = s.provider
    s.serving = true
    defer: s.serving = false
    try:
      inc modelFunctionDepth
      let value = try: provider(name)
                  finally: dec modelFunctionDepth
      if s.owner != owner or value.target != name or value.payload.len > s.maxBytes: return
      let p = if value.payload.len == 0: nil else: cast[g.Pguchar](unsafeAddr value.payload[0])
      rawGtk.set(selection, atom, 8, p, g.gint(value.payload.len))
    except Exception as error: reportSignalError(error)

proc offerCustom*(clipboard: Clipboard, targets: openArray[string], provider: ClipboardProvider,
                  maxBytes = 16 * 1024 * 1024): CustomClipboardOffer =
  ## Claim with a unique native GObject owner. The synchronous provider only receives a MIME value.
  let p = clipboard.raw
  if provider == nil: raise newException(ValueError, "custom clipboard provider cannot be nil")
  if targets.len notin 1..256: raise newException(ValueError, "custom clipboard needs 1..256 targets")
  if maxBytes notin 0..(high(g.gint).int - 1):
    raise newException(ValueError, "custom clipboard maxBytes must be in 0..2147483646")
  var names: seq[string]
  for name in targets:
    checkBinaryMime(name)
    if name in names: raise newException(ValueError, "duplicate custom clipboard target")
    names.add(name)
  var entries = newSeq[rawGtk.TTargetEntry](names.len)
  let s = CustomClipboardState(clipboard: clipboard, names: names, provider: provider, maxBytes: maxBytes)
  for i, name in names:
    s.atoms.add(transferAtom(name.cstring))
    entries[i] = rawGtk.TTargetEntry(target: names[i].cstring, flags: 0, info: g.guint(i))
  let owner = g.g_object_new(g.G_TYPE_OBJECT, nil)
  if owner == nil: raise newException(ValueError, "could not allocate custom clipboard owner")
  defer: g.g_object_unref(owner) # Preserve until native claim returns, even after reentrant clear.
  discard g.g_object_ref(owner)
  s.owner = owner
  GC_ref(s)
  g.set_data_full(owner, customClipboardKey, cast[pointer](s), releaseCustomClipboard)
  if not g.toBool(rawGtk.set_with_owner(p, addr entries[0], g.guint(entries.len),
                                      customClipboardGet, customClipboardClear, owner)):
    clearCustomClipboard(s)
    raise newException(ValueError, "GTK could not claim custom clipboard ownership")
  result.state = s

proc checkedCustomOffer(offer: CustomClipboardOffer): CustomClipboardState =
  requireOutsideModelFunction()
  if not offer.active or rawGtk.get_owner(offer.state.clipboard.raw) != offer.state.owner:
    raise newException(ValueError, "clipboard offer is inactive")
  offer.state

proc clear*(offer: CustomClipboardOffer) =
  requireOutsideModelFunction()
  if offer.active and rawGtk.get_owner(offer.state.clipboard.raw) == offer.state.owner:
    offer.state.clipboard.clear()

proc persistCustomOffer(offer: CustomClipboardOffer, targets: openArray[string], now: bool) =
  let s = checkedCustomOffer(offer)
  if targets.len == 0 or targets.len > s.names.len:
    raise newException(ValueError, "choose a nonempty subset of offered custom targets")
  var names: seq[string]
  for name in targets:
    if name notin s.names or name in names:
      raise newException(ValueError, "persistence requires distinct offered custom targets")
    names.add(name)
  let owner = s.owner
  discard g.g_object_ref(owner)
  defer: g.g_object_unref(owner)
  persistClipboardOffer(s.clipboard, names, now)

proc allowPersistence*(offer: CustomClipboardOffer, targets: openArray[string]) =
  ## Authorize exactly these published targets, including native GTK shutdown.
  persistCustomOffer(offer, targets, false)

proc store*(offer: CustomClipboardOffer, targets: openArray[string]) =
  ## Authorize the subset and request native handoff. No success or durability result.
  persistCustomOffer(offer, targets, true)
