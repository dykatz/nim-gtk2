# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SIZE_GROUP*(): GType =
  result = size_group_get_type()

proc SIZE_GROUP*(obj: pointer): PSizeGroup =
  result = cast[PSizeGroup](CHECK_CAST(obj, TYPE_SIZE_GROUP()))

proc SIZE_GROUP_CLASS*(klass: pointer): PSizeGroupClass =
  result = cast[PSizeGroupClass](CHECK_CLASS_CAST(klass, TYPE_SIZE_GROUP()))

proc IS_SIZE_GROUP*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_SIZE_GROUP())

proc IS_SIZE_GROUP_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_SIZE_GROUP())

proc SIZE_GROUP_GET_CLASS*(obj: pointer): PSizeGroupClass =
  result = cast[PSizeGroupClass](CHECK_GET_CLASS(obj, TYPE_SIZE_GROUP()))

proc have_width*(a: PSizeGroup): guint =
  result = (a.SizeGroupflag0 and bm_TGtkSizeGroup_have_width) shr
      bp_TGtkSizeGroup_have_width

proc set_have_width*(a: PSizeGroup, `have_width`: guint) =
  a.SizeGroupflag0 = a.SizeGroupflag0 or
      (uint16(`have_width` shl bp_TGtkSizeGroup_have_width) and
      bm_TGtkSizeGroup_have_width)

proc have_height*(a: PSizeGroup): guint =
  result = (a.SizeGroupflag0 and bm_TGtkSizeGroup_have_height) shr
      bp_TGtkSizeGroup_have_height

proc set_have_height*(a: PSizeGroup, `have_height`: guint) =
  a.SizeGroupflag0 = a.SizeGroupflag0 or
      (uint16(`have_height` shl bp_TGtkSizeGroup_have_height) and
      bm_TGtkSizeGroup_have_height)

