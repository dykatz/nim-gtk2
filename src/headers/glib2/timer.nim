# Included by headers/glib2.nim; do not import directly.
proc g_timer_new*(): PGTimer{.cdecl, dynlib: gliblib, importc: "g_timer_new".}
proc destroy*(timer: PGTimer){.cdecl, dynlib: gliblib,
                                       importc: "g_timer_destroy".}
proc start*(timer: PGTimer){.cdecl, dynlib: gliblib,
                                     importc: "g_timer_start".}
proc stop*(timer: PGTimer){.cdecl, dynlib: gliblib,
                                    importc: "g_timer_stop".}
proc reset*(timer: PGTimer){.cdecl, dynlib: gliblib,
                                     importc: "g_timer_reset".}
proc elapsed*(timer: PGTimer, microseconds: Pgulong): gdouble{.cdecl,
    dynlib: gliblib, importc: "g_timer_elapsed".}
proc g_usleep*(microseconds: gulong){.cdecl, dynlib: gliblib,
                                      importc: "g_usleep".}
proc val_add*(time: PGTimeVal, microseconds: glong){.cdecl,
    dynlib: gliblib, importc: "g_time_val_add".}
