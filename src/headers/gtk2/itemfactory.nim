# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ITEM_FACTORY*(): GType
proc ITEM_FACTORY*(anObject: pointer): PItemFactory
proc ITEM_FACTORY_CLASS*(klass: pointer): PItemFactoryClass
proc IS_ITEM_FACTORY*(anObject: pointer): bool
proc IS_ITEM_FACTORY_CLASS*(klass: pointer): bool
proc ITEM_FACTORY_GET_CLASS*(obj: pointer): PItemFactoryClass
proc item_factory_get_type*(): TType{.cdecl, dynlib: lib,
                                      importc: "gtk_item_factory_get_type".}
proc item_factory_new*(container_type: TType, path: cstring,
                       accel_group: PAccelGroup): PItemFactory{.cdecl,
    dynlib: lib, importc: "gtk_item_factory_new".}
proc construct*(ifactory: PItemFactory, container_type: TType,
                             path: cstring, accel_group: PAccelGroup){.cdecl,
    dynlib: lib, importc: "gtk_item_factory_construct".}
proc item_factory_add_foreign*(accel_widget: PWidget, full_path: cstring,
                               accel_group: PAccelGroup, keyval: guint,
                               modifiers: gdk2.TModifierType){.cdecl, dynlib: lib,
    importc: "gtk_item_factory_add_foreign".}
proc item_factory_from_widget*(widget: PWidget): PItemFactory{.cdecl,
    dynlib: lib, importc: "gtk_item_factory_from_widget".}
proc item_factory_path_from_widget*(widget: PWidget): cstring{.cdecl,
    dynlib: lib, importc: "gtk_item_factory_path_from_widget".}
proc get_item*(ifactory: PItemFactory, path: cstring): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_item_factory_get_item".}
proc get_widget*(ifactory: PItemFactory, path: cstring): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_item_factory_get_widget".}
proc get_widget_by_action*(ifactory: PItemFactory, action: guint): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_item_factory_get_widget_by_action".}
proc get_item_by_action*(ifactory: PItemFactory, action: guint): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_item_factory_get_item_by_action".}
proc create_item*(ifactory: PItemFactory, entry: PItemFactoryEntry,
                               callback_data: gpointer, callback_type: guint){.
    cdecl, dynlib: lib, importc: "gtk_item_factory_create_item".}
proc create_items*(ifactory: PItemFactory, n_entries: guint,
                                entries: PItemFactoryEntry,
                                callback_data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_item_factory_create_items".}
proc delete_item*(ifactory: PItemFactory, path: cstring){.cdecl,
    dynlib: lib, importc: "gtk_item_factory_delete_item".}
proc delete_entry*(ifactory: PItemFactory, entry: PItemFactoryEntry){.
    cdecl, dynlib: lib, importc: "gtk_item_factory_delete_entry".}
proc delete_entries*(ifactory: PItemFactory, n_entries: guint,
                                  entries: PItemFactoryEntry){.cdecl,
    dynlib: lib, importc: "gtk_item_factory_delete_entries".}
proc popup*(ifactory: PItemFactory, x: guint, y: guint,
                         mouse_button: guint, time: guint32){.cdecl,
    dynlib: lib, importc: "gtk_item_factory_popup".}
proc popup*(ifactory: PItemFactory, popup_data: gpointer,
                                   destroy: TDestroyNotify, x: guint, y: guint,
                                   mouse_button: guint, time: guint32){.cdecl,
    dynlib: lib, importc: "gtk_item_factory_popup_with_data".}
proc popup_data*(ifactory: PItemFactory): gpointer{.cdecl,
    dynlib: lib, importc: "gtk_item_factory_popup_data".}
proc item_factory_popup_data_from_widget*(widget: PWidget): gpointer{.cdecl,
    dynlib: lib, importc: "gtk_item_factory_popup_data_from_widget".}
proc set_translate_func*(ifactory: PItemFactory,
                                      fun: TTranslateFunc, data: gpointer,
                                      notify: TDestroyNotify){.cdecl,
    dynlib: lib, importc: "gtk_item_factory_set_translate_func".}
