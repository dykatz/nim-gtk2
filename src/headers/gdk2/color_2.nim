# Included by headers/gdk2.nim; do not import directly.
proc COLORMAP*(anObject: pointer): PColormap =
  result = cast[PColormap](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_COLORMAP()))

proc COLORMAP_CLASS*(klass: pointer): PColormapClass =
  result = cast[PColormapClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_COLORMAP()))

proc IS_COLORMAP*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_COLORMAP())

proc IS_COLORMAP_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_COLORMAP())

proc COLORMAP_GET_CLASS*(obj: pointer): PColormapClass =
  result = cast[PColormapClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_COLORMAP()))

proc TYPE_COLOR*(): GType =
  result = gdk2.color_get_type()

