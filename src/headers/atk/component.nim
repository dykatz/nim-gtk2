# Included by headers/atk.nim; do not import directly.
proc TYPE_COMPONENT*(): GType
proc IS_COMPONENT*(obj: pointer): bool
proc COMPONENT*(obj: pointer): PComponent
proc COMPONENT_GET_IFACE*(obj: pointer): PComponentIface
proc component_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "atk_component_get_type".}
proc add_focus_handler*(component: PComponent, handler: TFocusHandler): guint{.
    cdecl, dynlib: lib, importc: "atk_component_add_focus_handler".}
proc contains*(component: PComponent, x, y: gint,
                         coord_type: TCoordType): gboolean{.cdecl, dynlib: lib,
    importc: "atk_component_contains".}
proc ref_accessible_at_point*(component: PComponent, x, y: gint,
                                        coord_type: TCoordType): PObject{.cdecl,
    dynlib: lib, importc: "atk_component_ref_accessible_at_point".}
proc get_extents*(component: PComponent, x, y, width, height: Pgint,
                            coord_type: TCoordType){.cdecl, dynlib: lib,
    importc: "atk_component_get_extents".}
proc get_position*(component: PComponent, x: Pgint, y: Pgint,
                             coord_type: TCoordType){.cdecl, dynlib: lib,
    importc: "atk_component_get_position".}
proc get_size*(component: PComponent, width: Pgint, height: Pgint){.
    cdecl, dynlib: lib, importc: "atk_component_get_size".}
proc get_layer*(component: PComponent): TLayer{.cdecl, dynlib: lib,
    importc: "atk_component_get_layer".}
proc get_mdi_zorder*(component: PComponent): gint{.cdecl, dynlib: lib,
    importc: "atk_component_get_mdi_zorder".}
proc grab_focus*(component: PComponent): gboolean{.cdecl, dynlib: lib,
    importc: "atk_component_grab_focus".}
proc remove_focus_handler*(component: PComponent, handler_id: guint){.
    cdecl, dynlib: lib, importc: "atk_component_remove_focus_handler".}
proc set_extents*(component: PComponent, x: gint, y: gint,
                            width: gint, height: gint, coord_type: TCoordType): gboolean{.
    cdecl, dynlib: lib, importc: "atk_component_set_extents".}
proc set_position*(component: PComponent, x: gint, y: gint,
                             coord_type: TCoordType): gboolean{.cdecl,
    dynlib: lib, importc: "atk_component_set_position".}
proc set_size*(component: PComponent, width: gint, height: gint): gboolean{.
    cdecl, dynlib: lib, importc: "atk_component_set_size".}
