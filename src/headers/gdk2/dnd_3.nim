# Included by headers/gdk2.nim; do not import directly.
proc DRAG_CONTEXT*(anObject: pointer): PDragContext =
  result = cast[PDragContext](G_TYPE_CHECK_INSTANCE_CAST(anObject,
      TYPE_DRAG_CONTEXT()))

proc DRAG_CONTEXT_CLASS*(klass: pointer): PDragContextClass =
  result = cast[PDragContextClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_DRAG_CONTEXT()))

proc IS_DRAG_CONTEXT*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_DRAG_CONTEXT())

proc IS_DRAG_CONTEXT_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_DRAG_CONTEXT())

proc DRAG_CONTEXT_GET_CLASS*(obj: pointer): PDragContextClass =
  result = cast[PDragContextClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_DRAG_CONTEXT()))

proc region_EXTENTCHECK*(r1, r2: PRegionBox): bool =
  result = ((r1.x2) > r2.x1) and ((r1.x1) < r2.x2) and ((r1.y2) > r2.y1) and
      ((r1.y1) < r2.y2)

