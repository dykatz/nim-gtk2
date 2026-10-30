# Included by headers/glib2.nim; do not import directly.
proc g_list_alloc*(): PGList{.cdecl, dynlib: gliblib, importc: "g_list_alloc".}
proc free*(list: PGList){.cdecl, dynlib: gliblib, importc: "g_list_free".}
proc free_1*(list: PGList){.cdecl, dynlib: gliblib,
                                   importc: "g_list_free_1".}
proc append*(list: PGList, data: gpointer): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_append".}
proc prepend*(list: PGList, data: gpointer): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_prepend".}
proc insert*(list: PGList, data: gpointer, position: gint): PGList{.
    cdecl, dynlib: gliblib, importc: "g_list_insert".}
proc insert_sorted*(list: PGList, data: gpointer, fn: TGCompareFunc): PGList{.
    cdecl, dynlib: gliblib, importc: "g_list_insert_sorted".}
proc insert_before*(list: PGList, sibling: PGList, data: gpointer): PGList{.
    cdecl, dynlib: gliblib, importc: "g_list_insert_before".}
proc concat*(list1: PGList, list2: PGList): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_concat".}
proc remove*(list: PGList, data: gconstpointer): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_remove".}
proc remove_all*(list: PGList, data: gconstpointer): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_remove_all".}
proc remove_link*(list: PGList, llink: PGList): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_remove_link".}
proc delete_link*(list: PGList, link: PGList): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_delete_link".}
proc reverse*(list: PGList): PGList{.cdecl, dynlib: gliblib,
    importc: "g_list_reverse".}
proc copy*(list: PGList): PGList{.cdecl, dynlib: gliblib,
    importc: "g_list_copy".}
proc nth*(list: PGList, n: guint): PGList{.cdecl, dynlib: gliblib,
    importc: "g_list_nth".}
proc nth_prev*(list: PGList, n: guint): PGList{.cdecl, dynlib: gliblib,
    importc: "g_list_nth_prev".}
proc find*(list: PGList, data: gconstpointer): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_find".}
proc find_custom*(list: PGList, data: gconstpointer, fn: TGCompareFunc): PGList{.
    cdecl, dynlib: gliblib, importc: "g_list_find_custom".}
proc position*(list: PGList, llink: PGList): gint{.cdecl,
    dynlib: gliblib, importc: "g_list_position".}
proc index*(list: PGList, data: gconstpointer): gint{.cdecl,
    dynlib: gliblib, importc: "g_list_index".}
proc last*(list: PGList): PGList{.cdecl, dynlib: gliblib,
    importc: "g_list_last".}
proc first*(list: PGList): PGList{.cdecl, dynlib: gliblib,
    importc: "g_list_first".}
proc length*(list: PGList): guint{.cdecl, dynlib: gliblib,
    importc: "g_list_length".}
proc foreach*(list: PGList, fn: TGFunc, user_data: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_list_foreach".}
proc sort*(list: PGList, compare_func: TGCompareFunc): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_sort".}
proc sort*(list: PGList, compare_func: TGCompareDataFunc,
                            user_data: gpointer): PGList{.cdecl,
    dynlib: gliblib, importc: "g_list_sort_with_data".}
proc nth_data*(list: PGList, n: guint): gpointer{.cdecl, dynlib: gliblib,
    importc: "g_list_nth_data".}
proc previous*(list: PGList): PGList
proc next*(list: PGList): PGList
