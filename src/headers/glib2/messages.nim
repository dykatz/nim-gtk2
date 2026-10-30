# Included by headers/glib2.nim; do not import directly.
proc g_log_set_handler*(log_domain: cstring, log_levels: TGLogLevelFlags,
                        log_func: TGLogFunc, user_data: gpointer): guint{.cdecl,
    dynlib: gliblib, importc: "g_log_set_handler".}
proc g_log_remove_handler*(log_domain: cstring, handler_id: guint){.cdecl,
    dynlib: gliblib, importc: "g_log_remove_handler".}
proc g_log_default_handler*(log_domain: cstring, log_level: TGLogLevelFlags,
                            TheMessage: cstring, unused_data: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_log_default_handler".}
proc g_log_set_fatal_mask*(log_domain: cstring, fatal_mask: TGLogLevelFlags): TGLogLevelFlags{.
    cdecl, dynlib: gliblib, importc: "g_log_set_fatal_mask".}
proc g_log_set_always_fatal*(fatal_mask: TGLogLevelFlags): TGLogLevelFlags{.
    cdecl, dynlib: gliblib, importc: "g_log_set_always_fatal".}
proc `g_log_fallback_handler`*(log_domain: cstring, log_level: TGLogLevelFlags,
                               message: cstring, unused_data: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_log_fallback_handler".}
const
  G_LOG_DOMAIN* = nil

