# Included by headers/glib2.nim; do not import directly.
proc g_datalist_init*(datalist: PPGData){.cdecl, dynlib: gliblib,
    importc: "g_datalist_init".}
proc g_datalist_clear*(datalist: PPGData){.cdecl, dynlib: gliblib,
    importc: "g_datalist_clear".}
proc g_datalist_id_get_data*(datalist: PPGData, key_id: TGQuark): gpointer{.
    cdecl, dynlib: gliblib, importc: "g_datalist_id_get_data".}
proc g_datalist_id_set_data_full*(datalist: PPGData, key_id: TGQuark,
                                  data: gpointer, destroy_func: TGDestroyNotify){.
    cdecl, dynlib: gliblib, importc: "g_datalist_id_set_data_full".}
proc g_datalist_id_remove_no_notify*(datalist: PPGData, key_id: TGQuark): gpointer{.
    cdecl, dynlib: gliblib, importc: "g_datalist_id_remove_no_notify".}
proc g_datalist_foreach*(datalist: PPGData, fn: TGDataForeachFunc,
                         user_data: gpointer){.cdecl, dynlib: gliblib,
    importc: "g_datalist_foreach".}
proc g_datalist_id_set_data*(datalist: PPGData, key_id: TGQuark, data: gpointer)
proc g_datalist_id_remove_data*(datalist: PPGData, key_id: TGQuark)
proc g_datalist_get_data*(datalist: PPGData, key_str: cstring): PPGData
proc g_datalist_set_data_full*(datalist: PPGData, key_str: cstring,
                               data: gpointer, destroy_func: TGDestroyNotify)
proc g_datalist_set_data*(datalist: PPGData, key_str: cstring, data: gpointer)
proc g_datalist_remove_no_notify*(datalist: PPGData, key_str: cstring)
proc g_datalist_remove_data*(datalist: PPGData, key_str: cstring)
proc g_dataset_id_get_data*(dataset_location: gconstpointer, key_id: TGQuark): gpointer{.
    cdecl, dynlib: gliblib, importc: "g_dataset_id_get_data".}
proc g_dataset_id_set_data_full*(dataset_location: gconstpointer,
                                 key_id: TGQuark, data: gpointer,
                                 destroy_func: TGDestroyNotify){.cdecl,
    dynlib: gliblib, importc: "g_dataset_id_set_data_full".}
proc g_dataset_id_remove_no_notify*(dataset_location: gconstpointer,
                                    key_id: TGQuark): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_dataset_id_remove_no_notify".}
proc g_dataset_foreach*(dataset_location: gconstpointer,
                        fn: TGDataForeachFunc, user_data: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_dataset_foreach".}
