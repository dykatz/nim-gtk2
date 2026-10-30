# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_RENDERER_TOGGLE*(): GType
proc CELL_RENDERER_TOGGLE*(obj: pointer): PCellRendererToggle
proc CELL_RENDERER_TOGGLE_CLASS*(klass: pointer): PCellRendererToggleClass
proc IS_CELL_RENDERER_TOGGLE*(obj: pointer): bool
proc IS_CELL_RENDERER_TOGGLE_CLASS*(klass: pointer): bool
proc CELL_RENDERER_TOGGLE_GET_CLASS*(obj: pointer): PCellRendererToggleClass
proc active*(a: PCellRendererToggle): guint
proc set_active*(a: PCellRendererToggle, `active`: guint)
proc activatable*(a: PCellRendererToggle): guint
proc set_activatable*(a: PCellRendererToggle, `activatable`: guint)
proc radio*(a: PCellRendererToggle): guint
proc set_radio*(a: PCellRendererToggle, `radio`: guint)
proc cell_renderer_toggle_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_toggle_get_type".}
proc cell_renderer_toggle_new*(): PCellRenderer{.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_toggle_new".}
proc toggle_get_radio*(toggle: PCellRendererToggle): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_cell_renderer_toggle_get_radio".}
proc toggle_set_radio*(toggle: PCellRendererToggle,
                                     radio: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_toggle_set_radio".}
proc toggle_get_active*(toggle: PCellRendererToggle): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_cell_renderer_toggle_get_active".}
proc toggle_set_active*(toggle: PCellRendererToggle,
                                      setting: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_toggle_set_active".}
