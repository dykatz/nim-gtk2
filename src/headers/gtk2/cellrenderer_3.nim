# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_RENDERER*(): GType =
  result = cell_renderer_get_type()

proc CELL_RENDERER*(obj: pointer): PCellRenderer =
  result = cast[PCellRenderer](CHECK_CAST(obj, TYPE_CELL_RENDERER()))

proc CELL_RENDERER_CLASS*(klass: pointer): PCellRendererClass =
  result = cast[PCellRendererClass](CHECK_CLASS_CAST(klass, TYPE_CELL_RENDERER()))

proc IS_CELL_RENDERER*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_CELL_RENDERER())

proc IS_CELL_RENDERER_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_CELL_RENDERER())

proc CELL_RENDERER_GET_CLASS*(obj: pointer): PCellRendererClass =
  result = cast[PCellRendererClass](CHECK_GET_CLASS(obj, TYPE_CELL_RENDERER()))

proc mode*(a: PCellRenderer): guint =
  result = (a.CellRendererflag0 and bm_TGtkCellRenderer_mode) shr
      bp_TGtkCellRenderer_mode

proc set_mode*(a: PCellRenderer, `mode`: guint) =
  a.CellRendererflag0 = a.CellRendererflag0 or
      (uint16(`mode` shl bp_TGtkCellRenderer_mode) and
      bm_TGtkCellRenderer_mode)

proc visible*(a: PCellRenderer): guint =
  result = (a.CellRendererflag0 and bm_TGtkCellRenderer_visible) shr
      bp_TGtkCellRenderer_visible

proc set_visible*(a: PCellRenderer, `visible`: guint) =
  a.CellRendererflag0 = a.CellRendererflag0 or
      (uint16(`visible` shl bp_TGtkCellRenderer_visible) and
      bm_TGtkCellRenderer_visible)

proc is_expander*(a: PCellRenderer): guint =
  result = (a.CellRendererflag0 and bm_TGtkCellRenderer_is_expander) shr
      bp_TGtkCellRenderer_is_expander

proc set_is_expander*(a: PCellRenderer, `is_expander`: guint) =
  a.CellRendererflag0 = a.CellRendererflag0 or
      (uint16(`is_expander` shl bp_TGtkCellRenderer_is_expander) and
      bm_TGtkCellRenderer_is_expander)

proc is_expanded*(a: PCellRenderer): guint =
  result = (a.CellRendererflag0 and bm_TGtkCellRenderer_is_expanded) shr
      bp_TGtkCellRenderer_is_expanded

proc set_is_expanded*(a: PCellRenderer, `is_expanded`: guint) =
  a.CellRendererflag0 = a.CellRendererflag0 or
      (uint16(`is_expanded` shl bp_TGtkCellRenderer_is_expanded) and
      bm_TGtkCellRenderer_is_expanded)

proc cell_background_set*(a: PCellRenderer): guint =
  result = (a.CellRendererflag0 and bm_TGtkCellRenderer_cell_background_set) shr
      bp_TGtkCellRenderer_cell_background_set

proc set_cell_background_set*(a: PCellRenderer, `cell_background_set`: guint) =
  a.CellRendererflag0 = a.CellRendererflag0 or
      (uint16(`cell_background_set` shl
      bp_TGtkCellRenderer_cell_background_set) and
      bm_TGtkCellRenderer_cell_background_set)

