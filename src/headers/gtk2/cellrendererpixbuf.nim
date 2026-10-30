# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_RENDERER_PIXBUF*(): GType
proc CELL_RENDERER_PIXBUF*(obj: pointer): PCellRendererPixbuf
proc CELL_RENDERER_PIXBUF_CLASS*(klass: pointer): PCellRendererPixbufClass
proc IS_CELL_RENDERER_PIXBUF*(obj: pointer): bool
proc IS_CELL_RENDERER_PIXBUF_CLASS*(klass: pointer): bool
proc CELL_RENDERER_PIXBUF_GET_CLASS*(obj: pointer): PCellRendererPixbufClass
proc cell_renderer_pixbuf_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_pixbuf_get_type".}
proc cell_renderer_pixbuf_new*(): PCellRenderer{.cdecl, dynlib: lib,
    importc: "gtk_cell_renderer_pixbuf_new".}
