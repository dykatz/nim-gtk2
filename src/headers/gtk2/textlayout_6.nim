# Included by headers/gtk2.nim; do not import directly.
proc is_strong*(a: PTextCursorDisplay): guint =
  result = (a.flag0 and bm_TGtkTextCursorDisplay_is_strong) shr
      bp_TGtkTextCursorDisplay_is_strong

proc set_is_strong*(a: PTextCursorDisplay, `is_strong`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_strong` shl bp_TGtkTextCursorDisplay_is_strong) and
      bm_TGtkTextCursorDisplay_is_strong)

proc is_weak*(a: PTextCursorDisplay): guint =
  result = (a.flag0 and bm_TGtkTextCursorDisplay_is_weak) shr
      bp_TGtkTextCursorDisplay_is_weak

proc set_is_weak*(a: PTextCursorDisplay, `is_weak`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_weak` shl bp_TGtkTextCursorDisplay_is_weak) and
      bm_TGtkTextCursorDisplay_is_weak)

