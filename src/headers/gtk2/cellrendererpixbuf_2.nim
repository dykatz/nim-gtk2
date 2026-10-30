# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_RENDERER_PIXBUF*(): GType =
  result = cell_renderer_pixbuf_get_type()

proc CELL_RENDERER_PIXBUF*(obj: pointer): PCellRendererPixbuf =
  result = cast[PCellRendererPixbuf](CHECK_CAST(obj, TYPE_CELL_RENDERER_PIXBUF()))

proc CELL_RENDERER_PIXBUF_CLASS*(klass: pointer): PCellRendererPixbufClass =
  result = cast[PCellRendererPixbufClass](CHECK_CLASS_CAST(klass,
      TYPE_CELL_RENDERER_PIXBUF()))

proc IS_CELL_RENDERER_PIXBUF*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_CELL_RENDERER_PIXBUF())

proc IS_CELL_RENDERER_PIXBUF_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_CELL_RENDERER_PIXBUF())

proc CELL_RENDERER_PIXBUF_GET_CLASS*(obj: pointer): PCellRendererPixbufClass =
  result = cast[PCellRendererPixbufClass](CHECK_GET_CLASS(obj,
      TYPE_CELL_RENDERER_PIXBUF()))

