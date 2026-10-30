# Included by headers/glib2.nim; do not import directly.
proc g_dataset_id_set_data*(location: gconstpointer, key_id: TGQuark,
                            data: gpointer) =
  g_dataset_id_set_data_full(location, key_id, data, nil)

proc g_dataset_id_remove_data*(location: gconstpointer, key_id: TGQuark) =
  g_dataset_id_set_data(location, key_id, nil)

proc g_dataset_get_data*(location: gconstpointer, key_str: cstring): gpointer =
  result = g_dataset_id_get_data(location, g_quark_try_string(key_str))

proc g_dataset_set_data_full*(location: gconstpointer, key_str: cstring,
                              data: gpointer, destroy_func: TGDestroyNotify) =
  g_dataset_id_set_data_full(location, g_quark_from_string(key_str), data,
                             destroy_func)

proc g_dataset_remove_no_notify*(location: gconstpointer, key_str: cstring) =
  discard g_dataset_id_remove_no_notify(location, g_quark_try_string(key_str))

proc g_dataset_set_data*(location: gconstpointer, key_str: cstring,
                         data: gpointer) =
  g_dataset_set_data_full(location, key_str, data, nil)

proc g_dataset_remove_data*(location: gconstpointer, key_str: cstring) =
  g_dataset_id_set_data(location, g_quark_try_string(key_str), nil)

proc G_FILE_ERROR*(): TGQuark =
  result = g_file_error_quark()

