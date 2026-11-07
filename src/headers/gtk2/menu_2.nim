# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MENU*(): GType
proc MENU*(obj: pointer): PMenu
proc MENU_CLASS*(klass: pointer): PMenuClass
proc IS_MENU*(obj: pointer): bool
proc IS_MENU_CLASS*(klass: pointer): bool
proc MENU_GET_CLASS*(obj: pointer): PMenuClass
proc needs_destruction_ref_count*(a: PMenu): guint
proc set_needs_destruction_ref_count*(a: PMenu,
                                      `needs_destruction_ref_count`: guint)
proc torn_off*(a: PMenu): guint
proc set_torn_off*(a: PMenu, `torn_off`: guint)
proc tearoff_active*(a: PMenu): guint
proc set_tearoff_active*(a: PMenu, `tearoff_active`: guint)
proc scroll_fast*(a: PMenu): guint
proc set_scroll_fast*(a: PMenu, `scroll_fast`: guint)
proc upper_arrow_visible*(a: PMenu): guint
proc set_upper_arrow_visible*(a: PMenu, `upper_arrow_visible`: guint)
proc lower_arrow_visible*(a: PMenu): guint
proc set_lower_arrow_visible*(a: PMenu, `lower_arrow_visible`: guint)
proc upper_arrow_prelight*(a: PMenu): guint
proc set_upper_arrow_prelight*(a: PMenu, `upper_arrow_prelight`: guint)
proc lower_arrow_prelight*(a: PMenu): guint
proc set_lower_arrow_prelight*(a: PMenu, `lower_arrow_prelight`: guint)
proc menu_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_menu_get_type".}
proc menu_new*(): PMenu{.cdecl, dynlib: lib, importc: "gtk_menu_new".}
proc popup*(menu: PMenu, parent_menu_shell: PWidget,
                 parent_menu_item: PWidget, fun: TMenuPositionFunc,
                 data: gpointer, button: guint, activate_time: guint32){.cdecl,
    dynlib: lib, importc: "gtk_menu_popup".}
proc reposition*(menu: PMenu){.cdecl, dynlib: lib,
                                    importc: "gtk_menu_reposition".}
proc popdown*(menu: PMenu){.cdecl, dynlib: lib, importc: "gtk_menu_popdown".}
proc get_active*(menu: PMenu): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_menu_get_active".}
proc set_active*(menu: PMenu, index: guint){.cdecl, dynlib: lib,
    importc: "gtk_menu_set_active".}
proc set_accel_group*(menu: PMenu, accel_group: PAccelGroup){.cdecl,
    dynlib: lib, importc: "gtk_menu_set_accel_group".}
proc get_accel_group*(menu: PMenu): PAccelGroup{.cdecl, dynlib: lib,
    importc: "gtk_menu_get_accel_group".}
proc set_accel_path*(menu: PMenu, accel_path: cstring){.cdecl, dynlib: lib,
    importc: "gtk_menu_set_accel_path".}
proc attach_to_widget*(menu: PMenu, attach_widget: PWidget,
                            detacher: TMenuDetachFunc){.cdecl, dynlib: lib,
    importc: "gtk_menu_attach_to_widget".}
proc detach*(menu: PMenu){.cdecl, dynlib: lib, importc: "gtk_menu_detach".}
proc get_attach_widget*(menu: PMenu): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_menu_get_attach_widget".}
proc set_tearoff_state*(menu: PMenu, torn_off: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_menu_set_tearoff_state".}
proc get_tearoff_state*(menu: PMenu): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_menu_get_tearoff_state".}
proc set_title*(menu: PMenu, title: cstring){.cdecl, dynlib: lib,
    importc: "gtk_menu_set_title".}
proc get_title*(menu: PMenu): cstring{.cdecl, dynlib: lib,
    importc: "gtk_menu_get_title".}
proc reorder_child*(menu: PMenu, child: PWidget, position: gint){.cdecl,
    dynlib: lib, importc: "gtk_menu_reorder_child".}
proc set_screen*(menu: PMenu, screen: gdk2.PScreen){.cdecl, dynlib: lib,
    importc: "gtk_menu_set_screen".}

