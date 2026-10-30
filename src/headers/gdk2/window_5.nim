# Included by headers/gdk2.nim; do not import directly.
proc WINDOW_CLASS*(klass: pointer): PWindowObjectClass =
  result = cast[PWindowObjectClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_WINDOW()))

proc IS_WINDOW*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_WINDOW())

proc IS_WINDOW_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_WINDOW())

proc WINDOW_GET_CLASS*(obj: pointer): PWindowObjectClass =
  result = cast[PWindowObjectClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_WINDOW()))

proc WINDOW_OBJECT*(anObject: pointer): PWindowObject =
  result = cast[PWindowObject](WINDOW(anObject))

proc WindowObject_guffaw_gravity*(a: PWindowObject): guint =
  result = (a.flag0 and bm_TWindowObject_guffaw_gravity) shr
      bp_TWindowObject_guffaw_gravity

proc WindowObject_set_guffaw_gravity*(a: PWindowObject,
                                      `guffaw_gravity`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`guffaw_gravity` shl bp_TWindowObject_guffaw_gravity) and
      bm_TWindowObject_guffaw_gravity)

proc WindowObject_input_only*(a: PWindowObject): guint =
  result = ((a.flag0 and bm_TWindowObject_input_only) shr
      bp_TWindowObject_input_only).guint

proc WindowObject_set_input_only*(a: PWindowObject, `input_only`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`input_only` shl bp_TWindowObject_input_only) and
      bm_TWindowObject_input_only)

proc WindowObject_modal_hint*(a: PWindowObject): guint =
  result = ((a.flag0 and bm_TWindowObject_modal_hint) shr
      bp_TWindowObject_modal_hint).guint

proc WindowObject_set_modal_hint*(a: PWindowObject, `modal_hint`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`modal_hint` shl bp_TWindowObject_modal_hint) and
      bm_TWindowObject_modal_hint)

proc WindowObject_destroyed*(a: PWindowObject): guint =
  result = ((a.flag0 and bm_TWindowObject_destroyed) shr
      bp_TWindowObject_destroyed).guint

proc WindowObject_set_destroyed*(a: PWindowObject, `destroyed`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`destroyed` shl bp_TWindowObject_destroyed) and
      bm_TWindowObject_destroyed)

