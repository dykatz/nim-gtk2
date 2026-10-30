# Included by headers/xkb.nim; do not import directly.
type
  PXkbDeviceLedChangesPtr* = ptr XkbDeviceLedChangesRec
  XkbDeviceLedChangesRec*{.final.} = object
    led_class*: int16
    led_id*: int16
    defined*: int16           #names or maps changed
    next*: PXkbDeviceLedChangesPtr


  XkbDeviceChangesRec*{.final.} = object
    changed*: int16
    first_btn*: int16
    num_btns*: int16
    leds*: XkbDeviceLedChangesRec

  PXkbDeviceChangesPtr* = ptr XkbDeviceChangesRec
