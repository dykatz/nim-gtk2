# Included by headers/gdk2.nim; do not import directly.
proc TYPE_FONT*(): GType =
  result = gdk2.font_get_type()

