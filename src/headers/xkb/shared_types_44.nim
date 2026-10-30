# Included by headers/xkb.nim; do not import directly.
type
  XkbDeviceLedInfoRec*{.final.} = object
    led_class*: int16
    led_id*: int16
    phys_indicators*: int16
    maps_present*: int16
    names_present*: int16
    state*: int16
    names*: array[0..XkbNumIndicators - 1, Atom]
    maps*: array[0..XkbNumIndicators - 1, XkbIndicatorMapRec]

  PXkbDeviceLedInfoPtr* = ptr XkbDeviceLedInfoRec
