# Included by headers/gtk2.nim; do not import directly.
type
  TImagePixmapData*{.final, pure.} = object
    pixmap*: gdk2.PPixmap

  PImagePixmapData* = ptr TImagePixmapData
  TImagePixbufData*{.final, pure.} = object
    pixbuf*: gdk2pixbuf.PPixbuf

  PImagePixbufData* = ptr TImagePixbufData
  TImageStockData*{.final, pure.} = object
    stock_id*: cstring

  PImageStockData* = ptr TImageStockData
  TImageIconSetData*{.final, pure.} = object
    icon_set*: PIconSet

  PImageIconSetData* = ptr TImageIconSetData
  TImageAnimationData*{.final, pure.} = object
    anim*: gdk2pixbuf.PPixbufAnimation
    iter*: gdk2pixbuf.PPixbufAnimationIter
    frame_timeout*: guint

  PImageAnimationData* = ptr TImageAnimationData
  TImageType* {.size: sizeof(cint).} = enum
    IMAGE_EMPTY, IMAGE_PIXMAP, IMAGE_IMAGE, IMAGE_PIXBUF, IMAGE_STOCK,
    IMAGE_ICON_SET, IMAGE_ANIMATION, IMAGE_ICON_NAME, IMAGE_GICON
  PImageType* = ptr TImageType
  TImage* = object of TMisc
    storage_type*: TImageType
    pixmap*: TImagePixmapData
    mask*: gdk2.PBitmap
    icon_size*: TIconSize

  PImage* = ptr TImage
  TImageImageData*{.final, pure.} = object
    image*: gdk2.PImage

  PImageImageData* = ptr TImageImageData
