# Included by headers/gtk2.nim; do not import directly.
proc TYPE_STYLE*(): GType =
  result = style_get_type()

proc STYLE*(anObject: pointer): PStyle =
  result = cast[PStyle](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_STYLE()))

proc STYLE_CLASS*(klass: pointer): PStyleClass =
  result = cast[PStyleClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_STYLE()))

proc IS_STYLE*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_STYLE())

proc IS_STYLE_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_STYLE())

proc STYLE_GET_CLASS*(obj: pointer): PStyleClass =
  result = cast[PStyleClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_STYLE()))

proc TYPE_BORDER*(): GType =
  result = border_get_type()

proc STYLE_ATTACHED*(style: pointer): bool =
  result = ((STYLE(style)).attach_count) > 0'u32

proc apply_default_pixmap*(style: PStyle, window: gdk2.PWindow,
                                 state_type: TStateType, area: gdk2.PRectangle,
                                 x: gint, y: gint, width: gint, height: gint) =
  apply_default_background(style, window, true, state_type, area, x, y,
                           width, height)

