# Included by headers/xkb.nim; do not import directly.
type
  XkbDescRec*{.final.} = object
    dpy*: PDisplay
    flags*: int16
    device_spec*: int16
    min_key_code*: KeyCode
    max_key_code*: KeyCode
    ctrls*: PXkbControlsPtr
    server*: PXkbServerMapPtr
    map*: PXkbClientMapPtr
    indicators*: PXkbIndicatorPtr
    names*: PXkbNamesPtr
    compat*: PXkbCompatMapPtr
    geom*: PXkbGeometryPtr

  PXkbDescPtr* = ptr XkbDescRec
