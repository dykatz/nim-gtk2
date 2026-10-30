# Included by headers/glib2.nim; do not import directly.
proc g_qsort*(pbase: gconstpointer, total_elems: gint, size: gsize,
                        compare_func: TGCompareDataFunc, user_data: gpointer){.
    cdecl, dynlib: gliblib, importc: "g_qsort_with_data".}
