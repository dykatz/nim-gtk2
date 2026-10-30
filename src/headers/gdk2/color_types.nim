# Included by headers/gdk2.nim; do not import directly.
type
  TColor*{.final, pure.} = object
    pixel*: guint32
    red*: guint16
    green*: guint16
    blue*: guint16

  PColor* = ptr TColor
  TColormapClass* = object of TGObjectClass
  PColormapClass* = ptr TColormapClass
