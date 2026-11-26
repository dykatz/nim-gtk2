# Included after the four transfer source types.
type TransferDragSource* = TextDragSource | UriDragSource | BinaryDragSource | ImageDragSource

proc setCopiedIcon(source: TransferDragSource, image: Pixbuf, x, y: g.gint) =
  let snapshot = image.copy()
  if not source.connected: raise newException(ValueError, "drag source is disconnected")
  source.state.icon = DragIconConfig(image: snapshot, x: x, y: y)

proc setIcon*(source: TransferDragSource, image: Pixbuf) =
  ## Copied pixels with GTK's native site hotspot, for future drags only.
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "drag source is disconnected")
  setCopiedIcon(source, image, -2, -2)

proc setIcon*(source: TransferDragSource, image: Pixbuf, hotspotX, hotspotY: int) =
  ## Copied pixels with an explicit hotspot inside the image.
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "drag source is disconnected")
  let x = checkedInt(hotspotX)
  let y = checkedInt(hotspotY)
  if x >= image.width or y >= image.height:
    raise newException(ValueError, "drag icon hotspot must be inside the image")
  setCopiedIcon(source, image, x, y)

proc setIconWidget*(source: TransferDragSource, factory: DragIconFactory, hotspotX = 0, hotspotY = 0) =
  ## At each future drag-begin, build fresh unrealized content for an SDK-owned popup.
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "drag source is disconnected")
  if factory == nil: raise newException(ValueError, "drag icon factory cannot be nil")
  source.state.icon = DragIconConfig(factory: factory, x: checkedInt(hotspotX), y: checkedInt(hotspotY))

proc clearIcon*(source: TransferDragSource) =
  ## Future drags use GTK's actual default; an already active context is unchanged.
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "drag source is disconnected")
  source.state.icon = DragIconConfig()

proc dragContexts*(source: TransferDragSource): seq[DragContextInfo] =
  ## Copied source-side snapshots. A disconnected source has no observable contexts.
  requireOutsideModelFunction()
  if source.connected:
    for flight in source.state.flights:
      result.add(snapshotDragContext(flight.context))
