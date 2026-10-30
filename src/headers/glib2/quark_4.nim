# Included by headers/glib2.nim; do not import directly.
proc g_dataset_id_set_data*(location: gconstpointer, key_id: TGQuark,
                            data: gpointer)
proc g_dataset_id_remove_data*(location: gconstpointer, key_id: TGQuark)
proc g_dataset_get_data*(location: gconstpointer, key_str: cstring): gpointer
proc g_dataset_set_data_full*(location: gconstpointer, key_str: cstring,
                              data: gpointer, destroy_func: TGDestroyNotify)
proc g_dataset_remove_no_notify*(location: gconstpointer, key_str: cstring)
proc g_dataset_set_data*(location: gconstpointer, key_str: cstring,
                         data: gpointer)
proc g_dataset_remove_data*(location: gconstpointer, key_str: cstring)
