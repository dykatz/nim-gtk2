# Included by headers/gdk2.nim; do not import directly.
type
  TDeviceKey*{.final, pure.} = object
    keyval*: guint
    modifiers*: TModifierType

  PDeviceKey* = ptr TDeviceKey
  TDevice* = object of TGObject
    name*: cstring
    source*: TInputSource
    mode*: TInputMode
    has_cursor*: gboolean
    num_axes*: gint
    axes*: PDeviceAxis
    num_keys*: gint
    keys*: PDeviceKey

  PDevice* = ptr TDevice
