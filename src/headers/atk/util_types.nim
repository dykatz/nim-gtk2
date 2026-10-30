# Included by headers/atk.nim; do not import directly.
type
  TCoordType* = enum
    XY_SCREEN, XY_WINDOW
  PCoordType* = ptr TCoordType
  TKeyEventStruct*{.final, pure.} = object
    `type`*: gint
    state*: guint
    keyval*: guint
    length*: gint
    string*: cstring
    keycode*: guint16
    timestamp*: guint32

  PKeyEventStruct* = ptr TKeyEventStruct
  TKeyEventType* = enum
    KEY_EVENT_PRESS, KEY_EVENT_RELEASE, KEY_EVENT_LAST_DEFINED
  PKeyEventType* = ptr TKeyEventType
  TUtil* = object of TGObject
  PUtil* = ptr TUtil
