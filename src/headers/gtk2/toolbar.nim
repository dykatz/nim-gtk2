# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TOOLBAR*(): GType
proc TOOLBAR*(obj: pointer): PToolbar
proc TOOLBAR_CLASS*(klass: pointer): PToolbarClass
proc IS_TOOLBAR*(obj: pointer): bool
proc IS_TOOLBAR_CLASS*(klass: pointer): bool
proc TOOLBAR_GET_CLASS*(obj: pointer): PToolbarClass
proc style_set*(a: PToolbar): guint
proc set_style_set*(a: PToolbar, `style_set`: guint)
proc icon_size_set*(a: PToolbar): guint
proc set_icon_size_set*(a: PToolbar, `icon_size_set`: guint)
proc toolbar_get_type*(): TType{.cdecl, dynlib: lib,
                                 importc: "gtk_toolbar_get_type".}
proc toolbar_new*(): PToolbar{.cdecl, dynlib: lib, importc: "gtk_toolbar_new".}
proc append_item*(toolbar: PToolbar, text: cstring,
                          tooltip_text: cstring, tooltip_private_text: cstring,
                          icon: PWidget, callback: TSignalFunc,
                          user_data: gpointer): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_toolbar_append_item".}
proc prepend_item*(toolbar: PToolbar, text: cstring,
                           tooltip_text: cstring, tooltip_private_text: cstring,
                           icon: PWidget, callback: TSignalFunc,
                           user_data: gpointer): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_toolbar_prepend_item".}
proc insert_item*(toolbar: PToolbar, text: cstring,
                          tooltip_text: cstring, tooltip_private_text: cstring,
                          icon: PWidget, callback: TSignalFunc,
                          user_data: gpointer, position: gint): PWidget{.cdecl,
    dynlib: lib, importc: "gtk_toolbar_insert_item".}
proc insert_stock*(toolbar: PToolbar, stock_id: cstring,
                           tooltip_text: cstring, tooltip_private_text: cstring,
                           callback: TSignalFunc, user_data: gpointer,
                           position: gint): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_toolbar_insert_stock".}
proc append_space*(toolbar: PToolbar){.cdecl, dynlib: lib,
    importc: "gtk_toolbar_append_space".}
proc prepend_space*(toolbar: PToolbar){.cdecl, dynlib: lib,
    importc: "gtk_toolbar_prepend_space".}
proc insert_space*(toolbar: PToolbar, position: gint){.cdecl,
    dynlib: lib, importc: "gtk_toolbar_insert_space".}
proc remove_space*(toolbar: PToolbar, position: gint){.cdecl,
    dynlib: lib, importc: "gtk_toolbar_remove_space".}
proc append_element*(toolbar: PToolbar, thetype: TToolbarChildType,
                             widget: PWidget, text: cstring,
                             tooltip_text: cstring,
                             tooltip_private_text: cstring, icon: PWidget,
                             callback: TSignalFunc, user_data: gpointer): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_toolbar_append_element".}
proc prepend_element*(toolbar: PToolbar, thetype: TToolbarChildType,
                              widget: PWidget, text: cstring,
                              tooltip_text: cstring,
                              tooltip_private_text: cstring, icon: PWidget,
                              callback: TSignalFunc, user_data: gpointer): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_toolbar_prepend_element".}
proc insert_element*(toolbar: PToolbar, thetype: TToolbarChildType,
                             widget: PWidget, text: cstring,
                             tooltip_text: cstring,
                             tooltip_private_text: cstring, icon: PWidget,
                             callback: TSignalFunc, user_data: gpointer,
                             position: gint): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_toolbar_insert_element".}
proc append_widget*(toolbar: PToolbar, widget: PWidget,
                            tooltip_text: cstring, tooltip_private_text: cstring){.
    cdecl, dynlib: lib, importc: "gtk_toolbar_append_widget".}
proc prepend_widget*(toolbar: PToolbar, widget: PWidget,
                             tooltip_text: cstring,
                             tooltip_private_text: cstring){.cdecl, dynlib: lib,
    importc: "gtk_toolbar_prepend_widget".}
proc insert_widget*(toolbar: PToolbar, widget: PWidget,
                            tooltip_text: cstring,
                            tooltip_private_text: cstring, position: gint){.
    cdecl, dynlib: lib, importc: "gtk_toolbar_insert_widget".}
proc set_orientation*(toolbar: PToolbar, orientation: TOrientation){.
    cdecl, dynlib: lib, importc: "gtk_toolbar_set_orientation".}
proc set_style*(toolbar: PToolbar, style: TToolbarStyle){.cdecl,
    dynlib: lib, importc: "gtk_toolbar_set_style".}
proc set_icon_size*(toolbar: PToolbar, icon_size: TIconSize){.cdecl,
    dynlib: lib, importc: "gtk_toolbar_set_icon_size".}
proc unset_style*(toolbar: PToolbar){.cdecl, dynlib: lib,
    importc: "gtk_toolbar_unset_style".}
proc unset_icon_size*(toolbar: PToolbar){.cdecl, dynlib: lib,
    importc: "gtk_toolbar_unset_icon_size".}
proc get_orientation*(toolbar: PToolbar): TOrientation{.cdecl,
    dynlib: lib, importc: "gtk_toolbar_get_orientation".}
proc get_style*(toolbar: PToolbar): TToolbarStyle{.cdecl, dynlib: lib,
    importc: "gtk_toolbar_get_style".}
proc get_icon_size*(toolbar: PToolbar): TIconSize{.cdecl, dynlib: lib,
    importc: "gtk_toolbar_get_icon_size".}
proc TYPE_TREE_DRAG_SOURCE*(): GType
