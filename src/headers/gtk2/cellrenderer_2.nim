# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_RENDERER*(): GType
proc CELL_RENDERER*(obj: pointer): PCellRenderer
proc CELL_RENDERER_CLASS*(klass: pointer): PCellRendererClass
proc IS_CELL_RENDERER*(obj: pointer): bool
proc IS_CELL_RENDERER_CLASS*(klass: pointer): bool
proc CELL_RENDERER_GET_CLASS*(obj: pointer): PCellRendererClass
proc mode*(a: PCellRenderer): guint
proc set_mode*(a: PCellRenderer, `mode`: guint)
proc visible*(a: PCellRenderer): guint
proc set_visible*(a: PCellRenderer, `visible`: guint)
proc is_expander*(a: PCellRenderer): guint
proc set_is_expander*(a: PCellRenderer, `is_expander`: guint)
proc is_expanded*(a: PCellRenderer): guint
proc set_is_expanded*(a: PCellRenderer, `is_expanded`: guint)
proc cell_background_set*(a: PCellRenderer): guint
proc set_cell_background_set*(a: PCellRenderer, `cell_background_set`: guint)
proc cell_renderer_get_type*(): GType{.cdecl, dynlib: lib,
                                       importc: "gtk_cell_renderer_get_type".}
proc get_size*(cell: PCellRenderer, widget: PWidget,
                             cell_area: gdk2.PRectangle, x_offset: Pgint,
                             y_offset: Pgint, width: Pgint, height: Pgint){.
    cdecl, dynlib: lib, importc: "gtk_cell_renderer_get_size".}
proc render*(cell: PCellRenderer, window: gdk2.PWindow,
                           widget: PWidget, background_area: gdk2.PRectangle,
                           cell_area: gdk2.PRectangle, expose_area: gdk2.PRectangle,
                           flags: TCellRendererState){.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_render".}
proc activate*(cell: PCellRenderer, event: gdk2.PEvent,
                             widget: PWidget, path: cstring,
                             background_area: gdk2.PRectangle,
                             cell_area: gdk2.PRectangle, flags: TCellRendererState): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_cell_renderer_activate".}
proc start_editing*(cell: PCellRenderer, event: gdk2.PEvent,
                                  widget: PWidget, path: cstring,
                                  background_area: gdk2.PRectangle,
                                  cell_area: gdk2.PRectangle,
                                  flags: TCellRendererState): PCellEditable{.
    cdecl, dynlib: lib, importc: "gtk_cell_renderer_start_editing".}
proc set_fixed_size*(cell: PCellRenderer, width: gint,
                                   height: gint){.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_set_fixed_size".}
proc get_fixed_size*(cell: PCellRenderer, width: Pgint,
                                   height: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_get_fixed_size".}
const
  bm_TGtkCellRendererText_strikethrough* = 0x0001'u16
const
  bp_TGtkCellRendererText_strikethrough* = 0'u16
const
  bm_TGtkCellRendererText_editable* = 0x0002'u16
const
  bp_TGtkCellRendererText_editable* = 1'u16
const
  bm_TGtkCellRendererText_scale_set* = 0x0004'u16
const
  bp_TGtkCellRendererText_scale_set* = 2'u16
const
  bm_TGtkCellRendererText_foreground_set* = 0x0008'u16
const
  bp_TGtkCellRendererText_foreground_set* = 3'u16
const
  bm_TGtkCellRendererText_background_set* = 0x0010'u16
const
  bp_TGtkCellRendererText_background_set* = 4'u16
const
  bm_TGtkCellRendererText_underline_set* = 0x0020'u16
const
  bp_TGtkCellRendererText_underline_set* = 5'u16
const
  bm_TGtkCellRendererText_rise_set* = 0x0040'u16
const
  bp_TGtkCellRendererText_rise_set* = 6'u16
const
  bm_TGtkCellRendererText_strikethrough_set* = 0x0080'u16
const
  bp_TGtkCellRendererText_strikethrough_set* = 7'u16
const
  bm_TGtkCellRendererText_editable_set* = 0x0100'u16
const
  bp_TGtkCellRendererText_editable_set* = 8'u16
const
  bm_TGtkCellRendererText_calc_fixed_height* = 0x0200'u16
const
  bp_TGtkCellRendererText_calc_fixed_height* = 9'u16

