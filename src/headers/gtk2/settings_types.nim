# Included by headers/gtk2.nim; do not import directly.
type
  TSettings* = object of TGObject
    queued_settings*: PGData
    property_values*: PGValue
    rc_context*: PRcContext
    screen*: gdk2.PScreen

  PSettings* = ptr TSettings
  TSettingsClass* = object of TGObjectClass
  PSettingsClass* = ptr TSettingsClass
  TSettingsValue*{.final, pure.} = object
    origin*: cstring
    value*: TGValue

  PSettingsValue* = ptr TSettingsValue
