# Included after the four copied offer families. Explicit native hints/handoff, not success proof.
var clipboardStoreBusy = false
proc supportsPersistence*(clipboard: Clipboard): bool =
  requireOutsideModelFunction()
  let p = clipboard.raw
  if clipboard.selectionKind != clipboardStandard: return false
  g.toBool(rawGdk.supports_clipboard_persistence(rawGtk.get_display(p)))

proc persistClipboardOffer(clipboard: Clipboard, targets: seq[string], now: bool) =
  requireOutsideModelFunction()
  if clipboard.selectionKind != clipboardStandard:
    raise newException(ValueError, "clipboard persistence requires CLIPBOARD, not PRIMARY")
  if clipboardStoreBusy:
    raise newException(ValueError, "clipboard persistence is already in progress")
  let p = clipboard.raw
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  if targets.len == 0: raise newException(ValueError, "clipboard persistence needs offered targets")
  discard checkedInt(targets.len)
  var names: seq[string]
  for target in targets: names.add(target)
  var entries = newSeq[rawGtk.TTargetEntry](names.len)
  for i in 0..<names.len: entries[i] = rawGtk.TTargetEntry(target: names[i].cstring, flags: 0, info: 0)
  clipboardStoreBusy = true
  defer: clipboardStoreBusy = false
  rawGtk.set_can_store(p, addr entries[0], g.gint(entries.len))
  if now: rawGtk.store(p) # Void; may run native nested event loop for about ten seconds.

template copiedOfferPersistence(Offer: typedesc, targets: untyped) =
  proc allowPersistence*(offer: Offer) =
    ## Authorize exact targets for native manager/exit persistence; not a durability claim.
    requireOutsideModelFunction()
    if not offer.active: raise newException(ValueError, "clipboard offer is inactive")
    let s {.inject.} = offer.state
    persistClipboardOffer(s.clipboard, targets, false)
  proc store*(offer: Offer) =
    ## Mark exact targets and synchronously ask native GTK to store. No success/cancel result.
    requireOutsideModelFunction()
    if not offer.active: raise newException(ValueError, "clipboard offer is inactive")
    let s {.inject.} = offer.state
    persistClipboardOffer(s.clipboard, targets, true)

copiedOfferPersistence(TextClipboardOffer, s.targets)
copiedOfferPersistence(UriClipboardOffer, @["text/uri-list"])
copiedOfferPersistence(BinaryClipboardOffer, @[s.value.target])
copiedOfferPersistence(ImageClipboardOffer, s.targets)
