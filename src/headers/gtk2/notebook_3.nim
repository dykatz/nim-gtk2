# Included by headers/gtk2.nim; do not import directly.
proc click_child*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_click_child) shr
      bp_TGtkNotebook_click_child

proc set_click_child*(a: PNotebook, `click_child`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`click_child` shl bp_TGtkNotebook_click_child) and
      bm_TGtkNotebook_click_child)

proc button*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_button) shr
      bp_TGtkNotebook_button

proc set_button*(a: PNotebook, `button`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`button` shl bp_TGtkNotebook_button) and bm_TGtkNotebook_button)

proc need_timer*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_need_timer) shr
      bp_TGtkNotebook_need_timer

proc set_need_timer*(a: PNotebook, `need_timer`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`need_timer` shl bp_TGtkNotebook_need_timer) and
      bm_TGtkNotebook_need_timer)

proc child_has_focus*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_child_has_focus) shr
      bp_TGtkNotebook_child_has_focus

proc set_child_has_focus*(a: PNotebook, `child_has_focus`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`child_has_focus` shl bp_TGtkNotebook_child_has_focus) and
      bm_TGtkNotebook_child_has_focus)

proc have_visible_child*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_have_visible_child) shr
      bp_TGtkNotebook_have_visible_child

proc set_have_visible_child*(a: PNotebook, `have_visible_child`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`have_visible_child` shl bp_TGtkNotebook_have_visible_child) and
      bm_TGtkNotebook_have_visible_child)

proc focus_out*(a: PNotebook): guint =
  result = (a.Notebookflag0 and bm_TGtkNotebook_focus_out) shr
      bp_TGtkNotebook_focus_out

proc set_focus_out*(a: PNotebook, `focus_out`: guint) =
  a.Notebookflag0 = a.Notebookflag0 or
      (uint16(`focus_out` shl bp_TGtkNotebook_focus_out) and
      bm_TGtkNotebook_focus_out)

