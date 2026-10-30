# Included by headers/gdk2.nim; do not import directly.
proc window_get_colormap*(drawable: PDrawable): PColormap =
  result = get_colormap(drawable)

proc window_set_colormap*(drawable: PDrawable, colormap: PColormap) =
  set_colormap(drawable, colormap)

proc window_get_visual*(drawable: PDrawable): PVisual =
  result = get_visual(drawable)

proc window_ref*(drawable: PDrawable): PDrawable =
  result = DRAWABLE(g_object_ref(G_OBJECT(drawable)))

proc window_unref*(drawable: PDrawable) =
  g_object_unref(G_OBJECT(drawable))

proc window_copy_area*(drawable: PDrawable, gc: PGC, x, y: gint,
                       source_drawable: PDrawable, source_x, source_y: gint,
                       width, height: gint) =
  pixmap(drawable, gc, source_drawable, source_x, source_y, x, y, width,
         height)
