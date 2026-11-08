# Included after the three source types. No native icon getter or source-site mutation.
proc setIcon*(source: TextDragSource | UriDragSource | BinaryDragSource, image: Pixbuf) =
  ## Copy pixels now, apply to future native drag-begins only. Empty images reject.
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "drag source is disconnected")
  let snapshot = image.copy()
  if not source.connected: raise newException(ValueError, "drag source is disconnected")
  source.state.icon = snapshot

proc clearIcon*(source: TextDragSource | UriDragSource | BinaryDragSource) =
  ## Future drags use GTK's actual default; an already active context is unchanged.
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "drag source is disconnected")
  source.state.icon = Pixbuf()
