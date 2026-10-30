# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SCALE*(): GType =
  result = scale_get_type()

proc SCALE*(obj: pointer): PScale =
  result = cast[PScale](CHECK_CAST(obj, TYPE_SCALE()))

proc SCALE_CLASS*(klass: pointer): PScaleClass =
  result = cast[PScaleClass](CHECK_CLASS_CAST(klass, TYPE_SCALE()))

proc IS_SCALE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_SCALE())

proc IS_SCALE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_SCALE())

proc SCALE_GET_CLASS*(obj: pointer): PScaleClass =
  result = cast[PScaleClass](CHECK_GET_CLASS(obj, TYPE_SCALE()))

proc draw_value*(a: PScale): guint =
  result = (a.Scaleflag0 and bm_TGtkScale_draw_value) shr
      bp_TGtkScale_draw_value

proc set_draw_value*(a: PScale, `draw_value`: guint) =
  a.Scaleflag0 = a.Scaleflag0 or
      (uint16(`draw_value` shl bp_TGtkScale_draw_value) and
      bm_TGtkScale_draw_value)

proc value_pos*(a: PScale): guint =
  result = (a.Scaleflag0 and bm_TGtkScale_value_pos) shr
      bp_TGtkScale_value_pos

