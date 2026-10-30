# Included by headers/glib2.nim; do not import directly.
proc g_trash_stack_push*(stack_p: PPGTrashStack, data_p: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_trash_stack_push".}
proc g_trash_stack_pop*(stack_p: PPGTrashStack): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_trash_stack_pop".}
proc g_trash_stack_peek*(stack_p: PPGTrashStack): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_trash_stack_peek".}
proc g_trash_stack_height*(stack_p: PPGTrashStack): guint{.cdecl,
    dynlib: gliblib, importc: "g_trash_stack_height".}
