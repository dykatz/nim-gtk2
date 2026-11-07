# Unrealized icon API tests. No desktop selections, mapped widgets or real input.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc unrealized(entry: ui.Entry) = doAssert not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
proc emitPointer(p: n.PEntry, position = n.ENTRY_ICON_PRIMARY, release = false) =
  var event: gd.TEventButton
  event.type = if release: gd.BUTTON_RELEASE else: gd.BUTTON_PRESS
  event.x = 3.5
  event.y = 4.5
  event.x_root = 123.25
  event.y_root = 234.5
  event.button = high(g.guint)
  event.time = high(g.guint32)
  event.state = gd.TModifierType(1 shl 2)
  let signal = if release: "icon-release" else: "icon-press"
  g.g_signal_emit_by_name(p, signal.cstring, position, cast[gd.PEvent](addr event))
  event.x = -100 # Borrowed data must already have been copied.
proc emit(entry: ui.Entry, position = n.ENTRY_ICON_PRIMARY, release = false) =
  emitPointer(entry.raw, position, release)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc install(entry: ui.Entry, finalized: ptr int) =
  let image = newPixbuf(16, 16, 0x3388ffff'u32)
  g.weak_ref(cast[g.PGObject](image.raw), gone, finalized)
  entry.setIcon(iconPrimary, image)
type CaptureObj = object
  freed: ptr int
proc `=destroy`(value: var CaptureObj) = inc value.freed[]
type Capture = ref CaptureObj
proc tracked(entry: ui.Entry, freed: ptr int): EntryIconConnection =
  let capture = Capture(freed: freed)
  entry.onIconEvent(proc (value: EntryIconEvent) = discard capture.freed)
proc noAlias(freed, finalized: ptr int): EntryIconConnection =
  let entry = newEntry("secret")
  entry.setIcon(iconPrimary, newPixbuf(12, 12))
  g.weak_ref(cast[g.PGObject](entry.raw), gone, finalized)
  result = tracked(entry, freed)
  emit(entry)
proc parentOnly(host: Window, calls: ptr int): tuple[p: n.PEntry, token: EntryIconConnection] =
  let entry = newEntry()
  host.add(entry)
  entry.setIcon(iconPrimary, newPixbuf(12, 12))
  result.p = entry.raw
  result.token = entry.onIconEvent(proc (value: EntryIconEvent) = inc calls[])
ui.init()
suite "Entry icons (unrealized)":
  test "native image ownership, rendered pixbuf reference and storage replacement":
    let entry = newEntry()
    defer: entry.destroy()
    unrealized(entry)
    check entry.iconStorage(iconPrimary) == imageEmpty and entry.iconPixbuf(iconPrimary).isEmpty
    var finalized = 0
    install(entry, addr finalized)
    check finalized == 0 and entry.iconStorage(iconPrimary) == imagePixbuf
    var retained = entry.iconPixbuf(iconPrimary)
    check retained.width == 16 and retained.height == 16
    expect ValueError: discard entry.iconName(iconPrimary)
    entry.clearIcon(iconPrimary)
    check finalized == 0 and entry.iconPixbuf(iconPrimary).isEmpty
    retained = Pixbuf()
    check finalized == 1
    entry.setIconName(iconSecondary, "edit-clear")
    check entry.iconName(iconSecondary) == "edit-clear" and entry.iconStorage(iconSecondary) == imageIconName
    let rendered = entry.iconPixbuf(iconSecondary)
    check not rendered.isEmpty
    entry.clearIcon(iconSecondary)
    check entry.iconName(iconSecondary) == "" and rendered.width > 0
    unrealized(entry)
  test "atomic validation, plain allocated tooltip, policy survives image clear":
    let entry = newEntry()
    defer: entry.destroy()
    entry.setIconName(iconPrimary, "edit-clear")
    entry.setIconTooltip(iconPrimary, "<b>literal & λ🙂")
    let copied = entry.iconTooltip(iconPrimary)
    check copied == "<b>literal & λ🙂"
    entry.setIconSensitive(iconPrimary, false)
    entry.setIconActivatable(iconPrimary, false)
    check not entry.iconSensitive(iconPrimary) and not entry.iconActivatable(iconPrimary)
    for bad in ["", "bad\0name", "\xff"]:
      expect ValueError: entry.setIconName(iconPrimary, bad)
      check entry.iconName(iconPrimary) == "edit-clear"
    expect ValueError: entry.setIconTooltip(iconPrimary, "bad\0tooltip")
    let invalid = cast[EntryIconPosition](99)
    expect ValueError: entry.setIconSensitive(invalid, true)
    expect ValueError: discard entry.iconStorage(invalid)
    entry.clearIcon(iconPrimary)
    check entry.iconTooltip(iconPrimary) == copied and not entry.iconSensitive(iconPrimary)
    entry.setIcon(iconPrimary, newPixbuf(12, 12))
    check not entry.iconActivatable(iconPrimary)
    entry.setIconTooltip(iconPrimary, "")
    check entry.iconTooltip(iconPrimary) == ""
    unrealized(entry)
  test "per-emission button copy, ordering and listener snapshot; not a synthesized click":
    let entry = newEntry("unchanged")
    defer: entry.destroy()
    entry.setIcon(iconPrimary, newPixbuf(12, 12))
    var values: seq[EntryIconEvent]
    let token = entry.onIconEvent(proc (value: EntryIconEvent) = values.add(value))
    expect ValueError: discard entry.onIconEvent(nil)
    emit(entry)
    emit(entry, release = true)
    check values.len == 0
    var late = 0
    entry.onIconEvent(proc (value: EntryIconEvent) = inc late)
    drain()
    check values.len == 2 and late == 0 and entry.text == "unchanged"
    check values[0].position == iconPrimary and values[0].event.kind == buttonPress
    check values[1].event.kind == buttonRelease and values[0].event.x == 3.5
    check values[0].event.rootX == 123.25 and values[0].event.button == high(uint32)
    check values[0].event.time == high(uint32) and values[0].event.modifiers.has(modifierControl)
    emit(entry)
    token.disconnect()
    drain()
    check not token.connected and values.len == 2 and late == 1
    unrealized(entry)
  test "position-local generation cancels replacement/policy work before each listener":
    let entry = newEntry()
    defer: entry.destroy()
    for pos in [iconPrimary, iconSecondary]: entry.setIcon(pos, newPixbuf(12, 12))
    var values: seq[EntryIconEvent]
    entry.onIconEvent(proc (value: EntryIconEvent) = values.add(value))
    emit(entry)
    emit(entry, n.ENTRY_ICON_SECONDARY, true)
    entry.setIconName(iconPrimary, "edit-clear")
    drain()
    check values.len == 1 and values[0].position == iconSecondary
    emit(entry)
    expect ValueError: entry.setIconName(iconPrimary, "bad\0name")
    drain()
    check values.len == 2 and values[^1].position == iconPrimary
    values.setLen(1)
    emit(entry)
    entry.setIconTooltip(iconPrimary, "new tooltip")
    drain()
    check values.len == 1
    emit(entry)
    entry.setIconSensitive(iconPrimary, false)
    drain()
    check values.len == 1
    entry.setIconSensitive(iconPrimary, true)
    emit(entry)
    entry.setIconActivatable(iconPrimary, false)
    drain()
    check values.len == 1
    entry.setIconActivatable(iconPrimary, true)
    emit(entry)
    entry.sensitive = false
    drain()
    check values.len == 1
    unrealized(entry)
  test "hide cancels pending records without ending the observation or realizing widgets":
    let entry = newEntry()
    defer: entry.destroy()
    entry.setIcon(iconPrimary, newPixbuf(12, 12))
    var calls = 0
    let token = entry.onIconEvent(proc (value: EntryIconEvent) = inc calls)
    entry.showAll() # An unparented non-toplevel stays unrealized/unmapped.
    unrealized(entry)
    check not g.toBool(n.get_mapped(cast[n.PWidget](entry.raw)))
    emit(entry)
    entry.hide()
    drain()
    check calls == 0 and token.connected
    entry.showAll()
    emit(entry)
    drain()
    check calls == 1
    unrealized(entry)
  test "native parent retains observer after all public entry aliases disappear":
    let host = newWindow("Unrealized parent")
    defer: host.destroy()
    var calls = 0
    let retained = parentOnly(host, addr calls)
    host.sensitive = false
    emitPointer(retained.p)
    drain()
    check calls == 0
    host.sensitive = true
    emitPointer(retained.p)
    drain()
    check calls == 1 and retained.token.connected
    check not g.toBool(n.get_realized(cast[n.PWidget](retained.p)))
    host.destroy()
    check not retained.token.connected
  test "a callback replacing the icon cancels other listeners and later queued events":
    let entry = newEntry()
    defer: entry.destroy()
    entry.setIcon(iconPrimary, newPixbuf(12, 12))
    var first, second = 0
    entry.onIconEvent(proc (value: EntryIconEvent) =
      inc first
      entry.clearIcon(iconPrimary))
    entry.onIconEvent(proc (value: EntryIconEvent) = inc second)
    emit(entry)
    emit(entry, release = true)
    drain()
    check first == 1 and second == 0
  test "readonly/password icon events contain no text and do not imply editing authorization":
    let entry = newEntry("secret λ🙂")
    defer: entry.destroy()
    entry.editable = false
    entry.textVisible = false
    entry.setIcon(iconSecondary, newPixbuf(12, 12))
    var calls = 0
    entry.onIconEvent(proc (value: EntryIconEvent) = inc calls)
    emit(entry, n.ENTRY_ICON_SECONDARY)
    drain()
    check calls == 1 and entry.text == "secret λ🙂"
    expect ValueError: discard entry.selectedText
    unrealized(entry)
  test "non-owning token/source, prompt captures, owner/combo destruction and self-close":
    var freed, finalized = 0
    let goneToken = noAlias(addr freed, addr finalized)
    check finalized == 1 and freed == 1 and not goneToken.connected
    drain()
    let combo = newComboBoxText(["λ🙂"], editable = true)
    let child = combo.entry
    child.setIcon(iconPrimary, newPixbuf(12, 12))
    let token = tracked(child, addr freed)
    emit(child)
    token.disconnect()
    check freed == 2
    discard tracked(child, addr freed)
    combo.destroy()
    check freed == 3 and child.isDestroyed
    drain()
    let entry = newEntry()
    entry.setIcon(iconPrimary, newPixbuf(12, 12))
    var calls = 0
    var connection: EntryIconConnection
    connection = entry.onIconEvent(proc (value: EntryIconEvent) =
      inc calls
      connection.disconnect()
      entry.destroy()
      raise newException(ValueError, "expected icon observer error"))
    emit(entry)
    emit(entry, release = true)
    drain()
    check calls == 1 and not connection.connected
  test "checked configuration/getters/disconnect are forbidden during pure matching":
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    let token = entry.onIconEvent(proc (value: EntryIconEvent) = discard)
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: entry.setIconName(iconPrimary, "edit-clear")
      except ValueError: inc denied
      try: discard entry.iconPixbuf(iconPrimary)
      except ValueError: inc denied
      try: token.disconnect()
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 3 and denied mod 3 == 0
    unrealized(entry)
