# Included by headers/gtk2.nim; do not import directly.
proc sort_reset_default_sort_func*(tree_model_sort: PTreeModelSort){.
    cdecl, dynlib: lib, importc: "gtk_tree_model_sort_reset_default_sort_func".}
proc sort_clear_cache*(tree_model_sort: PTreeModelSort){.cdecl,
    dynlib: lib, importc: "gtk_tree_model_sort_clear_cache".}
const
  bm_TGtkListStore_columns_dirty* = 0x0001'u16
const
  bp_TGtkListStore_columns_dirty* = 0'u16

