# Included by headers/gtk2.nim; do not import directly.
proc TYPE_NOTEBOOK*(): GType =
  result = notebook_get_type()

proc NOTEBOOK*(obj: pointer): PNotebook =
  result = cast[PNotebook](CHECK_CAST(obj, TYPE_NOTEBOOK()))

proc NOTEBOOK_CLASS*(klass: pointer): PNotebookClass =
  result = cast[PNotebookClass](CHECK_CLASS_CAST(klass, TYPE_NOTEBOOK()))

proc IS_NOTEBOOK*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_NOTEBOOK())

proc IS_NOTEBOOK_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_NOTEBOOK())

proc NOTEBOOK_GET_CLASS*(obj: pointer): PNotebookClass =
  result = cast[PNotebookClass](CHECK_GET_CLASS(obj, TYPE_NOTEBOOK()))

proc show_tabs*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_show_tabs) shr
      bp_TGtkNotebook_show_tabs

proc set_show_tabs*(a: PNotebook, `show_tabs`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`show_tabs` shl bp_TGtkNotebook_show_tabs) and
      bm_TGtkNotebook_show_tabs)

proc homogeneous*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_homogeneous) shr
      bp_TGtkNotebook_homogeneous

proc set_homogeneous*(a: PNotebook, `homogeneous`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`homogeneous` shl bp_TGtkNotebook_homogeneous) and
      bm_TGtkNotebook_homogeneous)

proc show_border*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_show_border) shr
      bp_TGtkNotebook_show_border

proc set_show_border*(a: PNotebook, `show_border`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`show_border` shl bp_TGtkNotebook_show_border) and
      bm_TGtkNotebook_show_border)

proc tab_pos*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_tab_pos) shr
      bp_TGtkNotebook_tab_pos

proc scrollable*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_scrollable) shr
      bp_TGtkNotebook_scrollable

proc set_scrollable*(a: PNotebook, `scrollable`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`scrollable` shl bp_TGtkNotebook_scrollable) and
      bm_TGtkNotebook_scrollable)

proc in_child*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_in_child) shr
      bp_TGtkNotebook_in_child

