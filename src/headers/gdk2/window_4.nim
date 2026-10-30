# Included by headers/gdk2.nim; do not import directly.
proc TYPE_WINDOW*(): GType =
  result = window_object_get_type()

