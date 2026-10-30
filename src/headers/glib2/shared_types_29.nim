# Included by headers/glib2.nim; do not import directly.
type
  TGSpawnChildSetupFunc* = proc (user_data: gpointer){.cdecl.}
