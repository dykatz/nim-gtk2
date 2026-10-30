# Included by headers/gdk2.nim; do not import directly.
type
  TFilterReturn* = enum
    FILTER_CONTINUE, FILTER_TRANSLATE, FILTER_REMOVE
  PFilterReturn* = ptr TFilterReturn
  TEventType* = gint
  PEventType* = ptr TEventType
  TEventMask* = gint32
  PEventMask* = ptr TEventMask
  TVisibilityState* = enum
    VISIBILITY_UNOBSCURED, VISIBILITY_PARTIAL, VISIBILITY_FULLY_OBSCURED
  PVisibilityState* = ptr TVisibilityState
  TScrollDirection* = enum
    SCROLL_UP, SCROLL_DOWN, SCROLL_LEFT, SCROLL_RIGHT
  PScrollDirection* = ptr TScrollDirection
  TNotifyType* = int
  PNotifyType* = ptr TNotifyType
  TCrossingMode* = enum
    CROSSING_NORMAL, CROSSING_GRAB, CROSSING_UNGRAB
  PCrossingMode* = ptr TCrossingMode
  TPropertyState* = enum
    PROPERTY_NEW_VALUE, PROPERTY_STATE_DELETE
  PPropertyState* = ptr TPropertyState
  TWindowState* = gint
  PWindowState* = ptr TWindowState
  TSettingAction* = enum
    SETTING_ACTION_NEW, SETTING_ACTION_CHANGED, SETTING_ACTION_DELETED
  PSettingAction* = ptr TSettingAction
  TEventAny*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8

  PEventAny* = ptr TEventAny
  TEventExpose*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    area*: TRectangle
    region*: PRegion
    count*: gint

  PEventExpose* = ptr TEventExpose
  TEventNoExpose*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8

  PEventNoExpose* = ptr TEventNoExpose
  TEventVisibility*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    state*: TVisibilityState

  PEventVisibility* = ptr TEventVisibility
  TEventKey*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    time*: guint32
    state*: guint
    keyval*: guint
    length*: gint
    `string`*: cstring
    hardware_keycode*: guint16
    group*: guint8

  PEventKey* = ptr TEventKey
  TEventCrossing*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    subwindow*: PWindow
    time*: guint32
    x*: gdouble
    y*: gdouble
    x_root*: gdouble
    y_root*: gdouble
    mode*: TCrossingMode
    detail*: TNotifyType
    focus*: gboolean
    state*: guint

  PEventCrossing* = ptr TEventCrossing
  TEventFocus*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    `in`*: gint16

  PEventFocus* = ptr TEventFocus
  TEventConfigure*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    x*: gint
    y*: gint
    width*: gint
    height*: gint

  PEventConfigure* = ptr TEventConfigure
  TEventProperty*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    atom*: TAtom
    time*: guint32
    state*: guint

  PEventProperty* = ptr TEventProperty
  TEventSelection*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    selection*: TAtom
    target*: TAtom
    `property`*: TAtom
    time*: guint32
    requestor*: TNativeWindow

  PEventSelection* = ptr TEventSelection
  TEventClient*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    message_type*: TAtom
    data_format*: gushort
    b*: array[0..19, char]

  PEventClient* = ptr TEventClient
  TEventSetting*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    action*: TSettingAction
    name*: cstring

  PEventSetting* = ptr TEventSetting
  TEventWindowState*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    changed_mask*: TWindowState
    new_window_state*: TWindowState

  PEventWindowState* = ptr TEventWindowState
  TEventDND*{.final, pure.} = object
    `type`*: TEventType
    window*: PWindow
    send_event*: gint8
    context*: PDragContext
    time*: guint32
    x_root*: gshort
    y_root*: gshort

  PEventDND* = ptr TEventDND
