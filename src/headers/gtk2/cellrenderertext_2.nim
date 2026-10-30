# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_RENDERER_TEXT*(): GType =
  result = cell_renderer_text_get_type()

proc CELL_RENDERER_TEXT*(obj: pointer): PCellRendererText =
  result = cast[PCellRendererText](CHECK_CAST(obj, TYPE_CELL_RENDERER_TEXT()))

proc CELL_RENDERER_TEXT_CLASS*(klass: pointer): PCellRendererTextClass =
  result = cast[PCellRendererTextClass](CHECK_CLASS_CAST(klass,
      TYPE_CELL_RENDERER_TEXT()))

proc IS_CELL_RENDERER_TEXT*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_CELL_RENDERER_TEXT())

proc IS_CELL_RENDERER_TEXT_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_CELL_RENDERER_TEXT())

proc CELL_RENDERER_TEXT_GET_CLASS*(obj: pointer): PCellRendererTextClass =
  result = cast[PCellRendererTextClass](CHECK_GET_CLASS(obj,
      TYPE_CELL_RENDERER_TEXT()))

proc strikethrough*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and bm_TGtkCellRendererText_strikethrough) shr
      bp_TGtkCellRendererText_strikethrough

proc set_strikethrough*(a: PCellRendererText, `strikethrough`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`strikethrough` shl bp_TGtkCellRendererText_strikethrough) and
      bm_TGtkCellRendererText_strikethrough)

proc editable*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and bm_TGtkCellRendererText_editable) shr
      bp_TGtkCellRendererText_editable

proc set_editable*(a: PCellRendererText, `editable`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`editable` shl bp_TGtkCellRendererText_editable) and
      bm_TGtkCellRendererText_editable)

proc scale_set*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and bm_TGtkCellRendererText_scale_set) shr
      bp_TGtkCellRendererText_scale_set

proc set_scale_set*(a: PCellRendererText, `scale_set`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`scale_set` shl bp_TGtkCellRendererText_scale_set) and
      bm_TGtkCellRendererText_scale_set)

proc foreground_set*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and
      bm_TGtkCellRendererText_foreground_set) shr
      bp_TGtkCellRendererText_foreground_set

proc set_foreground_set*(a: PCellRendererText, `foreground_set`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`foreground_set` shl bp_TGtkCellRendererText_foreground_set) and
      bm_TGtkCellRendererText_foreground_set)

proc background_set*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and
      bm_TGtkCellRendererText_background_set) shr
      bp_TGtkCellRendererText_background_set

proc set_background_set*(a: PCellRendererText, `background_set`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`background_set` shl bp_TGtkCellRendererText_background_set) and
      bm_TGtkCellRendererText_background_set)

proc underline_set*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and bm_TGtkCellRendererText_underline_set) shr
      bp_TGtkCellRendererText_underline_set

proc set_underline_set*(a: PCellRendererText, `underline_set`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`underline_set` shl bp_TGtkCellRendererText_underline_set) and
      bm_TGtkCellRendererText_underline_set)

proc rise_set*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and bm_TGtkCellRendererText_rise_set) shr
      bp_TGtkCellRendererText_rise_set

proc set_rise_set*(a: PCellRendererText, `rise_set`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`rise_set` shl bp_TGtkCellRendererText_rise_set) and
      bm_TGtkCellRendererText_rise_set)

proc strikethrough_set*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and
      bm_TGtkCellRendererText_strikethrough_set) shr
      bp_TGtkCellRendererText_strikethrough_set

proc set_strikethrough_set*(a: PCellRendererText, `strikethrough_set`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`strikethrough_set` shl
      bp_TGtkCellRendererText_strikethrough_set) and
      bm_TGtkCellRendererText_strikethrough_set)

proc editable_set*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and bm_TGtkCellRendererText_editable_set) shr
      bp_TGtkCellRendererText_editable_set

proc set_editable_set*(a: PCellRendererText, `editable_set`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`editable_set` shl bp_TGtkCellRendererText_editable_set) and
      bm_TGtkCellRendererText_editable_set)

proc calc_fixed_height*(a: PCellRendererText): guint =
  result = (a.CellRendererTextflag0 and
      bm_TGtkCellRendererText_calc_fixed_height) shr
      bp_TGtkCellRendererText_calc_fixed_height

proc set_calc_fixed_height*(a: PCellRendererText, `calc_fixed_height`: guint) =
  a.CellRendererTextflag0 = a.CellRendererTextflag0 or
      (uint16(`calc_fixed_height` shl
      bp_TGtkCellRendererText_calc_fixed_height) and
      bm_TGtkCellRendererText_calc_fixed_height)

