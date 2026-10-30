# Included by headers/gtk2.nim; do not import directly.
proc get_state*(widget: PWidget): TStateType {.importc: "gtk_widget_get_state",
    dynlib: lib, cdecl.}

