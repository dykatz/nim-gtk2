# Included by headers/gtk2.nim; do not import directly.
proc reallocate_redraws*(a: PContainer): guint
proc set_reallocate_redraws*(a: PContainer, `reallocate_redraws`: guint)
proc has_focus_chain*(a: PContainer): guint
proc set_has_focus_chain*(a: PContainer, `has_focus_chain`: guint)
proc container_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_container_get_type".}
proc set_border_width*(container: PContainer, border_width: guint){.
    cdecl, dynlib: lib, importc: "gtk_container_set_border_width".}
proc get_border_width*(container: PContainer): guint{.cdecl,
    dynlib: lib, importc: "gtk_container_get_border_width".}
proc add*(container: PContainer, widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_container_add".}
proc remove*(container: PContainer, widget: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_container_remove".}
proc set_resize_mode*(container: PContainer, resize_mode: TResizeMode){.
    cdecl, dynlib: lib, importc: "gtk_container_set_resize_mode".}
proc get_resize_mode*(container: PContainer): TResizeMode{.cdecl,
    dynlib: lib, importc: "gtk_container_get_resize_mode".}
proc check_resize*(container: PContainer){.cdecl, dynlib: lib,
    importc: "gtk_container_check_resize".}
proc foreach*(container: PContainer, callback: TCallback,
                        callback_data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_container_foreach".}
proc get_children*(container: PContainer): PGList{.cdecl, dynlib: lib,
    importc: "gtk_container_get_children".}
proc propagate_expose*(container: PContainer, child: PWidget,
                                 event: gdk2.PEventExpose){.cdecl, dynlib: lib,
    importc: "gtk_container_propagate_expose".}
proc set_focus_chain*(container: PContainer, focusable_widgets: PGList){.
    cdecl, dynlib: lib, importc: "gtk_container_set_focus_chain".}
proc get_focus_chain*(container: PContainer, s: var PGList): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_container_get_focus_chain".}
proc unset_focus_chain*(container: PContainer){.cdecl, dynlib: lib,
    importc: "gtk_container_unset_focus_chain".}
proc set_reallocate_redraws*(container: PContainer,
                                       needs_redraws: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_container_set_reallocate_redraws".}
proc set_focus_child*(container: PContainer, child: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_container_set_focus_child".}
proc set_focus_vadjustment*(container: PContainer,
                                      adjustment: PAdjustment){.cdecl,
    dynlib: lib, importc: "gtk_container_set_focus_vadjustment".}
proc get_focus_vadjustment*(container: PContainer): PAdjustment{.
    cdecl, dynlib: lib, importc: "gtk_container_get_focus_vadjustment".}
proc set_focus_hadjustment*(container: PContainer,
                                      adjustment: PAdjustment){.cdecl,
    dynlib: lib, importc: "gtk_container_set_focus_hadjustment".}
proc get_focus_hadjustment*(container: PContainer): PAdjustment{.
    cdecl, dynlib: lib, importc: "gtk_container_get_focus_hadjustment".}
proc resize_children*(container: PContainer){.cdecl, dynlib: lib,
    importc: "gtk_container_resize_children".}
proc child_type*(container: PContainer): TType{.cdecl, dynlib: lib,
    importc: "gtk_container_child_type".}
proc install_child_property*(cclass: PContainerClass,
    property_id: guint, pspec: PGParamSpec){.cdecl, dynlib: lib,
    importc: "gtk_container_class_install_child_property".}
proc container_class_find_child_property*(cclass: PGObjectClass,
    property_name: cstring): PGParamSpec{.cdecl, dynlib: lib,
    importc: "gtk_container_class_find_child_property".}
proc container_class_list_child_properties*(cclass: PGObjectClass,
    n_properties: Pguint): PPGParamSpec{.cdecl, dynlib: lib,
    importc: "gtk_container_class_list_child_properties".}
proc child_set_property*(container: PContainer, child: PWidget,
                                   property_name: cstring, value: PGValue){.
    cdecl, dynlib: lib, importc: "gtk_container_child_set_property".}
proc child_get_property*(container: PContainer, child: PWidget,
                                   property_name: cstring, value: PGValue){.
    cdecl, dynlib: lib, importc: "gtk_container_child_get_property".}
proc CONTAINER_WARN_INVALID_CHILD_PROPERTY_ID*(anObject: pointer,
    property_id: guint, pspec: pointer)
proc forall*(container: PContainer, callback: TCallback,
                       callback_data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_container_forall".}
proc queue_resize*(container: PContainer){.cdecl, dynlib: lib,
    importc: "_gtk_container_queue_resize".}
proc clear_resize_widgets*(container: PContainer){.cdecl, dynlib: lib,
    importc: "_gtk_container_clear_resize_widgets".}
proc child_composite_name*(container: PContainer, child: PWidget): cstring{.
    cdecl, dynlib: lib, importc: "_gtk_container_child_composite_name".}
proc dequeue_resize_handler*(container: PContainer){.cdecl,
    dynlib: lib, importc: "_gtk_container_dequeue_resize_handler".}
proc focus_sort*(container: PContainer, children: PGList,
                           direction: TDirectionType, old_focus: PWidget): PGList{.
    cdecl, dynlib: lib, importc: "_gtk_container_focus_sort".}
