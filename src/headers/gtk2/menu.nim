# Included by headers/gtk2.nim; do not import directly.
proc append*(menu_shell: PMenuShell, child: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_menu_shell_append".}
proc prepend*(menu_shell: PMenuShell, child: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_menu_shell_prepend".}
proc insert*(menu_shell: PMenuShell, child: PWidget, position: gint){.
    cdecl, dynlib: lib, importc: "gtk_menu_shell_insert".}
