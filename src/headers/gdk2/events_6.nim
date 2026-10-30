# Included by headers/gdk2.nim; do not import directly.
const
  EXPOSURE_MASK* = 1 shl 1
const
  POINTER_MOTION_MASK* = 1 shl 2
const
  POINTER_MOTION_HINT_MASK* = 1 shl 3
const
  BUTTON_MOTION_MASK* = 1 shl 4
const
  BUTTON1_MOTION_MASK* = 1 shl 5
const
  BUTTON2_MOTION_MASK* = 1 shl 6
const
  BUTTON3_MOTION_MASK* = 1 shl 7
const
  BUTTON_PRESS_MASK* = 1 shl 8
const
  BUTTON_RELEASE_MASK* = 1 shl 9
const
  KEY_PRESS_MASK* = 1 shl 10
const
  KEY_RELEASE_MASK* = 1 shl 11
const
  ENTER_NOTIFY_MASK* = 1 shl 12
const
  LEAVE_NOTIFY_MASK* = 1 shl 13
const
  FOCUS_CHANGE_MASK* = 1 shl 14
const
  STRUCTURE_MASK* = 1 shl 15
const
  PROPERTY_CHANGE_MASK* = 1 shl 16
const
  VISIBILITY_NOTIFY_MASK* = 1 shl 17
const
  PROXIMITY_IN_MASK* = 1 shl 18
const
  PROXIMITY_OUT_MASK* = 1 shl 19
const
  SUBSTRUCTURE_MASK* = 1 shl 20
const
  SCROLL_MASK* = 1 shl 21
const
  ALL_EVENTS_MASK* = 0x003FFFFE
const
  WINDOW_STATE_WITHDRAWN* = 1 shl 0
const
  WINDOW_STATE_ICONIFIED* = 1 shl 1
const
  WINDOW_STATE_MAXIMIZED* = 1 shl 2
const
  WINDOW_STATE_STICKY* = 1 shl 3

proc event_get_type*(): GType{.cdecl, dynlib: lib, importc: "gdk_event_get_type".}
proc events_pending*(): gboolean{.cdecl, dynlib: lib,
                                  importc: "gdk_events_pending".}
proc event_get*(): PEvent{.cdecl, dynlib: lib, importc: "gdk_event_get".}
proc event_peek*(): PEvent{.cdecl, dynlib: lib, importc: "gdk_event_peek".}
proc event_get_graphics_expose*(window: PWindow): PEvent{.cdecl, dynlib: lib,
    importc: "gdk_event_get_graphics_expose".}
proc put*(event: PEvent){.cdecl, dynlib: lib, importc: "gdk_event_put".}
proc copy*(event: PEvent): PEvent{.cdecl, dynlib: lib,
    importc: "gdk_event_copy".}
proc free*(event: PEvent){.cdecl, dynlib: lib, importc: "gdk_event_free".}
proc get_time*(event: PEvent): guint32{.cdecl, dynlib: lib,
    importc: "gdk_event_get_time".}
proc get_state*(event: PEvent, state: PModifierType): gboolean{.cdecl,
    dynlib: lib, importc: "gdk_event_get_state".}
proc get_coords*(event: PEvent, x_win: Pgdouble, y_win: Pgdouble): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_event_get_coords".}
proc get_root_coords*(event: PEvent, x_root: Pgdouble, y_root: Pgdouble): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_event_get_root_coords".}
proc get_axis*(event: PEvent, axis_use: TAxisUse, value: Pgdouble): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_event_get_axis".}
proc event_handler_set*(fn: TEventFunc, data: gpointer,
                        notify: TGDestroyNotify){.cdecl, dynlib: lib,
    importc: "gdk_event_handler_set".}
proc set_show_events*(show_events: gboolean){.cdecl, dynlib: lib,
    importc: "gdk_set_show_events".}
proc get_show_events*(): gboolean{.cdecl, dynlib: lib,
                                   importc: "gdk_get_show_events".}
