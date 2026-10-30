# Included by headers/gdk2.nim; do not import directly.
proc event_send_client_message_for_display*(display: PDisplay, event: PEvent,
    xid: guint32): gboolean{.cdecl, dynlib: lib, importc: "gdk_event_send_client_message_for_display".}
proc threads_enter*(){.cdecl, dynlib: lib, importc: "gdk_threads_enter".}
proc threads_leave*(){.cdecl, dynlib: lib, importc: "gdk_threads_leave".}
proc threads_init*(){.cdecl, dynlib: lib, importc: "gdk_threads_init".}
proc TYPE_RECTANGLE*(): GType =
  result = rectangle_get_type()

proc TYPE_COLORMAP*(): GType =
  result = colormap_get_type()

