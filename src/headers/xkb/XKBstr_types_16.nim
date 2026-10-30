# Included by headers/xkb.nim; do not import directly.
type
  XkbAction*{.final.} = object   #
                                 #      XKB request codes, used in:
                                 #      -  xkbReqType field of all requests
                                 #      -  requestMinor field of some events
                                 #
    any*: XkbAnyAction
    mods*: XkbModAction
    group*: XkbGroupAction
    iso*: XkbISOAction
    thePtr*: XkbPtrAction
    btn*: XkbPtrBtnAction
    dflt*: XkbPtrDfltAction
    screen*: XkbSwitchScreenAction
    ctrls*: XkbCtrlsAction
    msg*: XkbMessageAction
    redirect*: XkbRedirectKeyAction
    devbtn*: XkbDeviceBtnAction
    devval*: XkbDeviceValuatorAction
    theType*: int8

  PXkbAction* = ptr XkbAction
