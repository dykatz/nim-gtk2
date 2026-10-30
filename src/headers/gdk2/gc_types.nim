# Included by headers/gdk2.nim; do not import directly.
type
  TFunction* = enum
    funcCOPY, funcINVERT, funcXOR, funcCLEAR, funcAND,
    funcAND_REVERSE, funcAND_INVERT, funcNOOP, funcOR, funcEQUIV,
    funcOR_REVERSE, funcCOPY_INVERT, funcOR_INVERT, funcNAND, funcNOR, funcSET
  PFunction* = ptr TFunction
  TCapStyle* = enum
    CAP_NOT_LAST, CAP_BUTT, CAP_ROUND, CAP_PROJECTING
  PCapStyle* = ptr TCapStyle
  TFill* = enum
    SOLID, TILED, STIPPLED, OPAQUE_STIPPLED
  PFill* = ptr TFill
  TJoinStyle* = enum
    JOIN_MITER, JOIN_ROUND, JOIN_BEVEL
  PJoinStyle* = ptr TJoinStyle
  TLineStyle* = enum
    LINE_SOLID, LINE_ON_OFF_DASH, LINE_DOUBLE_DASH
  PLineStyle* = ptr TLineStyle
  TSubwindowMode* = int
  PSubwindowMode* = ptr TSubwindowMode
  TGCValuesMask* = int32
  PGCValuesMask* = ptr TGCValuesMask
  TGCValues*{.final, pure.} = object
    foreground*: TColor
    background*: TColor
    font*: PFont
    `function`*: TFunction
    fill*: TFill
    tile*: PPixmap
    stipple*: PPixmap
    clip_mask*: PPixmap
    subwindow_mode*: TSubwindowMode
    ts_x_origin*: gint
    ts_y_origin*: gint
    clip_x_origin*: gint
    clip_y_origin*: gint
    graphics_exposures*: gint
    line_width*: gint
    line_style*: TLineStyle
    cap_style*: TCapStyle
    join_style*: TJoinStyle

  PGCValues* = ptr TGCValues
