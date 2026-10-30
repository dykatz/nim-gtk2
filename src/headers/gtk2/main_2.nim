# Included by headers/gtk2.nim; do not import directly.
proc init*(argc, argv: pointer){.cdecl, dynlib: lib, importc: "gtk_init".}
proc init_check*(argc, argv: pointer): gboolean {.cdecl, dynlib: lib,
    importc: "gtk_init_check".}
proc main_level*(): guint{.cdecl, dynlib: lib, importc: "gtk_main_level".}
proc main_quit*(){.cdecl, dynlib: lib, importc: "gtk_main_quit".}
proc main_iteration*(): gboolean{.cdecl, dynlib: lib,
                                  importc: "gtk_main_iteration".}
proc main_iteration_do*(blocking: gboolean): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_main_iteration_do".}
proc gtkTrue*(): gboolean{.cdecl, dynlib: lib, importc: "gtk_true".}
proc gtkFalse*(): gboolean{.cdecl, dynlib: lib, importc: "gtk_false".}
proc grab_add*(widget: PWidget){.cdecl, dynlib: lib, importc: "gtk_grab_add".}
proc grab_get_current*(): PWidget{.cdecl, dynlib: lib,
                                   importc: "gtk_grab_get_current".}
proc grab_remove*(widget: PWidget){.cdecl, dynlib: lib,
                                    importc: "gtk_grab_remove".}
proc init_add*(`function`: TFunction, data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_init_add".}
proc quit_add_destroy*(main_level: guint, anObject: PObject){.cdecl,
    dynlib: lib, importc: "gtk_quit_add_destroy".}
proc quit_add*(main_level: guint, `function`: TFunction, data: gpointer): guint{.
    cdecl, dynlib: lib, importc: "gtk_quit_add".}
proc quit_add_full*(main_level: guint, `function`: TFunction,
                    marshal: TCallbackMarshal, data: gpointer,
                    destroy: TDestroyNotify): guint{.cdecl, dynlib: lib,
    importc: "gtk_quit_add_full".}
proc quit_remove*(quit_handler_id: guint){.cdecl, dynlib: lib,
    importc: "gtk_quit_remove".}
proc quit_remove_by_data*(data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_quit_remove_by_data".}
proc timeout_add*(interval: guint32, `function`: TFunction, data: gpointer): guint{.
    cdecl, dynlib: lib, importc: "gtk_timeout_add".}
proc timeout_add_full*(interval: guint32, `function`: TFunction,
                       marshal: TCallbackMarshal, data: gpointer,
                       destroy: TDestroyNotify): guint{.cdecl, dynlib: lib,
    importc: "gtk_timeout_add_full".}
proc timeout_remove*(timeout_handler_id: guint){.cdecl, dynlib: lib,
    importc: "gtk_timeout_remove".}
proc idle_add*(`function`: TFunction, data: gpointer): guint{.cdecl,
    dynlib: lib, importc: "gtk_idle_add".}
proc idle_add_priority*(priority: gint, `function`: TFunction, data: gpointer): guint{.
    cdecl, dynlib: lib, importc: "gtk_idle_add_priority".}
proc idle_add_full*(priority: gint, `function`: TFunction,
                    marshal: TCallbackMarshal, data: gpointer,
                    destroy: TDestroyNotify): guint{.cdecl, dynlib: lib,
    importc: "gtk_idle_add_full".}
proc idle_remove*(idle_handler_id: guint){.cdecl, dynlib: lib,
    importc: "gtk_idle_remove".}
proc idle_remove_by_data*(data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_idle_remove_by_data".}
proc input_add_full*(source: gint, condition: gdk2.TInputCondition,
                     `function`: gdk2.TInputFunction, marshal: TCallbackMarshal,
                     data: gpointer, destroy: TDestroyNotify): guint{.cdecl,
    dynlib: lib, importc: "gtk_input_add_full".}
proc input_remove*(input_handler_id: guint){.cdecl, dynlib: lib,
    importc: "gtk_input_remove".}
proc key_snooper_install*(snooper: TKeySnoopFunc, func_data: gpointer): guint{.
    cdecl, dynlib: lib, importc: "gtk_key_snooper_install".}
proc key_snooper_remove*(snooper_handler_id: guint){.cdecl, dynlib: lib,
    importc: "gtk_key_snooper_remove".}
proc get_current_event*(): gdk2.PEvent{.cdecl, dynlib: lib,
                                      importc: "gtk_get_current_event".}
proc get_current_event_time*(): guint32{.cdecl, dynlib: lib,
    importc: "gtk_get_current_event_time".}
proc get_current_event_state*(state: gdk2.PModifierType): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_get_current_event_state".}
proc get_event_widget*(event: gdk2.PEvent): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_get_event_widget".}
proc propagate_event*(widget: PWidget, event: gdk2.PEvent){.cdecl, dynlib: lib,
    importc: "gtk_propagate_event".}
proc boolean_handled_accumulator*(ihint: PGSignalInvocationHint,
                                  return_accu: PGValue, handler_return: PGValue,
                                  dummy: gpointer): gboolean{.cdecl,
    dynlib: lib, importc: "_gtk_boolean_handled_accumulator".}
proc find_module*(name: cstring, thetype: cstring): cstring{.cdecl, dynlib: lib,
    importc: "_gtk_find_module".}
proc get_module_path*(thetype: cstring): PPgchar{.cdecl, dynlib: lib,
    importc: "_gtk_get_module_path".}
