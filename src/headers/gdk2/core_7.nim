# Included by headers/gdk2.nim; do not import directly.
proc pointer_grab*(window: PWindow, owner_events: gboolean,
                   event_mask: TEventMask, confine_to: PWindow, cursor: PCursor,
                   time: guint32): TGrabStatus{.cdecl, dynlib: lib,
    importc: "gdk_pointer_grab".}
proc keyboard_grab*(window: PWindow, owner_events: gboolean, time: guint32): TGrabStatus{.
    cdecl, dynlib: lib, importc: "gdk_keyboard_grab".}
