# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HANDLE_BOX*(): GType =
  result = handle_box_get_type()

proc HANDLE_BOX*(obj: pointer): PHandleBox =
  result = cast[PHandleBox](CHECK_CAST(obj, TYPE_HANDLE_BOX()))

proc HANDLE_BOX_CLASS*(klass: pointer): PHandleBoxClass =
  result = cast[PHandleBoxClass](CHECK_CLASS_CAST(klass, TYPE_HANDLE_BOX()))

proc IS_HANDLE_BOX*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_HANDLE_BOX())

proc IS_HANDLE_BOX_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_HANDLE_BOX())

proc HANDLE_BOX_GET_CLASS*(obj: pointer): PHandleBoxClass =
  result = cast[PHandleBoxClass](CHECK_GET_CLASS(obj, TYPE_HANDLE_BOX()))

proc handle_position*(a: PHandleBox): guint =
  result = (a.Handlebox_flag0 and bm_TGtkHandleBox_handle_position) shr
      bp_TGtkHandleBox_handle_position

