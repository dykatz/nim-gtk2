# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SOCKET*(): GType =
  result = socket_get_type()

proc SOCKET*(obj: pointer): PSocket =
  result = cast[PSocket](CHECK_CAST(obj, TYPE_SOCKET()))

proc SOCKET_CLASS*(klass: pointer): PSocketClass =
  result = cast[PSocketClass](CHECK_CLASS_CAST(klass, TYPE_SOCKET()))

proc IS_SOCKET*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_SOCKET())

proc IS_SOCKET_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_SOCKET())

proc SOCKET_GET_CLASS*(obj: pointer): PSocketClass =
  result = cast[PSocketClass](CHECK_GET_CLASS(obj, TYPE_SOCKET()))

proc same_app*(a: PSocket): guint =
  result = (a.Socketflag0 and bm_TGtkSocket_same_app) shr
      bp_TGtkSocket_same_app

proc set_same_app*(a: PSocket, `same_app`: guint) =
  a.Socketflag0 = a.Socketflag0 or
      (uint16(`same_app` shl bp_TGtkSocket_same_app) and
      bm_TGtkSocket_same_app)

proc focus_in*(a: PSocket): guint =
  result = (a.Socketflag0 and bm_TGtkSocket_focus_in) shr
      bp_TGtkSocket_focus_in

proc set_focus_in*(a: PSocket, `focus_in`: guint) =
  a.Socketflag0 = a.Socketflag0 or
      (uint16(`focus_in` shl bp_TGtkSocket_focus_in) and
      bm_TGtkSocket_focus_in)

proc have_size*(a: PSocket): guint =
  result = (a.Socketflag0 and bm_TGtkSocket_have_size) shr
      bp_TGtkSocket_have_size

proc set_have_size*(a: PSocket, `have_size`: guint) =
  a.Socketflag0 = a.Socketflag0 or
      (uint16(`have_size` shl bp_TGtkSocket_have_size) and
      bm_TGtkSocket_have_size)

proc need_map*(a: PSocket): guint =
  result = (a.Socketflag0 and bm_TGtkSocket_need_map) shr
      bp_TGtkSocket_need_map

proc set_need_map*(a: PSocket, `need_map`: guint) =
  a.Socketflag0 = a.Socketflag0 or
      (uint16(`need_map` shl bp_TGtkSocket_need_map) and
      bm_TGtkSocket_need_map)

proc is_mapped*(a: PSocket): guint =
  result = (a.Socketflag0 and bm_TGtkSocket_is_mapped) shr
      bp_TGtkSocket_is_mapped

proc set_is_mapped*(a: PSocket, `is_mapped`: guint) =
  a.Socketflag0 = a.Socketflag0 or
      (uint16(`is_mapped` shl bp_TGtkSocket_is_mapped) and
      bm_TGtkSocket_is_mapped)

