# Included by gtk2.nim. Native desktop resources, not compatibility substitutes.
import headers/gdk2 as rawGdk

type
  Screen* = object of ObjectHandle
  Invisible* = object of Widget
  StatusIcon* = object of ObjectHandle
  StatusPopup* = object
    button*, time*: uint32
  StatusGeometry* = object
    available*: bool
    screen*: Screen
    x*, y*, width*, height*: int
    orientation*: Orientation
proc raw*(s: Screen): rawGdk.PScreen = cast[rawGdk.PScreen](nativePointer(s))
proc isEmpty*(s: Screen): bool = s.state == nil
proc ownedScreen(p: rawGdk.PScreen): Screen =
  if p != nil: result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false, sink = false)
proc defaultScreen*(): Screen =
  result = ownedScreen(rawGdk.get_default_screen())
  if result.isEmpty: raise newException(ValueError, "GTK has no default screen; initialize GTK first")
proc raw*(w: Invisible): rawGtk.PInvisible = cast[rawGtk.PInvisible](raw(Widget(w)))
proc newInvisible*(): Invisible = result.state = adoptWidget(rawGtk.invisible_new())
proc newInvisible*(screen: Screen): Invisible = result.state = adoptWidget(rawGtk.invisible_new_for_screen(screen.raw))
proc screen*(w: Invisible): Screen = ownedScreen(rawGtk.get_screen(w.raw))
proc `screen=`*(w: Invisible, value: Screen) = rawGtk.set_screen(w.raw, value.raw)
proc raw*(s: StatusIcon): rawGtk.PStatusIcon = cast[rawGtk.PStatusIcon](nativePointer(s))
proc desktopName(value: string): cstring =
  result = checkedUtf8Text(value)
  if value.len == 0: raise newException(ValueError, "desktop icon name cannot be empty")
proc newStatusIcon*(visible = false): StatusIcon =
  # Native constructor briefly shows its private tray widget BEFORE the
  # non-construct visible property can be set. Requires a display even if false.
  result.state = adoptObject(rawGtk.status_icon_new(), cache = true, hasDestroySignal = false, sink = false)
  rawGtk.status_icon_set_visible(result.raw, g.gbool(visible))
proc visible*(s: StatusIcon): bool = g.toBool(rawGtk.status_icon_get_visible(s.raw))
proc `visible=`*(s: StatusIcon, value: bool) = rawGtk.status_icon_set_visible(s.raw, g.gbool(value))
proc isEmbedded*(s: StatusIcon): bool = g.toBool(rawGtk.status_icon_is_embedded(s.raw))
proc size*(s: StatusIcon): int = rawGtk.status_icon_get_size(s.raw).int
proc title*(s: StatusIcon): string = $rawGtk.status_icon_get_title(s.raw)
proc `title=`*(s: StatusIcon, value: string) = rawGtk.status_icon_set_title(s.raw, checkedUtf8Text(value))
proc setName*(s: StatusIcon, value: string) = rawGtk.status_icon_set_name(s.raw, desktopName(value))
proc hasTooltip*(s: StatusIcon): bool = g.toBool(rawGtk.status_icon_get_has_tooltip(s.raw))
proc `hasTooltip=`*(s: StatusIcon, value: bool) = rawGtk.status_icon_set_has_tooltip(s.raw, g.gbool(value))
proc tooltipText*(s: StatusIcon): string = copiedFileText(rawGtk.status_icon_get_tooltip_text(s.raw)) # Transfer full.
proc `tooltipText=`*(s: StatusIcon, value: string) = rawGtk.status_icon_set_tooltip_text(s.raw, checkedUtf8Text(value))
proc screen*(s: StatusIcon): Screen = ownedScreen(rawGtk.status_icon_get_screen(s.raw))
proc `screen=`*(s: StatusIcon, value: Screen) = rawGtk.status_icon_set_screen(s.raw, value.raw)
proc storageKind*(s: StatusIcon): ImageStorage = ImageStorage(ord(rawGtk.status_icon_get_storage_type(s.raw)))
proc `pixbuf=`*(s: StatusIcon, value: Pixbuf) = rawGtk.status_icon_set_from_pixbuf(s.raw, value.pixbufPointer)
proc pixbuf*(s: StatusIcon): Pixbuf =
  if s.storageKind == imageEmpty: return
  if s.storageKind != imagePixbuf: raise newException(ValueError, "status icon does not contain a pixbuf")
  ownedPixbuf(rawGtk.status_icon_get_pixbuf(s.raw), borrowed = true)
proc setFromIcon*(s: StatusIcon, name: string) = rawGtk.status_icon_set_from_icon_name(s.raw, desktopName(name))
proc setFromStock*(s: StatusIcon, id: string) = rawGtk.status_icon_set_from_stock(s.raw, desktopName(id))
proc setFromFile*(s: StatusIcon, filename: string) = s.pixbuf = loadPixbuf(filename)
proc iconName*(s: StatusIcon): string =
  if s.storageKind != imageIconName: raise newException(ValueError, "status icon does not contain a named icon")
  $rawGtk.status_icon_get_icon_name(s.raw)
proc stockId*(s: StatusIcon): string =
  if s.storageKind != imageStock: raise newException(ValueError, "status icon does not contain a stock icon")
  $rawGtk.status_icon_get_stock(s.raw)
proc newStatusIcon*(image: Pixbuf, visible = false): StatusIcon =
  discard image.pixbufPointer
  result = newStatusIcon(false)
  result.pixbuf = image
  result.visible = visible
proc newStatusIconFromIcon*(name: string, visible = false): StatusIcon =
  discard desktopName(name)
  result = newStatusIcon(false)
  result.setFromIcon(name)
  result.visible = visible
proc newStatusIconFromStock*(id: string, visible = false): StatusIcon =
  discard desktopName(id)
  result = newStatusIcon(false)
  result.setFromStock(id)
  result.visible = visible
proc geometry*(s: StatusIcon): StatusGeometry =
  var screen: rawGdk.PScreen
  var area: rawGdk.TRectangle
  var orientation: rawGtk.TOrientation
  result.available = g.toBool(rawGtk.status_icon_get_geometry(s.raw, addr screen, addr area, addr orientation))
  if result.available:
    result.screen = ownedScreen(screen)
    result.x = area.x.int
    result.y = area.y.int
    result.width = area.width.int
    result.height = area.height.int
    result.orientation = Orientation(orientation)
proc disconnectSignals*(s: StatusIcon) = disconnectObjectSignals(s)
proc close*(s: StatusIcon) =
  ## Hide, cancel callbacks and invalidate all SDK aliases; unref on final release.
  if s.isDestroyed: return
  s.visible = false
  s.disconnectSignals()
  s.state.destroyed = true
  g.set_data(cast[g.PGObject](s.state.p), objectStateKey, cast[pointer](1))
proc statusActivate(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueRecent(data, true)
proc statusPopup(instance: pointer, button: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueRecent(data, StatusPopup(button: button.uint32, time: time.uint32))
proc statusSize(instance: pointer, size: g.gint, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueRecent(data, size.int)
  g.gbool(false) # Leave native scaling/handling enabled.
proc statusEmbedded(instance, pspec, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueRecent(data, g.toBool(rawGtk.status_icon_is_embedded(cast[rawGtk.PStatusIcon](instance))))
proc onActivate*(s: StatusIcon, fn: proc () {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectRecent(s, "activate", proc (unused: bool) = fn(), cast[g.TGCallback](statusActivate))
proc onPopupMenu*(s: StatusIcon, fn: proc (value: StatusPopup) {.closure.}): Connection {.discardable.} =
  connectRecent(s, "popup-menu", fn, cast[g.TGCallback](statusPopup))
proc onSizeChanged*(s: StatusIcon, fn: proc (size: int) {.closure.}): Connection {.discardable.} =
  connectRecent(s, "size-changed", fn, cast[g.TGCallback](statusSize))
proc onEmbeddedChanged*(s: StatusIcon, fn: proc (embedded: bool) {.closure.}): Connection {.discardable.} =
  connectRecent(s, "notify::embedded", fn, cast[g.TGCallback](statusEmbedded), coalesce = true, dedup = true, last = s.isEmbedded)

# Shared abstract GtkMisc API for Label, Image and Arrow.
proc raw*(w: Misc): rawGtk.PMisc = cast[rawGtk.PMisc](raw(Widget(w)))
proc alignment*(w: Misc): tuple[x, y: float64] =
  var x, y: g.gfloat
  rawGtk.get_alignment(w.raw, addr x, addr y)
  (x.float64, y.float64)
proc setAlignment*(w: Misc, x, y: float64) =
  let a = unitInterval(x)
  let b = unitInterval(y)
  rawGtk.set_alignment(w.raw, g.gfloat(a), g.gfloat(b))
proc padding*(w: Misc): tuple[x, y: int] =
  var x, y: g.gint
  rawGtk.get_padding(w.raw, addr x, addr y)
  (x.int, y.int)
proc setPadding*(w: Misc, x, y: int) =
  if x < 0 or y < 0 or x > 65535 or y > 65535:
    raise newException(ValueError, "GtkMisc padding must fit unsigned 16-bit storage")
  rawGtk.set_padding(w.raw, g.gint(x), g.gint(y))

when defined(posix) and not defined(macosx):
  include embeddingunix
