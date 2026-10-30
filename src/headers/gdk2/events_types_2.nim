# Included by headers/gdk2.nim; do not import directly.
type
  TEventMotion*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    time*: guint32
    x*: gdouble
    y*: gdouble
    axes*: Pgdouble
    state*: guint
    is_hint*: gint16
    device*: PDevice
    x_root*: gdouble
    y_root*: gdouble

  PEventMotion* = ptr TEventMotion
  TEventButton*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    time*: guint32
    x*: gdouble
    y*: gdouble
    axes*: Pgdouble
    state*: guint
    button*: guint
    device*: PDevice
    x_root*: gdouble
    y_root*: gdouble

  PEventButton* = ptr TEventButton
  TEventScroll*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    time*: guint32
    x*: gdouble
    y*: gdouble
    state*: guint
    direction*: TScrollDirection
    device*: PDevice
    x_root*: gdouble
    y_root*: gdouble

  PEventScroll* = ptr TEventScroll
  TEventProximity*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    time*: guint32
    device*: PDevice

  PEventProximity* = ptr TEventProximity
  TEvent*{.final, pure.} = object
    data*: array[0..255, char] # union of
                               # `type`: TEventType
                               #  any: TEventAny
                               #  expose: TEventExpose
                               #  no_expose: TEventNoExpose
                               #  visibility: TEventVisibility
                               #  motion: TEventMotion
                               #  button: TEventButton
                               #  scroll: TEventScroll
                               #  key: TEventKey
                               #  crossing: TEventCrossing
                               #  focus_change: TEventFocus
                               #  configure: TEventConfigure
                               #  `property`: TEventProperty
                               #  selection: TEventSelection
                               #  proximity: TEventProximity
                               #  client: TEventClient
                               #  dnd: TEventDND
                               #  window_state: TEventWindowState
                               #  setting: TEventSetting

  PEvent* = ptr TEvent
