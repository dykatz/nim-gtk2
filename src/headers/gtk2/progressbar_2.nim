# Included by headers/gtk2.nim; do not import directly.
proc TYPE_PROGRESS_BAR*(): GType =
  result = progress_bar_get_type()

proc PROGRESS_BAR*(obj: pointer): PProgressBar =
  result = cast[PProgressBar](CHECK_CAST(obj, TYPE_PROGRESS_BAR()))

proc PROGRESS_BAR_CLASS*(klass: pointer): PProgressBarClass =
  result = cast[PProgressBarClass](CHECK_CLASS_CAST(klass, TYPE_PROGRESS_BAR()))

proc IS_PROGRESS_BAR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_PROGRESS_BAR())

proc IS_PROGRESS_BAR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_PROGRESS_BAR())

proc PROGRESS_BAR_GET_CLASS*(obj: pointer): PProgressBarClass =
  result = cast[PProgressBarClass](CHECK_GET_CLASS(obj, TYPE_PROGRESS_BAR()))

proc activity_dir*(a: PProgressBar): guint =
  result = (a.ProgressBarflag0 and bm_TGtkProgressBar_activity_dir) shr
      bp_TGtkProgressBar_activity_dir

proc set_activity_dir*(a: PProgressBar, `activity_dir`: guint) =
  a.ProgressBarflag0 = a.ProgressBarflag0 or
      (uint16(`activity_dir` shl bp_TGtkProgressBar_activity_dir) and
      bm_TGtkProgressBar_activity_dir)

