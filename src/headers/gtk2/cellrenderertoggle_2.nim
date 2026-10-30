# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_RENDERER_TOGGLE*(): GType =
  result = cell_renderer_toggle_get_type()

proc CELL_RENDERER_TOGGLE*(obj: pointer): PCellRendererToggle =
  result = cast[PCellRendererToggle](CHECK_CAST(obj, TYPE_CELL_RENDERER_TOGGLE()))

proc CELL_RENDERER_TOGGLE_CLASS*(klass: pointer): PCellRendererToggleClass =
  result = cast[PCellRendererToggleClass](CHECK_CLASS_CAST(klass,
      TYPE_CELL_RENDERER_TOGGLE()))

proc IS_CELL_RENDERER_TOGGLE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_CELL_RENDERER_TOGGLE())

proc IS_CELL_RENDERER_TOGGLE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_CELL_RENDERER_TOGGLE())

proc CELL_RENDERER_TOGGLE_GET_CLASS*(obj: pointer): PCellRendererToggleClass =
  result = cast[PCellRendererToggleClass](CHECK_GET_CLASS(obj,
      TYPE_CELL_RENDERER_TOGGLE()))

proc active*(a: PCellRendererToggle): guint =
  result = (a.CellRendererToggleflag0 and bm_TGtkCellRendererToggle_active) shr
      bp_TGtkCellRendererToggle_active

proc set_active*(a: PCellRendererToggle, `active`: guint) =
  a.CellRendererToggleflag0 = a.CellRendererToggleflag0 or
      (uint16(`active` shl bp_TGtkCellRendererToggle_active) and
      bm_TGtkCellRendererToggle_active)

proc activatable*(a: PCellRendererToggle): guint =
  result = (a.CellRendererToggleflag0 and
      bm_TGtkCellRendererToggle_activatable) shr
      bp_TGtkCellRendererToggle_activatable

proc set_activatable*(a: PCellRendererToggle, `activatable`: guint) =
  a.CellRendererToggleflag0 = a.CellRendererToggleflag0 or
      (uint16(`activatable` shl bp_TGtkCellRendererToggle_activatable) and
      bm_TGtkCellRendererToggle_activatable)

proc radio*(a: PCellRendererToggle): guint =
  result = (a.CellRendererToggleflag0 and bm_TGtkCellRendererToggle_radio) shr
      bp_TGtkCellRendererToggle_radio

proc set_radio*(a: PCellRendererToggle, `radio`: guint) =
  a.CellRendererToggleflag0 = a.CellRendererToggleflag0 or
      (uint16(`radio` shl bp_TGtkCellRendererToggle_radio) and
      bm_TGtkCellRendererToggle_radio)

