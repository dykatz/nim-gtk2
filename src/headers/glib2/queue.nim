# Included by headers/glib2.nim; do not import directly.
proc g_queue_new*(): PGQueue{.cdecl, dynlib: gliblib, importc: "g_queue_new".}
proc free*(queue: PGQueue){.cdecl, dynlib: gliblib,
                                    importc: "g_queue_free".}
proc push_head*(queue: PGQueue, data: gpointer){.cdecl, dynlib: gliblib,
    importc: "g_queue_push_head".}
proc push_tail*(queue: PGQueue, data: gpointer){.cdecl, dynlib: gliblib,
    importc: "g_queue_push_tail".}
proc pop_head*(queue: PGQueue): gpointer{.cdecl, dynlib: gliblib,
    importc: "g_queue_pop_head".}
proc pop_tail*(queue: PGQueue): gpointer{.cdecl, dynlib: gliblib,
    importc: "g_queue_pop_tail".}
proc is_empty*(queue: PGQueue): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_queue_is_empty".}
proc peek_head*(queue: PGQueue): gpointer{.cdecl, dynlib: gliblib,
    importc: "g_queue_peek_head".}
proc peek_tail*(queue: PGQueue): gpointer{.cdecl, dynlib: gliblib,
    importc: "g_queue_peek_tail".}
proc push_head_link*(queue: PGQueue, link: PGList){.cdecl,
    dynlib: gliblib, importc: "g_queue_push_head_link".}
proc push_tail_link*(queue: PGQueue, link: PGList){.cdecl,
    dynlib: gliblib, importc: "g_queue_push_tail_link".}
proc pop_head_link*(queue: PGQueue): PGList{.cdecl, dynlib: gliblib,
    importc: "g_queue_pop_head_link".}
proc pop_tail_link*(queue: PGQueue): PGList{.cdecl, dynlib: gliblib,
    importc: "g_queue_pop_tail_link".}
