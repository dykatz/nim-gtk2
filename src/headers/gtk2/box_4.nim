# Included by headers/gtk2.nim; do not import directly.
proc TYPE_BOX*(): GType =
  result = box_get_type()

proc BOX*(obj: pointer): PBox =
  result = cast[PBox](CHECK_CAST(obj, TYPE_BOX()))

proc BOX_CLASS*(klass: pointer): PBoxClass =
  result = cast[PBoxClass](CHECK_CLASS_CAST(klass, TYPE_BOX()))

proc IS_BOX*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_BOX())

proc IS_BOX_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_BOX())

proc BOX_GET_CLASS*(obj: pointer): PBoxClass =
  result = cast[PBoxClass](CHECK_GET_CLASS(obj, TYPE_BOX()))

proc homogeneous*(a: PBox): guint =
  result = (a.box_flag0 and bm_TGtkBox_homogeneous) shr bp_TGtkBox_homogeneous

proc set_homogeneous*(a: PBox, `homogeneous`: guint) =
  a.box_flag0 = a.box_flag0 or
      (uint16(`homogeneous` shl bp_TGtkBox_homogeneous) and
      bm_TGtkBox_homogeneous)

proc expand*(a: PBoxChild): guint =
  result = (a.flag0 and bm_TGtkBoxChild_expand) shr bp_TGtkBoxChild_expand

proc set_expand*(a: PBoxChild, `expand`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`expand` shl bp_TGtkBoxChild_expand) and bm_TGtkBoxChild_expand)

proc fill*(a: PBoxChild): guint =
  result = ((a.flag0 and bm_TGtkBoxChild_fill) shr bp_TGtkBoxChild_fill).guint

proc set_fill*(a: PBoxChild, `fill`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`fill` shl bp_TGtkBoxChild_fill) and bm_TGtkBoxChild_fill)

proc pack*(a: PBoxChild): guint =
  result = ((a.flag0 and bm_TGtkBoxChild_pack) shr bp_TGtkBoxChild_pack).guint

proc set_pack*(a: PBoxChild, `pack`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`pack` shl bp_TGtkBoxChild_pack) and bm_TGtkBoxChild_pack)

proc is_secondary*(a: PBoxChild): guint =
  result = ((a.flag0 and bm_TGtkBoxChild_is_secondary) shr
      bp_TGtkBoxChild_is_secondary).guint

proc set_is_secondary*(a: PBoxChild, `is_secondary`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_secondary` shl bp_TGtkBoxChild_is_secondary) and
      bm_TGtkBoxChild_is_secondary)

proc TYPE_BUTTON_BOX*(): GType =
  result = button_box_get_type()

