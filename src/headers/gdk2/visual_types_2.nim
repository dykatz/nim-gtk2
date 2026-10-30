# Included by headers/gdk2.nim; do not import directly.
type
  TVisual* = object of TGObject
    TheType*: TVisualType
    depth*: gint
    byte_order*: TByteOrder
    colormap_size*: gint
    bits_per_rgb*: gint
    red_mask*: guint32
    red_shift*: gint
    red_prec*: gint
    green_mask*: guint32
    green_shift*: gint
    green_prec*: gint
    blue_mask*: guint32
    blue_shift*: gint
    blue_prec*: gint
    screen*: PScreen

  PVisual* = ptr TVisual
