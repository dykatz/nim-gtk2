# Included by headers/glib2.nim; do not import directly.
proc array_get_nth*(value_array: PGValueArray, index: guint): PGValue{.
    cdecl, dynlib: gobjectlib, importc: "g_value_array_get_nth".}
proc g_value_array_new*(n_prealloced: guint): PGValueArray{.cdecl,
    dynlib: gobjectlib, importc: "g_value_array_new".}
proc array_free*(value_array: PGValueArray){.cdecl, dynlib: gobjectlib,
    importc: "g_value_array_free".}
proc array_copy*(value_array: PGValueArray): PGValueArray{.cdecl,
    dynlib: gobjectlib, importc: "g_value_array_copy".}
proc array_prepend*(value_array: PGValueArray, value: PGValue): PGValueArray{.
    cdecl, dynlib: gobjectlib, importc: "g_value_array_prepend".}
proc array_append*(value_array: PGValueArray, value: PGValue): PGValueArray{.
    cdecl, dynlib: gobjectlib, importc: "g_value_array_append".}
proc array_insert*(value_array: PGValueArray, index: guint,
                           value: PGValue): PGValueArray{.cdecl,
    dynlib: gobjectlib, importc: "g_value_array_insert".}
proc array_remove*(value_array: PGValueArray, index: guint): PGValueArray{.
    cdecl, dynlib: gobjectlib, importc: "g_value_array_remove".}
proc array_sort*(value_array: PGValueArray, compare_func: TGCompareFunc): PGValueArray{.
    cdecl, dynlib: gobjectlib, importc: "g_value_array_sort".}
proc array_sort*(value_array: PGValueArray,
                                   compare_func: TGCompareDataFunc,
                                   user_data: gpointer): PGValueArray{.cdecl,
    dynlib: gobjectlib, importc: "g_value_array_sort_with_data".}
const
  G_VALUE_COLLECT_INT* = 'i'
const
  G_VALUE_COLLECT_LONG* = 'l'
const
  G_VALUE_COLLECT_INT64* = 'q'
const
  G_VALUE_COLLECT_DOUBLE* = 'd'
const
  G_VALUE_COLLECT_POINTER* = 'p'
const
  G_VALUE_COLLECT_FORMAT_MAX_LENGTH* = 8

