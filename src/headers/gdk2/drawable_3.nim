# Included by headers/gdk2.nim; do not import directly.
proc bitmap_ref*(drawable: PDrawable): PDrawable =
  result = DRAWABLE(g_object_ref(G_OBJECT(drawable)))

proc bitmap_unref*(drawable: PDrawable) =
  g_object_unref(G_OBJECT(drawable))

proc pixmap_ref*(drawable: PDrawable): PDrawable =
  result = DRAWABLE(g_object_ref(G_OBJECT(drawable)))

proc pixmap_unref*(drawable: PDrawable) =
  g_object_unref(G_OBJECT(drawable))

