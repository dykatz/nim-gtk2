# Included by headers/gdk2.nim; do not import directly.
proc window_at_pointer*(win_x: Pgint, win_y: Pgint): PWindow{.cdecl,
    dynlib: lib, importc: "gdk_window_at_pointer".}
proc show*(window: PWindow){.cdecl, dynlib: lib,
                                    importc: "gdk_window_show".}
proc hide*(window: PWindow){.cdecl, dynlib: lib,
                                    importc: "gdk_window_hide".}
proc withdraw*(window: PWindow){.cdecl, dynlib: lib,
                                        importc: "gdk_window_withdraw".}
proc show_unraised*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_show_unraised".}
proc move*(window: PWindow, x: gint, y: gint){.cdecl, dynlib: lib,
    importc: "gdk_window_move".}
proc resize*(window: PWindow, width: gint, height: gint){.cdecl,
    dynlib: lib, importc: "gdk_window_resize".}
proc move_resize*(window: PWindow, x: gint, y: gint, width: gint,
                         height: gint){.cdecl, dynlib: lib,
                                        importc: "gdk_window_move_resize".}
proc reparent*(window: PWindow, new_parent: PWindow, x: gint, y: gint){.
    cdecl, dynlib: lib, importc: "gdk_window_reparent".}
proc clear*(window: PWindow){.cdecl, dynlib: lib,
                                     importc: "gdk_window_clear".}
proc clear_area*(window: PWindow, x: gint, y: gint, width: gint,
                        height: gint){.cdecl, dynlib: lib,
                                       importc: "gdk_window_clear_area".}
proc clear_area_e*(window: PWindow, x: gint, y: gint, width: gint,
                          height: gint){.cdecl, dynlib: lib,
    importc: "gdk_window_clear_area_e".}
proc `raise`*(window: PWindow){.cdecl, dynlib: lib,
                                importc: "gdk_window_raise".}
proc lower*(window: PWindow){.cdecl, dynlib: lib,
                                     importc: "gdk_window_lower".}
proc focus*(window: PWindow, timestamp: guint32){.cdecl, dynlib: lib,
    importc: "gdk_window_focus".}
proc set_user_data*(window: PWindow, user_data: gpointer){.cdecl,
    dynlib: lib, importc: "gdk_window_set_user_data".}
proc set_override_redirect*(window: PWindow, override_redirect: gboolean){.
    cdecl, dynlib: lib, importc: "gdk_window_set_override_redirect".}
proc get_display*(win: gdk2.PWindow): gdk2.PDisplay{.cdecl, dynlib: lib,
  importc: "gdk_window_get_display".}
proc TFILTER_CALLBACK*(f: pointer): TFilterFunc =
  result = cast[TFilterFunc](f)
proc add_filter*(window: PWindow, `function`: TFilterFunc, data: gpointer){.
    cdecl, dynlib: lib, importc: "gdk_window_add_filter".}
proc remove_filter*(window: PWindow, `function`: TFilterFunc,
                           data: gpointer){.cdecl, dynlib: lib,
    importc: "gdk_window_remove_filter".}
proc scroll*(window: PWindow, dx: gint, dy: gint){.cdecl, dynlib: lib,
    importc: "gdk_window_scroll".}
proc shape_combine_mask*(window: PWindow, mask: PBitmap, x: gint, y: gint){.
    cdecl, dynlib: lib, importc: "gdk_window_shape_combine_mask".}
proc shape_combine_region*(window: PWindow, shape_region: PRegion,
                                  offset_x: gint, offset_y: gint){.cdecl,
    dynlib: lib, importc: "gdk_window_shape_combine_region".}
proc set_child_shapes*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_set_child_shapes".}
proc merge_child_shapes*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_merge_child_shapes".}
proc is_visible*(window: PWindow): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_window_is_visible".}
proc is_viewable*(window: PWindow): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_window_is_viewable".}
proc get_state*(window: PWindow): TWindowState{.cdecl, dynlib: lib,
    importc: "gdk_window_get_state".}
proc set_static_gravities*(window: PWindow, use_static: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_window_set_static_gravities".}
proc window_foreign_new_for_display*(display: PDisplay, anid: TNativeWindow): PWindow{.
    cdecl, dynlib: lib, importc: "gdk_window_foreign_new_for_display".}
proc window_lookup_for_display*(display: PDisplay, anid: TNativeWindow): PWindow{.
    cdecl, dynlib: lib, importc: "gdk_window_lookup_for_display".}
proc set_type_hint*(window: PWindow, hint: TWindowTypeHint){.cdecl,
    dynlib: lib, importc: "gdk_window_set_type_hint".}
proc set_modal_hint*(window: PWindow, modal: gboolean){.cdecl,
    dynlib: lib, importc: "gdk_window_set_modal_hint".}
proc set_geometry_hints*(window: PWindow, geometry: PGeometry,
                                geom_mask: TWindowHints){.cdecl, dynlib: lib,
    importc: "gdk_window_set_geometry_hints".}
proc set_sm_client_id*(sm_client_id: cstring){.cdecl, dynlib: lib,
    importc: "gdk_set_sm_client_id".}
proc begin_paint_rect*(window: PWindow, rectangle: PRectangle){.cdecl,
    dynlib: lib, importc: "gdk_window_begin_paint_rect".}
proc begin_paint_region*(window: PWindow, region: PRegion){.cdecl,
    dynlib: lib, importc: "gdk_window_begin_paint_region".}
proc end_paint*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_end_paint".}
proc set_title*(window: PWindow, title: cstring){.cdecl, dynlib: lib,
    importc: "gdk_window_set_title".}
proc set_role*(window: PWindow, role: cstring){.cdecl, dynlib: lib,
    importc: "gdk_window_set_role".}
proc set_transient_for*(window: PWindow, parent: PWindow){.cdecl,
    dynlib: lib, importc: "gdk_window_set_transient_for".}
proc set_background*(window: PWindow, color: PColor){.cdecl, dynlib: lib,
    importc: "gdk_window_set_background".}
proc set_back_pixmap*(window: PWindow, pixmap: PPixmap,
                             parent_relative: gboolean){.cdecl, dynlib: lib,
    importc: "gdk_window_set_back_pixmap".}
proc set_cursor*(window: PWindow, cursor: PCursor){.cdecl, dynlib: lib,
    importc: "gdk_window_set_cursor".}
proc get_user_data*(window: PWindow, data: gpointer){.cdecl, dynlib: lib,
    importc: "gdk_window_get_user_data".}
proc get_geometry*(window: PWindow, x: Pgint, y: Pgint, width: Pgint,
                          height: Pgint, depth: Pgint){.cdecl, dynlib: lib,
    importc: "gdk_window_get_geometry".}
proc get_position*(window: PWindow, x: Pgint, y: Pgint){.cdecl,
    dynlib: lib, importc: "gdk_window_get_position".}
proc get_origin*(window: PWindow, x: Pgint, y: Pgint): gint{.cdecl,
    dynlib: lib, importc: "gdk_window_get_origin".}
proc get_root_origin*(window: PWindow, x: Pgint, y: Pgint){.cdecl,
    dynlib: lib, importc: "gdk_window_get_root_origin".}
proc get_frame_extents*(window: PWindow, rect: PRectangle){.cdecl,
    dynlib: lib, importc: "gdk_window_get_frame_extents".}
proc get_pointer*(window: PWindow, x: Pgint, y: Pgint,
                         mask: PModifierType): PWindow{.cdecl, dynlib: lib,
    importc: "gdk_window_get_pointer".}
proc get_parent*(window: PWindow): PWindow{.cdecl, dynlib: lib,
    importc: "gdk_window_get_parent".}
proc get_toplevel*(window: PWindow): PWindow{.cdecl, dynlib: lib,
    importc: "gdk_window_get_toplevel".}
proc get_children*(window: PWindow): PGList{.cdecl, dynlib: lib,
    importc: "gdk_window_get_children".}
proc peek_children*(window: PWindow): PGList{.cdecl, dynlib: lib,
    importc: "gdk_window_peek_children".}
proc get_events*(window: PWindow): TEventMask{.cdecl, dynlib: lib,
    importc: "gdk_window_get_events".}
proc set_events*(window: PWindow, event_mask: TEventMask){.cdecl,
    dynlib: lib, importc: "gdk_window_set_events".}
proc set_icon_list*(window: PWindow, pixbufs: PGList){.cdecl,
    dynlib: lib, importc: "gdk_window_set_icon_list".}
proc set_icon*(window: PWindow, icon_window: PWindow, pixmap: PPixmap,
                      mask: PBitmap){.cdecl, dynlib: lib,
                                      importc: "gdk_window_set_icon".}
proc set_icon_name*(window: PWindow, name: cstring){.cdecl, dynlib: lib,
    importc: "gdk_window_set_icon_name".}
proc set_group*(window: PWindow, leader: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_set_group".}
proc set_decorations*(window: PWindow, decorations: TWMDecoration){.
    cdecl, dynlib: lib, importc: "gdk_window_set_decorations".}
proc get_decorations*(window: PWindow, decorations: PWMDecoration): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_window_get_decorations".}
proc set_functions*(window: PWindow, functions: TWMFunction){.cdecl,
    dynlib: lib, importc: "gdk_window_set_functions".}
proc iconify*(window: PWindow){.cdecl, dynlib: lib,
                                       importc: "gdk_window_iconify".}
proc deiconify*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_deiconify".}
proc stick*(window: PWindow){.cdecl, dynlib: lib,
                                     importc: "gdk_window_stick".}
proc unstick*(window: PWindow){.cdecl, dynlib: lib,
                                       importc: "gdk_window_unstick".}
proc maximize*(window: PWindow){.cdecl, dynlib: lib,
                                        importc: "gdk_window_maximize".}
proc unmaximize*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_unmaximize".}
proc register_dnd*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_register_dnd".}
proc begin_resize_drag*(window: PWindow, edge: TWindowEdge, button: gint,
                               root_x: gint, root_y: gint, timestamp: guint32){.
    cdecl, dynlib: lib, importc: "gdk_window_begin_resize_drag".}
proc begin_move_drag*(window: PWindow, button: gint, root_x: gint,
                             root_y: gint, timestamp: guint32){.cdecl,
    dynlib: lib, importc: "gdk_window_begin_move_drag".}
proc invalidate_rect*(window: PWindow, rect: PRectangle,
                             invalidate_children: gboolean){.cdecl, dynlib: lib,
    importc: "gdk_window_invalidate_rect".}
proc invalidate_region*(window: PWindow, region: PRegion,
                               invalidate_children: gboolean){.cdecl,
    dynlib: lib, importc: "gdk_window_invalidate_region".}
proc invalidate_maybe_recurse*(window: PWindow, region: PRegion,
    child_func: window_invalidate_maybe_recurse_child_func, user_data: gpointer){.
    cdecl, dynlib: lib, importc: "gdk_window_invalidate_maybe_recurse".}
proc get_update_area*(window: PWindow): PRegion{.cdecl, dynlib: lib,
    importc: "gdk_window_get_update_area".}
proc freeze_updates*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_freeze_updates".}
proc thaw_updates*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gdk_window_thaw_updates".}
proc window_process_all_updates*(){.cdecl, dynlib: lib,
                                    importc: "gdk_window_process_all_updates".}
proc process_updates*(window: PWindow, update_children: gboolean){.cdecl,
    dynlib: lib, importc: "gdk_window_process_updates".}
proc window_set_debug_updates*(setting: gboolean){.cdecl, dynlib: lib,
    importc: "gdk_window_set_debug_updates".}
proc window_constrain_size*(geometry: PGeometry, flags: guint, width: gint,
                            height: gint, new_width: Pgint, new_height: Pgint){.
    cdecl, dynlib: lib, importc: "gdk_window_constrain_size".}
proc get_internal_paint_info*(window: PWindow, e: var PDrawable,
                                     x_offset: Pgint, y_offset: Pgint){.cdecl,
    dynlib: lib, importc: "gdk_window_get_internal_paint_info".}
proc set_pointer_hooks*(new_hooks: PPointerHooks): PPointerHooks{.cdecl,
    dynlib: lib, importc: "gdk_set_pointer_hooks".}
proc get_default_root_window*(): PWindow{.cdecl, dynlib: lib,
    importc: "gdk_get_default_root_window".}
