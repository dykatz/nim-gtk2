# Included by headers/gdk2.nim; do not import directly.
proc destroy*(cursor: PCursor) =
  unref(cursor)

proc TYPE_CURSOR*(): GType =
  result = cursor_get_type()

proc TYPE_DRAG_CONTEXT*(): GType =
  result = drag_context_get_type()

