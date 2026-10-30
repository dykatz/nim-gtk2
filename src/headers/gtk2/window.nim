# Included by headers/gtk2.nim; do not import directly.
proc TYPE_WINDOW*(): GType
proc WINDOW*(obj: pointer): PWindow
proc WINDOW_CLASS*(klass: pointer): PWindowClass
proc IS_WINDOW*(obj: pointer): bool
proc IS_WINDOW_CLASS*(klass: pointer): bool
proc WINDOW_GET_CLASS*(obj: pointer): PWindowClass
proc allow_shrink*(a: gtk2.PWindow): guint
proc set_allow_shrink*(a: gtk2.PWindow, `allow_shrink`: guint)
proc allow_grow*(a: gtk2.PWindow): guint
proc set_allow_grow*(a: gtk2.PWindow, `allow_grow`: guint)
proc configure_notify_received*(a: gtk2.PWindow): guint
proc set_configure_notify_received*(a: gtk2.PWindow,
                                    `configure_notify_received`: guint)
proc need_default_position*(a: gtk2.PWindow): guint
proc set_need_default_position*(a: gtk2.PWindow, `need_default_position`: guint)
proc need_default_size*(a: gtk2.PWindow): guint
proc set_need_default_size*(a: gtk2.PWindow, `need_default_size`: guint)
proc position*(a: gtk2.PWindow): guint
proc get_type*(a: gtk2.PWindow): guint
proc set_type*(a: gtk2.PWindow, `type`: guint)
proc has_user_ref_count*(a: gtk2.PWindow): guint
proc set_has_user_ref_count*(a: gtk2.PWindow, `has_user_ref_count`: guint)
proc has_focus*(a: gtk2.PWindow): guint
proc set_has_focus*(a: gtk2.PWindow, `has_focus`: guint)
proc modal*(a: gtk2.PWindow): guint
proc set_modal*(a: gtk2.PWindow, `modal`: guint)
proc destroy_with_parent*(a: gtk2.PWindow): guint
proc set_destroy_with_parent*(a: gtk2.PWindow, `destroy_with_parent`: guint)
proc has_frame*(a: gtk2.PWindow): guint
proc set_has_frame*(a: gtk2.PWindow, `has_frame`: guint)
proc iconify_initially*(a: gtk2.PWindow): guint
proc set_iconify_initially*(a: gtk2.PWindow, `iconify_initially`: guint)
proc stick_initially*(a: gtk2.PWindow): guint
proc set_stick_initially*(a: gtk2.PWindow, `stick_initially`: guint)
proc maximize_initially*(a: gtk2.PWindow): guint
proc set_maximize_initially*(a: gtk2.PWindow, `maximize_initially`: guint)
proc decorated*(a: gtk2.PWindow): guint
proc set_decorated*(a: gtk2.PWindow, `decorated`: guint)
proc type_hint*(a: gtk2.PWindow): guint
proc set_type_hint*(a: gtk2.PWindow, `type_hint`: guint)
proc gravity*(a: gtk2.PWindow): guint
proc set_gravity*(a: gtk2.PWindow, `gravity`: guint)
proc TYPE_WINDOW_GROUP*(): GType
proc WINDOW_GROUP*(anObject: pointer): PWindowGroup
proc WINDOW_GROUP_CLASS*(klass: pointer): PWindowGroupClass
proc IS_WINDOW_GROUP*(anObject: pointer): bool
proc IS_WINDOW_GROUP_CLASS*(klass: pointer): bool
proc WINDOW_GROUP_GET_CLASS*(obj: pointer): PWindowGroupClass
proc window_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_window_get_type".}
proc window_new*(thetype: TWindowType): PWindow{.cdecl, dynlib: lib,
    importc: "gtk_window_new".}
proc set_title*(window: PWindow, title: cstring){.cdecl, dynlib: lib,
    importc: "gtk_window_set_title".}
proc get_title*(window: PWindow): cstring{.cdecl, dynlib: lib,
    importc: "gtk_window_get_title".}
proc set_wmclass*(window: PWindow, wmclass_name: cstring,
                         wmclass_class: cstring){.cdecl, dynlib: lib,
    importc: "gtk_window_set_wmclass".}
proc set_role*(window: PWindow, role: cstring){.cdecl, dynlib: lib,
    importc: "gtk_window_set_role".}
proc get_role*(window: PWindow): cstring{.cdecl, dynlib: lib,
    importc: "gtk_window_get_role".}
proc add_accel_group*(window: PWindow, accel_group: PAccelGroup){.cdecl,
    dynlib: lib, importc: "gtk_window_add_accel_group".}
proc remove_accel_group*(window: PWindow, accel_group: PAccelGroup){.
    cdecl, dynlib: lib, importc: "gtk_window_remove_accel_group".}
proc set_position*(window: PWindow, position: TWindowPosition){.cdecl,
    dynlib: lib, importc: "gtk_window_set_position".}
proc activate_focus*(window: PWindow): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_window_activate_focus".}
proc set_focus*(window: PWindow, focus: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_window_set_focus".}
proc get_focus*(window: PWindow): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_window_get_focus".}
proc set_default*(window: PWindow, default_widget: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_window_set_default".}
proc activate_default*(window: PWindow): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_window_activate_default".}
proc set_transient_for*(window: PWindow, parent: PWindow){.cdecl,
    dynlib: lib, importc: "gtk_window_set_transient_for".}
proc get_transient_for*(window: PWindow): PWindow{.cdecl, dynlib: lib,
    importc: "gtk_window_get_transient_for".}
proc set_type_hint*(window: PWindow, hint: gdk2.TWindowTypeHint){.cdecl,
    dynlib: lib, importc: "gtk_window_set_type_hint".}
proc get_type_hint*(window: PWindow): gdk2.TWindowTypeHint{.cdecl,
    dynlib: lib, importc: "gtk_window_get_type_hint".}
proc set_destroy_with_parent*(window: PWindow, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_window_set_destroy_with_parent".}
proc get_destroy_with_parent*(window: PWindow): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_window_get_destroy_with_parent".}
proc set_resizable*(window: PWindow, resizable: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_window_set_resizable".}
proc get_resizable*(window: PWindow): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_window_get_resizable".}
proc set_gravity*(window: PWindow, gravity: gdk2.TGravity){.cdecl,
    dynlib: lib, importc: "gtk_window_set_gravity".}
proc get_gravity*(window: PWindow): gdk2.TGravity{.cdecl, dynlib: lib,
    importc: "gtk_window_get_gravity".}
proc set_geometry_hints*(window: PWindow, geometry_widget: PWidget,
                                geometry: gdk2.PGeometry,
                                geom_mask: gdk2.TWindowHints){.cdecl, dynlib: lib,
    importc: "gtk_window_set_geometry_hints".}
proc set_screen*(window: PWindow, screen: gdk2.PScreen){.cdecl,
    dynlib: lib, importc: "gtk_window_set_screen".}
proc get_screen*(window: PWindow): gdk2.PScreen{.cdecl, dynlib: lib,
    importc: "gtk_window_get_screen".}
proc set_has_frame*(window: PWindow, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_window_set_has_frame".}
proc get_has_frame*(window: PWindow): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_window_get_has_frame".}
proc set_frame_dimensions*(window: PWindow, left: gint, top: gint,
                                  right: gint, bottom: gint){.cdecl,
    dynlib: lib, importc: "gtk_window_set_frame_dimensions".}
proc get_frame_dimensions*(window: PWindow, left: Pgint, top: Pgint,
                                  right: Pgint, bottom: Pgint){.cdecl,
    dynlib: lib, importc: "gtk_window_get_frame_dimensions".}
proc set_decorated*(window: PWindow, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_window_set_decorated".}
proc get_decorated*(window: PWindow): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_window_get_decorated".}
proc set_icon_list*(window: PWindow, list: PGList){.cdecl, dynlib: lib,
    importc: "gtk_window_set_icon_list".}
proc get_icon_list*(window: PWindow): PGList{.cdecl, dynlib: lib,
    importc: "gtk_window_get_icon_list".}
proc set_icon*(window: PWindow, icon: gdk2pixbuf.PPixbuf){.cdecl, dynlib: lib,
    importc: "gtk_window_set_icon".}
proc get_icon*(window: PWindow): gdk2pixbuf.PPixbuf{.cdecl, dynlib: lib,
    importc: "gtk_window_get_icon".}
proc window_set_default_icon_list*(list: PGList){.cdecl, dynlib: lib,
    importc: "gtk_window_set_default_icon_list".}
proc window_get_default_icon_list*(): PGList{.cdecl, dynlib: lib,
    importc: "gtk_window_get_default_icon_list".}
proc set_modal*(window: PWindow, modal: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_window_set_modal".}
proc get_modal*(window: PWindow): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_window_get_modal".}
proc window_list_toplevels*(): PGList{.cdecl, dynlib: lib,
                                       importc: "gtk_window_list_toplevels".}
proc add_mnemonic*(window: PWindow, keyval: guint, target: PWidget){.
    cdecl, dynlib: lib, importc: "gtk_window_add_mnemonic".}
proc remove_mnemonic*(window: PWindow, keyval: guint, target: PWidget){.
    cdecl, dynlib: lib, importc: "gtk_window_remove_mnemonic".}
proc mnemonic_activate*(window: PWindow, keyval: guint,
                               modifier: gdk2.TModifierType): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_window_mnemonic_activate".}
proc set_mnemonic_modifier*(window: PWindow, modifier: gdk2.TModifierType){.
    cdecl, dynlib: lib, importc: "gtk_window_set_mnemonic_modifier".}
proc get_mnemonic_modifier*(window: PWindow): gdk2.TModifierType{.cdecl,
    dynlib: lib, importc: "gtk_window_get_mnemonic_modifier".}
proc present*(window: PWindow){.cdecl, dynlib: lib,
                                       importc: "gtk_window_present".}
proc iconify*(window: PWindow){.cdecl, dynlib: lib,
                                       importc: "gtk_window_iconify".}
proc deiconify*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gtk_window_deiconify".}
proc stick*(window: PWindow){.cdecl, dynlib: lib,
                                     importc: "gtk_window_stick".}
proc unstick*(window: PWindow){.cdecl, dynlib: lib,
                                       importc: "gtk_window_unstick".}
proc maximize*(window: PWindow){.cdecl, dynlib: lib,
                                        importc: "gtk_window_maximize".}
proc unmaximize*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gtk_window_unmaximize".}
proc begin_resize_drag*(window: PWindow, edge: gdk2.TWindowEdge,
                               button: gint, root_x: gint, root_y: gint,
                               timestamp: guint32){.cdecl, dynlib: lib,
    importc: "gtk_window_begin_resize_drag".}
proc begin_move_drag*(window: PWindow, button: gint, root_x: gint,
                             root_y: gint, timestamp: guint32){.cdecl,
    dynlib: lib, importc: "gtk_window_begin_move_drag".}
proc set_default_size*(window: PWindow, width: gint, height: gint){.
    cdecl, dynlib: lib, importc: "gtk_window_set_default_size".}
proc get_default_size*(window: PWindow, width: Pgint, height: Pgint){.
    cdecl, dynlib: lib, importc: "gtk_window_get_default_size".}
proc resize*(window: PWindow, width: gint, height: gint){.cdecl,
    dynlib: lib, importc: "gtk_window_resize".}
proc get_size*(window: PWindow, width: Pgint, height: Pgint){.cdecl,
    dynlib: lib, importc: "gtk_window_get_size".}
proc move*(window: PWindow, x: gint, y: gint){.cdecl, dynlib: lib,
    importc: "gtk_window_move".}
proc get_position*(window: PWindow, root_x: Pgint, root_y: Pgint){.cdecl,
    dynlib: lib, importc: "gtk_window_get_position".}
proc parse_geometry*(window: PWindow, geometry: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_window_parse_geometry".}
proc reshow_with_initial_size*(window: PWindow){.cdecl, dynlib: lib,
    importc: "gtk_window_reshow_with_initial_size".}
proc window_group_get_type*(): GType{.cdecl, dynlib: lib,
                                      importc: "gtk_window_group_get_type".}
proc window_group_new*(): PWindowGroup{.cdecl, dynlib: lib,
                                        importc: "gtk_window_group_new".}
proc add_window*(window_group: PWindowGroup, window: PWindow){.
    cdecl, dynlib: lib, importc: "gtk_window_group_add_window".}
proc remove_window*(window_group: PWindowGroup, window: PWindow){.
    cdecl, dynlib: lib, importc: "gtk_window_group_remove_window".}
proc window_set_default_icon_name*(name: cstring){.cdecl, dynlib: lib,
    importc: "gtk_window_set_default_icon_name".}
proc internal_set_focus*(window: PWindow, focus: PWidget){.cdecl,
    dynlib: lib, importc: "_gtk_window_internal_set_focus".}
proc remove_embedded_xid*(window: PWindow, xid: guint){.cdecl,
    dynlib: lib, importc: "gtk_window_remove_embedded_xid".}
proc add_embedded_xid*(window: PWindow, xid: guint){.cdecl, dynlib: lib,
    importc: "gtk_window_add_embedded_xid".}
proc reposition*(window: PWindow, x: gint, y: gint){.cdecl, dynlib: lib,
    importc: "_gtk_window_reposition".}
proc constrain_size*(window: PWindow, width: gint, height: gint,
                            new_width: Pgint, new_height: Pgint){.cdecl,
    dynlib: lib, importc: "_gtk_window_constrain_size".}
proc get_group*(window: PWindow): PWindowGroup{.cdecl, dynlib: lib,
    importc: "_gtk_window_get_group".}
proc activate_key*(window: PWindow, event: gdk2.PEventKey): gboolean{.
    cdecl, dynlib: lib, importc: "_gtk_window_activate_key".}
proc keys_foreach*(window: PWindow, fn: TWindowKeysForeachFunc,
                          func_data: gpointer){.cdecl, dynlib: lib,
    importc: "_gtk_window_keys_foreach".}
proc query_nonaccels*(window: PWindow, accel_key: guint,
                             accel_mods: gdk2.TModifierType): gboolean{.cdecl,
    dynlib: lib, importc: "_gtk_window_query_nonaccels".}
const
  bm_TGtkLabel_jtype* = 0x0003'u16
const
  bp_TGtkLabel_jtype* = 0'u16
const
  bm_TGtkLabel_wrap* = 0x0004'u16
const
  bp_TGtkLabel_wrap* = 2'u16
const
  bm_TGtkLabel_use_underline* = 0x0008'u16
const
  bp_TGtkLabel_use_underline* = 3'u16
const
  bm_TGtkLabel_use_markup* = 0x0010'u16
const
  bp_TGtkLabel_use_markup* = 4'u16

