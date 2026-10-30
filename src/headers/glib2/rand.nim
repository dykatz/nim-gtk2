# Included by headers/glib2.nim; do not import directly.
proc g_rand_new*(seed: guint32): PGRand{.cdecl, dynlib: gliblib,
    importc: "g_rand_new_with_seed".}
proc g_rand_new*(): PGRand{.cdecl, dynlib: gliblib, importc: "g_rand_new".}
proc free*(rand: PGRand){.cdecl, dynlib: gliblib, importc: "g_rand_free".}
proc set_seed*(rand: PGRand, seed: guint32){.cdecl, dynlib: gliblib,
    importc: "g_rand_set_seed".}
proc boolean*(rand: PGRand): gboolean
proc randint*(rand: PGRand): guint32{.cdecl, dynlib: gliblib,
    importc: "g_rand_int".}
proc int_range*(rand: PGRand, `begin`: gint32, `end`: gint32): gint32{.
    cdecl, dynlib: gliblib, importc: "g_rand_int_range".}
proc double*(rand: PGRand): gdouble{.cdecl, dynlib: gliblib,
    importc: "g_rand_double".}
proc double_range*(rand: PGRand, `begin`: gdouble, `end`: gdouble): gdouble{.
    cdecl, dynlib: gliblib, importc: "g_rand_double_range".}
proc g_random_set_seed*(seed: guint32){.cdecl, dynlib: gliblib,
                                        importc: "g_random_set_seed".}
proc g_random_boolean*(): gboolean
proc g_random_int*(): guint32{.cdecl, dynlib: gliblib, importc: "g_random_int".}
proc g_random_int_range*(`begin`: gint32, `end`: gint32): gint32{.cdecl,
    dynlib: gliblib, importc: "g_random_int_range".}
proc g_random_double*(): gdouble{.cdecl, dynlib: gliblib,
                                  importc: "g_random_double".}
proc g_random_double_range*(`begin`: gdouble, `end`: gdouble): gdouble{.cdecl,
    dynlib: gliblib, importc: "g_random_double_range".}
