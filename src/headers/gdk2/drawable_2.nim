# Included by headers/gdk2.nim; do not import directly.
proc TYPE_DRAWABLE*(): GType =
  result = drawable_get_type()

proc DRAWABLE*(anObject: pointer): PDrawable =
  result = cast[PDrawable](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_DRAWABLE()))

proc DRAWABLE_CLASS*(klass: pointer): PDrawableClass =
  result = cast[PDrawableClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_DRAWABLE()))

proc IS_DRAWABLE*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_DRAWABLE())

proc IS_DRAWABLE_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_DRAWABLE())

proc DRAWABLE_GET_CLASS*(obj: pointer): PDrawableClass =
  result = cast[PDrawableClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_DRAWABLE()))

proc pixmap*(drawable: PDrawable, gc: PGC, src: PDrawable, xsrc: gint,
                  ysrc: gint, xdest: gint, ydest: gint, width: gint,
                  height: gint) =
  drawable(drawable, gc, src, xsrc, ysrc, xdest, ydest, width, height)

proc bitmap*(drawable: PDrawable, gc: PGC, src: PDrawable, xsrc: gint,
                  ysrc: gint, xdest: gint, ydest: gint, width: gint,
                  height: gint) =
  drawable(drawable, gc, src, xsrc, ysrc, xdest, ydest, width, height)

proc TYPE_EVENT*(): GType =
  result = event_get_type()

