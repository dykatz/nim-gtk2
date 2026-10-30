# Included by headers/xkb.nim; do not import directly.
type
  XkbDeviceInfoRec*{.final.} = object
    name*: cstring
    theType*: Atom
    device_spec*: int16
    has_own_state*: bool
    supported*: int16
    unsupported*: int16
    num_btns*: int16
    btn_acts*: PXkbAction
    sz_leds*: int16
    num_leds*: int16
    dflt_kbd_fb*: int16
    dflt_led_fb*: int16
    leds*: PXkbDeviceLedInfoPtr

  PXkbDeviceInfoPtr* = ptr XkbDeviceInfoRec
