# Included by headers/glib2.nim; do not import directly.
proc g_slist_alloc*(): PGSList{.cdecl, dynlib: gliblib, importc: "g_slist_alloc".}
proc free*(list: PGSList){.cdecl, dynlib: gliblib,
                                   importc: "g_slist_free".}
proc free_1*(list: PGSList){.cdecl, dynlib: gliblib,
                                     importc: "g_slist_free_1".}
proc append*(list: PGSList, data: gpointer): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_append".}
proc prepend*(list: PGSList, data: gpointer): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_prepend".}
proc insert*(list: PGSList, data: gpointer, position: gint): PGSList{.
    cdecl, dynlib: gliblib, importc: "g_slist_insert".}
proc insert_sorted*(list: PGSList, data: gpointer, fn: TGCompareFunc): PGSList{.
    cdecl, dynlib: gliblib, importc: "g_slist_insert_sorted".}
proc insert_before*(slist: PGSList, sibling: PGSList, data: gpointer): PGSList{.
    cdecl, dynlib: gliblib, importc: "g_slist_insert_before".}
proc concat*(list1: PGSList, list2: PGSList): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_concat".}
proc remove*(list: PGSList, data: gconstpointer): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_remove".}
proc remove_all*(list: PGSList, data: gconstpointer): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_remove_all".}
proc remove_link*(list: PGSList, link: PGSList): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_remove_link".}
proc delete_link*(list: PGSList, link: PGSList): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_delete_link".}
proc reverse*(list: PGSList): PGSList{.cdecl, dynlib: gliblib,
    importc: "g_slist_reverse".}
proc copy*(list: PGSList): PGSList{.cdecl, dynlib: gliblib,
    importc: "g_slist_copy".}
proc nth*(list: PGSList, n: guint): PGSList{.cdecl, dynlib: gliblib,
    importc: "g_slist_nth".}
proc find*(list: PGSList, data: gconstpointer): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_find".}
proc find_custom*(list: PGSList, data: gconstpointer,
                          fn: TGCompareFunc): PGSList{.cdecl, dynlib: gliblib,
    importc: "g_slist_find_custom".}
proc position*(list: PGSList, llink: PGSList): gint{.cdecl,
    dynlib: gliblib, importc: "g_slist_position".}
proc index*(list: PGSList, data: gconstpointer): gint{.cdecl,
    dynlib: gliblib, importc: "g_slist_index".}
proc last*(list: PGSList): PGSList{.cdecl, dynlib: gliblib,
    importc: "g_slist_last".}
proc length*(list: PGSList): guint{.cdecl, dynlib: gliblib,
    importc: "g_slist_length".}
proc foreach*(list: PGSList, fn: TGFunc, user_data: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_slist_foreach".}
proc sort*(list: PGSList, compare_func: TGCompareFunc): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_sort".}
proc sort*(list: PGSList, compare_func: TGCompareDataFunc,
                             user_data: gpointer): PGSList{.cdecl,
    dynlib: gliblib, importc: "g_slist_sort_with_data".}
proc nth_data*(list: PGSList, n: guint): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_slist_nth_data".}
proc next*(slist: PGSList): PGSList
proc list_push_allocator*(allocator: PGAllocator){.cdecl, dynlib: gliblib,
    importc: "g_list_push_allocator".}
proc g_list_pop_allocator*(){.cdecl, dynlib: gliblib,
                              importc: "g_list_pop_allocator".}
