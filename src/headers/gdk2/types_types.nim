# Included by headers/gdk2.nim; do not import directly.
type
  TWindow* = object of TDrawable
  PWindow* = ptr TWindow
  TPixmap* = object of TDrawable
  PPixmap* = ptr TPixmap
  TBitmap* = object of TDrawable
  PBitmap* = ptr TBitmap
  TInputCondition* = int32
  PInputCondition* = ptr TInputCondition
  TStatus* = int32
  PStatus* = ptr TStatus
  TPoint*{.final, pure.} = object
    x*: gint
    y*: gint

  PPoint* = ptr TPoint
  PPPoint* = ptr PPoint
  TSegment*{.final, pure.} = object
    x1*: gint
    y1*: gint
    x2*: gint
    y2*: gint

  PSegment* = ptr TSegment
  TRectangle*{.final, pure.} = object
    x*: gint
    y*: gint
    width*: gint
    height*: gint

  PRectangle* = ptr TRectangle
  TByteOrder* = enum
    LSB_FIRST, MSB_FIRST
  PByteOrder* = ptr TByteOrder
  TModifierType* = guint
  PModifierType* = ptr TModifierType
  TGrabStatus* = int
  PGrabStatus* = ptr TGrabStatus
  TSpan*{.final, pure.} = object
    x*: gint
    y*: gint
    width*: gint

  PSpan* = ptr TSpan
