# Included by headers/gdk2.nim; do not import directly.
proc drag_drop_succeeded*(context: PDragContext): gboolean {.cdecl, dynlib: lib,
    importc: "gdk_drag_drop_succeeded".}
proc drag_context_get_selected_action*(context: PDragContext): TDragAction {.cdecl,
    dynlib: lib, importc: "gdk_drag_context_get_selected_action".}
const
  ACTION_DEFAULT* = 1 shl 0
const
  ACTION_COPY* = 1 shl 1
const
  ACTION_MOVE* = 1 shl 2
const
  ACTION_LINK* = 1 shl 3
const
  ACTION_PRIVATE* = 1 shl 4
const
  ACTION_ASK* = 1 shl 5

