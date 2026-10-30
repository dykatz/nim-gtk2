# Included by headers/gdk2.nim; do not import directly.
type
  TImage* = object of TGObject
    `type`*: TImageType
    visual*: PVisual
    byte_order*: TByteOrder
    width*: gint
    height*: gint
    depth*: guint16
    bpp*: guint16
    bpl*: guint16
    bits_per_pixel*: guint16
    mem*: gpointer
    colormap*: PColormap
    windowing_data*: gpointer

  PImage* = ptr TImage
