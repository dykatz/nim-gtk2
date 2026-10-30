# Included by headers/glib2.nim; do not import directly.
proc g_datalist_id_set_data*(datalist: PPGData, key_id: TGQuark, data: gpointer) =
  g_datalist_id_set_data_full(datalist, key_id, data, TGDestroyNotify(nil))

proc g_datalist_id_remove_data*(datalist: PPGData, key_id: TGQuark) =
  g_datalist_id_set_data(datalist, key_id, nil)

proc g_datalist_get_data*(datalist: PPGData, key_str: cstring): PPGData =
  result = cast[PPGData](g_datalist_id_get_data(datalist,
      g_quark_try_string(key_str)))

proc g_datalist_set_data_full*(datalist: PPGData, key_str: cstring,
                               data: gpointer, destroy_func: TGDestroyNotify) =
  g_datalist_id_set_data_full(datalist, g_quark_from_string(key_str), data,
                              destroy_func)

proc g_datalist_set_data*(datalist: PPGData, key_str: cstring, data: gpointer) =
  g_datalist_set_data_full(datalist, key_str, data, nil)

proc g_datalist_remove_no_notify*(datalist: PPGData, key_str: cstring) =
  discard g_datalist_id_remove_no_notify(datalist, g_quark_try_string(key_str))

proc g_datalist_remove_data*(datalist: PPGData, key_str: cstring) =
  g_datalist_id_set_data(datalist, g_quark_try_string(key_str), nil)

