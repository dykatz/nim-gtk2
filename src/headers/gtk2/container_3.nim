# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CONTAINER*(): GType =
  result = container_get_type()

proc CONTAINER*(obj: pointer): PContainer =
  result = cast[PContainer](CHECK_CAST(obj, TYPE_CONTAINER()))

proc CONTAINER_CLASS*(klass: pointer): PContainerClass =
  result = cast[PContainerClass](CHECK_CLASS_CAST(klass, TYPE_CONTAINER()))

proc IS_CONTAINER*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_CONTAINER())

proc IS_CONTAINER_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_CONTAINER())

proc CONTAINER_GET_CLASS*(obj: pointer): PContainerClass =
  result = cast[PContainerClass](CHECK_GET_CLASS(obj, TYPE_CONTAINER()))

proc IS_RESIZE_CONTAINER*(widget: pointer): bool =
  result = (IS_CONTAINER(widget)) and
      ((resize_mode(cast[PContainer](widget))) != uint32(RESIZE_PARENT))

proc border_width*(a: PContainer): guint =
  result = (a.Container_flag0 and bm_TGtkContainer_border_width) shr
      bp_TGtkContainer_border_width

proc need_resize*(a: PContainer): guint =
  result = (a.Container_flag0 and bm_TGtkContainer_need_resize) shr
      bp_TGtkContainer_need_resize

proc set_need_resize*(a: PContainer, `need_resize`: guint) =
  a.Container_flag0 = a.Container_flag0 or
      ((`need_resize` shl bp_TGtkContainer_need_resize) and
      bm_TGtkContainer_need_resize)

proc resize_mode*(a: PContainer): guint =
  result = (a.Container_flag0 and bm_TGtkContainer_resize_mode) shr
      bp_TGtkContainer_resize_mode

