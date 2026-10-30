# Included by headers/gdk2.nim; do not import directly.
proc get_type*(window: PWindow): TWindowType =
  result = get_window_type(window)

