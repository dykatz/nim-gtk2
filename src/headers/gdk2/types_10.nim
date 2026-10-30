# Included by headers/gdk2.nim; do not import directly.
proc ROOT_PARENT*(): PWindow =
  result = get_default_root_window()

