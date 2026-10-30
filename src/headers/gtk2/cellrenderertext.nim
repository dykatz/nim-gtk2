# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_RENDERER_TEXT*(): GType
proc CELL_RENDERER_TEXT*(obj: pointer): PCellRendererText
proc CELL_RENDERER_TEXT_CLASS*(klass: pointer): PCellRendererTextClass
proc IS_CELL_RENDERER_TEXT*(obj: pointer): bool
proc IS_CELL_RENDERER_TEXT_CLASS*(klass: pointer): bool
proc CELL_RENDERER_TEXT_GET_CLASS*(obj: pointer): PCellRendererTextClass
proc strikethrough*(a: PCellRendererText): guint
proc set_strikethrough*(a: PCellRendererText, `strikethrough`: guint)
proc editable*(a: PCellRendererText): guint
proc set_editable*(a: PCellRendererText, `editable`: guint)
proc scale_set*(a: PCellRendererText): guint
proc set_scale_set*(a: PCellRendererText, `scale_set`: guint)
proc foreground_set*(a: PCellRendererText): guint
proc set_foreground_set*(a: PCellRendererText, `foreground_set`: guint)
proc background_set*(a: PCellRendererText): guint
proc set_background_set*(a: PCellRendererText, `background_set`: guint)
proc underline_set*(a: PCellRendererText): guint
proc set_underline_set*(a: PCellRendererText, `underline_set`: guint)
proc rise_set*(a: PCellRendererText): guint
proc set_rise_set*(a: PCellRendererText, `rise_set`: guint)
proc strikethrough_set*(a: PCellRendererText): guint
proc set_strikethrough_set*(a: PCellRendererText, `strikethrough_set`: guint)
proc editable_set*(a: PCellRendererText): guint
proc set_editable_set*(a: PCellRendererText, `editable_set`: guint)
proc calc_fixed_height*(a: PCellRendererText): guint
proc set_calc_fixed_height*(a: PCellRendererText, `calc_fixed_height`: guint)
proc cell_renderer_text_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_text_get_type".}
proc cell_renderer_text_new*(): PCellRenderer{.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_text_new".}
proc text_set_fixed_height_from_font*(renderer: PCellRendererText,
    number_of_rows: gint){.cdecl, dynlib: lib, importc: "gtk_cell_renderer_text_set_fixed_height_from_font".}
const
  bm_TGtkCellRendererToggle_active* = 0x0001'u16
const
  bp_TGtkCellRendererToggle_active* = 0'u16
const
  bm_TGtkCellRendererToggle_activatable* = 0x0002'u16
const
  bp_TGtkCellRendererToggle_activatable* = 1'u16
const
  bm_TGtkCellRendererToggle_radio* = 0x0004'u16
const
  bp_TGtkCellRendererToggle_radio* = 2'u16

