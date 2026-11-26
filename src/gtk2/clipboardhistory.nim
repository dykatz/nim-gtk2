# Explicit application-owned text history; no desktop manager or clipboard observer.
type
  ClipboardHistory* = object
    initialized: bool
    entryLimit, byteLimit, used: int
    records: seq[string] # Newest first. Never returns borrowed storage.
  HistoryAdmission* = enum
    historyRecorded, historyRefreshed, historyDenied, historyTooLarge, historyUnavailable

proc newClipboardHistory*(maxEntries = 32, maxBytes = 256 * 1024): ClipboardHistory =
  ## In-memory only. Limits count entries and UTF-8 payload bytes, not heap overhead.
  if maxEntries <= 0 or maxBytes < 0 or maxBytes >= high(g.gint).int:
    raise newException(ValueError, "clipboard history requires positive maxEntries and maxBytes in 0..2147483646")
  ClipboardHistory(initialized: true, entryLimit: maxEntries, byteLimit: maxBytes)

proc len*(history: ClipboardHistory): int = history.records.len
proc byteCount*(history: ClipboardHistory): int = history.used
proc text*(history: ClipboardHistory, index: int): string =
  ## Copied UTF-8 text, most recent at index zero. Empty text is an entry.
  if index < 0 or index >= history.len:
    raise newException(ValueError, "clipboard history index is out of range")
  history.records[index]

proc remember*(history: var ClipboardHistory, text: string, retain: bool): HistoryAdmission =
  ## Explicit decision per capture. Denial, invalid text and oversized input do not evict anything.
  if not retain: return historyDenied
  if not history.initialized: raise newException(ValueError, "clipboard history is uninitialized")
  if text.len > history.byteLimit: return historyTooLarge
  discard checkedUtf8Text(text)
  var previous = -1
  for i, value in history.records:
    if value == text:
      previous = i
      break
  if previous == 0: return historyRefreshed
  # Build only the retained prefix; never sum beyond the configured capacity.
  var kept = @[text]
  var used = text.len
  for i, value in history.records:
    if i == previous: continue
    if kept.len == history.entryLimit or value.len > history.byteLimit - used: break
    kept.add(value)
    used += value.len
  history.records = move(kept)
  history.used = used
  if previous == -1: historyRecorded else: historyRefreshed

proc remember*(history: var ClipboardHistory, reply: ClipboardText, retain: bool): HistoryAdmission =
  ## Use with an explicit requestText result; unavailable isn't an empty entry.
  if not retain: return historyDenied
  if not reply.available: return historyUnavailable
  history.remember(reply.text, retain = true)

proc forget*(history: var ClipboardHistory, index: int) =
  let size = history.text(index).len
  history.records.delete(index)
  history.used -= size

proc clear*(history: var ClipboardHistory) =
  ## Forget this history's records; not secure erasure or a change to desktop ownership.
  history.records = @[]
  history.used = 0

proc restoreText*(history: ClipboardHistory, index: int, clipboard: Clipboard): TextClipboardOffer =
  ## Explicitly publish an entry, without reordering history or authorizing persistence.
  requireOutsideModelFunction()
  clipboard.offerText(history.text(index))
