# Included by headers/gtk2.nim; do not import directly.
proc TYPE_WIDGET*(): GType =
  result = widget_get_type()

proc WIDGET*(widget: pointer): PWidget =
  result = cast[PWidget](CHECK_CAST(widget, TYPE_WIDGET()))

proc WIDGET_CLASS*(klass: pointer): PWidgetClass =
  result = cast[PWidgetClass](CHECK_CLASS_CAST(klass, TYPE_WIDGET()))

proc IS_WIDGET*(widget: pointer): bool =
  result = CHECK_TYPE(widget, TYPE_WIDGET())

proc IS_WIDGET_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_WIDGET())

proc WIDGET_GET_CLASS*(obj: pointer): PWidgetClass =
  result = cast[PWidgetClass](CHECK_GET_CLASS(obj, TYPE_WIDGET()))

proc WIDGET_TYPE*(wid: pointer): GType =
  result = OBJECT_TYPE(wid)

proc WIDGET_STATE*(wid: pointer): uint32 =
  result = (WIDGET(wid)).state

proc WIDGET_SAVED_STATE*(wid: pointer): uint32 =
  result = (WIDGET(wid)).saved_state

proc WIDGET_FLAGS*(wid: pointer): guint32 =
  result = OBJECT_FLAGS(wid)

proc WIDGET_TOPLEVEL*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(TOPLEVEL)) != 0'u32

proc WIDGET_NO_WINDOW*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(NO_WINDOW)) != 0'u32

proc WIDGET_REALIZED*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(constREALIZED)) != 0'u32

proc WIDGET_MAPPED*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(MAPPED)) != 0'u32

proc WIDGET_VISIBLE*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(constVISIBLE)) != 0'u32

proc WIDGET_DRAWABLE*(wid: pointer): gboolean =
  result = (WIDGET_VISIBLE(wid)) and (WIDGET_MAPPED(wid))

proc WIDGET_SENSITIVE*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(SENSITIVE)) != 0'u32

proc WIDGET_PARENT_SENSITIVE*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(PARENT_SENSITIVE)) != 0'u32

proc WIDGET_IS_SENSITIVE*(wid: pointer): gboolean =
  result = (WIDGET_SENSITIVE(wid)) and (WIDGET_PARENT_SENSITIVE(wid))

proc WIDGET_CAN_FOCUS*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(CAN_FOCUS)) != 0'u32

proc WIDGET_HAS_FOCUS*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(constHAS_FOCUS)) != 0'u32

proc WIDGET_CAN_DEFAULT*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(CAN_DEFAULT)) != 0'u32

proc WIDGET_HAS_DEFAULT*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(HAS_DEFAULT)) != 0'u32

proc WIDGET_HAS_GRAB*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(HAS_GRAB)) != 0'u32

proc WIDGET_RC_STYLE*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(RC_STYLE)) != 0'u32

proc WIDGET_COMPOSITE_CHILD*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(COMPOSITE_CHILD)) != 0'u32

proc WIDGET_APP_PAINTABLE*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(APP_PAINTABLE)) != 0'u32

proc WIDGET_RECEIVES_DEFAULT*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(RECEIVES_DEFAULT)) != 0'u32

proc WIDGET_DOUBLE_BUFFERED*(wid: pointer): gboolean =
  result = ((WIDGET_FLAGS(wid)) and uint32(DOUBLE_BUFFERED)) != 0'u32

proc TYPE_REQUISITION*(): GType =
  result = requisition_get_type()

proc x_set*(a: PWidgetAuxInfo): guint =
  result = (a.flag0 and bm_TGtkWidgetAuxInfo_x_set) shr
      bp_TGtkWidgetAuxInfo_x_set

proc set_x_set*(a: PWidgetAuxInfo, `x_set`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`x_set` shl bp_TGtkWidgetAuxInfo_x_set) and
      bm_TGtkWidgetAuxInfo_x_set)

proc y_set*(a: PWidgetAuxInfo): guint =
  result = ((a.flag0 and bm_TGtkWidgetAuxInfo_y_set) shr
      bp_TGtkWidgetAuxInfo_y_set).guint

proc set_y_set*(a: PWidgetAuxInfo, `y_set`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`y_set` shl bp_TGtkWidgetAuxInfo_y_set) and
      bm_TGtkWidgetAuxInfo_y_set)

proc widget_set_visual*(widget, visual: pointer) =
  if (widget != nil) and (visual != nil): discard

proc widget_push_visual*(visual: pointer) =
  if (visual != nil): discard

proc widget_pop_visual*() =
  discard

proc widget_set_default_visual*(visual: pointer) =
  if (visual != nil): discard

proc widget_set_rc_style*(widget: pointer) =
  set_style(cast[PWidget](widget), nil)

proc widget_restore_default_style*(widget: pointer) =
  set_style(cast[PWidget](widget), nil)

proc SET_FLAGS*(wid: PWidget, flags: TWidgetFlags): TWidgetFlags =
  cast[PObject](wid).flags = cast[PObject](wid).flags or (flags)
  result = cast[PObject](wid).flags

proc UNSET_FLAGS*(wid: PWidget, flags: TWidgetFlags): TWidgetFlags =
  cast[PObject](wid).flags = cast[PObject](wid).flags and (not (flags))
  result = cast[PObject](wid).flags

