# Included by headers/gtk2.nim; do not import directly.
proc TYPE_PLUG*(): GType =
  result = plug_get_type()

proc PLUG*(obj: pointer): PPlug =
  result = cast[PPlug](CHECK_CAST(obj, TYPE_PLUG()))

proc PLUG_CLASS*(klass: pointer): PPlugClass =
  result = cast[PPlugClass](CHECK_CLASS_CAST(klass, TYPE_PLUG()))

proc IS_PLUG*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_PLUG())

proc IS_PLUG_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_PLUG())

proc PLUG_GET_CLASS*(obj: pointer): PPlugClass =
  result = cast[PPlugClass](CHECK_GET_CLASS(obj, TYPE_PLUG()))

proc same_app*(a: PPlug): guint =
  result = (a.Plugflag0 and bm_TGtkPlug_same_app) shr bp_TGtkPlug_same_app

proc set_same_app*(a: PPlug, `same_app`: guint) =
  a.Plugflag0 = a.Plugflag0 or
      (uint16(`same_app` shl bp_TGtkPlug_same_app) and bm_TGtkPlug_same_app)

