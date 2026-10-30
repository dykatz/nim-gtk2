# Included by headers/gtk2.nim; do not import directly.
proc TYPE_WIDGET*(): GType
proc WIDGET*(widget: pointer): PWidget
proc WIDGET_CLASS*(klass: pointer): PWidgetClass
proc IS_WIDGET*(widget: pointer): bool
proc IS_WIDGET_CLASS*(klass: pointer): bool
proc WIDGET_GET_CLASS*(obj: pointer): PWidgetClass
proc WIDGET_TYPE*(wid: pointer): GType
proc WIDGET_STATE*(wid: pointer): uint32
proc WIDGET_SAVED_STATE*(wid: pointer): uint32
proc WIDGET_FLAGS*(wid: pointer): guint32
proc WIDGET_TOPLEVEL*(wid: pointer): gboolean
proc WIDGET_NO_WINDOW*(wid: pointer): gboolean
proc WIDGET_REALIZED*(wid: pointer): gboolean
proc WIDGET_MAPPED*(wid: pointer): gboolean
proc WIDGET_VISIBLE*(wid: pointer): gboolean
proc WIDGET_DRAWABLE*(wid: pointer): gboolean
proc WIDGET_SENSITIVE*(wid: pointer): gboolean
proc WIDGET_PARENT_SENSITIVE*(wid: pointer): gboolean
proc WIDGET_IS_SENSITIVE*(wid: pointer): gboolean
proc WIDGET_CAN_FOCUS*(wid: pointer): gboolean
proc WIDGET_HAS_FOCUS*(wid: pointer): gboolean
proc WIDGET_CAN_DEFAULT*(wid: pointer): gboolean
proc WIDGET_HAS_DEFAULT*(wid: pointer): gboolean
proc WIDGET_HAS_GRAB*(wid: pointer): gboolean
proc WIDGET_RC_STYLE*(wid: pointer): gboolean
proc WIDGET_COMPOSITE_CHILD*(wid: pointer): gboolean
proc WIDGET_APP_PAINTABLE*(wid: pointer): gboolean
proc WIDGET_RECEIVES_DEFAULT*(wid: pointer): gboolean
proc WIDGET_DOUBLE_BUFFERED*(wid: pointer): gboolean
proc SET_FLAGS*(wid: PWidget, flags: TWidgetFlags): TWidgetFlags
proc UNSET_FLAGS*(wid: PWidget, flags: TWidgetFlags): TWidgetFlags
proc TYPE_REQUISITION*(): GType
proc x_set*(a: PWidgetAuxInfo): guint
proc set_x_set*(a: PWidgetAuxInfo, x_set: guint)
proc y_set*(a: PWidgetAuxInfo): guint
proc set_y_set*(a: PWidgetAuxInfo, y_set: guint)
proc widget_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_widget_get_type".}
proc reference*(widget: PWidget): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_widget_ref".}
proc unref*(widget: PWidget){.cdecl, dynlib: lib,
                                     importc: "gtk_widget_unref".}
proc destroy*(widget: PWidget){.cdecl, dynlib: lib,
                                       importc: "gtk_widget_destroy".}
proc destroyed*(widget: PWidget, r: var PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_destroyed".}
proc unparent*(widget: PWidget){.cdecl, dynlib: lib,
                                        importc: "gtk_widget_unparent".}
proc show*(widget: PWidget){.cdecl, dynlib: lib,
                                    importc: "gtk_widget_show".}
proc show_now*(widget: PWidget){.cdecl, dynlib: lib,
                                        importc: "gtk_widget_show_now".}
proc get_visible*(widget: PWidget): gboolean {.cdecl, dynlib: lib,
    importc: "gtk_widget_get_visible".}
proc hide*(widget: PWidget){.cdecl, dynlib: lib,
                                    importc: "gtk_widget_hide".}
proc show_all*(widget: PWidget){.cdecl, dynlib: lib,
                                        importc: "gtk_widget_show_all".}
proc hide_all*(widget: PWidget){.cdecl, dynlib: lib,
                                        importc: "gtk_widget_hide_all".}
proc map*(widget: PWidget){.cdecl, dynlib: lib, importc: "gtk_widget_map".}
proc unmap*(widget: PWidget){.cdecl, dynlib: lib,
                                     importc: "gtk_widget_unmap".}
proc realize*(widget: PWidget){.cdecl, dynlib: lib,
                                       importc: "gtk_widget_realize".}
proc unrealize*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_unrealize".}
proc queue_draw*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_queue_draw".}
proc queue_draw_area*(widget: PWidget, x: gint, y: gint, width: gint,
                             height: gint){.cdecl, dynlib: lib,
    importc: "gtk_widget_queue_draw_area".}
proc queue_resize*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_queue_resize".}
proc size_request*(widget: PWidget, requisition: PRequisition){.cdecl,
    dynlib: lib, importc: "gtk_widget_size_request".}
proc size_allocate*(widget: PWidget, allocation: PAllocation){.cdecl,
    dynlib: lib, importc: "gtk_widget_size_allocate".}
proc get_child_requisition*(widget: PWidget, requisition: PRequisition){.
    cdecl, dynlib: lib, importc: "gtk_widget_get_child_requisition".}
proc add_accelerator*(widget: PWidget, accel_signal: cstring,
                             accel_group: PAccelGroup, accel_key: guint,
                             accel_mods: gdk2.TModifierType,
                             accel_flags: TAccelFlags){.cdecl, dynlib: lib,
    importc: "gtk_widget_add_accelerator".}
proc remove_accelerator*(widget: PWidget, accel_group: PAccelGroup,
                                accel_key: guint, accel_mods: gdk2.TModifierType): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_widget_remove_accelerator".}
proc set_accel_path*(widget: PWidget, accel_path: cstring,
                            accel_group: PAccelGroup){.cdecl, dynlib: lib,
    importc: "gtk_widget_set_accel_path".}
proc get_accel_path*(widget: PWidget, locked: Pgboolean): cstring{.cdecl,
    dynlib: lib, importc: "_gtk_widget_get_accel_path".}
proc list_accel_closures*(widget: PWidget): PGList{.cdecl, dynlib: lib,
    importc: "gtk_widget_list_accel_closures".}
proc mnemonic_activate*(widget: PWidget, group_cycling: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_widget_mnemonic_activate".}
proc event*(widget: PWidget, event: gdk2.PEvent): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_widget_event".}
proc send_expose*(widget: PWidget, event: gdk2.PEvent): gint{.cdecl,
    dynlib: lib, importc: "gtk_widget_send_expose".}
proc activate*(widget: PWidget): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_widget_activate".}
proc set_scroll_adjustments*(widget: PWidget, hadjustment: PAdjustment,
                                    vadjustment: PAdjustment): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_widget_set_scroll_adjustments".}
proc reparent*(widget: PWidget, new_parent: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_reparent".}
proc intersect*(widget: PWidget, area: gdk2.PRectangle,
                       intersection: gdk2.PRectangle): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_widget_intersect".}
proc region_intersect*(widget: PWidget, region: gdk2.PRegion): gdk2.PRegion{.
    cdecl, dynlib: lib, importc: "gtk_widget_region_intersect".}
proc freeze_child_notify*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_freeze_child_notify".}
proc child_notify*(widget: PWidget, child_property: cstring){.cdecl,
    dynlib: lib, importc: "gtk_widget_child_notify".}
proc thaw_child_notify*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_thaw_child_notify".}
proc is_focus*(widget: PWidget): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_widget_is_focus".}
proc grab_focus*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_grab_focus".}
proc grab_default*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_grab_default".}
proc set_name*(widget: PWidget, name: cstring){.cdecl, dynlib: lib,
    importc: "gtk_widget_set_name".}
proc get_name*(widget: PWidget): cstring{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_name".}
proc set_state*(widget: PWidget, state: TStateType){.cdecl, dynlib: lib,
    importc: "gtk_widget_set_state".}
proc set_can_default*(widget: PWidget, can_default: gboolean) {.cdecl, dynlib: lib,
    importc: "gtk_widget_set_can_default".}
proc get_sensitive*(widget: PWidget): gboolean {.cdecl, dynlib: lib,
    importc: "gtk_widget_get_sensitive".}
proc set_sensitive*(widget: PWidget, sensitive: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_widget_set_sensitive".}
proc set_app_paintable*(widget: PWidget, app_paintable: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_widget_set_app_paintable".}
proc set_double_buffered*(widget: PWidget, double_buffered: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_widget_set_double_buffered".}
proc set_redraw_on_allocate*(widget: PWidget,
                                    redraw_on_allocate: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_widget_set_redraw_on_allocate".}
proc set_parent*(widget: PWidget, parent: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_set_parent".}
proc set_parent_window*(widget: PWidget, parent_window: gdk2.PWindow){.
    cdecl, dynlib: lib, importc: "gtk_widget_set_parent_window".}
proc set_child_visible*(widget: PWidget, is_visible: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_widget_set_child_visible".}
proc get_child_visible*(widget: PWidget): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_child_visible".}
proc get_parent*(widget: PWidget): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_parent".}
proc get_parent_window*(widget: PWidget): gdk2.PWindow{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_parent_window".}
proc child_focus*(widget: PWidget, direction: TDirectionType): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_widget_child_focus".}
proc set_size_request*(widget: PWidget, width: gint, height: gint){.
    cdecl, dynlib: lib, importc: "gtk_widget_set_size_request".}
proc get_size_request*(widget: PWidget, width: Pgint, height: Pgint){.
    cdecl, dynlib: lib, importc: "gtk_widget_get_size_request".}
proc set_events*(widget: PWidget, events: gint){.cdecl, dynlib: lib,
    importc: "gtk_widget_set_events".}
proc add_events*(widget: PWidget, events: gint){.cdecl, dynlib: lib,
    importc: "gtk_widget_add_events".}
proc set_extension_events*(widget: PWidget, mode: gdk2.TExtensionMode){.
    cdecl, dynlib: lib, importc: "gtk_widget_set_extension_events".}
proc get_extension_events*(widget: PWidget): gdk2.TExtensionMode{.cdecl,
    dynlib: lib, importc: "gtk_widget_get_extension_events".}
proc get_toplevel*(widget: PWidget): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_toplevel".}
proc get_ancestor*(widget: PWidget, widget_type: TType): PWidget{.cdecl,
    dynlib: lib, importc: "gtk_widget_get_ancestor".}
proc get_colormap*(widget: PWidget): gdk2.PColormap{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_colormap".}
proc get_visual*(widget: PWidget): gdk2.PVisual{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_visual".}
proc get_screen*(widget: PWidget): gdk2.PScreen{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_screen".}
proc has_screen*(widget: PWidget): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_widget_has_screen".}
proc get_display*(widget: PWidget): gdk2.PDisplay{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_display".}
proc get_root_window*(widget: PWidget): gdk2.PWindow{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_root_window".}
proc get_settings*(widget: PWidget): PSettings{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_settings".}
proc get_clipboard*(widget: PWidget, selection: gdk2.TAtom): PClipboard{.
    cdecl, dynlib: lib, importc: "gtk_widget_get_clipboard".}
proc get_accessible*(widget: PWidget): atk.PObject{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_accessible".}
proc set_colormap*(widget: PWidget, colormap: gdk2.PColormap){.cdecl,
    dynlib: lib, importc: "gtk_widget_set_colormap".}
proc get_events*(widget: PWidget): gint{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_events".}
proc get_pointer*(widget: PWidget, x: Pgint, y: Pgint){.cdecl,
    dynlib: lib, importc: "gtk_widget_get_pointer".}
proc is_ancestor*(widget: PWidget, ancestor: PWidget): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_widget_is_ancestor".}
proc translate_coordinates*(src_widget: PWidget, dest_widget: PWidget,
                                   src_x: gint, src_y: gint, dest_x: Pgint,
                                   dest_y: Pgint): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_widget_translate_coordinates".}
proc hide_on_delete*(widget: PWidget): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_widget_hide_on_delete".}
proc set_style*(widget: PWidget, style: PStyle){.cdecl, dynlib: lib,
    importc: "gtk_widget_set_style".}
proc ensure_style*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_ensure_style".}
proc get_style*(widget: PWidget): PStyle{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_style".}
proc modify_style*(widget: PWidget, style: PRcStyle){.cdecl, dynlib: lib,
    importc: "gtk_widget_modify_style".}
proc get_modifier_style*(widget: PWidget): PRcStyle{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_modifier_style".}
proc modify_fg*(widget: PWidget, state: TStateType, color: gdk2.PColor){.
    cdecl, dynlib: lib, importc: "gtk_widget_modify_fg".}
proc modify_bg*(widget: PWidget, state: TStateType, color: gdk2.PColor){.
    cdecl, dynlib: lib, importc: "gtk_widget_modify_bg".}
proc modify_text*(widget: PWidget, state: TStateType, color: gdk2.PColor){.
    cdecl, dynlib: lib, importc: "gtk_widget_modify_text".}
proc modify_base*(widget: PWidget, state: TStateType, color: gdk2.PColor){.
    cdecl, dynlib: lib, importc: "gtk_widget_modify_base".}
proc modify_font*(widget: PWidget, font_desc: pango.PFontDescription){.
    cdecl, dynlib: lib, importc: "gtk_widget_modify_font".}
proc create_pango_context*(widget: PWidget): pango.PContext{.cdecl,
    dynlib: lib, importc: "gtk_widget_create_pango_context".}
proc get_pango_context*(widget: PWidget): pango.PContext{.cdecl,
    dynlib: lib, importc: "gtk_widget_get_pango_context".}
proc create_pango_layout*(widget: PWidget, text: cstring): pango.PLayout{.
    cdecl, dynlib: lib, importc: "gtk_widget_create_pango_layout".}
proc render_icon*(widget: PWidget, stock_id: cstring, size: TIconSize,
                         detail: cstring): gdk2pixbuf.PPixbuf{.cdecl, dynlib: lib,
    importc: "gtk_widget_render_icon".}
proc set_composite_name*(widget: PWidget, name: cstring){.cdecl,
    dynlib: lib, importc: "gtk_widget_set_composite_name".}
proc get_composite_name*(widget: PWidget): cstring{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_composite_name".}
proc reset_rc_styles*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_reset_rc_styles".}
proc widget_push_colormap*(cmap: gdk2.PColormap){.cdecl, dynlib: lib,
    importc: "gtk_widget_push_colormap".}
proc widget_push_composite_child*(){.cdecl, dynlib: lib,
                                     importc: "gtk_widget_push_composite_child".}
proc widget_pop_composite_child*(){.cdecl, dynlib: lib,
                                    importc: "gtk_widget_pop_composite_child".}
proc widget_pop_colormap*(){.cdecl, dynlib: lib,
                             importc: "gtk_widget_pop_colormap".}
proc install_style_property*(klass: PWidgetClass,
    pspec: PGParamSpec){.cdecl, dynlib: lib,
                         importc: "gtk_widget_class_install_style_property".}
proc install_style_property_parser*(klass: PWidgetClass,
    pspec: PGParamSpec, parser: TRcPropertyParser){.cdecl, dynlib: lib,
    importc: "gtk_widget_class_install_style_property_parser".}
proc find_style_property*(klass: PWidgetClass,
                                       property_name: cstring): PGParamSpec{.
    cdecl, dynlib: lib, importc: "gtk_widget_class_find_style_property".}
proc list_style_properties*(klass: PWidgetClass,
    n_properties: Pguint): PPGParamSpec{.cdecl, dynlib: lib,
    importc: "gtk_widget_class_list_style_properties".}
proc style_get_property*(widget: PWidget, property_name: cstring,
                                value: PGValue){.cdecl, dynlib: lib,
    importc: "gtk_widget_style_get_property".}
proc widget_set_default_colormap*(colormap: gdk2.PColormap){.cdecl, dynlib: lib,
    importc: "gtk_widget_set_default_colormap".}
proc widget_get_default_style*(): PStyle{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_default_style".}
proc set_direction*(widget: PWidget, dir: TTextDirection){.cdecl,
    dynlib: lib, importc: "gtk_widget_set_direction".}
proc get_direction*(widget: PWidget): TTextDirection{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_direction".}
proc widget_set_default_direction*(dir: TTextDirection){.cdecl, dynlib: lib,
    importc: "gtk_widget_set_default_direction".}
proc widget_get_default_direction*(): TTextDirection{.cdecl, dynlib: lib,
    importc: "gtk_widget_get_default_direction".}
proc shape_combine_mask*(widget: PWidget, shape_mask: gdk2.PBitmap,
                                offset_x: gint, offset_y: gint){.cdecl,
    dynlib: lib, importc: "gtk_widget_shape_combine_mask".}
proc reset_shapes*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_widget_reset_shapes".}
proc path*(widget: PWidget, path_length: Pguint, path: PPgchar,
                  path_reversed: PPgchar){.cdecl, dynlib: lib,
    importc: "gtk_widget_path".}
proc class_path*(widget: PWidget, path_length: Pguint, path: PPgchar,
                        path_reversed: PPgchar){.cdecl, dynlib: lib,
    importc: "gtk_widget_class_path".}
