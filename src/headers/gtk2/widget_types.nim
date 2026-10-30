# Included by headers/gtk2.nim; do not import directly.
type
  TWidgetFlags* = uint32
  PWidgetFlags* = ptr TWidgetFlags
  TWidgetHelpType* = enum
    WIDGET_HELP_TOOLTIP, WIDGET_HELP_WHATS_THIS
  PWidgetHelpType* = ptr TWidgetHelpType
  TRequisition*{.final, pure.} = object
    width*: gint
    height*: gint

  PRequisition* = ptr TRequisition
  TWidgetAuxInfo*{.final, pure.} = object
    x*: gint
    y*: gint
    width*: gint
    height*: gint
    flag0*: guint16

  PWidgetAuxInfo* = ptr TWidgetAuxInfo
  TWidgetShapeInfo*{.final, pure.} = object
    offset_x*: gint16
    offset_y*: gint16
    shape_mask*: gdk2.PBitmap

  PWidgetShapeInfo* = ptr TWidgetShapeInfo
  PClipboard* = pointer
