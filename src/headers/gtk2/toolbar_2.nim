# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TOOLBAR*(): GType =
  result = toolbar_get_type()

proc TOOLBAR*(obj: pointer): PToolbar =
  result = cast[PToolbar](CHECK_CAST(obj, TYPE_TOOLBAR()))

proc TOOLBAR_CLASS*(klass: pointer): PToolbarClass =
  result = cast[PToolbarClass](CHECK_CLASS_CAST(klass, TYPE_TOOLBAR()))

proc IS_TOOLBAR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TOOLBAR())

proc IS_TOOLBAR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TOOLBAR())

proc TOOLBAR_GET_CLASS*(obj: pointer): PToolbarClass =
  result = cast[PToolbarClass](CHECK_GET_CLASS(obj, TYPE_TOOLBAR()))

proc style_set*(a: PToolbar): guint =
  result = (a.Toolbarflag0 and bm_TGtkToolbar_style_set) shr
      bp_TGtkToolbar_style_set

proc set_style_set*(a: PToolbar, `style_set`: guint) =
  a.Toolbarflag0 = a.Toolbarflag0 or
      (uint16(`style_set` shl bp_TGtkToolbar_style_set) and
      bm_TGtkToolbar_style_set)

proc icon_size_set*(a: PToolbar): guint =
  result = (a.Toolbarflag0 and bm_TGtkToolbar_icon_size_set) shr
      bp_TGtkToolbar_icon_size_set

proc set_icon_size_set*(a: PToolbar, `icon_size_set`: guint) =
  a.Toolbarflag0 = a.Toolbarflag0 or
      (uint16(`icon_size_set` shl bp_TGtkToolbar_icon_size_set) and
      bm_TGtkToolbar_icon_size_set)

proc TYPE_TREE_DRAG_SOURCE*(): GType =
  result = tree_drag_source_get_type()

