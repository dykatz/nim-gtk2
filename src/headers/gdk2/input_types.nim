# Included by headers/gdk2.nim; do not import directly.
type
  TDeviceClass* = object of TGObjectClass
  PDeviceClass* = ptr TDeviceClass
  TExtensionMode* = enum
    EXTENSION_EVENTS_NONE, EXTENSION_EVENTS_ALL, EXTENSION_EVENTS_CURSOR
  PExtensionMode* = ptr TExtensionMode
  TInputSource* = enum
    SOURCE_MOUSE, SOURCE_PEN, SOURCE_ERASER, SOURCE_CURSOR
  PInputSource* = ptr TInputSource
  TInputMode* = enum
    MODE_DISABLED, MODE_SCREEN, MODE_WINDOW
  PInputMode* = ptr TInputMode
  TAxisUse* = int32
  PAxisUse* = ptr TAxisUse
  TDeviceAxis*{.final, pure.} = object
    use*: TAxisUse
    min*: gdouble
    max*: gdouble

  PDeviceAxis* = ptr TDeviceAxis
  TTimeCoord*{.final, pure.} = object
    time*: guint32
    axes*: array[0..(MAX_TIMECOORD_AXES) - 1, gdouble]

  PTimeCoord* = ptr TTimeCoord
  PPTimeCoord* = ptr PTimeCoord
