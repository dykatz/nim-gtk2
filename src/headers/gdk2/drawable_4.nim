# Included by headers/gdk2.nim; do not import directly.
proc window_get_size*(drawable: PDrawable, width: Pgint, height: Pgint) =
  get_size(drawable, width, height)

