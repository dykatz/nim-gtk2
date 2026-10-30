# Included by headers/gtk2.nim; do not import directly.
proc TYPE_PROGRESS_BAR*(): GType
proc PROGRESS_BAR*(obj: pointer): PProgressBar
proc PROGRESS_BAR_CLASS*(klass: pointer): PProgressBarClass
proc IS_PROGRESS_BAR*(obj: pointer): bool
proc IS_PROGRESS_BAR_CLASS*(klass: pointer): bool
proc PROGRESS_BAR_GET_CLASS*(obj: pointer): PProgressBarClass
proc activity_dir*(a: PProgressBar): guint
proc set_activity_dir*(a: PProgressBar, `activity_dir`: guint)
proc progress_bar_get_type*(): TType{.cdecl, dynlib: lib,
                                      importc: "gtk_progress_bar_get_type".}
proc progress_bar_new*(): PProgressBar{.cdecl, dynlib: lib,
                                        importc: "gtk_progress_bar_new".}
proc pulse*(pbar: PProgressBar){.cdecl, dynlib: lib,
    importc: "gtk_progress_bar_pulse".}
proc set_text*(pbar: PProgressBar, text: cstring){.cdecl,
    dynlib: lib, importc: "gtk_progress_bar_set_text".}
proc set_fraction*(pbar: PProgressBar, fraction: gdouble){.cdecl,
    dynlib: lib, importc: "gtk_progress_bar_set_fraction".}
proc set_pulse_step*(pbar: PProgressBar, fraction: gdouble){.cdecl,
    dynlib: lib, importc: "gtk_progress_bar_set_pulse_step".}
proc set_orientation*(pbar: PProgressBar,
                                   orientation: TProgressBarOrientation){.cdecl,
    dynlib: lib, importc: "gtk_progress_bar_set_orientation".}
proc get_text*(pbar: PProgressBar): cstring{.cdecl, dynlib: lib,
    importc: "gtk_progress_bar_get_text".}
proc get_fraction*(pbar: PProgressBar): gdouble{.cdecl,
    dynlib: lib, importc: "gtk_progress_bar_get_fraction".}
proc get_pulse_step*(pbar: PProgressBar): gdouble{.cdecl,
    dynlib: lib, importc: "gtk_progress_bar_get_pulse_step".}
proc get_orientation*(pbar: PProgressBar): TProgressBarOrientation{.
    cdecl, dynlib: lib, importc: "gtk_progress_bar_get_orientation".}
