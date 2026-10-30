# Included by headers/gtk2.nim; do not import directly.
proc TYPE_WINDOW*(): GType =
  result = window_get_type()

proc WINDOW*(obj: pointer): PWindow =
  result = cast[PWindow](CHECK_CAST(obj, gtk2.TYPE_WINDOW()))

proc WINDOW_CLASS*(klass: pointer): PWindowClass =
  result = cast[PWindowClass](CHECK_CLASS_CAST(klass, gtk2.TYPE_WINDOW()))

proc IS_WINDOW*(obj: pointer): bool =
  result = CHECK_TYPE(obj, gtk2.TYPE_WINDOW())

proc IS_WINDOW_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, gtk2.TYPE_WINDOW())

proc WINDOW_GET_CLASS*(obj: pointer): PWindowClass =
  result = cast[PWindowClass](CHECK_GET_CLASS(obj, gtk2.TYPE_WINDOW()))

proc allow_shrink*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_allow_shrink) shr
      bp_TGtkWindow_allow_shrink

proc set_allow_shrink*(a: gtk2.PWindow, `allow_shrink`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`allow_shrink` shl bp_TGtkWindow_allow_shrink) and
      bm_TGtkWindow_allow_shrink)

proc allow_grow*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_allow_grow) shr
      bp_TGtkWindow_allow_grow

proc set_allow_grow*(a: gtk2.PWindow, `allow_grow`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`allow_grow` shl bp_TGtkWindow_allow_grow) and
      bm_TGtkWindow_allow_grow)

proc configure_notify_received*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_configure_notify_received) shr
      bp_TGtkWindow_configure_notify_received

proc set_configure_notify_received*(a: gtk2.PWindow,
                                    `configure_notify_received`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`configure_notify_received` shl
      bp_TGtkWindow_configure_notify_received) and
      bm_TGtkWindow_configure_notify_received)

proc need_default_position*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_need_default_position) shr
      bp_TGtkWindow_need_default_position

proc set_need_default_position*(a: gtk2.PWindow, `need_default_position`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`need_default_position` shl bp_TGtkWindow_need_default_position) and
      bm_TGtkWindow_need_default_position)

proc need_default_size*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_need_default_size) shr
      bp_TGtkWindow_need_default_size

proc set_need_default_size*(a: gtk2.PWindow, `need_default_size`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`need_default_size` shl bp_TGtkWindow_need_default_size) and
      bm_TGtkWindow_need_default_size)

proc position*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_position) shr
      bp_TGtkWindow_position

proc get_type*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_type) shr bp_TGtkWindow_type

proc set_type*(a: gtk2.PWindow, `type`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`type` shl bp_TGtkWindow_type) and bm_TGtkWindow_type)

proc has_user_ref_count*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_has_user_ref_count) shr
      bp_TGtkWindow_has_user_ref_count

proc set_has_user_ref_count*(a: gtk2.PWindow, `has_user_ref_count`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`has_user_ref_count` shl bp_TGtkWindow_has_user_ref_count) and
      bm_TGtkWindow_has_user_ref_count)

proc has_focus*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_has_focus) shr
      bp_TGtkWindow_has_focus

proc set_has_focus*(a: gtk2.PWindow, `has_focus`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`has_focus` shl bp_TGtkWindow_has_focus) and bm_TGtkWindow_has_focus)

proc modal*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_modal) shr bp_TGtkWindow_modal

proc set_modal*(a: gtk2.PWindow, `modal`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`modal` shl bp_TGtkWindow_modal) and bm_TGtkWindow_modal)

proc destroy_with_parent*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_destroy_with_parent) shr
      bp_TGtkWindow_destroy_with_parent

proc set_destroy_with_parent*(a: gtk2.PWindow, `destroy_with_parent`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`destroy_with_parent` shl bp_TGtkWindow_destroy_with_parent) and
      bm_TGtkWindow_destroy_with_parent)

proc has_frame*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_has_frame) shr
      bp_TGtkWindow_has_frame

proc set_has_frame*(a: gtk2.PWindow, `has_frame`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`has_frame` shl bp_TGtkWindow_has_frame) and bm_TGtkWindow_has_frame)

proc iconify_initially*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_iconify_initially) shr
      bp_TGtkWindow_iconify_initially

proc set_iconify_initially*(a: gtk2.PWindow, `iconify_initially`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`iconify_initially` shl bp_TGtkWindow_iconify_initially) and
      bm_TGtkWindow_iconify_initially)

proc stick_initially*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_stick_initially) shr
      bp_TGtkWindow_stick_initially

proc set_stick_initially*(a: gtk2.PWindow, `stick_initially`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`stick_initially` shl bp_TGtkWindow_stick_initially) and
      bm_TGtkWindow_stick_initially)

proc maximize_initially*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_maximize_initially) shr
      bp_TGtkWindow_maximize_initially

proc set_maximize_initially*(a: gtk2.PWindow, `maximize_initially`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`maximize_initially` shl bp_TGtkWindow_maximize_initially) and
      bm_TGtkWindow_maximize_initially)

proc decorated*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_decorated) shr
      bp_TGtkWindow_decorated

proc set_decorated*(a: gtk2.PWindow, `decorated`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`decorated` shl bp_TGtkWindow_decorated) and bm_TGtkWindow_decorated)

proc type_hint*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_type_hint) shr
      bp_TGtkWindow_type_hint

proc set_type_hint*(a: gtk2.PWindow, `type_hint`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`type_hint` shl bp_TGtkWindow_type_hint) and bm_TGtkWindow_type_hint)

proc gravity*(a: gtk2.PWindow): guint =
  result = (a.window_flag0 and bm_TGtkWindow_gravity) shr
      bp_TGtkWindow_gravity

proc set_gravity*(a: gtk2.PWindow, `gravity`: guint) =
  a.window_flag0 = a.window_flag0 or
      ((`gravity` shl bp_TGtkWindow_gravity) and bm_TGtkWindow_gravity)

proc TYPE_WINDOW_GROUP*(): GType =
  result = window_group_get_type()

proc WINDOW_GROUP*(anObject: pointer): PWindowGroup =
  result = cast[PWindowGroup](G_TYPE_CHECK_INSTANCE_CAST(anObject,
      TYPE_WINDOW_GROUP()))

proc WINDOW_GROUP_CLASS*(klass: pointer): PWindowGroupClass =
  result = cast[PWindowGroupClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_WINDOW_GROUP()))

proc IS_WINDOW_GROUP*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_WINDOW_GROUP())

proc IS_WINDOW_GROUP_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_WINDOW_GROUP())

proc WINDOW_GROUP_GET_CLASS*(obj: pointer): PWindowGroupClass =
  result = cast[PWindowGroupClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_WINDOW_GROUP()))

