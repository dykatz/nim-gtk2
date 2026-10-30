# Included by headers/gtk2.nim; do not import directly.
proc RC_STYLE_get*(anObject: pointer): PRcStyle =
  result = cast[PRcStyle](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_RC_STYLE()))

proc RC_STYLE_CLASS*(klass: pointer): PRcStyleClass =
  result = cast[PRcStyleClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_RC_STYLE()))

proc IS_RC_STYLE*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_RC_STYLE())

proc IS_RC_STYLE_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_RC_STYLE())

proc RC_STYLE_GET_CLASS*(obj: pointer): PRcStyleClass =
  result = cast[PRcStyleClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_RC_STYLE()))

proc engine_specified*(a: PRcStyle): guint =
  result = (a.RcStyleflag0 and bm_TGtkRcStyle_engine_specified) shr
      bp_TGtkRcStyle_engine_specified

proc set_engine_specified*(a: PRcStyle, `engine_specified`: guint) =
  a.RcStyleflag0 = a.RcStyleflag0 or
      (uint16(`engine_specified` shl bp_TGtkRcStyle_engine_specified) and
      bm_TGtkRcStyle_engine_specified)

