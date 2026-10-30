# Included by headers/glib2.nim; do not import directly.
type
  TGLogFunc* = proc (log_domain: cstring, log_level: TGLogLevelFlags,
                     TheMessage: cstring, user_data: gpointer){.cdecl.}

