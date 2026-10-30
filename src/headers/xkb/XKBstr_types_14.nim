# Included by headers/xkb.nim; do not import directly.
type
  XkbDeviceValuatorAction*{.final.} = object   #
                                               #      Macros to classify key actions
                                               #
    theType*: int8
    device*: int8
    v1_what*: int8
    v1_ndx*: int8
    v1_value*: int8
    v2_what*: int8
    v2_ndx*: int8
    v2_value*: int8

  PXkbDeviceValuatorAction* = ptr XkbDeviceValuatorAction
