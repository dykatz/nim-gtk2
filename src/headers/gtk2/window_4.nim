# Included by headers/gtk2.nim; do not import directly.
proc set_skip_taskbar_hint*(window: PWindow, setting: gboolean){.cdecl,
  dynlib: lib, importc: "gtk_window_set_skip_taskbar_hint".}

